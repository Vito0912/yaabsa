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
      left: math.max(mediaQuery.padding.left, mediaQuery.systemGestureInsets.left),
      right: math.max(mediaQuery.padding.right, mediaQuery.systemGestureInsets.right),
      bottom: math.max(mediaQuery.padding.bottom, mediaQuery.systemGestureInsets.bottom),
    );
    final mergedViewPadding = mediaQuery.viewPadding.copyWith(
      left: math.max(mediaQuery.viewPadding.left, mediaQuery.systemGestureInsets.left),
      right: math.max(mediaQuery.viewPadding.right, mediaQuery.systemGestureInsets.right),
      bottom: math.max(mediaQuery.viewPadding.bottom, mediaQuery.systemGestureInsets.bottom),
    );

    return MediaQuery(
      data: mediaQuery.copyWith(padding: mergedPadding, viewPadding: mergedViewPadding),
      child: child,
    );
  }
}
