import 'package:flutter/material.dart';

class ScrollToTopButton extends StatefulWidget {
  const ScrollToTopButton({
    super.key,
    required this.controller,
    this.showAfterPixels = 540,
    this.bottom = 14,
    this.right = 14,
  });

  final ScrollController controller;
  final double showAfterPixels;
  final double bottom;
  final double right;

  @override
  State<ScrollToTopButton> createState() => _ScrollToTopButtonState();
}

class _ScrollToTopButtonState extends State<ScrollToTopButton> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleScroll());
  }

  @override
  void didUpdateWidget(covariant ScrollToTopButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) {
      return;
    }

    oldWidget.controller.removeListener(_handleScroll);
    widget.controller.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleScroll());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleScroll);
    super.dispose();
  }

  void _handleScroll() {
    if (!widget.controller.hasClients) {
      return;
    }

    final shouldShow = widget.controller.offset > widget.showAfterPixels;
    if (shouldShow == _isVisible) {
      return;
    }

    setState(() => _isVisible = shouldShow);
  }

  void _scrollToTop() {
    if (!widget.controller.hasClients) {
      return;
    }

    widget.controller.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Positioned(
      right: widget.right,
      bottom: widget.bottom,
      child: IgnorePointer(
        ignoring: !_isVisible,
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          offset: _isVisible ? Offset.zero : const Offset(0, 0.2),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            opacity: _isVisible ? 1 : 0,
            child: Material(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.92),
              shape: const CircleBorder(),
              elevation: 2,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _scrollToTop,
                child: SizedBox(
                  width: 42,
                  height: 42,
                  child: Icon(Icons.keyboard_arrow_up_rounded, color: colorScheme.onSurfaceVariant),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
