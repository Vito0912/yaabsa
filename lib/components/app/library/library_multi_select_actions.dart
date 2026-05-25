import 'package:flutter/material.dart';
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

Future<void> quickMatchSelectedBooks({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
  required List<LibraryItem> selectedItems,
  required VoidCallback onSuccess,
}) async {
  if (selectedItems.isEmpty) {
    return;
  }

  final selectedBookIds = selectedItems.map((item) => item.id).toList(growable: false);

  final defaultProvider = _resolveLibraryDefaultProvider(ref: ref, libraryId: libraryId);

  final options = await showQuickMatchOptionsDialog(
    context: context,
    mediaType: 'book',
    previewItems: selectedItems,
    title: 'Quick match selected books',
    confirmLabel: 'Start',
    initialProvider: defaultProvider,
  );

  if (!context.mounted || options == null) {
    return;
  }

  final api = ref.read(absApiProvider);
  if (api == null) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No API session available.')));
    }
    return;
  }

  try {
    final response = await api.getLibraryItemApi().batchQuickMatchLibraryItems(
      request: BatchQuickMatchLibraryItemsRequest(libraryItemIds: selectedBookIds, options: options),
    );

    if (!context.mounted) {
      return;
    }

    final updates = response.updates;
    final responseError = response.error?.trim();

    final message = responseError != null && responseError.isNotEmpty
        ? responseError
        : updates > 0
        ? 'Metadata change request sent for ${selectedBookIds.length == 1 ? '1 book' : '${selectedBookIds.length} books'}.'
        : 'Metadata change request sent.';

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

    onSuccess();
  } catch (error) {
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not quick match selected books: $error')));
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
