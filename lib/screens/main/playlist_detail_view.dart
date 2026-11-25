import 'dart:async';

import 'package:dio/dio.dart';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/list/playlist.dart';
import 'package:yaabsa/api/list/playlist_item.dart';
import 'package:yaabsa/components/app/library/library_grid_layout_builder.dart';
import 'package:yaabsa/components/common/connection_issue_view.dart';
import 'package:yaabsa/components/common/list_entity_missing_view.dart';
import 'package:yaabsa/components/common/managed_list_operations.dart';
import 'package:yaabsa/components/common/library_item_widget.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/features/library/widgets/managed_list_detail_frame.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/common/playlist_provider.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';
import 'package:yaabsa/util/random_playback.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/menus/yaabsa_context_menu_button.dart';

class PlaylistDetailView extends HookConsumerWidget {
  const PlaylistDetailView({required this.playlistId, super.key, this.initialEntry, this.libraryId});

  final String playlistId;
  final String? libraryId;
  final MultiBookEntryData? initialEntry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final selectedLibrary = ref.watch(selectedLibraryProvider);
    final serverReachable = ref.watch(serverStatusProvider).value ?? false;
    final libraryId = this.libraryId ?? selectedLibrary?.id;
    if (libraryId == null || libraryId.isEmpty) {
      return Center(child: Text(context.l10n.errorNoLibrarySelected));
    }

    final api = ref.watch(absApiProvider);
    if (api == null) {
      return ConnectionIssueView.offline();
    }

    final details = ref.watch(playlistByIdProvider(libraryId, playlistId));
    final currentUserId = ref.watch(currentUserProvider).value?.id;
    ref.watch(userSettingsWatcherProvider);
    final resolvedPlaylist = details.hasError ? null : details.value;
    final allowBookSelection = resolvedPlaylist?.items?.every((item) => item.episodeId == null) ?? false;
    final resolvedEntry = _resolveEntry(playlistId, initialEntry, resolvedPlaylist);

    if (resolvedPlaylist == null) {
      if (details.isLoading) {
        return const Center(child: YaabsaCircularProgressIndicator());
      }
      final error = details.error;
      final missing = error is DioException && error.response?.statusCode == 404;
      if (details.hasError && !missing) {
        if (!serverReachable) {
          return ConnectionIssueView.offline(
            onRetry: () => ref.refresh(playlistByIdProvider(libraryId, playlistId).future),
          );
        }

        return ConnectionIssueView.requestFailed(
          error: details.error ?? Exception(context.l10n.errorUnableToLoadContent),
          title: context.l10n.errorPlaylistUnavailable,
          onRetry: () => ref.refresh(playlistByIdProvider(libraryId, playlistId).future),
        );
      }

      return ListEntityMissingView(
        icon: Icons.playlist_play_rounded,
        title: context.l10n.errorPlaylistMissing,
        message: context.l10n.statusListMayBeRemoved,
      );
    }

    final playlistItems = resolvedPlaylist.items ?? const <PlaylistItem>[];
    final displayEntries = _playlistDisplayEntries(playlistItems);
    final missingCount = (playlistItems.length - displayEntries.length).clamp(0, playlistItems.length);
    final canManagePlaylist = _canManagePlaylist(playlist: resolvedPlaylist, currentUserId: currentUserId);
    final showShuffleButton =
        currentUserId != null &&
        ref
            .read(settingsManagerProvider.notifier)
            .getUserSetting<bool>(currentUserId, SettingKeys.showShuffleButton, defaultValue: false);
    final description = resolvedPlaylist.description?.trim();

