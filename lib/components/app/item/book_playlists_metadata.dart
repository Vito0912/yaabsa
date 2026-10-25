import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/app/item/item_detail_components.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/util/playlist_membership.dart';

ItemMetadataRowData buildBookPlaylistsMetadataRow(
  BuildContext context, {
  required AsyncValue<BookPlaylistMemberships> playlists,
  required VoidCallback onRetry,
}) {
  if (playlists.isLoading && !playlists.hasValue) {
    return const ItemMetadataRowData(label: 'Playlists', value: 'Loading playlists…');
  }
  final state = playlists.value;
  final hasError = playlists.hasError || state?.error != null;
  final unknown = state?.hasUnknown ?? false;
  final values = (state?.items ?? [])
      .map(
        (playlist) => ItemLinkValue(
          label: playlist.name,
          onTap: () => context.push(
            Uri(
              pathSegments: ['', 'playlist', playlist.id],
              queryParameters: {'libraryId': playlist.libraryId},
            ).toString(),
            extra: MultiBookEntryData.fromPlaylist(playlist),
          ),
        ),
      )
      .toList();
  if (hasError || state == null) {
    values.add(ItemLinkValue(label: 'Could not load playlists. Retry', onTap: onRetry));
  } else if (unknown) {
    values.add(ItemLinkValue(label: 'Some memberships are unknown. Retry', onTap: onRetry));
  } else if (values.isEmpty) {
    return const ItemMetadataRowData(label: 'Playlists', value: 'No playlists');
  }
  return ItemMetadataRowData(label: 'Playlists', values: values);
}
