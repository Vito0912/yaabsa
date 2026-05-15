import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/list/playlist.dart';
import 'package:yaabsa/api/list/playlist_item.dart';
import 'package:yaabsa/components/common/connection_issue_view.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';
import 'package:yaabsa/components/common/managed_list_operations.dart';
import 'package:yaabsa/components/common/managed_multi_book_view.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/common/playlist_provider.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

class PlaylistView extends HookConsumerWidget {
  const PlaylistView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final selectedLibrary = ref.watch(selectedLibraryProvider);
    final serverReachable = ref.watch(serverStatusProvider).value ?? false;

    if (selectedLibrary == null) {
      return const Center(child: Text('No library selected. Please select a library via the switcher.'));
    }

    final libraryId = selectedLibrary.id;
    final api = ref.watch(absApiProvider);
    if (api == null) {
      return ConnectionIssueView.offline();
    }

    final currentUser = ref.watch(currentUserProvider).value;
    final canCreatePlaylists = currentUser != null;

    final playlistStateAsync = ref.watch(playlistsProvider(libraryId));

    return playlistStateAsync.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: (state) {
        final playlists = state.items;
        final allowBookSelection = selectedLibrary.mediaType == 'book';

        final cards = playlists
            .map(
              (playlist) => ManagedMultiBookCardConfig(
                entry: MultiBookEntryData.fromPlaylist(playlist),
                onTap: () {
                  context.push('/playlist/${playlist.id}', extra: MultiBookEntryData.fromPlaylist(playlist));
                },
                onLongPress: _canManagePlaylist(playlist: playlist, currentUserId: currentUser?.id)
                    ? () => _showPlaylistActionsSheet(
                        context: context,
                        ref: ref,
                        libraryId: libraryId,
                        playlist: playlist,
                        allowBookSelection: allowBookSelection,
                      )
                    : null,
              ),
            )
            .toList(growable: false);

        return ManagedMultiBookView(
          title: 'Playlists',
          createLabel: 'New playlist',
          emptyTitle: 'No playlists yet.',
          emptyMessage: 'Create one when you want to queue your next listens.',
          onCreate: canCreatePlaylists
              ? () => _createPlaylist(
                  context: context,
                  ref: ref,
                  libraryId: libraryId,
                  allowBookSelection: allowBookSelection,
                )
              : null,
          scrollController: scrollController,
          api: api,
          cards: cards,
          onRefresh: () => ref.read(playlistsProvider(libraryId).notifier).refresh(withLoading: false),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        if (!serverReachable) {
          return ConnectionIssueView.offline(
            onRetry: () => ref.read(playlistsProvider(libraryId).notifier).refresh(withLoading: true),
          );
        }

        return ConnectionIssueView.requestFailed(
          error: error,
          title: 'Error loading playlists',
          onRetry: () => ref.read(playlistsProvider(libraryId).notifier).refresh(withLoading: true),
        );
      },
    );
  }
}

bool _canManagePlaylist({required Playlist playlist, required String? currentUserId}) {
  if (currentUserId == null || currentUserId.isEmpty) {
    return false;
  }

  return playlist.userId == null || playlist.userId == currentUserId;
}

Future<void> _showPlaylistActionsSheet({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
  required Playlist playlist,
  required bool allowBookSelection,
}) async {
  final selectedAction = await showModalBottomSheet<_PlaylistAction>(
    context: context,
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text(playlist.name, maxLines: 1, overflow: TextOverflow.ellipsis)),
            const Divider(height: 1),
            if (allowBookSelection)
              ListTile(
                leading: const Icon(Icons.menu_book_rounded),
                title: const Text('Edit books'),
                onTap: () => Navigator.of(sheetContext).pop(_PlaylistAction.editBooks),
              ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit details'),
              onTap: () => Navigator.of(sheetContext).pop(_PlaylistAction.edit),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded),
              title: const Text('Delete playlist'),
              onTap: () => Navigator.of(sheetContext).pop(_PlaylistAction.delete),
            ),
          ],
        ),
      );
    },
  );

  if (!context.mounted || selectedAction == null) {
    return;
  }

  switch (selectedAction) {
    case _PlaylistAction.editBooks:
      await _editPlaylistBooks(context: context, ref: ref, libraryId: libraryId, playlist: playlist);
      break;
    case _PlaylistAction.edit:
      await _editPlaylist(context: context, ref: ref, libraryId: libraryId, playlist: playlist);
      break;
    case _PlaylistAction.delete:
      await _deletePlaylist(context: context, ref: ref, libraryId: libraryId, playlist: playlist);
      break;
  }
}