    return LibraryGridLayoutBuilder(
      builder: (context, _, tileWidth, _) => ManagedListDetailFrame(
        title: resolvedEntry?.title ?? resolvedPlaylist.name,
        description: description,
        statusMessage: missingCount > 0 ? context.l10n.errorLibraryItemsNotLoaded(missingCount) : null,
        emptyTitle: context.l10n.statusNoItemsInManagedList,
        emptyMessage: context.l10n.promptAddItemsToManagedList,
        emptyIcon: Icons.playlist_play_rounded,
        scrollController: scrollController,
        tileWidth: tileWidth,
        onRefresh: () => ref.refresh(playlistByIdProvider(libraryId, playlistId).future).then<void>((_) {}),
        itemCount: displayEntries.length,
        itemBuilder: (context, index) {
          final entry = displayEntries[index];
          final item = entry.displayItem;
          final episode = entry.episode;
          return LibraryItemWidget(
            item,
            api,
            showProgress: true,
            squareCover: true,
            episodeIdToReveal: episode?.id,
            onPlay: () {
              if (episode != null) {
                audioHandler.playPodcastEpisode(
                  entry.libraryItem,
                  episode,
                  autoQueueStart: AutoQueueStart(
                    type: AutoQueueStartType.playlist,
                    sourceId: playlistId,
                    globalIndex: entry.playlistIndex,
                  ),
                );
                return;
              }

              audioHandler.playLibraryItem(
                item,
                autoQueueStart: AutoQueueStart(
                  type: AutoQueueStartType.playlist,
                  sourceId: playlistId,
                  globalIndex: entry.playlistIndex,
                ),
              );
            },
          );
        },
        headerActions: Wrap(
          spacing: 0,
          children: [
            if (showShuffleButton && hasRandomPlaylistPlaybackTarget(playlistItems))
              IconButton(
                onPressed: () => unawaited(
                  playRandomPlaylistItemOrEpisode(
                    playlistItems,
                    sourceType: AutoQueueStartType.playlist,
                    sourceId: playlistId,
                  ),
                ),
                icon: const Icon(Icons.shuffle_rounded),
                tooltip: context.l10n.actionPlayRandomItem,
              ),
            if (canManagePlaylist)
              YaabsaContextMenuButton<_PlaylistDetailAction>(
                tooltip: context.l10n.actionMore,
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
                      PopupMenuItem<_PlaylistDetailAction>(
                        value: _PlaylistDetailAction.editBooks,
                        child: Text(context.l10n.actionEditBooks),
                      ),
                    );
                  }
                  items.addAll([
                    PopupMenuItem<_PlaylistDetailAction>(
                      value: _PlaylistDetailAction.edit,
                      child: Text(context.l10n.actionEditDetails),
                    ),
                    PopupMenuItem<_PlaylistDetailAction>(
                      value: _PlaylistDetailAction.delete,
                      child: Text(context.l10n.actionDelete),
                    ),
                  ]);
                  return items;
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _PlaylistDisplayEntry {
  const _PlaylistDisplayEntry({
    required this.playlistIndex,
    required this.libraryItem,
    required this.displayItem,
    required this.episode,
  });

  final int playlistIndex;
  final LibraryItem libraryItem;
  final LibraryItem displayItem;
  final Episode? episode;
}

List<_PlaylistDisplayEntry> _playlistDisplayEntries(List<PlaylistItem> playlistItems) {
  final entries = <_PlaylistDisplayEntry>[];

  for (var index = 0; index < playlistItems.length; index++) {
    final playlistItem = playlistItems[index];
    final libraryItem = playlistItem.libraryItem;
    if (libraryItem == null) {
      continue;
    }

    final episodeId = playlistItem.episodeId?.trim();
    final episode = playlistItem.episode ?? _findPlaylistEpisode(libraryItem, episodeId);
    final displayItem = episode == null ? libraryItem : _libraryItemForPlaylistEpisode(libraryItem, episode);
    entries.add(
      _PlaylistDisplayEntry(playlistIndex: index, libraryItem: libraryItem, displayItem: displayItem, episode: episode),
    );
  }

  return entries;
}

Episode? _findPlaylistEpisode(LibraryItem item, String? episodeId) {
  if (episodeId == null || episodeId.isEmpty) {
    return null;
  }

  for (final episode in item.media?.podcastMedia?.episodes ?? const <Episode>[]) {
    if (episode.id == episodeId) {
      return episode;
    }
  }

  return null;
}

LibraryItem _libraryItemForPlaylistEpisode(LibraryItem item, Episode episode) {
  final media = item.media;
  final podcastMedia = media?.podcastMedia;
  if (media == null || podcastMedia == null) {
    return item.copyWith(recentEpisode: episode);
  }

  return item.copyWith(
    recentEpisode: episode,
    media: media.copyWith(podcastMedia: podcastMedia.copyWith(episodes: <Episode>[episode])),
  );
}

MultiBookEntryData? _resolveEntry(String playlistId, MultiBookEntryData? initialEntry, Playlist? playlist) {
  if (playlist != null) {
    return MultiBookEntryData.fromPlaylist(playlist);
  }

  return initialEntry?.id == playlistId ? initialEntry : null;
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
    title: context.l10n.actionEditBooks,
    confirmLabel: context.l10n.actionSaveBooks,
    selectionRequired: true,
    initialBooks: currentBooks,
    onSave: (bookIds) => ref
        .read(playlistsProvider(libraryId).notifier)
        .replaceBooksInPlaylist(
          playlist.id,
          currentBookIds: currentBooks.map((item) => item.id).toList(growable: false),
          desiredBookIds: bookIds,
        ),
    successMessage: context.l10n.statusNamedBooksUpdated(context.l10n.fieldPlaylist),
    errorFallback: context.l10n.errorNamedBooksUpdateFailed(context.l10n.fieldPlaylist),
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
    title: context.l10n.editNamedEntity(context.l10n.fieldPlaylist),
    initialName: playlist.name,
    initialDescription: playlist.description,
    onSave: ({required name, description}) => ref
        .read(playlistsProvider(libraryId).notifier)
        .updatePlaylist(playlist.id, name: name, description: description),
    successMessage: context.l10n.statusNamedEntityUpdated(context.l10n.fieldPlaylist),
    errorFallback: context.l10n.errorNamedEntityUpdateFailed(context.l10n.fieldPlaylist),
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
    title: context.l10n.headingDeleteManagedList,
    message: context.l10n.deleteNamedEntityMessage(playlist.name),
    onDelete: () => ref.read(playlistsProvider(libraryId).notifier).deletePlaylist(playlist.id),
    successMessage: context.l10n.statusNamedEntityDeleted(context.l10n.fieldPlaylist),
    errorFallback: context.l10n.errorNamedEntityDeleteFailed(context.l10n.fieldPlaylist),
    popOnSuccess: true,
  );
}

enum _PlaylistDetailAction { editBooks, edit, delete }
