import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/list/collection.dart';
import 'package:yaabsa/api/list/playlist.dart';
import 'package:yaabsa/components/app/library/library_target_picker_sheet.dart';
import 'package:yaabsa/components/common/managed_list_operations.dart';
import 'package:yaabsa/provider/common/collection_provider.dart';
import 'package:yaabsa/provider/common/playlist_provider.dart';

Future<void> addSelectedBooksToPlaylist({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
  required String? currentUserId,
  required List<String> selectedBookIds,
  required VoidCallback onSuccess,
}) async {
  if (selectedBookIds.isEmpty || currentUserId == null || currentUserId.isEmpty) {
    return;
  }

  final targetOption = await showLibraryTargetPickerSheet(
    context: context,
    title: 'Add to playlist',
    emptyMessage: 'No editable playlists found.',
    loadErrorMessage: 'Could not load playlists.',
    loadOptions: () async {
      final playlistsNotifier = ref.read(playlistsProvider(libraryId).notifier);
      var playlists = ref.read(playlistsProvider(libraryId)).value?.items ?? const <Playlist>[];

      if (playlists.isEmpty) {
        await playlistsNotifier.refresh(withLoading: false, forceServer: true);
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

  if (!context.mounted || targetOption == null) {
    return;
  }

  await runManagedListMutation(
    context: context,
    action: () =>
        ref.read(playlistsProvider(libraryId).notifier).addBooksToPlaylist(targetOption.id, bookIds: selectedBookIds),
    successMessage: selectedBookIds.length == 1
        ? 'Added 1 book to "${targetOption.title}".'
        : 'Added ${selectedBookIds.length} books to "${targetOption.title}".',
    errorFallback: 'Could not add books to playlist.',
    onSuccess: onSuccess,
  );
}

Future<void> addSelectedBooksToCollection({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
  required List<String> selectedBookIds,
  required VoidCallback onSuccess,
}) async {
  if (selectedBookIds.isEmpty) {
    return;
  }

  final targetOption = await showLibraryTargetPickerSheet(
    context: context,
    title: 'Add to collection',
    emptyMessage: 'No collections found.',
    loadErrorMessage: 'Could not load collections.',
    loadOptions: () async {
      final collectionsNotifier = ref.read(collectionsProvider(libraryId).notifier);
      var collections = ref.read(collectionsProvider(libraryId)).value?.items ?? const <Collection>[];

      if (collections.isEmpty) {
        await collectionsNotifier.refresh(withLoading: false, forceServer: true);
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
    successMessage: selectedBookIds.length == 1
        ? 'Added 1 book to "${targetOption.title}".'
        : 'Added ${selectedBookIds.length} books to "${targetOption.title}".',
    errorFallback: 'Could not add books to collection.',
    onSuccess: onSuccess,
  );
}