Future<void> _createPlaylist({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
  required bool allowBookSelection,
}) async {
  if (allowBookSelection) {
    await createManagedListEntity(
      context: context,
      formTitle: 'Create playlist',
      booksTitle: 'Edit books',
      createLabel: 'Create',
      selectionRequired: false,
      allowEmptyCreation: true,
      emptyCreationLabel: 'Create empty',
      onCreate: ({required name, description, required bookIds}) {
        return ref
            .read(playlistsProvider(libraryId).notifier)
            .createPlaylist(
              name: name,
              description: description,
              items: bookIds.map((bookId) => <String, dynamic>{'libraryItemId': bookId}).toList(growable: false),
            );
      },
      successMessage: 'Playlist created.',
      errorFallback: 'Could not create playlist.',
    );
    return;
  }

  final metadata = await showListManagementFormDialog(
    context: context,
    title: 'Create playlist',
    confirmLabel: 'Create',
  );
  if (!context.mounted || metadata == null) {
    return;
  }

  await runManagedListMutation(
    context: context,
    action: () => ref
        .read(playlistsProvider(libraryId).notifier)
        .createPlaylist(name: metadata.name, description: metadata.description),
    successMessage: 'Playlist created.',
    errorFallback: 'Could not create playlist.',
  );
}

Future<void> _editPlaylistBooks({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
  required Playlist playlist,
}) async {
  final currentBooks = _playlistBooks(playlist);
  await editManagedListBooks(
    context: context,
    title: 'Edit books',
    confirmLabel: 'Save books',
    selectionRequired: true,
    initialBooks: currentBooks,
    onSave: (bookIds) => ref
        .read(playlistsProvider(libraryId).notifier)
        .replaceBooksInPlaylist(
          playlist.id,
          currentBookIds: currentBooks.map((item) => item.id).toList(growable: false),
          desiredBookIds: bookIds,
        ),
    successMessage: 'Playlist books updated.',
    errorFallback: 'Could not update playlist books.',
  );
}

Future<void> _editPlaylist({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
  required Playlist playlist,
}) async {
  await editManagedListDetails(
    context: context,
    title: 'Edit playlist',
    initialName: playlist.name,
    initialDescription: playlist.description,
    onSave: ({required name, description}) => ref
        .read(playlistsProvider(libraryId).notifier)
        .updatePlaylist(playlist.id, name: name, description: description),
    successMessage: 'Playlist updated.',
    errorFallback: 'Could not update playlist.',
  );
}

Future<void> _deletePlaylist({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
  required Playlist playlist,
}) async {
  await deleteManagedListEntity(
    context: context,
    title: 'Delete playlist?',
    message: '"${playlist.name}" will be permanently removed.',
    onDelete: () => ref.read(playlistsProvider(libraryId).notifier).deletePlaylist(playlist.id),
    successMessage: 'Playlist deleted.',
    errorFallback: 'Could not delete playlist.',
  );
}

List<LibraryItem> _playlistBooks(Playlist playlist) {
  final books = <LibraryItem>[];
  final seen = <String>{};

  for (final item in playlist.items ?? const <PlaylistItem>[]) {
    final libraryItem = item.libraryItem;
    if (libraryItem == null || !seen.add(libraryItem.id)) {
      continue;
    }
    books.add(libraryItem);
  }

  return books;
}

enum _PlaylistAction { editBooks, edit, delete }
