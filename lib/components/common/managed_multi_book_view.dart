import 'package:yaabsa/components/common/screen_refresh_indicator.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/common/list_management_header.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/components/common/scroll_to_top_button.dart';
import 'package:yaabsa/util/layout_sizes.dart';
import 'package:yaabsa/components/common/paged_list_footer.dart';
import 'package:yaabsa/ui/components/feedback/feedback_panel.dart';
import 'package:yaabsa/util/l10n.dart';

class ManagedMultiBookCardConfig {
  const ManagedMultiBookCardConfig({required this.entry, required this.onTap, this.onLongPress});

  final MultiBookEntryData entry;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
}

class ManagedMultiBookView extends StatelessWidget {
  const ManagedMultiBookView({
    required this.createLabel,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.emptyIcon,
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

  final String createLabel;
  final String emptyTitle;
  final String emptyMessage;
  final IconData emptyIcon;
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
              onCreate: onCreate,
              createLabel: createLabel,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            ),
            if (refreshError != null) TextButton(onPressed: onRefresh, child: Text(context.l10n.errorRefreshLists)),
            Expanded(
              child: cards.isEmpty && !hasNextPage
                  ? _ManagedMultiBookEmptyState(
                      title: emptyTitle,
                      message: emptyMessage,
                      icon: emptyIcon,
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
    required this.icon,
    this.onCreate,
  });

  final String title;
  final String message;
  final String createLabel;
  final IconData icon;
  final VoidCallback? onCreate;

  @override
  Widget build(BuildContext context) {
    return YaabsaFeedbackPanel(
      icon: icon,
      title: title,
      message: message,
      action: onCreate == null
          ? null
          : FilledButton.tonalIcon(onPressed: onCreate, icon: const Icon(Icons.add_rounded), label: Text(createLabel)),
    );
  }
}
