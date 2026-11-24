import 'package:material_ui/material_ui.dart';

class CoverLoadingPlaceholder extends StatefulWidget {
  const CoverLoadingPlaceholder({super.key, this.borderRadius = 14});

  final double borderRadius;

  @override
  State<CoverLoadingPlaceholder> createState() => _CoverLoadingPlaceholderState();
}

class _CoverLoadingPlaceholderState extends State<CoverLoadingPlaceholder> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 950))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundGradient = LinearGradient(
      colors: [colorScheme.surfaceContainerHigh, colorScheme.surfaceContainer, colorScheme.surfaceContainerHigh],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    final shimmerGradient = LinearGradient(
      colors: [Colors.transparent, colorScheme.surfaceContainerLow.withValues(alpha: 0.85), Colors.transparent],
      stops: const [0.1, 0.5, 0.9],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
          ),
          child: CustomPaint(
            painter: _CoverShimmerPainter(
              animation: _controller,
              backgroundGradient: backgroundGradient,
              shimmerGradient: shimmerGradient,
            ),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class _CoverShimmerPainter extends CustomPainter {
  _CoverShimmerPainter({required this.animation, required this.backgroundGradient, required this.shimmerGradient})
    : super(repaint: animation);

  final Animation<double> animation;
  final LinearGradient backgroundGradient;
  final LinearGradient shimmerGradient;

  final Paint _backgroundPaint = Paint();
  final Paint _shimmerPaint = Paint();
  Size? _shaderSize;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) {
      return;
    }

    final shimmerWidth = size.width * 0.65;
    final shimmerBounds = Rect.fromLTWH(0, 0, shimmerWidth, size.height);
    if (_shaderSize != size) {
      _backgroundPaint.shader = backgroundGradient.createShader(Offset.zero & size);
      _shimmerPaint.shader = shimmerGradient.createShader(shimmerBounds);
      _shaderSize = size;
    }

    canvas.drawRect(Offset.zero & size, _backgroundPaint);

    final travelDistance = size.width + shimmerWidth;
    final left = -shimmerWidth + travelDistance * animation.value;
    canvas.save();
    canvas.translate(left, 0);
    canvas.drawRect(shimmerBounds, _shimmerPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CoverShimmerPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.backgroundGradient != backgroundGradient ||
        oldDelegate.shimmerGradient != shimmerGradient;
  }
}
