import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/provider/wear/wear_browse_provider.dart';
import 'package:yaabsa/util/browse/compact_browse_models.dart';

part 'wear_browse_feed_provider.g.dart';

class WearBrowseFeedState {
  WearBrowseFeedState({
    required Iterable<CompactBrowseEntry> entries,
    required this.nextPage,
    required this.hasMore,
    this.loadingMore = false,
    this.loadMoreError,
  }) : entries = List.unmodifiable(entries);

  final List<CompactBrowseEntry> entries;
  final int nextPage;
  final bool hasMore;
  final bool loadingMore;
  final Object? loadMoreError;
}

@riverpod
class WearBrowseFeed extends _$WearBrowseFeed {
  int _generation = 0;

  CompactBrowseQuery _pageQuery(int page) {
    return compactBrowseQuery(
      query.section,
      libraryId: query.libraryId,
      itemId: query.itemId,
      filter: query.filter,
      page: page,
    );
  }

  @override
  Future<WearBrowseFeedState> build(CompactBrowseQuery query) async {
    _generation++;
    ref.onDispose(() {
      _generation++;
    });

    final firstPageQuery = compactBrowseQuery(
      query.section,
      libraryId: query.libraryId,
      itemId: query.itemId,
      filter: query.filter,
    );
    final firstPage = await ref.watch(wearBrowseProvider(firstPageQuery).future);

    return WearBrowseFeedState(entries: firstPage.entries, nextPage: 1, hasMore: firstPage.hasMore);
  }

  void refresh() {
    ref.invalidate(wearBrowseProvider(_pageQuery(0)));
  }

  Future<void> loadMore() async {
    final previous = state.value;
    if (state.isLoading || previous == null || previous.loadingMore || !previous.hasMore) {
      return;
    }

    final generation = _generation;
    final nextQuery = _pageQuery(previous.nextPage);
    final pageProvider = wearBrowseProvider(nextQuery);
    ref.invalidate(pageProvider);

    final subscription = ref.listen(pageProvider, (_, _) {});
    state = AsyncData(
      WearBrowseFeedState(
        entries: previous.entries,
        nextPage: previous.nextPage,
        hasMore: previous.hasMore,
        loadingMore: true,
      ),
    );

    try {
      final page = await ref.read(pageProvider.future);
      if (!ref.mounted || generation != _generation) {
        return;
      }

      final entries = _appendEntries(previous.entries, page.entries);
      state = AsyncData(WearBrowseFeedState(entries: entries, nextPage: previous.nextPage + 1, hasMore: page.hasMore));
    } catch (error) {
      if (!ref.mounted || generation != _generation) {
        return;
      }

      state = AsyncData(
        WearBrowseFeedState(
          entries: previous.entries,
          nextPage: previous.nextPage,
          hasMore: previous.hasMore,
          loadMoreError: error,
        ),
      );
    } finally {
      subscription.close();
    }
  }

  List<CompactBrowseEntry> _appendEntries(List<CompactBrowseEntry> existing, List<CompactBrowseEntry> incoming) {
    final entries = [...existing];
    final keys = existing.map(_entryKey).toSet();
    for (final entry in incoming) {
      if (keys.add(_entryKey(entry))) {
        entries.add(entry);
      }
    }

    return entries;
  }

  Object _entryKey(CompactBrowseEntry entry) {
    if (entry.itemId != null) {
      return (entry.itemId, entry.episodeId);
    }

    return entry.destination ?? entry.title;
  }
}
