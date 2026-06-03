import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AndroidEdgeToEdgeInsetGuard extends StatelessWidget {
  const AndroidEdgeToEdgeInsetGuard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return child;
    }

    final mediaQuery = MediaQuery.of(context);
    final mergedPadding = mediaQuery.padding.copyWith(
      bottom: math.max(mediaQuery.padding.bottom, mediaQuery.systemGestureInsets.bottom),
    );
    final mergedViewPadding = mediaQuery.viewPadding.copyWith(
      bottom: math.max(mediaQuery.viewPadding.bottom, mediaQuery.systemGestureInsets.bottom),
    );

    return MediaQuery(
      data: mediaQuery.copyWith(padding: mergedPadding, viewPadding: mergedViewPadding),
      child: child,
    );
  }
}
