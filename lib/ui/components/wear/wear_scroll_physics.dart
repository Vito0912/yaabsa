import 'package:material_ui/material_ui.dart';

class WearScrollPhysics extends ClampingScrollPhysics {
  const WearScrollPhysics({super.parent});

  @override
  WearScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return WearScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double get maxFlingVelocity => 2400;

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    final simulation = super.createBallisticSimulation(position, velocity);
    if (simulation is! ClampingScrollSimulation) {
      return simulation;
    }

    return ClampingScrollSimulation(
      position: position.pixels,
      velocity: velocity.clamp(-maxFlingVelocity, maxFlingVelocity),
      friction: 0.04,
      tolerance: toleranceFor(position),
    );
  }
}
