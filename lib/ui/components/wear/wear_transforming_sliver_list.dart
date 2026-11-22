import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/wear/wear_circle_geometry.dart';
import 'package:yaabsa/ui/components/wear/wear_transforming_list_item.dart';

class WearTransformingSliverList extends SliverList {
  const WearTransformingSliverList({required this.controller, required super.delegate, super.key});

  final ScrollController controller;

  @override
  RenderWearTransformingSliverList createRenderObject(BuildContext context) {
    return RenderWearTransformingSliverList(controller, childManager: context as SliverMultiBoxAdaptorElement);
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderWearTransformingSliverList renderObject) {
    renderObject.controller = controller;
  }
}

class RenderWearTransformingSliverList extends RenderSliverList {
  RenderWearTransformingSliverList(this._controller, {required super.childManager});

  static const _topCurveFactor = 0.65;

  ScrollController _controller;
  final _paintOffsets = <RenderBox, double>{};

  set controller(ScrollController value) {
    if (identical(value, _controller)) {
      return;
    }

    _controller = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    _paintOffsets.clear();
    super.performLayout();

    final viewport = RenderAbstractViewport.maybeOf(this);
    if (viewport == null ||
        viewport is! RenderBox ||
        !_controller.hasClients ||
        geometry?.scrollOffsetCorrection != null) {
      return;
    }

    final viewportBox = viewport as RenderBox;
    final circle = WearCircleGeometry(radius: viewportBox.size.shortestSide / 2 - 2);
    final center = viewportBox.size.height / 2;
    final scrollOffset = _controller.position.pixels;
    final rows = <_WearRow>[];
    RenderBox? child = firstChild;
    while (child != null) {
      final transform = _findTransform(child);
      final layoutOffset = childScrollOffset(child);
      if (transform != null && layoutOffset != null) {
        final originalTop = layoutOffset + constraints.precedingScrollExtent - scrollOffset;
        rows.add(_WearRow(child: child, transform: transform, originalTop: originalTop));
      }
      child = childAfter(child);
    }

    if (rows.isEmpty) {
      return;
    }

    var anchorIndex = 0;
    var nearestDistance = double.infinity;
    for (var index = 0; index < rows.length; index++) {
      final distance = (rows[index].originalCenter - center).abs();
      if (distance < nearestDistance) {
        nearestDistance = distance;
        anchorIndex = index;
      }
    }

    final anchor = rows[anchorIndex];
    final anchorBelowCenter = anchor.originalCenter > center;
    var anchorDistance = nearestDistance;
    if (!anchorBelowCenter) {
      anchorDistance *= _topCurveFactor;
    }

    final anchorScale = circle.scaleAtCenter(size: anchor.child.size, distance: anchorDistance);
    final anchorHeight = anchor.child.size.height * anchorScale;
    final anchorTop = anchor.originalCenter - anchorHeight / 2;
    _positionRow(anchor, top: anchorTop, scale: anchorScale, fadeOut: anchorBelowCenter);

    var bottomEdge = anchorTop + anchorHeight;
    for (var index = anchorIndex + 1; index < rows.length; index++) {
      final row = rows[index];
      final scale = circle.scaleAfterEdge(size: row.child.size, edgeDistance: bottomEdge - center);
      _positionRow(row, top: bottomEdge, scale: scale);
      bottomEdge += row.child.size.height * scale;
    }

    var topEdge = anchorTop;
    for (var index = anchorIndex - 1; index >= 0; index--) {
      final row = rows[index];
      final distance = (center - topEdge) * _topCurveFactor;
      final scale = circle.scaleAfterEdge(size: row.child.size, edgeDistance: distance);
      topEdge -= row.child.size.height * scale;
      _positionRow(row, top: topEdge, scale: scale, fadeOut: false);
    }
  }

  void _positionRow(_WearRow row, {required double top, required double scale, bool fadeOut = true}) {
    _paintOffsets[row.child] = top - row.originalTop;
    row.transform.setPaintScale(scale, fadeOut: fadeOut);
  }

  RenderWearTransformingListItem? _findTransform(RenderObject object) {
    if (object is RenderWearTransformingListItem) {
      return object;
    }

    RenderWearTransformingListItem? found;
    object.visitChildren((child) {
      found ??= _findTransform(child);
    });
    return found;
  }

  @override
  double childMainAxisPosition(RenderBox child) {
    return super.childMainAxisPosition(child) + (_paintOffsets[child] ?? 0);
  }
}

class _WearRow {
  const _WearRow({required this.child, required this.transform, required this.originalTop});

  final RenderBox child;
  final RenderWearTransformingListItem transform;
  final double originalTop;

  double get originalCenter => originalTop + child.size.height / 2;
}
