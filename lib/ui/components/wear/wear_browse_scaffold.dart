import 'package:material_ui/material_ui.dart';
import 'package:wear_plus/wear_plus.dart';
import 'package:yaabsa/ui/components/wear/wear_page_header.dart';
import 'package:yaabsa/ui/components/wear/wear_scroll_indicator.dart';
import 'package:yaabsa/ui/components/wear/wear_scroll_physics.dart';
import 'package:yaabsa/ui/components/wear/wear_swipe_to_dismiss.dart';
import 'package:yaabsa/ui/components/wear/wear_transforming_list_item.dart';
import 'package:yaabsa/ui/components/wear/wear_transforming_sliver_list.dart';

class WearBrowseScaffoldView extends StatefulWidget {
  const WearBrowseScaffoldView({
    this.title,
    this.subtitle,
    required this.itemCount,
    required this.itemBuilder,
    this.background,
    this.backgroundColor = Colors.black,
    this.dismissible = true,
    this.transformItems = true,
    this.flatScrolling = false,
    this.nowOverride,
    this.onLoadMore,
    super.key,
  });

  final String? title;
  final String? subtitle;
  final Widget? background;
  final Color backgroundColor;
  final bool dismissible;
  final bool transformItems;
  final bool flatScrolling;
  final DateTime? nowOverride;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final VoidCallback? onLoadMore;

  @override
  State<WearBrowseScaffoldView> createState() => _WearBrowseScaffoldViewState();
}

class _WearBrowseScaffoldViewState extends State<WearBrowseScaffoldView> {
  final _controller = ScrollController();
  bool _loadCheckScheduled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scheduleLoadCheck);
  }

  void _scheduleLoadCheck() {
    if (_loadCheckScheduled || widget.onLoadMore == null) {
      return;
    }

    _loadCheckScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCheckScheduled = false;
      if (!mounted ||
          !_controller.hasClients ||
          !WearActiveScope.isActive(context) ||
          !(ModalRoute.isCurrentOf(context) ?? true)) {
        return;
      }

      final position = _controller.position;
      if (position.hasContentDimensions && position.extentAfter <= position.viewportDimension * 0.75) {
        widget.onLoadMore?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scheduleLoadCheck();

    return WearSwipeToDismiss(
      enabled: widget.dismissible,
      child: Scaffold(
        backgroundColor: widget.backgroundColor,
        body: Stack(
          fit: StackFit.expand,
          children: [
            if (widget.background != null) Positioned.fill(child: widget.background!),
            WatchShape(
              builder: (context, shape, child) {
                return SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final round = shape == WearShape.round;
                      final transformRows =
                          widget.transformItems &&
                          !widget.flatScrolling &&
                          round &&
                          !MediaQuery.accessibleNavigationOf(context) &&
                          MediaQuery.textScalerOf(context).scale(14) <= 18;
                      final horizontalInset = round ? (constraints.maxWidth * 0.06).clamp(12.0, 18.0) : 12.0;
                      final delegate = SliverChildBuilderDelegate((context, index) {
                        if (index == 0) {
                          return WearPageHeader(
                            title: widget.title,
                            subtitle: widget.subtitle,
                            nowOverride: widget.nowOverride,
                          );
                        }

                        final item = widget.itemBuilder(context, index - 1);
                        if (!transformRows) {
                          return item;
                        }

                        return WearTransformingListItem(child: item);
                      }, childCount: widget.itemCount + 1);
                      final list = CustomScrollView(
                        controller: _controller,
                        physics: const WearScrollPhysics(),
                        scrollCacheExtent: ScrollCacheExtent.pixels(transformRows ? constraints.maxHeight : 64),
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.fromLTRB(
                              horizontalInset,
                              round ? constraints.maxHeight * 0.10 : 16,
                              horizontalInset,
                              round ? constraints.maxHeight * 0.18 : 16,
                            ),
                            sliver: transformRows
                                ? WearTransformingSliverList(controller: _controller, delegate: delegate)
                                : SliverList(delegate: delegate),
                          ),
                        ],
                      );

                      if (round) {
                        return ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                          child: WearScrollIndicator(controller: _controller, child: list),
                        );
                      }

                      return ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                        child: RawScrollbar(
                          controller: _controller,
                          interactive: false,
                          thickness: 3,
                          radius: const Radius.circular(3),
                          minThumbLength: 16,
                          mainAxisMargin: 12,
                          crossAxisMargin: 2,
                          thumbColor: Theme.of(context).colorScheme.onSurfaceVariant,
                          child: list,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
