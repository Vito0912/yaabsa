import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/list/playlist.dart';
import 'package:yaabsa/api/list/playlist_item.dart';
import 'package:yaabsa/components/common/connection_issue_view.dart';
import 'package:yaabsa/components/common/list_entity_missing_view.dart';
import 'package:yaabsa/components/common/managed_list_operations.dart';
import 'package:yaabsa/components/common/library_item_widget.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/components/common/scroll_to_top_button.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/common/playlist_provider.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/layout_sizes.dart';

class PlaylistDetailView extends HookConsumerWidget {
  const PlaylistDetailView({required this.playlistId, super.key, this.initialEntry});

  final String playlistId;
  final MultiBookEntryData? initialEntry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final selectedLibrary = ref.watch(selectedLibraryProvider);
    final serverReachable = ref.watch(serverStatusProvider).value ?? false;
    if (selectedLibrary == null) {
      return const Center(child: Text('No library selected. Please select a library via the switcher.'));
    }

    final api = ref.watch(absApiProvider);
    if (api == null) {
      return ConnectionIssueView.offline();
    }

    final libraryId = selectedLibrary.id;
    final allPlaylistsAsync = ref.watch(playlistsProvider(libraryId));
    final currentUserId = ref.watch(currentUserProvider).value?.id;
    final allowBookSelection = selectedLibrary.mediaType == 'book';
    final resolvedPlaylist = _resolvePlaylist(playlistId, allPlaylistsAsync.value?.items);
    final resolvedEntry = _resolveEntry(playlistId, initialEntry, resolvedPlaylist);

