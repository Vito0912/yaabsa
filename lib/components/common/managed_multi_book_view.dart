import 'package:yaabsa/components/common/screen_refresh_indicator.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/common/list_management_header.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/components/common/scroll_to_top_button.dart';
import 'package:yaabsa/util/layout_sizes.dart';
import 'package:yaabsa/components/common/paged_list_footer.dart';

class ManagedMultiBookCardConfig {
  const ManagedMultiBookCardConfig({required this.entry, required this.onTap, this.onLongPress});

  final MultiBookEntryData entry;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
}

class ManagedMultiBookView extends StatelessWidget {
  const ManagedMultiBookView({
    required this.title,
    required this.createLabel,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.scrollController,
    required this.api,
    required this.cards,
    required this.onRefresh,
    this.onCreate,
    this.hasNextPage = false,
    this.isLoadingNextPage = false,
    this.nextPageError,
    this.refreshError,
    this.onLoadMore,
    super.key,
  });

  final String title;
  final String createLabel;
  final String emptyTitle;
  final String emptyMessage;
  final VoidCallback? onCreate;
  final ScrollController scrollController;
  final ABSApi api;
  final List<ManagedMultiBookCardConfig> cards;
  final Future<void> Function() onRefresh;
  final bool hasNextPage;
  final bool isLoadingNextPage;
  final Object? nextPageError;
  final Object? refreshError;
  final VoidCallback? onLoadMore;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gridLayout = appCenteredGridLayout(constraints.maxWidth, tileWidth: appGridTileWidth * 1.5);

        return Column(
          children: [
            ListManagementHeader(
              title: title,
              onCreate: onCreate,
              createLabel: createLabel,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            ),
            if (refreshError != null)
              TextButton(onPressed: onRefresh, child: const Text('Could not refresh lists. Retry')),
            Expanded(
              child: cards.isEmpty && !hasNextPage
                  ? _ManagedMultiBookEmptyState(
                      title: emptyTitle,
                      message: emptyMessage,
                      onCreate: onCreate,
                      createLabel: createLabel,
                    )
                  : Stack(
                      children: [
                        Positioned.fill(
                          child: ScreenRefreshIndicator(
                            onRefresh: onRefresh,
                            child: NotificationListener<ScrollNotification>(
                              onNotification: (notification) {
                                if (notification.depth == 0 &&
                                    notification.metrics.extentAfter < 240 &&
                                    hasNextPage &&
                                    !isLoadingNextPage &&
                                    nextPageError == null) {
                                  onLoadMore?.call();
                                }
                                return false;
                              },
                              child: AlignedGridView.count(
                                controller: scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.fromLTRB(
                                  gridLayout.horizontalPadding,
                                  4,
                                  gridLayout.horizontalPadding,
                                  16,
                                ),
                                crossAxisCount: gridLayout.crossAxisCount,
                                mainAxisSpacing: appGridSpacing,
                                crossAxisSpacing: appGridSpacing,
                                itemCount: cards.length + (hasNextPage ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == cards.length) {
                                    return PagedListFooter(
                                      loading: isLoadingNextPage,
                                      error: nextPageError,
                                      onLoadMore: () => onLoadMore?.call(),
                                    );
                                  }
                                  final card = cards[index];
                                  return MultiBookEntryWidget(
                                    api: api,
                                    entry: card.entry,
                                    compact: constraints.maxWidth < 700,
                                    squareCover: true,
                                    coverHeight: appGridTileWidth,
                                    showSubtitle: true,
                                    maxBooksToShow: defaultMultiBookPreviewLimit,
                                    onTap: card.onTap,
                                    onLongPress: card.onLongPress,
                                  );
                                },
                              ),
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
}

class _ManagedMultiBookEmptyState extends StatelessWidget {
  const _ManagedMultiBookEmptyState({
    required this.title,
    required this.message,
    required this.createLabel,
    this.onCreate,
  });

  final String title;
  final String message;
  final String createLabel;
  final VoidCallback? onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            if (onCreate != null) ...[
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: onCreate,
                icon: const Icon(Icons.add_rounded),
                label: Text(createLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
