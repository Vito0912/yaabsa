import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/common/list_management_header.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/components/common/scroll_to_top_button.dart';
import 'package:yaabsa/util/layout_sizes.dart';

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
            Expanded(
              child: cards.isEmpty
                  ? _ManagedMultiBookEmptyState(
                      title: emptyTitle,
                      message: emptyMessage,
                      onCreate: onCreate,
                      createLabel: createLabel,
                    )
                  : Stack(
                      children: [
                        Positioned.fill(
                          child: RefreshIndicator(
                            onRefresh: onRefresh,
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
                              itemCount: cards.length,
                              itemBuilder: (context, index) {
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
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
