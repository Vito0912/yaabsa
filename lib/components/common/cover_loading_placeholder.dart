import 'package:flutter/material.dart';

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
    final baseColor = colorScheme.surfaceContainerHighest;
    final highlightColor = colorScheme.surfaceContainerLow;

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: baseColor,
          border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth.isFinite && constraints.maxWidth > 0 ? constraints.maxWidth : 120.0;
            final shimmerWidth = width * 0.65;
            final travelDistance = width + shimmerWidth;

            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final left = -shimmerWidth + (travelDistance * _controller.value);

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.surfaceContainerHigh,
                            colorScheme.surfaceContainer,
                            colorScheme.surfaceContainerHigh,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    Positioned(
                      left: left,
                      top: 0,
                      bottom: 0,
                      width: shimmerWidth,
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, highlightColor.withValues(alpha: 0.85), Colors.transparent],
                              stops: const [0.1, 0.5, 0.9],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
