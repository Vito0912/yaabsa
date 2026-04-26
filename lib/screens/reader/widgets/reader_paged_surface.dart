import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaabsa/screens/reader/widgets/reader_navigation_button.dart';

class ReaderPagedSurface extends StatelessWidget {
  const ReaderPagedSurface({
    super.key,
    required this.content,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.interceptPointerScrollForPaging,
    this.centerOverlay,
  });

  final Widget content;
  final Future<void> Function() onPreviousPage;
  final Future<void> Function() onNextPage;
  final bool canGoPrevious;
  final bool canGoNext;
  final bool interceptPointerScrollForPaging;
  final Widget? centerOverlay;

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.arrowLeft): _ReaderPreviousPageIntent(),
        SingleActivator(LogicalKeyboardKey.arrowRight): _ReaderNextPageIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _ReaderPreviousPageIntent: CallbackAction<_ReaderPreviousPageIntent>(
            onInvoke: (intent) {
              if (canGoPrevious) {
                unawaited(onPreviousPage());
              }
              return null;
            },
          ),
          _ReaderNextPageIntent: CallbackAction<_ReaderNextPageIntent>(
            onInvoke: (intent) {
              if (canGoNext) {
                unawaited(onNextPage());
              }
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Listener(
            onPointerSignal: (pointerSignal) {
              if (!interceptPointerScrollForPaging || pointerSignal is! PointerScrollEvent) {
                return;
              }

              if (HardwareKeyboard.instance.isControlPressed || HardwareKeyboard.instance.isMetaPressed) {
                return;
              }

              if (pointerSignal.scrollDelta.dy > 0 && canGoNext) {
                unawaited(onNextPage());
              } else if (pointerSignal.scrollDelta.dy < 0 && canGoPrevious) {
                unawaited(onPreviousPage());
              }
            },
            child: Stack(
              children: [
                Positioned.fill(child: content),
                _ReaderNavigationButtons(
                  onPrevious: canGoPrevious ? () => unawaited(onPreviousPage()) : null,
                  onNext: canGoNext ? () => unawaited(onNextPage()) : null,
                ),
                if (centerOverlay != null) Positioned.fill(child: IgnorePointer(child: centerOverlay)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReaderPreviousPageIntent extends Intent {
  const _ReaderPreviousPageIntent();
}

class _ReaderNextPageIntent extends Intent {
  const _ReaderNextPageIntent();
}

class _ReaderNavigationButtons extends StatelessWidget {
  const _ReaderNavigationButtons({required this.onPrevious, required this.onNext});

  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ReaderNavigationButton(icon: Icons.arrow_back, onTap: onPrevious),
            ReaderNavigationButton(icon: Icons.arrow_forward, onTap: onNext),
          ],
        ),
      ],
    );
  }
}
