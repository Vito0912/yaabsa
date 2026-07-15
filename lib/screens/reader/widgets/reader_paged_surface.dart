import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReaderPagedSurface extends StatelessWidget {
  const ReaderPagedSurface({
    super.key,
    required this.content,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.interceptPointerScrollForPaging,
    this.showNavigationHoverAreas = true,
    this.centerOverlay,
  });

  final Widget content;
  final Future<void> Function() onPreviousPage;
  final Future<void> Function() onNextPage;
  final bool canGoPrevious;
  final bool canGoNext;
  final bool interceptPointerScrollForPaging;
  final bool showNavigationHoverAreas;
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
                if (showNavigationHoverAreas) ...[
                  _ReaderNavigationHoverArea(
                    icon: Icons.arrow_back,
                    onTap: canGoPrevious ? () => unawaited(onPreviousPage()) : null,
                    alignment: Alignment.centerLeft,
                  ),
                  _ReaderNavigationHoverArea(
                    icon: Icons.arrow_forward,
                    onTap: canGoNext ? () => unawaited(onNextPage()) : null,
                    alignment: Alignment.centerRight,
                  ),
                ],
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

class _ReaderNavigationHoverArea extends StatefulWidget {
  const _ReaderNavigationHoverArea({required this.icon, required this.onTap, required this.alignment});

  final IconData icon;
  final VoidCallback? onTap;
  final Alignment alignment;

  @override
  State<_ReaderNavigationHoverArea> createState() => _ReaderNavigationHoverAreaState();
}

class _ReaderNavigationHoverAreaState extends State<_ReaderNavigationHoverArea> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 0,
      bottom: 0,
      left: widget.alignment == Alignment.centerLeft ? 0.0 : null,
      right: widget.alignment == Alignment.centerRight ? 0.0 : null,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 120,
            height: double.infinity,
            alignment: widget.alignment,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isHovered ? 1.0 : 0.0,
              child: Icon(widget.icon, color: Colors.white70, size: 36),
            ),
          ),
        ),
      ),
    );
  }
}
