import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/screens/wear/components/wear_scroll_view.dart';

class WearVolumeControl extends StatefulWidget {
  const WearVolumeControl({required this.volume, required this.onChanged, super.key});
  final double volume;
  final ValueChanged<double> onChanged;

  @override
  State<WearVolumeControl> createState() => _WearVolumeControlState();
}

class _WearVolumeControlState extends State<WearVolumeControl> {
  late double _v = widget.volume;

  @override
  void didUpdateWidget(WearVolumeControl old) {
    super.didUpdateWidget(old);
    if (old.volume != widget.volume) {
      _v = widget.volume;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Listener(
      onPointerSignal: (e) {
        try {
          final d = (e as dynamic).scrollDelta?.y as double?;
          if (d != null) {
            setState(() => _v = (_v + d * 0.05).clamp(0.0, 1.0));
            widget.onChanged(_v);
          }
        } catch (_) {}
      },
      child: Scaffold(
        body: WearScrollView(
          children: [
            Icon(Icons.volume_up, color: colorScheme.onSurface.withValues(alpha: 0.38), size: 18),
            const SizedBox(height: 8),
            SizedBox.square(
              dimension: 80,
              child: CustomPaint(
                painter: _CircularVolumePainter(
                  volume: _v,
                  color: colorScheme.primary,
                  bg: colorScheme.onSurface.withValues(alpha: 0.24),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(_v * 100).round()}%',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: colorScheme.onSurface),
            ),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                _vBtn(Icons.remove_circle_outline, () {
                  setState(() => _v = (_v - 0.1).clamp(0.0, 1.0));
                  widget.onChanged(_v);
                }),
                IconButton.filled(
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Done',
                  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  icon: const Icon(Icons.check, size: 22),
                ),
                _vBtn(Icons.add_circle_outline, () {
                  setState(() => _v = (_v + 0.1).clamp(0.0, 1.0));
                  widget.onChanged(_v);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _vBtn(IconData i, VoidCallback f) => IconButton(
    icon: Icon(i, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.70), size: 26),
    onPressed: f,
    tooltip: i == Icons.remove_circle_outline ? 'Decrease volume' : 'Increase volume',
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
  );
}

class _CircularVolumePainter extends CustomPainter {
  _CircularVolumePainter({required this.volume, required this.color, required this.bg});
  final double volume;
  final Color color, bg;

  @override
  void paint(Canvas c, Size s) {
    final o = Offset(s.width / 2, s.height / 2), r = s.width / 2 - 8;
    c.drawCircle(
      o,
      r,
      Paint()
        ..color = bg
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );
    c.drawArc(
      Rect.fromCircle(center: o, radius: r),
      -math.pi / 2,
      volume * 2 * math.pi,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularVolumePainter o) => o.volume != volume;
}
