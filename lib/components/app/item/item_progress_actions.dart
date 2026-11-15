import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/app/item/book_collection_membership_dialog.dart';
import 'package:yaabsa/components/app/item/book_playlist_membership_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/common/managed_list_operations.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/common/collection_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

Episode? selectablePodcastEpisode(LibraryItem item) {
  if (!supportsPodcastEpisodeFinishedProgressUpdates(item)) {
    return null;
  }
  return item.recentEpisode ?? item.media?.podcastMedia?.episodes?.singleOrNull;
}

String libraryItemSelectionKey(LibraryItem item) {
  return mediaProgressKey(item.id, selectablePodcastEpisode(item)?.id);
}

bool isBulkSelectableLibraryItem(LibraryItem item) {
  return item.collapsedSeries == null &&
      (supportsFinishedProgressUpdates(item) || selectablePodcastEpisode(item) != null);
}

bool supportsFinishedProgressUpdates(LibraryItem item) {
  return item.mediaType == 'book' || item.media?.bookMedia != null;
}

bool supportsPodcastEpisodeFinishedProgressUpdates(LibraryItem item) {
  return item.mediaType == 'podcast' || item.media?.podcastMedia != null;
}

bool canAddLibraryItemToPlaylist(LibraryItem item, String? currentUserId) {
  final libraryId = item.libraryId;
  return supportsFinishedProgressUpdates(item) &&
      libraryId != null &&
      libraryId.isNotEmpty &&
      currentUserId != null &&
      currentUserId.isNotEmpty;
}

bool canAddLibraryItemToCollection(LibraryItem item, {required bool canUpdate}) {
  final libraryId = item.libraryId;
  return supportsFinishedProgressUpdates(item) && libraryId != null && libraryId.isNotEmpty && canUpdate;
}

Future<void> addLibraryItemToPlaylist({
  required BuildContext context,
  required WidgetRef ref,
  required LibraryItem item,
  required String? currentUserId,
}) async {
  if (!canAddLibraryItemToPlaylist(item, currentUserId)) {
    return;
  }

  await showBookPlaylistMembershipDialog(context: context, item: item);
}

Future<void> addLibraryItemToCollection({
  required BuildContext context,
  required WidgetRef ref,
  required LibraryItem item,
  required bool canUpdate,
}) async {
  if (!canAddLibraryItemToCollection(item, canUpdate: canUpdate)) {
    return;
  }

  if (!ref.read(collectionMembershipEditingAllowedProvider)) return;
  await showBookCollectionMembershipDialog(context: context, item: item);
}

bool isLibraryItemFinished(LibraryItem item, Map<String, MediaProgress> progressByKey) {
  if (!supportsFinishedProgressUpdates(item)) {
    return false;
  }
  return progressByKey[item.id]?.isFinished ?? false;
}

bool isPodcastEpisodeFinished({
  required LibraryItem item,
  required Episode episode,
  required Map<String, MediaProgress> progressByKey,
}) {
  if (!supportsPodcastEpisodeFinishedProgressUpdates(item)) {
    return false;
  }
  return progressByKey[mediaProgressKey(item.id, episode.id)]?.isFinished ?? false;
}

bool areAllSupportedLibraryItemsFinished(List<LibraryItem> items, Map<String, MediaProgress> progressByKey) {
  var hasSupportedItems = false;
  for (final item in items) {
    if (!isBulkSelectableLibraryItem(item)) {
      continue;
    }

    hasSupportedItems = true;
    if (!(progressByKey[libraryItemSelectionKey(item)]?.isFinished ?? false)) {
      return false;
    }
  }

  return hasSupportedItems;
}

Future<void> _setLibraryItemFinishedState({
  required BuildContext context,
  required WidgetRef ref,
  required LibraryItem item,
  required bool isFinished,
}) async {
  const stateLabel = 'finished';

  if (!supportsFinishedProgressUpdates(item)) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Progress updates are currently available for books only.')));
    return;
  }

  await runManagedListMutation(
    context: context,
    action: () async {
      final api = ref.read(absApiProvider);
      if (api == null) {
        throw Exception('API not available');
      }

      if (isFinished) {
        await api.getMeApi().patchMediaProgress(item.id, updatePayload: const <String, dynamic>{'isFinished': true});
        await ref.read(mediaProgressProvider.notifier).fetchOrRefreshIndividualProgress(item.id);
        return;
      }

      await _deleteMediaProgressRecord(ref: ref, api: api, libraryItemId: item.id);
    },
    successMessage: isFinished ? 'Marked "${item.title}" as $stateLabel.' : 'Cleared progress for "${item.title}".',
    errorFallback: isFinished ? 'Could not mark item as $stateLabel.' : 'Could not clear progress for "${item.title}".',
  );
}

