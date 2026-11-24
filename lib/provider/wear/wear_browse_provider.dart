import 'dart:async';

import 'package:yaabsa/util/local_cover_path.dart';

import 'package:yaabsa/provider/core/socket_work_policy.dart';
import 'package:yaabsa/provider/core/socket_provider.dart';
import 'package:yaabsa/provider/common/library_item_events.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/browse/compact_browse_models.dart';
import 'package:yaabsa/util/browse/compact_browse_repository.dart';

part 'wear_browse_provider.g.dart';

@Riverpod(retry: _noBrowseRetry)
Future<CompactBrowsePage> wearBrowse(Ref ref, CompactBrowseQuery query) async {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) {
    throw StateError('Sign in to browse.');
  }

  Timer? refreshTimer;
  bool needsRefresh = false;

  void scheduleRefresh() {
    needsRefresh = true;
    refreshTimer?.cancel();
    if (!ref.read(socketInteractionActiveProvider)) {
      return;
    }
    refreshTimer = Timer(const Duration(seconds: 1), () {
      if (ref.mounted) {
        ref.invalidateSelf();
      }
    });
  }

  ref.onDispose(() {
    refreshTimer?.cancel();
  });
  ref.listen<bool>(socketInteractionActiveProvider, (_, active) {
    if (active && needsRefresh) {
      scheduleRefresh();
    }
  });

  if (query.section == CompactBrowseSection.downloads) {
    ref.listen(completedDownloadItemIdsProvider, (_, _) {
      scheduleRefresh();
    });
  } else {
    ref.listen(libraryItemMutationProvider, (_, event) {
      if (event != null && (query.libraryId == null || event.libraryId == query.libraryId)) {
        scheduleRefresh();
      }
    });
    if (query.section == CompactBrowseSection.continueListening) {
      ref.listen(remoteMediaProgressUpdateProvider, (previous, next) {
        if (next != null &&
            (previous?.libraryItemId != next.libraryItemId ||
                previous?.episodeId != next.episodeId ||
                previous?.isFinished != next.isFinished)) {
          scheduleRefresh();
        }
      });
    }
  }

  if (query.section == CompactBrowseSection.downloads) {
    final result = await ref
        .read(appDatabaseProvider)
        .getStoredDownloadsPage(userId: user.id, page: query.page, pageSize: compactBrowsePageSize);
    final entries = <CompactBrowseEntry>[];
    for (final download in result.downloads) {
      final item = download.item;
      if (!download.isComplete || item == null || download.tracks.isEmpty) {
        continue;
      }
      final coverPath = await resolveDisplayCoverPath(download.coverPath, cacheKey: 'wear:${user.id}:${item.id}');
      final coverUri = parseCoverPathUri(coverPath);
      entries.add(
        CompactBrowseEntry(
          title: download.episode?.title ?? item.title,
          subtitle: download.episode == null ? item.authorString : item.title,
          itemId: item.id,
          episodeId: download.episode?.id,
          coverUri: coverUri,
        ),
      );
    }
    return CompactBrowsePage(entries: entries, hasMore: result.hasMore);
  }

  final api = ref.watch(absApiProvider);
  if (api == null) {
    throw StateError('The server connection is unavailable.');
  }
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);

  final repository = CompactBrowseRepository(api);
  final result = await repository.load(query, cancelToken: cancelToken);
  if (cancelToken.isCancelled) {
    throw cancelToken.cancelError!;
  }
  return result;
}

Duration? _noBrowseRetry(int retryCount, Object error) => null;
