// ignore_for_file: use_null_aware_elements

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library/request/library_author_sort.dart';
import 'package:yaabsa/components/app/library/author_cleanup_tool.dart';
import 'package:yaabsa/components/app/library/author_sort_sheet.dart';
import 'package:yaabsa/components/common/author_card.dart';
import 'package:yaabsa/components/common/connection_issue_view.dart';
import 'package:yaabsa/components/common/cover_loading_placeholder.dart';
import 'package:yaabsa/components/common/scroll_to_top_button.dart';
import 'package:yaabsa/provider/common/library_author_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/util/globals.dart';

const int _authorsPrefetchThreshold = 8;
const int _authorsApproxScrollPastCount = 24;

class AuthorsView extends HookConsumerWidget {
  const AuthorsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final selectedLibrary = ref.watch(selectedLibraryProvider);
    final serverReachable = ref.watch(serverStatusProvider).value ?? false;

    if (selectedLibrary == null) {
      return const Center(child: Text('No library selected. Please select a library via the switcher.'));
    }

    if (selectedLibrary.mediaType != 'book') {
      return const Center(child: Text('Authors are available only for book libraries.'));
    }

    final libraryId = selectedLibrary.id;
    final authorsProvider = libraryAuthorsProvider(libraryId);
    final authorsStateAsync = ref.watch(authorsProvider);

    return authorsStateAsync.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: (state) {
        final authors = state.items;

        Future<void> openSortSheet() async {
          final result = await showModalBottomSheet<LibraryAuthorSortSelection>(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            builder: (context) => LibraryAuthorSortSheet(activeSort: state.sort, activeSortDesc: state.desc),
          );

          if (result == null) {
            return;
          }

          await ref.read(authorsProvider.notifier).setSort(result.sort, newDesc: result.desc);
        }

        final horizontalPadding = context.isDesktop
            ? 24.0
            : context.isTablet
            ? 16.0
            : 10.0;
        final crossAxisCount = context.isDesktop ? 3 : (context.isTablet ? 2 : 1);
        final estimatedItemCount = _estimatedItemCount(
          loadedCount: authors.length,
          totalItems: state.totalItems,
          hasNextPage: state.hasNextPage,
        );

        return Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  _AuthorsToolbar(
                    sortLabel: buildLibraryAuthorSortLabel(activeSort: state.sort, activeDesc: state.desc),
                    onSortPressed: openSortSheet,
                    trailingAction: RemoveAuthorsWithoutBooksTool(libraryId: libraryId),
                  ),
                  Expanded(
                    child: authors.isEmpty && !state.hasNextPage && !state.isLoadingNextPage
                        ? RefreshIndicator(
                            onRefresh: () => ref.read(authorsProvider.notifier).refresh(withLoading: false),
                            child: ListView(
                              controller: scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.fromLTRB(horizontalPadding, 12, horizontalPadding, 16),
                              children: const [
                                SizedBox(height: 80),
                                Center(child: Text('No authors found in this library.')),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () => ref.read(authorsProvider.notifier).refresh(withLoading: false),
                            child: GridView.builder(
                              controller: scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.fromLTRB(horizontalPadding, 12, horizontalPadding, 16),
                              itemCount: estimatedItemCount,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: context.isMobile ? 3.4 : 3.7,
                              ),
                              itemBuilder: (context, index) {
                                if (index >= authors.length - _authorsPrefetchThreshold) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    ref.read(authorsProvider.notifier).ensureLoadedForIndex(index);
                                  });
                                }

                                if (index >= authors.length) {
                                  return const _AuthorGridPlaceholderTile();
                                }

                                final author = authors[index];
                                return AuthorCard(
                                  authorId: author.id,
                                  name: author.name,
                                  subtitle: _bookCountLabel(author.numBooks),
                                  onTap: () {
                                    context.push('/author/${author.id}');
                                  },
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
            ScrollToTopButton(controller: scrollController),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        if (!serverReachable) {
          return ConnectionIssueView.offline(
            onRetry: () async {
              ref.invalidate(libraryFilterDataProvider(libraryId));
              await ref.read(libraryFilterDataProvider(libraryId).future);
            },
          );
        }

        return ConnectionIssueView.requestFailed(
          error: error,
          title: 'Error loading authors',
          onRetry: () async {
            ref.invalidate(libraryFilterDataProvider(libraryId));
            await ref.read(libraryFilterDataProvider(libraryId).future);
          },
        );
      },
    );
  }
}

int _estimatedItemCount({required int loadedCount, required int totalItems, required bool hasNextPage}) {
  if (totalItems > loadedCount) {
    return totalItems;
  }

  if (hasNextPage) {
    return loadedCount + _authorsApproxScrollPastCount;
  }

  return loadedCount;
}

String _bookCountLabel(int numBooks) => '$numBooks ${numBooks == 1 ? 'book' : 'books'}';

class _AuthorsToolbar extends StatelessWidget {
  const _AuthorsToolbar({required this.sortLabel, required this.onSortPressed, this.trailingAction});

  final String sortLabel;
  final VoidCallback onSortPressed;
  final Widget? trailingAction;

  @override
  Widget build(BuildContext context) {
    final sortButtonLabel = 'Sort: ${_truncateLabel(sortLabel)}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: Wrap(
          alignment: WrapAlignment.end,
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (trailingAction != null) trailingAction!,
            OutlinedButton.icon(
              onPressed: onSortPressed,
              icon: const Icon(Icons.sort_rounded),
              label: Text(sortButtonLabel),
            ),
          ],
        ),
      ),
    );
  }

  static String _truncateLabel(String label, {int maxLength = 34}) {
    if (label.length <= maxLength) {
      return label;
    }

    return '${label.substring(0, maxLength - 3)}...';
  }
}

class _AuthorGridPlaceholderTile extends StatelessWidget {
  const _AuthorGridPlaceholderTile();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            const SizedBox(width: 64, height: 64, child: CoverLoadingPlaceholder(borderRadius: 12)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 14,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FractionallySizedBox(
                    widthFactor: 0.42,
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
