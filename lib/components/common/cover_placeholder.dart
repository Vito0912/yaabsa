import 'dart:math' as math;

import 'package:flutter/material.dart';

class CoverPlaceholder extends StatelessWidget {
  const CoverPlaceholder({super.key, this.borderRadius = 14});

  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final shortestSide = constraints.biggest.shortestSide;
          final cubeSize = (shortestSide.isFinite && shortestSide > 0) ? shortestSide * 0.34 : 34.0;
          final edgeColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.7);

          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.surfaceContainerHighest,
                  colorScheme.surfaceContainer,
                  colorScheme.surfaceContainerLow,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.65)),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  top: -cubeSize * 0.3,
                  right: -cubeSize * 0.2,
                  child: _CubeOutline(size: cubeSize * 0.9, color: edgeColor.withValues(alpha: 0.35)),
                ),
                Positioned(
                  bottom: -cubeSize * 0.4,
                  left: -cubeSize * 0.25,
                  child: _CubeOutline(size: cubeSize * 1.05, color: edgeColor.withValues(alpha: 0.25)),
                ),
                Center(
                  child: _CubeOutline(size: cubeSize, color: edgeColor),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CubeOutline extends StatelessWidget {
  const _CubeOutline({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -math.pi / 6,
      child: Icon(Icons.view_in_ar_rounded, size: size, color: color),
    );
  }
}
