import 'package:yaabsa/components/app/item/item_progress_actions.dart';
import 'package:material_ui/material_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/request/batch_quick_match_library_items_request.dart';
import 'package:yaabsa/api/list/collection.dart';
import 'package:yaabsa/api/list/playlist.dart';
import 'package:yaabsa/components/app/item/match/quick_match_options_dialog.dart';
import 'package:yaabsa/components/app/library/library_target_picker_sheet.dart';
import 'package:yaabsa/components/common/managed_list_operations.dart';
import 'package:yaabsa/provider/common/collection_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/common/playlist_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/l10n.dart';

Future<void> addSelectedLibraryItemsToPlaylist({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
  required String? currentUserId,
  required List<LibraryItem> items,
  required VoidCallback onSuccess,
}) async {
  final l10n = context.l10n;
  final selectedItems = <String, LibraryItem>{
    for (final item in items)
      if (isBulkSelectableLibraryItem(item)) libraryItemSelectionKey(item): item,
  };
  if (selectedItems.isEmpty || currentUserId == null || currentUserId.isEmpty) {
    return;
  }
  final target = await _showEditablePlaylistPicker(
    context: context,
    ref: ref,
    libraryId: libraryId,
    currentUserId: currentUserId,
    title: l10n.actionAddToPlaylist,
  );
  if (!context.mounted || target == null) {
    return;
  }
  await runManagedListMutation(
    context: context,
    action: () async {
      final api = ref.read(absApiProvider);
      if (api == null) {
        throw Exception('API not available');
      }
      final response = await api.getListApi().addItemsToPlaylist(
        target.id,
        items: selectedItems.values
            .map(
              (item) => <String, dynamic>{
                'libraryItemId': item.id,
                if (selectablePodcastEpisode(item) != null) 'episodeId': selectablePodcastEpisode(item)!.id,
              },
            )
            .toList(growable: false),
      );
      if (response.data == null) {
        throw Exception('No playlist data returned from add request.');
      }
      await ref
          .read(playlistsProvider(libraryId).notifier)
          .refresh(withLoading: false, forceServer: true, invalidatePending: true);
    },
    successMessage: l10n.statusItemsAddedToPlaylist(selectedItems.length, target.title),
    errorFallback: l10n.errorAddItemsToPlaylistFailed,
    onSuccess: onSuccess,
  );
}

Future<void> addSelectedBooksToPlaylist({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
  required String? currentUserId,
  required List<String> selectedBookIds,
  required VoidCallback onSuccess,
}) async {
  final l10n = context.l10n;
  if (selectedBookIds.isEmpty || currentUserId == null || currentUserId.isEmpty) {
    return;
  }

  final targetOption = await _showEditablePlaylistPicker(
    context: context,
    ref: ref,
    libraryId: libraryId,
    currentUserId: currentUserId,
    title: l10n.actionAddToPlaylist,
  );

  if (!context.mounted || targetOption == null) {
    return;
  }

  await runManagedListMutation(
    context: context,
    action: () =>
        ref.read(playlistsProvider(libraryId).notifier).addBooksToPlaylist(targetOption.id, bookIds: selectedBookIds),
    successMessage: l10n.statusBooksAddedToTarget(selectedBookIds.length, targetOption.title),
    errorFallback: l10n.errorAddBooksToPlaylistFailed,
    onSuccess: onSuccess,
  );
}

Future<void> addSelectedPodcastEpisodesToPlaylist({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
  required String? currentUserId,
  required String podcastItemId,
  required List<String> selectedEpisodeIds,
  required VoidCallback onSuccess,
}) async {
  final l10n = context.l10n;
  if (selectedEpisodeIds.isEmpty || currentUserId == null || currentUserId.isEmpty) {
    return;
  }

  final targetOption = await _showEditablePlaylistPicker(
    context: context,
    ref: ref,
    libraryId: libraryId,
    currentUserId: currentUserId,
    title: l10n.headingAddEpisodesToPlaylist,
  );

  if (!context.mounted || targetOption == null) {
    return;
  }

  await runManagedListMutation(
    context: context,
    action: () => ref
        .read(playlistsProvider(libraryId).notifier)
        .addPodcastEpisodesToPlaylist(targetOption.id, libraryItemId: podcastItemId, episodeIds: selectedEpisodeIds),
    successMessage: l10n.statusEpisodesAddedToPlaylist(selectedEpisodeIds.length, targetOption.title),
    errorFallback: l10n.errorAddEpisodesToPlaylistFailed,
    onSuccess: onSuccess,
  );
}