Future<void> _deleteMediaProgressRecord({
  required WidgetRef ref,
  required ABSApi api,
  required String libraryItemId,
  String? episodeId,
}) async {
  final progressKey = mediaProgressKey(libraryItemId, episodeId);
  final notifier = ref.read(mediaProgressProvider.notifier);
  var progress = notifier.progressForKey(progressKey);
  progress ??= await notifier.fetchOrRefreshIndividualProgress(libraryItemId, episodeId: episodeId);
  if (progress == null) {
    return;
  }

  if (api.user?.id != progress.userId) {
    throw Exception('The active user changed before progress could be cleared.');
  }

  final deleted = await api.getMeApi().deleteMediaProgress(progress.id);
  if (!deleted) {
    throw Exception('The server did not delete the progress record.');
  }

  await notifier.removeProgressRecordLocally(libraryItemId, episodeId: episodeId, userId: progress.userId);
}

Future<void> markLibraryItemAsFinished({
  required BuildContext context,
  required WidgetRef ref,
  required LibraryItem item,
}) async {
  return _setLibraryItemFinishedState(context: context, ref: ref, item: item, isFinished: true);
}

Future<void> markLibraryItemAsUnfinished({
  required BuildContext context,
  required WidgetRef ref,
  required LibraryItem item,
}) async {
  return _setLibraryItemFinishedState(context: context, ref: ref, item: item, isFinished: false);
}

Future<void> setLibraryItemProgress({
  required BuildContext context,
  required WidgetRef ref,
  required LibraryItem item,
  required Episode? episode,
  required double progress,
  required double durationSeconds,
  required DateTime startedDate,
  required DateTime? finishedDate,
}) async {
  if (durationSeconds <= 0) {
    return;
  }

  final boundedProgress = progress.clamp(0.0, 1.0).toDouble();
  final currentTime = durationSeconds * boundedProgress;
  final isFinished = boundedProgress >= 1.0;
  final selectedFinishedDate = isFinished ? finishedDate ?? startedDate : null;
  final startedAt = _calendarDateTimestamp(startedDate);
  final finishedAt = selectedFinishedDate == null ? null : _calendarDateTimestamp(selectedFinishedDate);

  await runManagedListMutation(
    context: context,
    action: () async {
      final api = ref.read(absApiProvider);
      if (api == null) {
        throw Exception('API not available');
      }

      final progressNotifier = ref.read(mediaProgressProvider.notifier);
      final progressKey = mediaProgressKey(item.id, episode?.id);
      var existingProgress = progressNotifier.progressForKey(progressKey);
      existingProgress ??= await progressNotifier.fetchOrRefreshIndividualProgress(item.id, episodeId: episode?.id);
      final existingFinishedAt = existingProgress?.finishedAt;
      final didChangeStartedDate =
          existingProgress != null && !_hasSameCalendarDate(existingProgress.startedAt, startedDate);
      final didChangeFinishedDate =
          existingProgress != null &&
          isFinished &&
          selectedFinishedDate != null &&
          (existingFinishedAt == null || !_hasSameCalendarDate(existingFinishedAt, selectedFinishedDate));
      final shouldReplaceProgress = didChangeStartedDate || didChangeFinishedDate;

      if (shouldReplaceProgress) {
        await _deleteMediaProgressRecord(ref: ref, api: api, libraryItemId: item.id, episodeId: episode?.id);
      }

      final updatePayload = existingProgress == null || shouldReplaceProgress
          ? _newProgressPayload(
              durationSeconds: durationSeconds,
              currentTime: currentTime,
              progress: boundedProgress,
              isFinished: isFinished,
              startedAt: startedAt,
              finishedAt: finishedAt,
            )
          : buildChangedProgressPayload(
              existingProgress: existingProgress,
              durationSeconds: durationSeconds,
              currentTime: currentTime,
              progress: boundedProgress,
              isFinished: isFinished,
              selectedFinishedDate: selectedFinishedDate,
              finishedAt: finishedAt,
            );

      if (updatePayload.isEmpty) {
        return;
      }

      await api.getMeApi().patchMediaProgress(item.id, episodeId: episode?.id, updatePayload: updatePayload);
      await progressNotifier.fetchOrRefreshIndividualProgress(item.id, episodeId: episode?.id);
    },
    successMessage: 'Progress updated for "${episode?.title ?? item.title}".',
    errorFallback: 'Could not update progress.',
  );
}

Map<String, dynamic> _newProgressPayload({
  required double durationSeconds,
  required double currentTime,
  required double progress,
  required bool isFinished,
  required int startedAt,
  required int? finishedAt,
}) {
  final payload = <String, dynamic>{
    'duration': durationSeconds,
    'currentTime': currentTime,
    'progress': progress,
    'isFinished': isFinished,
    'createdAt': startedAt,
  };

  if (finishedAt != null) {
    payload['finishedAt'] = finishedAt;
  }

  return payload;
}

