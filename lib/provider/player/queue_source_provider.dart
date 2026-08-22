import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/api/library/request/library_items_request.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/list/playlist_item.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/models/queue_source.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

part 'queue_source_provider.g.dart';

const int queueSourcePageSize = 20;

@Riverpod(keepAlive: true)
QueueSourceRepository queueSourceRepository(Ref ref) {
  return QueueSourceRepository(ref);
}

class QueueSourceRepository {
  QueueSourceRepository(this._ref);

  final Ref _ref;
  final Map<String, List<QueueCandidate>> _expandedSourceCache = <String, List<QueueCandidate>>{};
  final Map<String, int?> _sourceRevisionCache = <String, int?>{};
  final Map<String, Future<_ExpandedSourceResult>> _expandedSourceRequests = <String, Future<_ExpandedSourceResult>>{};
  int _cacheGeneration = 0;

  void clearCache() {
    _cacheGeneration++;
    _expandedSourceCache.clear();
    _sourceRevisionCache.clear();
    _expandedSourceRequests.clear();
  }

  Future<CandidatePage> page(MediaSourceDescriptor source, {int page = 0, int pageSize = queueSourcePageSize}) async {
    final api = _ref.read(absApiProvider);
    if (api == null) {
      throw StateError('No API available for queue source');
    }

    switch (source.type) {
      case MediaSourceType.series:
        return _seriesPage(api, source, page: page, pageSize: pageSize);
      case MediaSourceType.playlist:
        final expanded = await _expandedSource(source, () async {
          final response = await api.getListApi().getPlaylist(source.sourceId, extra: const {'noCache': true});
          final playlist = response.data;
          return _ExpandedSourceResult(
            candidates: playlist == null ? const <QueueCandidate>[] : _playlistCandidates(playlist.items),
            revision: playlist?.lastUpdate,
          );
        });
        return _slice(expanded.candidates, page: page, pageSize: pageSize, revision: expanded.revision);
      case MediaSourceType.collection:
        final expanded = await _expandedSource(source, () async {
          final response = await api.getListApi().getCollection(source.sourceId, extra: const {'noCache': true});
          final collection = response.data;
          return _ExpandedSourceResult(
            candidates: collection == null ? const <QueueCandidate>[] : _libraryCandidates(collection.items),
            revision: collection?.lastUpdate,
          );
        });
        return _slice(expanded.candidates, page: page, pageSize: pageSize, revision: expanded.revision);
      case MediaSourceType.podcast:
        final expanded = await _expandedSource(source, () async {
          final item = await _ref.read(libraryItemProvider(source.sourceId).future);
          return _ExpandedSourceResult(candidates: _podcastCandidates(item, source), revision: item.updatedAt);
        });
        return _slice(expanded.candidates, page: page, pageSize: pageSize, revision: expanded.revision);
    }
  }

  Future<_ExpandedSourceResult> _expandedSource(
    MediaSourceDescriptor source,
    Future<_ExpandedSourceResult> Function() fetch,
  ) async {
    final key = _cacheKey(source);
    final cached = _expandedSourceCache[key];
    if (cached != null) {
      return _ExpandedSourceResult(candidates: cached, revision: _sourceRevisionCache[key]);
    }

    final pending = _expandedSourceRequests[key] ?? fetch();
    _expandedSourceRequests[key] = pending;
    final generation = _cacheGeneration;
    try {
      final result = await pending;
      if (generation == _cacheGeneration) {
        _expandedSourceCache[key] = result.candidates;
        _sourceRevisionCache[key] = result.revision;
      }
      return result;
    } finally {
      if (identical(_expandedSourceRequests[key], pending)) {
        _expandedSourceRequests.remove(key);
      }
    }
  }

  Future<CandidatePage> _seriesPage(
    ABSApi api,
    MediaSourceDescriptor source, {
    required int page,
    required int pageSize,
  }) async {
    final request = LibraryItemsRequest(
      limit: pageSize,
      page: page,
      sort: 'sequence',
      desc: source.descending ? 1 : 0,
      filter: LibraryFilter.grouped(LibraryFilterGroup.series, source.sourceId).queryValue,
      collapseseries: 0,
    );
    final response = await api.getLibraryApi().getLibraryItems(
      source.libraryId,
      request,
      extra: const {'noCache': true},
    );
    final data = response.data;
    if (data == null) {
      throw StateError('No series page data received');
    }

    return CandidatePage(
      candidates: _libraryCandidates(data.results),
      total: data.total ?? data.results.length,
      page: data.page ?? page,
      pageSize: data.limit ?? pageSize,
    );
  }

