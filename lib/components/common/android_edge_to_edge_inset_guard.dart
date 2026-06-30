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
    final isKeyboardOpen = mediaQuery.viewInsets.bottom > 0;
    final bottomPadding = isKeyboardOpen
        ? mediaQuery.padding.bottom
        : math.max(mediaQuery.padding.bottom, mediaQuery.systemGestureInsets.bottom);
    final bottomViewPadding = isKeyboardOpen
        ? mediaQuery.viewPadding.bottom
        : math.max(mediaQuery.viewPadding.bottom, mediaQuery.systemGestureInsets.bottom);

    final mergedPadding = mediaQuery.padding.copyWith(bottom: bottomPadding);
    final mergedViewPadding = mediaQuery.viewPadding.copyWith(bottom: bottomViewPadding);

    return MediaQuery(
      data: mediaQuery.copyWith(padding: mergedPadding, viewPadding: mergedViewPadding),
      child: child,
    );
  }
}
