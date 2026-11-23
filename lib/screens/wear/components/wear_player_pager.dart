import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/screens/wear/components/wear_activity_scope.dart';

class WearPlayerPager extends StatefulWidget {
  const WearPlayerPager({required this.background, required this.player, required this.actionsBuilder, super.key});

  final Widget background;
  final Widget player;
  final Widget Function(VoidCallback showPlayer) actionsBuilder;

  @override
  State<WearPlayerPager> createState() => _WearPlayerPagerState();
}

class _WearPlayerPagerState extends State<WearPlayerPager> {
  final _controller = PageController();
  int _page = 0;
  int _settledPage = 0;
  bool _isPaging = false;

  void _showPlayer() {
    if (!_controller.hasClients) {
      return;
    }

    unawaited(_controller.animateToPage(0, duration: const Duration(milliseconds: 250), curve: Curves.easeOutCubic));
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification.depth != 0 || notification.metrics.axis != Axis.horizontal) {
      return false;
    }

    if (notification is ScrollStartNotification) {
      setState(() {
        _isPaging = true;
      });
    } else if (notification is ScrollEndNotification) {
      setState(() {
        _settledPage = _page;
        _isPaging = false;
      });
    }

    return false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = WearActivityScope.isActive(context);
    final colors = Theme.of(context).colorScheme;
    return PopScope(
      canPop: _settledPage == 0 && !_isPaging,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showPlayer();
        }
      },
      child: ColoredBox(
        color: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                child: widget.background,
                builder: (context, child) {
                  final page = _controller.hasClients ? _controller.page ?? 0 : 0.0;
                  final coverOpacity = 1.0 - page.clamp(0.0, 1.0);
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      const ColoredBox(color: Colors.black),
                      if (child != null) Opacity(opacity: coverOpacity, child: child),
                    ],
                  );
                },
              ),
            ),
            Positioned.fill(
              bottom: 20,
              child: NotificationListener<ScrollNotification>(
                onNotification: _onScroll,
                child: PageView(
                  controller: _controller,
                  physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  onPageChanged: (page) {
                    setState(() {
                      _page = page;
                    });
                  },
                  children: [
                    WearActivityScope(active: active && _page == 0, child: widget.player),
                    WearActivityScope(active: active && _page == 1, child: widget.actionsBuilder(_showPlayer)),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 7,
              child: Semantics(
                label: _page == 0 ? 'Player, page 1 of 2' : 'Item actions, page 2 of 2',
                child: ExcludeSemantics(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var index = 0; index < 2; index++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: _page == index ? 14 : 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: _page == index ? colors.primary : colors.onSurface.withValues(alpha: 0.30),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
