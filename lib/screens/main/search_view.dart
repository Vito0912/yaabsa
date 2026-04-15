import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/api/library/search_library.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/common/library_search_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

class SearchView extends ConsumerWidget {
  const SearchView({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLibrary = ref.watch(selectedLibraryProvider);
    if (selectedLibrary == null) {
      return const Center(child: Text('No library selected. Please select a library via the switcher.'));
    }

    final searchAsync = ref.watch(librarySearchProvider(query));

    return searchAsync.when(
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

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          children: [
            Text('Search results for "$query"', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            if (resultItems.isNotEmpty) _SearchResultItems(items: resultItems),
            if (searchResult.series?.isNotEmpty ?? false) ...[
              const SizedBox(height: 20),
              _TokenSection(
                title: 'Series',
                tokens: searchResult.series!.map((series) => '${series.series.name} (${series.books.length})').toList(),
              ),
            ],
            if (searchResult.authors?.isNotEmpty ?? false) ...[
              const SizedBox(height: 20),
              _TokenSection(
                title: 'Authors',
                tokens: searchResult.authors!.map((author) => '${author.name} (${author.numBooks})').toList(),
              ),
            ],
            if (searchResult.narrators?.isNotEmpty ?? false) ...[
              const SizedBox(height: 20),
              _TokenSection(
                title: 'Narrators',
                tokens: searchResult.narrators!
                    .map((narrator) => '${narrator.name} (${narrator.numItems ?? 0})')
                    .toList(),
              ),
            ],
            if (searchResult.tags?.isNotEmpty ?? false) ...[
              const SizedBox(height: 20),
              _TokenSection(
                title: 'Tags',
                tokens: searchResult.tags!.map((tag) => '${tag.name} (${tag.numItems ?? 0})').toList(),
              ),
            ],
            if (searchResult.genres?.isNotEmpty ?? false) ...[
              const SizedBox(height: 20),
              _TokenSection(
                title: 'Genres',
                tokens: searchResult.genres!.map((genre) => '${genre.name} (${genre.numItems ?? 0})').toList(),
              ),
            ],
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
                          child: api.getLibraryItemApi().getLibraryItemCover(item.id),
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
  final List<String> tokens;

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
          children: tokens.map((token) => Chip(label: Text(token), visualDensity: VisualDensity.compact)).toList(),
        ),
      ],
    );
  }
}