Future<LibraryTargetPickerOption?> _showEditablePlaylistPicker({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
  required String currentUserId,
  required String title,
}) {
  final l10n = context.l10n;
  return showLibraryTargetPickerSheet(
    context: context,
    title: title,
    emptyMessage: l10n.statusNoEditablePlaylistsFound,
    loadErrorMessage: l10n.errorLoadPlaylistsFailed,
    loadOptions: () async {
      final playlistsNotifier = ref.read(playlistsProvider(libraryId).notifier);
      await playlistsNotifier.ensureAllLoaded();
      var playlists = ref.read(playlistsProvider(libraryId)).value?.items ?? const <Playlist>[];

      if (playlists.isEmpty) {
        await playlistsNotifier.refresh(withLoading: false, forceServer: true);
        await playlistsNotifier.ensureAllLoaded();
        playlists = ref.read(playlistsProvider(libraryId)).value?.items ?? const <Playlist>[];
      }

      final editablePlaylists = playlists
          .where((playlist) => playlist.userId == null || playlist.userId == currentUserId)
          .toList(growable: false);

      return editablePlaylists
          .map(
            (playlist) =>
                LibraryTargetPickerOption(id: playlist.id, title: playlist.name, subtitle: playlist.description),
          )
          .toList(growable: false);
    },
  );
}

Future<void> addSelectedBooksToCollection({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
  required List<String> selectedBookIds,
  required VoidCallback onSuccess,
}) async {
  final l10n = context.l10n;
  if (selectedBookIds.isEmpty) {
    return;
  }

  final targetOption = await showLibraryTargetPickerSheet(
    context: context,
    title: l10n.actionAddToCollection,
    emptyMessage: l10n.statusNoCollectionsFound,
    loadErrorMessage: l10n.errorLoadCollectionsFailed,
    loadOptions: () async {
      final collectionsNotifier = ref.read(collectionsProvider(libraryId).notifier);
      await collectionsNotifier.ensureAllLoaded();
      var collections = ref.read(collectionsProvider(libraryId)).value?.items ?? const <Collection>[];

      if (collections.isEmpty) {
        await collectionsNotifier.refresh(withLoading: false, forceServer: true);
        await collectionsNotifier.ensureAllLoaded();
        collections = ref.read(collectionsProvider(libraryId)).value?.items ?? const <Collection>[];
      }

      return collections
          .map(
            (collection) =>
                LibraryTargetPickerOption(id: collection.id, title: collection.name, subtitle: collection.description),
          )
          .toList(growable: false);
    },
  );

  if (!context.mounted || targetOption == null) {
    return;
  }

  await runManagedListMutation(
    context: context,
    action: () => ref
        .read(collectionsProvider(libraryId).notifier)
        .addBooksToCollection(targetOption.id, bookIds: selectedBookIds),
    successMessage: l10n.statusBooksAddedToTarget(selectedBookIds.length, targetOption.title),
    errorFallback: l10n.errorAddBooksToCollectionFailed,
    onSuccess: onSuccess,
  );
}

Future<void> quickMatchSelectedBooks({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
  required List<LibraryItem> selectedItems,
  required VoidCallback onSuccess,
}) async {
  final l10n = context.l10n;
  if (selectedItems.isEmpty) {
    return;
  }

  final selectedBookIds = selectedItems.map((item) => item.id).toList(growable: false);

  final defaultProvider = _resolveLibraryDefaultProvider(ref: ref, libraryId: libraryId);

  final options = await showQuickMatchOptionsDialog(
    context: context,
    mediaType: 'book',
    previewItems: selectedItems,
    title: l10n.headingQuickMatchSelectedBooks,
    confirmLabel: l10n.actionStart,
    initialProvider: defaultProvider,
  );

  if (!context.mounted || options == null) {
    return;
  }

  final api = ref.read(absApiProvider);
  if (api == null) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.errorConnectionUnavailable)));
    }
    return;
  }

  try {
    final started = await api.getLibraryItemApi().batchQuickMatchLibraryItems(
      request: BatchQuickMatchLibraryItemsRequest(libraryItemIds: selectedBookIds, options: options),
    );

    if (!context.mounted) {
      return;
    }

    if (started) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.statusQuickMatchBatchStarted(selectedBookIds.length))));
      onSuccess();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.errorStartQuickMatchBatchFailed)));
    }
  } catch (error) {
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.errorQuickMatchBatchFailed(error.toString()))));
  }
}

String? _resolveLibraryDefaultProvider({required WidgetRef ref, required String libraryId}) {
  final selectedLibrary = ref.read(selectedLibraryProvider);
  if (selectedLibrary?.id == libraryId && selectedLibrary?.provider.trim().isNotEmpty == true) {
    return selectedLibrary?.provider;
  }

  final userLibraries = ref.read(userLibrariesProvider).value;
  if (userLibraries != null) {
    for (final library in userLibraries) {
      if (library.id != libraryId || library.provider.trim().isEmpty) {
        continue;
      }
      return library.provider;
    }
  }

  if (selectedLibrary?.provider.trim().isNotEmpty == true) {
    return selectedLibrary?.provider;
  }

  return null;
}
