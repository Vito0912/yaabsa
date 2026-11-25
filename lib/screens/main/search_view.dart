import 'package:material_ui/material_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/api/library/search_library.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/components/common/desktop_page_shortcuts.dart';
import 'package:yaabsa/components/common/scroll_to_top_button.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/common/library_search_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/item_view_navigation.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

class SearchView extends HookConsumerWidget {
  const SearchView({required this.query, this.limit = 5, super.key});

  final String query;
  final int? limit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final selectedLibrary = ref.watch(selectedLibraryProvider);
    if (selectedLibrary == null) {
      return Center(child: Text(context.l10n.errorNoLibrarySelected));
    }

    final searchProvider = librarySearchProvider((query: query, limit: limit, libraryId: null));
    final searchAsync = ref.watch(searchProvider);

    final content = searchAsync.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: (searchResult) {
        if (searchResult == null) {
          return Center(child: Text(context.l10n.searchNoResults));
        }

        final resultItems = _buildLibraryItems(searchResult);

        final hasMetadataResults =
            (searchResult.series?.isNotEmpty ?? false) ||
            (searchResult.authors?.isNotEmpty ?? false) ||
            (searchResult.narrators?.isNotEmpty ?? false) ||
            (searchResult.tags?.isNotEmpty ?? false) ||
            (searchResult.genres?.isNotEmpty ?? false);

        if (resultItems.isEmpty && !hasMetadataResults) {
          return Center(child: Text(context.l10n.searchNoResultsFor(query)));
        }

        return Stack(
          children: [
            Positioned.fill(
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        context.l10n.searchResultsFor(query),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList.builder(
                      itemCount: resultItems.length,
                      itemBuilder: (context, index) =>
                          _SearchResultItem(key: ValueKey(resultItems[index].id), item: resultItems[index]),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (searchResult.series?.isNotEmpty ?? false) ...[
                            const SizedBox(height: 20),
                            _TokenSection(
                              title: context.l10n.navSeries,
                              tokens: searchResult.series!
                                  .map(
                                    (series) => _SearchToken(
                                      label: context.l10n.searchResultCount(
                                        series.series.name,
                                        context.l10n.bookCount(series.books.length),
                                      ),
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
                              title: context.l10n.navAuthors,
                              tokens: searchResult.authors!
                                  .map(
                                    (author) => _SearchToken(
                                      label: context.l10n.searchResultCount(
                                        author.name,
                                        context.l10n.bookCount(author.numBooks),
                                      ),
                                      onTap: () => context.push('/author/${author.id}'),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                          if (searchResult.narrators?.isNotEmpty ?? false) ...[
                            const SizedBox(height: 20),
                            _TokenSection(
                              title: context.l10n.navNarrators,
                              tokens: searchResult.narrators!
                                  .map(
                                    (narrator) => _SearchToken(
                                      label: context.l10n.searchResultCount(
                                        narrator.name,
                                        context.l10n.bookCount(narrator.numBooks ?? 0),
                                      ),
                                      onTap: () => context.push('/narrator/${Uri.encodeComponent(narrator.name)}'),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                          if (searchResult.tags?.isNotEmpty ?? false) ...[
                            const SizedBox(height: 20),
                            _TokenSection(
                              title: context.l10n.fieldTags,
                              tokens: searchResult.tags!
                                  .map(
                                    (tag) => _SearchToken(
                                      label: context.l10n.searchResultCount(
                                        tag.name,
                                        context.l10n.itemCount(tag.numItems ?? 0),
                                      ),
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
                              title: context.l10n.fieldGenres,
                              tokens: searchResult.genres!
                                  .map(
                                    (genre) => _SearchToken(
                                      label: context.l10n.searchResultCount(
                                        genre.name,
                                        context.l10n.itemCount(genre.numItems ?? 0),
                                      ),
                                      onTap: () {
                                        openLibraryWithFilter(
                                          context,
                                          ref,
                                          filter: LibraryFilter.grouped(
                                            LibraryFilterGroup.genres,
                                            genre.name,
                                          ).queryValue,
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
                  ),
                ],
              ),
            ),
            ScrollToTopButton(controller: scrollController),
          ],
        );
      },
      loading: () => const Center(child: YaabsaCircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(context.l10n.errorUnableToLoadContent, textAlign: TextAlign.center),
        ),
      ),
    );
    return DesktopPageShortcuts(
      onRefresh: () async {
        ref.invalidate(searchProvider);
        await ref.read(searchProvider.future);
      },
      child: content,
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

class _SearchResultItem extends ConsumerWidget {
  const _SearchResultItem({super.key, required this.item});

  final LibraryItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(absApiProvider);
    if (api == null) {
      return const SizedBox.shrink();
    }

    final coverSize = (56 * MediaQuery.devicePixelRatioOf(context)).ceilToDouble();
    return Card(
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
                  child: api.getLibraryItemApi().getLibraryItemCover(
                    item.id,
                    item: item,
                    cacheWidth: coverSize,
                    cacheHeight: coverSize,
                  ),
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
                      item.mediaType ?? context.l10n.statusUnknown,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
