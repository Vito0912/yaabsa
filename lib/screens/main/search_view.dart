import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/api/library/search_library.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/components/common/scroll_to_top_button.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/common/library_search_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/item_view_navigation.dart';

class SearchView extends HookConsumerWidget {
  const SearchView({required this.query, this.limit = 5, super.key});

  final String query;
  final int? limit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final selectedLibrary = ref.watch(selectedLibraryProvider);
    if (selectedLibrary == null) {
      return const Center(child: Text('No library selected. Please select a library via the switcher.'));
    }

    final searchAsync = ref.watch(librarySearchProvider((query: query, limit: limit)));

    return searchAsync.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: (searchResult) {
        if (searchResult == null) {
          return const Center(child: Text('No results found.'));
        }

        final resultItems = _buildLibraryItems(searchResult);

        final hasMetadataResults =
            (searchResult.series?.isNotEmpty ?? false) ||
            (searchResult.authors?.isNotEmpty ?? false) ||
            (searchResult.narrators?.isNotEmpty ?? false) ||
            (searchResult.tags?.isNotEmpty ?? false) ||
            (searchResult.genres?.isNotEmpty ?? false);

        if (resultItems.isEmpty && !hasMetadataResults) {
          return Center(child: Text('No results found for "$query".'));
        }

        return Stack(
          children: [
            Positioned.fill(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                children: [
                  Text('Search results for "$query"', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 12),
                  if (resultItems.isNotEmpty) _SearchResultItems(items: resultItems),
                  if (searchResult.series?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 20),
                    _TokenSection(
                      title: 'Series',
                      tokens: searchResult.series!
                          .map(
                            (series) => _SearchToken(
                              label: '${series.series.name} (${series.books.length})',
                              onTap: () => context.push(
                                '/series/${series.series.id}',
                                extra: MultiBookEntryData.fromSeries(series.series),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  if (searchResult.authors?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 20),
                    _TokenSection(
                      title: 'Authors',
                      tokens: searchResult.authors!
                          .map(
                            (author) => _SearchToken(
                              label: '${author.name} (${author.numBooks})',
                              onTap: () => context.push('/author/${author.id}'),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  if (searchResult.narrators?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 20),
                    _TokenSection(
                      title: 'Narrators',
                      tokens: searchResult.narrators!
                          .map(
                            (narrator) => _SearchToken(
                              label: '${narrator.name} (${narrator.numBooks})',
                              onTap: () => context.push('/narrator/${Uri.encodeComponent(narrator.name)}'),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  if (searchResult.tags?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 20),
                    _TokenSection(
                      title: 'Tags',
                      tokens: searchResult.tags!
                          .map(
                            (tag) => _SearchToken(
                              label: '${tag.name} (${tag.numItems ?? 0})',
                              onTap: () {
                                openLibraryWithFilter(
                                  context,
                                  ref,
                                  filter: LibraryFilter.grouped(LibraryFilterGroup.tags, tag.name).queryValue,
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  if (searchResult.genres?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 20),
                    _TokenSection(
                      title: 'Genres',
                      tokens: searchResult.genres!
                          .map(
                            (genre) => _SearchToken(
                              label: '${genre.name} (${genre.numItems ?? 0})',
                              onTap: () {
                                openLibraryWithFilter(
                                  context,
                                  ref,
                                  filter: LibraryFilter.grouped(LibraryFilterGroup.genres, genre.name).queryValue,
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            ScrollToTopButton(controller: scrollController),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error loading search results: $err', textAlign: TextAlign.center),
        ),
      ),
    );
  }

  List<LibraryItem> _buildLibraryItems(SearchLibrary searchResult) {
    final List<LibraryItem> items = [];
    final seenIds = <String>{};

    void add(List<SearchLibraryResult>? source) {
      if (source == null) return;
      for (final result in source) {
        final item = result.libraryItem;
        if (item == null || seenIds.contains(item.id)) {
          continue;
        }
        seenIds.add(item.id);
        items.add(item);
      }
    }

    add(searchResult.book);
    add(searchResult.podcast);
    return items;
  }
}

class _SearchResultItems extends ConsumerWidget {
  const _SearchResultItems({required this.items});

  final List<LibraryItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(absApiProvider);
    if (api == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: items
          .map(
            (item) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => context.push('/item/${item.id}'),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: api.getLibraryItemApi().getLibraryItemCover(item.id, item: item),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.mediaType ?? 'Unknown media',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _TokenSection extends StatelessWidget {
  const _TokenSection({required this.title, required this.tokens});

  final String title;
  final List<_SearchToken> tokens;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tokens
              .map(
                (token) => token.onTap == null
                    ? Chip(label: Text(token.label), visualDensity: VisualDensity.compact)
                    : ActionChip(
                        label: Text(token.label),
                        visualDensity: VisualDensity.compact,
                        onPressed: token.onTap,
                      ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _SearchToken {
  const _SearchToken({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;
}
