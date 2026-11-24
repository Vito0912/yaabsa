import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';

class WearTransformingListItem extends SingleChildRenderObjectWidget {
  const WearTransformingListItem({required super.child, super.key});

  @override
  RenderWearTransformingListItem createRenderObject(BuildContext context) {
    return RenderWearTransformingListItem();
  }
}

class RenderWearTransformingListItem extends RenderProxyBox {
  static const _contentFadeStartScale = 0.65;
  static const _contentFadeEndScale = 0.35;
  static const _backgroundFadeStartScale = 0.85;
  static const _minimumTopOpacity = 0.1;

  double _scale = 1.0;
  bool _fadeOut = true;
  final _opacityLayer = LayerHandle<OpacityLayer>();

  double get contentOpacity {
    if (!_fadeOut) {
      return 1.0;
    }

    final fadeRange = _contentFadeStartScale - _contentFadeEndScale;
    return ((_scale - _contentFadeEndScale) / fadeRange).clamp(0.0, 1.0);
  }

  void setPaintScale(double value, {bool fadeOut = true}) {
    if (_scale == value && _fadeOut == fadeOut) {
      return;
    }

    _scale = value;
    _fadeOut = fadeOut;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  @override
  bool get alwaysNeedsCompositing => child != null;

  @override
  void dispose() {
    _opacityLayer.layer = null;
    super.dispose();
  }

  Matrix4 _paintTransform() {
    return Matrix4.identity()
      ..translateByDouble(size.width * (1 - _scale) / 2, 0, 0, 1)
      ..scaleByDouble(_scale, _scale, 1, 1);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    var opacity = _scale.clamp(_minimumTopOpacity, 1.0);
    if (_fadeOut) {
      opacity = (_scale / _backgroundFadeStartScale).clamp(0.0, 1.0);
    }

    final alpha = (255 * opacity).round();
    if (child == null || alpha == 0) {
      _opacityLayer.layer = null;
      return;
    }

    final transform = _paintTransform();
    _opacityLayer.layer = context.pushOpacity(offset, alpha, (context, offset) {
      context.pushTransform(needsCompositing, offset, transform, super.paint);
    }, oldLayer: _opacityLayer.layer);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (_scale <= 0 || contentOpacity == 0) {
      return false;
    }

    return result.addWithPaintTransform(
      transform: _paintTransform(),
      position: position,
      hitTest: (result, position) {
        return super.hitTestChildren(result, position: position);
      },
    );
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    transform.multiply(_paintTransform());
  }
}