@visibleForTesting
Map<String, dynamic> buildChangedProgressPayload({
  required MediaProgress existingProgress,
  required double durationSeconds,
  required double currentTime,
  required double progress,
  required bool isFinished,
  required DateTime? selectedFinishedDate,
  required int? finishedAt,
}) {
  final updatePayload = <String, dynamic>{};

  if (existingProgress.duration != durationSeconds) {
    updatePayload['duration'] = durationSeconds;
  }
  if (existingProgress.currentTime != currentTime) {
    updatePayload['currentTime'] = currentTime;
  }
  if (existingProgress.progress != progress) {
    updatePayload['progress'] = progress;
  }
  if (existingProgress.isFinished != isFinished) {
    updatePayload['isFinished'] = isFinished;
  }

  final existingFinishedAt = existingProgress.finishedAt;
  final finishedDateChanged = existingFinishedAt == null
      ? selectedFinishedDate != null
      : selectedFinishedDate == null || !_hasSameCalendarDate(existingFinishedAt, selectedFinishedDate);
  if (finishedDateChanged) {
    updatePayload['finishedAt'] = finishedAt;
  }

  return updatePayload;
}

bool _hasSameCalendarDate(int timestamp, DateTime selectedDate) {
  final existingDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return existingDate.year == selectedDate.year &&
      existingDate.month == selectedDate.month &&
      existingDate.day == selectedDate.day;
}

int _calendarDateTimestamp(DateTime date) {
  return DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
}

Future<void> _setPodcastEpisodeFinishedState({
  required BuildContext context,
  required WidgetRef ref,
  required LibraryItem item,
  required Episode episode,
  required bool isFinished,
}) async {
  const stateLabel = 'finished';

  if (!supportsPodcastEpisodeFinishedProgressUpdates(item)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Progress updates are currently available for podcast episodes only.')),
    );
    return;
  }

  final rawTitle = episode.title?.trim();
  final episodeTitle = (rawTitle == null || rawTitle.isEmpty) ? 'Episode' : rawTitle;

  await runManagedListMutation(
    context: context,
    action: () async {
      final api = ref.read(absApiProvider);
      if (api == null) {
        throw Exception('API not available');
      }

      if (isFinished) {
        await api.getMeApi().patchMediaProgress(
          item.id,
          episodeId: episode.id,
          updatePayload: const <String, dynamic>{'isFinished': true},
        );
        await ref.read(mediaProgressProvider.notifier).fetchOrRefreshIndividualProgress(item.id, episodeId: episode.id);
        return;
      }

      await _deleteMediaProgressRecord(ref: ref, api: api, libraryItemId: item.id, episodeId: episode.id);
    },
    successMessage: isFinished ? 'Marked "$episodeTitle" as $stateLabel.' : 'Cleared progress for "$episodeTitle".',
    errorFallback: isFinished
        ? 'Could not mark episode as $stateLabel.'
        : 'Could not clear progress for "$episodeTitle".',
  );
}

Future<void> markPodcastEpisodeAsFinished({
  required BuildContext context,
  required WidgetRef ref,
  required LibraryItem item,
  required Episode episode,
}) async {
  return _setPodcastEpisodeFinishedState(context: context, ref: ref, item: item, episode: episode, isFinished: true);
}

Future<void> markPodcastEpisodeAsUnfinished({
  required BuildContext context,
  required WidgetRef ref,
  required LibraryItem item,
  required Episode episode,
}) async {
  return _setPodcastEpisodeFinishedState(context: context, ref: ref, item: item, episode: episode, isFinished: false);
}

Future<void> _setLibraryItemsFinishedState({
  required BuildContext context,
  required WidgetRef ref,
  required List<LibraryItem> items,
  required bool isFinished,
  VoidCallback? onSuccess,
}) async {
  final stateLabel = isFinished ? 'finished' : 'unfinished';

  final selectedItems = <String, LibraryItem>{
    for (final item in items)
      if (isBulkSelectableLibraryItem(item)) libraryItemSelectionKey(item): item,
  };

  if (selectedItems.isEmpty) {
    return;
  }

  await runManagedListMutation(
    context: context,
    action: () async {
      final api = ref.read(absApiProvider);
      if (api == null) {
        throw Exception('API not available');
      }

      final payloads = selectedItems.values
          .map(
            (item) => <String, dynamic>{
              'libraryItemId': item.id,
              if (selectablePodcastEpisode(item) != null) 'episodeId': selectablePodcastEpisode(item)!.id,
              'isFinished': isFinished,
            },
          )
          .toList(growable: false);

      await api.getMeApi().batchUpdateMediaProgress(payloads);
      await ref.read(mediaProgressProvider.notifier).refreshAllProgress(clearBefore: false);
    },
    successMessage: 'Marked ${selectedItems.length} selected item(s) as $stateLabel.',
    errorFallback: 'Could not mark selected items as $stateLabel.',
    onSuccess: onSuccess,
  );
}

Future<void> markLibraryItemsAsFinished({
  required BuildContext context,
  required WidgetRef ref,
  required List<LibraryItem> items,
  VoidCallback? onSuccess,
}) async {
  return _setLibraryItemsFinishedState(
    context: context,
    ref: ref,
    items: items,
    isFinished: true,
    onSuccess: onSuccess,
  );
}

Future<void> markLibraryItemsAsUnfinished({
  required BuildContext context,
  required WidgetRef ref,
  required List<LibraryItem> items,
  VoidCallback? onSuccess,
}) async {
  return _setLibraryItemsFinishedState(
    context: context,
    ref: ref,
    items: items,
    isFinished: false,
    onSuccess: onSuccess,
  );
}
