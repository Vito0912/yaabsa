import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

class WearCircleGeometry {
  const WearCircleGeometry({required this.radius});

  final double radius;

  double scaleAtCenter({required Size size, required double distance}) {
    if (size.isEmpty || radius <= 0 || distance >= radius) {
      return 0.0;
    }

    final capRadius = size.height / 2;
    final halfStraight = math.max(0.0, (size.width - size.height) / 2);
    return _solveScale(
      availableRadiusSquared: radius * radius - distance * distance,
      linearTerm: 2 * radius * capRadius,
      quadraticTerm: halfStraight * halfStraight - capRadius * capRadius,
    );
  }

  double scaleAfterEdge({required Size size, required double edgeDistance}) {
    if (size.isEmpty || radius <= 0 || edgeDistance >= radius) {
      return 0.0;
    }

    final capRadius = size.height / 2;
    final halfStraight = math.max(0.0, (size.width - size.height) / 2);
    return _solveScale(
      availableRadiusSquared: radius * radius - edgeDistance * edgeDistance,
      linearTerm: 2 * capRadius * (radius + edgeDistance),
      quadraticTerm: halfStraight * halfStraight,
    );
  }

  double _solveScale({
    required double availableRadiusSquared,
    required double linearTerm,
    required double quadraticTerm,
  }) {
    final discriminant = linearTerm * linearTerm + 4 * quadraticTerm * availableRadiusSquared;
    final denominator = linearTerm + math.sqrt(math.max(0.0, discriminant));
    if (denominator <= 0) {
      return 1.0;
    }

    return (2 * availableRadiusSquared / denominator).clamp(0.0, 1.0);
  }
}
