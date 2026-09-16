import 'package:material_ui/material_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/components/app/library/library_multi_select_actions.dart';
import 'package:yaabsa/components/common/managed_list_operations.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
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

  await addSelectedBooksToPlaylist(
    context: context,
    ref: ref,
    libraryId: item.libraryId!,
    currentUserId: currentUserId,
    selectedBookIds: <String>[item.id],
    onSuccess: () {},
  );
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

  await addSelectedBooksToCollection(
    context: context,
    ref: ref,
    libraryId: item.libraryId!,
    selectedBookIds: <String>[item.id],
    onSuccess: () {},
  );
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
  final stateLabel = isFinished ? 'finished' : 'unfinished';

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

      await api.getMeApi().patchMediaProgress(item.id, updatePayload: <String, dynamic>{'isFinished': isFinished});
      await ref.read(mediaProgressProvider.notifier).fetchOrRefreshIndividualProgress(item.id);
    },
    successMessage: 'Marked "${item.title}" as $stateLabel.',
    errorFallback: 'Could not mark item as $stateLabel.',
  );
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

Future<void> _setPodcastEpisodeFinishedState({
  required BuildContext context,
  required WidgetRef ref,
  required LibraryItem item,
  required Episode episode,
  required bool isFinished,
}) async {
  final stateLabel = isFinished ? 'finished' : 'unfinished';

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

      await api.getMeApi().patchMediaProgress(
        item.id,
        episodeId: episode.id,
        updatePayload: <String, dynamic>{'isFinished': isFinished},
      );
      await ref.read(mediaProgressProvider.notifier).fetchOrRefreshIndividualProgress(item.id, episodeId: episode.id);
    },
    successMessage: 'Marked "$episodeTitle" as $stateLabel.',
    errorFallback: 'Could not mark episode as $stateLabel.',
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
