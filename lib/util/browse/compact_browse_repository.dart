import 'package:dio/dio.dart';
import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/api/library/request/library_items_request.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/util/browse/audio_browse_policy.dart';
import 'package:yaabsa/util/browse/compact_browse_models.dart';

const compactBrowsePageSize = 20;
const _requestOptions = <String, dynamic>{'doNotCache': true};

class CompactBrowseRepository {
  const CompactBrowseRepository(this.api);

  final ABSApi api;

  Future<CompactBrowsePage> load(CompactBrowseQuery query, {required CancelToken cancelToken}) {
    if (query.page < 0) {
      throw ArgumentError.value(query.page, 'page');
    }

    return switch (query.section) {
      CompactBrowseSection.libraries => _libraries(query, cancelToken),
      CompactBrowseSection.library => _categories(query, cancelToken),
      CompactBrowseSection.continueListening => _continueListening(cancelToken),
      CompactBrowseSection.items || CompactBrowseSection.recent => _items(query, cancelToken),
      CompactBrowseSection.authors => _authors(query, cancelToken),
      CompactBrowseSection.series => _series(query, cancelToken),
      CompactBrowseSection.latestEpisodes => _latestEpisodes(query, cancelToken),
      CompactBrowseSection.episodes => _episodes(query, cancelToken),
      CompactBrowseSection.downloads => throw StateError('Downloads must be loaded from local storage.'),
    };
  }

  Future<CompactBrowsePage> _libraries(CompactBrowseQuery query, CancelToken cancelToken) async {
    final response = await api.getLibraryApi().getLibraries(cancelToken: cancelToken, extra: _requestOptions);
    final libraries = response.data?.libraries;
    if (libraries == null) {
      throw const FormatException('Libraries are unavailable.');
    }

    final audioLibraries = libraries.where(isAudioLibrary).toList();
    audioLibraries.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    final visibleLibraries = audioLibraries.skip(query.page * compactBrowsePageSize).take(compactBrowsePageSize);
    return CompactBrowsePage(
      entries: visibleLibraries.map(
        (library) => CompactBrowseEntry(
          title: library.name,
          libraryIcon: library.icon,
          destination: compactBrowseQuery(CompactBrowseSection.library, libraryId: library.id),
        ),
      ),
      hasMore: (query.page + 1) * compactBrowsePageSize < audioLibraries.length,
    );
  }

  Future<CompactBrowsePage> _categories(CompactBrowseQuery query, CancelToken cancelToken) async {
    final response = await api.getLibraryApi().getLibraries(cancelToken: cancelToken, extra: _requestOptions);
    final library = response.data?.libraries.where((library) => library.id == query.libraryId).firstOrNull;
    if (library == null) {
      throw const FormatException('This library is no longer available.');
    }

    final podcast = library.mediaType == 'podcast';
    CompactBrowseEntry category(String title, CompactBrowseSection section) {
      return CompactBrowseEntry(
        title: title,
        destination: compactBrowseQuery(section, libraryId: library.id),
      );
    }

    return CompactBrowsePage(
      entries: [
        category('Recently added', CompactBrowseSection.recent),
        category(podcast ? 'Podcasts' : 'All audiobooks', CompactBrowseSection.items),
        if (podcast) category('Latest episodes', CompactBrowseSection.latestEpisodes),
        if (!podcast) category('Authors', CompactBrowseSection.authors),
        if (!podcast) category('Series', CompactBrowseSection.series),
      ],
    );
  }

  Future<CompactBrowsePage> _continueListening(CancelToken cancelToken) async {
    final response = await api.getMeApi().getItemsInProgress(
      limit: compactBrowsePageSize,
      cancelToken: cancelToken,
      extra: _requestOptions,
    );
    final items = response.data?.libraryItems;
    if (items == null) {
      throw const FormatException('Listening history is unavailable.');
    }

    return CompactBrowsePage(
      entries: items.take(compactBrowsePageSize).where(isSupportedAudioItem).map(_continueEntry),
    );
  }

  Future<CompactBrowsePage> _items(CompactBrowseQuery query, CancelToken cancelToken) async {
    final recent = query.section == CompactBrowseSection.recent;
    final group = parseGroupedLibraryFilterQuery(query.filter)?.group;
    var sort = 'media.metadata.title';
    if (recent) {
      sort = 'addedAt';
    } else if (group == LibraryFilterGroup.series) {
      sort = 'sequence';
    }
    final request = LibraryItemsRequest(
      limit: compactBrowsePageSize,
      page: query.page,
      sort: sort,
      desc: recent ? 1 : 0,
      filter: query.filter,
      collapseseries: 0,
    );
    final response = await api.getLibraryApi().getLibraryItems(
      query.libraryId!,
      request,
      cancelToken: cancelToken,
      extra: _requestOptions,
    );
    final data = response.data;
    if (data == null || (data.page != null && data.page != query.page)) {
      throw const FormatException('Invalid library page.');
    }

    return CompactBrowsePage(
      entries: data.results.take(compactBrowsePageSize).where(isSupportedAudioItem).map(_itemEntry),
      hasMore: _hasMore(query.page, data.total, data.results.length),
    );
  }

