import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/common/screen_refresh_indicator.dart';
import 'package:yaabsa/components/common/scroll_to_top_button.dart';
import 'package:yaabsa/ui/components/cards/surface_card.dart';
import 'package:yaabsa/ui/components/feedback/feedback_panel.dart';
import 'package:yaabsa/util/layout_sizes.dart';
import 'package:yaabsa/util/l10n.dart';

class ManagedListDetailFrame extends StatelessWidget {
  const ManagedListDetailFrame({
    super.key,
    required this.title,
    required this.description,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.emptyIcon,
    required this.scrollController,
    required this.onRefresh,
    required this.itemCount,
    required this.itemBuilder,
    this.tileWidth = appGridTileWidth,
    this.headerActions,
    this.statusMessage,
    this.statusIcon = Icons.info_outline_rounded,
  });

  final String title;
  final String? description;
  final String emptyTitle;
  final String emptyMessage;
  final IconData emptyIcon;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double tileWidth;
  final Widget? headerActions;
  final String? statusMessage;
  final IconData statusIcon;

  @override
  Widget build(BuildContext context) {
    final resolvedDescription = description?.trim();
    final resolvedStatus = statusMessage?.trim();

    return LayoutBuilder(
      builder: (context, constraints) {
        final gridLayout = appCenteredGridLayout(constraints.maxWidth, tileWidth: tileWidth);

        return Column(
          children: [
            _ManagedListDetailHeader(title: title, actions: headerActions),
            if (resolvedDescription != null && resolvedDescription.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    resolvedDescription,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            if (resolvedStatus != null && resolvedStatus.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: YaabsaSurfaceCard(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  borderRadius: 16,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(statusIcon, size: 20, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 10),
                      Expanded(child: Text(resolvedStatus, style: Theme.of(context).textTheme.bodySmall)),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: itemCount == 0
                  ? _buildEmptyContent(context)
                  : Stack(
                      children: [
                        Positioned.fill(
                          child: ScreenRefreshIndicator(
                            onRefresh: onRefresh,
                            child: AlignedGridView.count(
                              controller: scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.fromLTRB(
                                gridLayout.horizontalPadding,
                                0,
                                gridLayout.horizontalPadding,
                                16,
                              ),
                              crossAxisCount: gridLayout.crossAxisCount,
                              mainAxisSpacing: appGridSpacing,
                              crossAxisSpacing: appGridSpacing,
                              itemCount: itemCount,
                              itemBuilder: itemBuilder,
                            ),
                          ),
                        ),
                        ScrollToTopButton(controller: scrollController),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyContent(BuildContext context) {
    return ScreenRefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 80),
          YaabsaFeedbackPanel(
            icon: emptyIcon,
            title: emptyTitle,
            message: emptyMessage,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          ),
        ],
      ),
    );
  }
}

class _ManagedListDetailHeader extends StatelessWidget {
  const _ManagedListDetailHeader({required this.title, this.actions});

  final String title;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_rounded),
            tooltip: context.l10n.actionBack,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (actions != null) ...[const SizedBox(width: 4), actions!],
        ],
      ),
    );
  }
}