  List<QueueCandidate> _podcastCandidates(LibraryItem item, MediaSourceDescriptor source) {
    final episodes = item.media?.podcastMedia?.episodes ?? const <Episode>[];
    final progress = _ref.read(mediaProgressProvider).asData?.value ?? const {};
    final candidates = <QueueCandidate>[];

    final orderedEpisodes = episodes.toList(growable: true)
      ..sort((left, right) {
        final byTimestamp = _podcastTimestamp(right).compareTo(_podcastTimestamp(left));
        if (byTimestamp != 0) return byTimestamp;
        final byIndex = (right.index ?? -1).compareTo(left.index ?? -1);
        if (byIndex != 0) return byIndex;
        return (right.title ?? '').toLowerCase().compareTo((left.title ?? '').toLowerCase());
      });
    if (!source.descending) {
      final ascendingEpisodes = orderedEpisodes.reversed.toList(growable: false);
      orderedEpisodes
        ..clear()
        ..addAll(ascendingEpisodes);
    }
    for (final episode in orderedEpisodes) {
      if (episode.id.isEmpty || episode.audioFile == null) {
        continue;
      }

      final episodeProgress = progress[mediaProgressKey(item.id, episode.id)];
      candidates.add(
        QueueCandidate(
          ref: PlayableRef(itemId: item.id, episodeId: episode.id),
          title: _nonEmpty(episode.title) ?? item.title,
          subtitle: _nonEmpty(episode.subtitle) ?? item.title,
          author: item.authorString,
          order: episode.index,
          addedAt: episode.addedAt,
          publishedAt: episode.publishedAt,
          estimatedBytes: episode.size ?? episode.audioFile?.metadata.size,
          isFinished: episodeProgress?.isFinished ?? false,
        ),
      );
    }

    return candidates;
  }

  List<QueueCandidate> _libraryCandidates(List<LibraryItem>? items) {
    if (items == null || items.isEmpty) {
      return const <QueueCandidate>[];
    }

    final seen = <String>{};
    final candidates = <QueueCandidate>[];
    final progress = _ref.read(mediaProgressProvider).asData?.value ?? const {};
    for (var index = 0; index < items.length; index++) {
      final item = items[index];
      if (item.id.isEmpty || !seen.add(item.id)) {
        continue;
      }
      candidates.add(
        QueueCandidate(
          ref: PlayableRef(itemId: item.id),
          title: item.title,
          subtitle: item.subtitle,
          author: item.authorString,
          order: index,
          addedAt: item.addedAt,
          estimatedBytes: item.size,
          isFinished: progress[mediaProgressKey(item.id)]?.isFinished ?? false,
        ),
      );
    }
    return candidates;
  }

  List<QueueCandidate> _playlistCandidates(List<PlaylistItem>? items) {
    if (items == null || items.isEmpty) {
      return const <QueueCandidate>[];
    }

    final seen = <String>{};
    final candidates = <QueueCandidate>[];
    final progress = _ref.read(mediaProgressProvider).asData?.value ?? const {};
    for (var index = 0; index < items.length; index++) {
      final playlistItem = items[index];
      final itemId = playlistItem.itemId.trim();
      if (itemId.isEmpty) {
        continue;
      }
      final episodeId = playlistItem.episodeId ?? playlistItem.episode?.id;
      final ref = PlayableRef(itemId: itemId, episodeId: episodeId);
      final key = '${ref.itemId}::${ref.episodeId ?? ''}';
      if (!seen.add(key)) {
        continue;
      }
      final item = playlistItem.libraryItem;
      final episode = playlistItem.episode;
      candidates.add(
        QueueCandidate(
          ref: ref,
          title: _nonEmpty(episode?.title) ?? item?.title,
          subtitle: _nonEmpty(episode?.subtitle) ?? item?.subtitle,
          author: item?.authorString,
          order: index,
          addedAt: episode?.addedAt ?? item?.addedAt,
          publishedAt: episode?.publishedAt,
          estimatedBytes: episode?.size ?? item?.size,
          isFinished: progress[mediaProgressKey(itemId, episodeId)]?.isFinished ?? false,
        ),
      );
    }
    return candidates;
  }

  CandidatePage _slice(List<QueueCandidate> candidates, {required int page, required int pageSize, int? revision}) {
    final safePageSize = pageSize < 1 ? queueSourcePageSize : pageSize;
    final start = page * safePageSize;
    final end = (start + safePageSize).clamp(start, candidates.length).toInt();
    return CandidatePage(
      candidates: start >= candidates.length ? const <QueueCandidate>[] : candidates.sublist(start, end),
      total: candidates.length,
      page: page,
      pageSize: safePageSize,
      revision: revision,
    );
  }

  String? _nonEmpty(String? value) {
    final normalized = value?.trim();
    return normalized == null || normalized.isEmpty ? null : normalized;
  }

  int _podcastTimestamp(Episode episode) {
    return episode.publishedAt ?? episode.addedAt ?? episode.updatedAt ?? 0;
  }

  String _cacheKey(MediaSourceDescriptor source) {
    final user = _ref.read(currentUserProvider).value;
    final userScope = '${user?.id ?? ''}@${user?.server?.url ?? ''}';
    return '$userScope:${source.type.name}:${source.libraryId}:${source.sourceId}:'
        '${source.descending ? 'desc' : 'asc'}:${source.revision ?? ''}';
  }
}

class _ExpandedSourceResult {
  const _ExpandedSourceResult({required this.candidates, required this.revision});

  final List<QueueCandidate> candidates;
  final int? revision;
}