  Future<CompactBrowsePage> _authors(CompactBrowseQuery query, CancelToken cancelToken) async {
    final request = LibraryItemsRequest(limit: compactBrowsePageSize, page: query.page, sort: 'name', desc: 0);
    final response = await api.getLibraryApi().getLibraryAuthors(
      query.libraryId!,
      request,
      cancelToken: cancelToken,
      extra: _requestOptions,
    );
    final data = response.data;
    if (data == null || (data.page != null && data.page != query.page)) {
      throw const FormatException('Authors are unavailable.');
    }

    return CompactBrowsePage(
      entries: data.results
          .take(compactBrowsePageSize)
          .map(
            (author) =>
                _filteredEntry(query: query, title: author.name, group: LibraryFilterGroup.authors, id: author.id),
          ),
      hasMore: _hasMore(query.page, data.total, data.results.length),
    );
  }

  Future<CompactBrowsePage> _series(CompactBrowseQuery query, CancelToken cancelToken) async {
    final request = LibraryItemsRequest(limit: compactBrowsePageSize, page: query.page, sort: 'name', desc: 0);
    final response = await api.getLibraryApi().getLibrarySeries(
      query.libraryId!,
      request,
      cancelToken: cancelToken,
      extra: _requestOptions,
    );
    final data = response.data;
    if (data == null || data.page != query.page) {
      throw const FormatException('Series are unavailable.');
    }

    return CompactBrowsePage(
      entries: data.results
          .take(compactBrowsePageSize)
          .map(
            (series) =>
                _filteredEntry(query: query, title: series.name, group: LibraryFilterGroup.series, id: series.id),
          ),
      hasMore: _hasMore(query.page, data.total, data.results.length),
    );
  }

  Future<CompactBrowsePage> _latestEpisodes(CompactBrowseQuery query, CancelToken cancelToken) async {
    final response = await api.getLibraryApi().getRecentEpisodes(
      query.libraryId!,
      limit: compactBrowsePageSize,
      page: query.page,
      cancelToken: cancelToken,
      extra: _requestOptions,
    );
    final data = response.data;
    if (data == null || data.page != query.page) {
      throw const FormatException('Episodes are unavailable.');
    }

    return CompactBrowsePage(
      entries: data.episodes.take(compactBrowsePageSize).map(_episodeEntry),
      hasMore: data.episodes.length == compactBrowsePageSize,
    );
  }

  Future<CompactBrowsePage> _episodes(CompactBrowseQuery query, CancelToken cancelToken) async {
    // This endpoint returns all episodes. Only the displayed page survives
    // this request, and the expanded podcast bypasses the shared disk cache.
    final response = await api.getLibraryItemApi().getLibraryItem(
      itemId: query.itemId!,
      cancelToken: cancelToken,
      extra: _requestOptions,
    );
    final item = response.data;
    if (item == null) {
      throw const FormatException('Podcast is unavailable.');
    }

    final episodes = item.media?.podcastMedia?.episodes ?? const <Episode>[];
    final playable = episodes.where((episode) => episode.audioFile != null || episode.audioTrack != null).toList();
    playable.sort((a, b) => (b.publishedAt ?? 0).compareTo(a.publishedAt ?? 0));
    final visibleEpisodes = playable.skip(query.page * compactBrowsePageSize).take(compactBrowsePageSize);
    return CompactBrowsePage(
      entries: visibleEpisodes.map(_episodeEntry),
      hasMore: (query.page + 1) * compactBrowsePageSize < playable.length,
    );
  }

  bool _hasMore(int page, int? total, int received) {
    if (total == null) {
      return received == compactBrowsePageSize;
    }
    return (page + 1) * compactBrowsePageSize < total;
  }

  CompactBrowseEntry _filteredEntry({
    required CompactBrowseQuery query,
    required String title,
    required LibraryFilterGroup group,
    required String id,
  }) {
    return CompactBrowseEntry(
      title: title,
      destination: compactBrowseQuery(
        CompactBrowseSection.items,
        libraryId: query.libraryId,
        filter: LibraryFilter.grouped(group, id).queryValue,
      ),
    );
  }

  Uri? _itemCover(LibraryItem item) {
    if (!item.hasCover) {
      return null;
    }
    return api.getLibraryItemApi().getCoverUri(item.id, item: item, width: 144, height: 144);
  }

  CompactBrowseEntry _itemEntry(LibraryItem item) {
    if (isPodcastItem(item)) {
      return CompactBrowseEntry(
        title: item.title,
        subtitle: item.authorString,
        coverUri: _itemCover(item),
        destination: compactBrowseQuery(CompactBrowseSection.episodes, itemId: item.id, libraryId: item.libraryId),
      );
    }
    return CompactBrowseEntry(
      title: item.title,
      subtitle: item.authorString,
      itemId: item.id,
      coverUri: _itemCover(item),
    );
  }

  CompactBrowseEntry _continueEntry(LibraryItem item) {
    final episode = item.recentEpisode;
    if (episode != null) {
      return CompactBrowseEntry(
        title: episode.title ?? item.title,
        subtitle: item.title,
        itemId: item.id,
        episodeId: episode.id,
        coverUri: _itemCover(item),
      );
    }
    return _itemEntry(item);
  }

  CompactBrowseEntry _episodeEntry(Episode episode) {
    return CompactBrowseEntry(
      title: episode.title ?? 'Episode',
      subtitle: episode.podcast?.metadata.title,
      itemId: episode.libraryItemId,
      episodeId: episode.id,
      coverUri: api.getLibraryItemApi().getCoverUri(episode.libraryItemId, width: 144, height: 144),
    );
  }
}
