import 'package:yaabsa/util/globals.dart';
import 'package:flutter/material.dart';

typedef ResponsiveWidgetBuilder = Widget Function(BuildContext context);

class PlatformBuilder extends StatelessWidget {
  final ResponsiveWidgetBuilder mobileBuilder;
  final ResponsiveWidgetBuilder tabletBuilder;
  final ResponsiveWidgetBuilder desktopBuilder;

  const PlatformBuilder({
    super.key,
    required this.mobileBuilder,
    required this.tabletBuilder,
    required this.desktopBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final double screenWidth = screenSize.width;

    if (screenWidth < kTabletBreakpoint) {
      return mobileBuilder(context);
    } else if (screenWidth < kDesktopBreakpoint) {
      return tabletBuilder(context);
    } else {
      return desktopBuilder(context);
    }
  }
}