    if (resolvedPlaylist == null) {
      if (allPlaylistsAsync.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (allPlaylistsAsync.hasError) {
        if (!serverReachable) {
          return ConnectionIssueView.offline(
            onRetry: () => ref.read(playlistsProvider(libraryId).notifier).refresh(withLoading: true),
          );
        }

        return ConnectionIssueView.requestFailed(
          error: allPlaylistsAsync.error ?? Exception('Unknown playlist loading error.'),
          title: 'Playlist details could not be loaded',
          onRetry: () => ref.read(playlistsProvider(libraryId).notifier).refresh(withLoading: true),
        );
      }

      return const ListEntityMissingView(
        icon: Icons.playlist_play_rounded,
        title: 'Playlist is no longer available',
        message: 'It may have been deleted or moved to another user.',
      );
    }

    final playlistItems = resolvedPlaylist.items ?? const <PlaylistItem>[];
    final libraryItems = _playlistLibraryItems(playlistItems);
    final missingCount = (playlistItems.length - libraryItems.length).clamp(0, playlistItems.length);
    final canManagePlaylist = _canManagePlaylist(playlist: resolvedPlaylist, currentUserId: currentUserId);
    final description = resolvedPlaylist.description?.trim();

    return LayoutBuilder(
      builder: (context, constraints) {
        final gridLayout = appCenteredGridLayout(constraints.maxWidth);
        final horizontalPadding = gridLayout.horizontalPadding;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                    tooltip: 'Back',
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      resolvedEntry?.title ?? resolvedPlaylist.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (canManagePlaylist)
                    PopupMenuButton<_PlaylistDetailAction>(
                      tooltip: 'Playlist actions',
                      onSelected: (action) => _handlePlaylistAction(
                        context: context,
                        ref: ref,
                        libraryId: libraryId,
                        playlist: resolvedPlaylist,
                        allowBookSelection: allowBookSelection,
                        action: action,
                      ),
                      itemBuilder: (context) {
                        final items = <PopupMenuEntry<_PlaylistDetailAction>>[];
                        if (allowBookSelection) {
                          items.add(
                            const PopupMenuItem<_PlaylistDetailAction>(
                              value: _PlaylistDetailAction.editBooks,
                              child: Text('Edit books'),
                            ),
                          );
                        }
                        items.addAll(const [
                          PopupMenuItem<_PlaylistDetailAction>(
                            value: _PlaylistDetailAction.edit,
                            child: Text('Edit details'),
                          ),
                          PopupMenuItem<_PlaylistDetailAction>(
                            value: _PlaylistDetailAction.delete,
                            child: Text('Delete playlist'),
                          ),
                        ]);
                        return items;
                      },
                    ),
                ],
              ),
            ),
            if (description != null && description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            if (missingCount > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '$missingCount playlist entr${missingCount == 1 ? 'y is' : 'ies are'} not directly displayable.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            if (libraryItems.isEmpty)
              const Expanded(child: Center(child: Text('No library items found in this playlist.')))
            else
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: RefreshIndicator(
                        onRefresh: () => ref.read(playlistsProvider(libraryId).notifier).refresh(withLoading: false),
                        child: AlignedGridView.count(
                          controller: scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 16),
                          crossAxisCount: gridLayout.crossAxisCount,
                          mainAxisSpacing: appGridSpacing,
                          crossAxisSpacing: appGridSpacing,
                          itemCount: libraryItems.length,
                          itemBuilder: (context, index) {
                            final item = libraryItems[index];
                            return LibraryItemWidget(
                              item,
                              api,
                              showProgress: true,
                              squareCover: true,
                              onPlay: () {
                                audioHandler.playLibraryItemFromPlaylistView(
                                  item,
                                  libraryId: libraryId,
                                  playlistId: playlistId,
                                  itemIndex: index,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    ScrollToTopButton(controller: scrollController),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

Playlist? _resolvePlaylist(String playlistId, List<Playlist>? allPlaylists) {
  if (allPlaylists == null) return null;

  for (final playlist in allPlaylists) {
    if (playlist.id == playlistId) {
      return playlist;
    }
  }

  return null;
}

MultiBookEntryData? _resolveEntry(String playlistId, MultiBookEntryData? initialEntry, Playlist? playlist) {
  if (initialEntry != null && initialEntry.id == playlistId) {
    return initialEntry;
  }

  if (playlist != null) {
    return MultiBookEntryData.fromPlaylist(playlist);
  }

  return initialEntry;
}

List<LibraryItem> _playlistLibraryItems(List<PlaylistItem> playlistItems) {
  final items = <LibraryItem>[];
  final seenIds = <String>{};

  for (final playlistItem in playlistItems) {
    final libraryItem = playlistItem.libraryItem;
    if (libraryItem == null) {
      continue;
    }

    if (seenIds.add(libraryItem.id)) {
      items.add(libraryItem);
    }
  }

  return items;
}

bool _canManagePlaylist({required Playlist playlist, required String? currentUserId}) {
  if (currentUserId == null || currentUserId.isEmpty) {
    return false;
  }

  return playlist.userId == null || playlist.userId == currentUserId;
}

Future<void> _handlePlaylistAction({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
  required Playlist playlist,
  required bool allowBookSelection,
  required _PlaylistDetailAction action,
}) async {
  switch (action) {
    case _PlaylistDetailAction.editBooks:
      if (!allowBookSelection) {
        return;
      }
      await _editPlaylistBooks(context: context, ref: ref, libraryId: libraryId, playlist: playlist);
      break;
    case _PlaylistDetailAction.edit:
      await _editPlaylist(context: context, ref: ref, libraryId: libraryId, playlist: playlist);
      break;
    case _PlaylistDetailAction.delete:
      await _deletePlaylist(context: context, ref: ref, libraryId: libraryId, playlist: playlist);
      break;
  }
}

Future<void> _editPlaylistBooks({
  required BuildContext context,
  required WidgetRef ref,
  required String libraryId,
  required Playlist playlist,
}) async {
  final currentBooks = _playlistLibraryItems(playlist.items ?? const <PlaylistItem>[]);
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
    popOnSuccess: true,
  );
}

enum _PlaylistDetailAction { editBooks, edit, delete }
