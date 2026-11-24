import 'dart:async';
import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

class WearScrollIndicator extends StatefulWidget {
  const WearScrollIndicator({required this.controller, required this.child, super.key});

  final ScrollController controller;
  final Widget child;

  @override
  State<WearScrollIndicator> createState() => _WearScrollIndicatorState();
}

class _WearScrollIndicatorState extends State<WearScrollIndicator> {
  final _visible = ValueNotifier(false);
  Timer? _hide;

  bool _onScroll(ScrollNotification notification) {
    if (notification.depth != 0) {
      return false;
    }
    if (notification is ScrollStartNotification || notification is ScrollUpdateNotification) {
      _hide?.cancel();
      _hide = null;
      _visible.value = true;
    } else if (notification is ScrollEndNotification) {
      _hide?.cancel();
      _hide = Timer(const Duration(milliseconds: 800), () {
        _visible.value = false;
      });
    }
    return false;
  }

  @override
  void dispose() {
    _hide?.cancel();
    _visible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      child: CustomPaint(
        foregroundPainter: _WearScrollPainter(
          controller: widget.controller,
          visible: _visible,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          rtl: Directionality.of(context) == TextDirection.rtl,
        ),
        child: widget.child,
      ),
    );
  }
}

class _WearScrollPainter extends CustomPainter {
  _WearScrollPainter({required this.controller, required this.visible, required this.color, required this.rtl})
    : super(repaint: Listenable.merge([controller, visible]));

  final ScrollController controller;
  final ValueNotifier<bool> visible;
  final Color color;
  final bool rtl;

  @override
  void paint(Canvas canvas, Size size) {
    if (!visible.value || !controller.hasClients) {
      return;
    }
    final position = controller.position;
    if (!position.hasContentDimensions || position.maxScrollExtent <= 0) {
      return;
    }

    final radius = size.shortestSide / 2 - 3;
    final bounds = Rect.fromCircle(center: size.center(Offset.zero), radius: radius);
    final start = rtl ? -3 * math.pi / 4 : -math.pi / 4;
    final sweep = rtl ? -math.pi / 2 : math.pi / 2;
    final contentExtent = position.maxScrollExtent + position.viewportDimension;
    final thumbFraction = (position.viewportDimension / contentExtent).clamp(0.12, 0.8);
    final progress = (position.pixels / position.maxScrollExtent).clamp(0.0, 1.0);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3
      ..color = color.withValues(alpha: 0.18);
    canvas.drawArc(bounds, start, sweep, false, paint);

    paint.color = color;
    canvas.drawArc(bounds, start + sweep * (1 - thumbFraction) * progress, sweep * thumbFraction, false, paint);
  }

  @override
  bool shouldRepaint(_WearScrollPainter oldDelegate) {
    return controller != oldDelegate.controller ||
        visible != oldDelegate.visible ||
        color != oldDelegate.color ||
        rtl != oldDelegate.rtl;
  }
}
