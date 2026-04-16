import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/list/playlist.dart';
import 'package:yaabsa/api/list/playlist_item.dart';
import 'package:yaabsa/components/common/library_item_widget.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/common/playlist_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/layout_sizes.dart';

class PlaylistDetailView extends ConsumerWidget {
  const PlaylistDetailView({required this.playlistId, super.key, this.initialEntry});

  final String playlistId;
  final MultiBookEntryData? initialEntry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLibrary = ref.watch(selectedLibraryProvider);
    if (selectedLibrary == null) {
      return const Center(child: Text('No library selected. Please select a library via the switcher.'));
    }

    final api = ref.watch(absApiProvider);
    if (api == null) {
      return const Center(child: Text('No server connection available.'));
    }

    final libraryId = selectedLibrary.id;
    final allPlaylistsAsync = ref.watch(playlistsProvider(libraryId));
    final resolvedPlaylist = _resolvePlaylist(playlistId, allPlaylistsAsync.value?.items);
    final resolvedEntry = _resolveEntry(playlistId, initialEntry, resolvedPlaylist);

    if (resolvedPlaylist == null) {
      if (allPlaylistsAsync.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      return const Center(child: Text('Playlist details could not be loaded.'));
    }

    final playlistItems = resolvedPlaylist.items ?? const <PlaylistItem>[];
    final libraryItems = _playlistLibraryItems(playlistItems);
    final missingCount = (playlistItems.length - libraryItems.length).clamp(0, playlistItems.length);

    return LayoutBuilder(
      builder: (context, constraints) {
        final gridLayout = appCenteredGridLayout(constraints.maxWidth);
        final horizontalPadding = gridLayout.horizontalPadding;
        final subtitle = _resolveSubtitle(resolvedEntry, playlistItems.length);

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 10, horizontalPadding, 8),
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
                ],
              ),
            ),
            if (subtitle != null)
              Padding(
                padding: EdgeInsets.fromLTRB(horizontalPadding + 58, 0, horizontalPadding, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            if (missingCount > 0)
              Padding(
                padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 10),
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
                child: RefreshIndicator(
                  onRefresh: () => ref.read(playlistsProvider(libraryId).notifier).refresh(withLoading: false),
                  child: AlignedGridView.count(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 16),
                    crossAxisCount: gridLayout.crossAxisCount,
                    mainAxisSpacing: appGridSpacing,
                    crossAxisSpacing: appGridSpacing,
                    itemCount: libraryItems.length,
                    itemBuilder: (context, index) {
                      return LibraryItemWidget(libraryItems[index], api, showProgress: true, squareCover: true);
                    },
                  ),
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

String? _resolveSubtitle(MultiBookEntryData? entry, int itemCount) {
  if (entry != null && entry.subtitle != null && entry.subtitle!.isNotEmpty) {
    return entry.subtitle;
  }

  if (itemCount > 0) {
    return '$itemCount items';
  }

  return null;
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
