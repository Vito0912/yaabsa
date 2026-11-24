import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/wear/wear_transforming_list_item.dart';

class WearListItemContent extends SingleChildRenderObjectWidget {
  const WearListItemContent({required super.child, super.key});

  @override
  RenderWearListItemContent createRenderObject(BuildContext context) {
    return RenderWearListItemContent();
  }
}

class RenderWearListItemContent extends RenderProxyBox {
  final _opacityLayer = LayerHandle<OpacityLayer>();

  @override
  bool get alwaysNeedsCompositing => child != null;

  double _contentOpacity() {
    RenderObject? ancestor = parent;
    while (ancestor != null) {
      if (ancestor is RenderWearTransformingListItem) {
        return ancestor.contentOpacity;
      }
      ancestor = ancestor.parent;
    }

    return 1.0;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final alpha = (255 * _contentOpacity()).round();
    if (alpha == 0 || child == null) {
      _opacityLayer.layer = null;
      return;
    }

    _opacityLayer.layer = context.pushOpacity(offset, alpha, super.paint, oldLayer: _opacityLayer.layer);
  }

  @override
  void dispose() {
    _opacityLayer.layer = null;
    super.dispose();
  }
}
