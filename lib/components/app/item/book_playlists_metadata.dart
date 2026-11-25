import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/app/item/item_detail_components.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/util/playlist_membership.dart';
import 'package:yaabsa/util/l10n.dart';

ItemMetadataRowData buildBookPlaylistsMetadataRow(
  BuildContext context, {
  required AsyncValue<BookPlaylistMemberships> playlists,
  required VoidCallback onRetry,
  VoidCallback? onLoadMore,
}) {
  final localizations = context.l10n;

  if (playlists.isLoading && !playlists.hasValue) {
    return ItemMetadataRowData(label: localizations.navPlaylists, value: localizations.statusLoadingContent);
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
    values.add(
      ItemLinkValue(label: localizations.errorLoadNamedItemsRetry(localizations.entityPlaylists), onTap: onRetry),
    );
  } else if (unknown) {
    values.add(
      ItemLinkValue(label: localizations.statusNamedItemsUnknown(localizations.entityPlaylists), onTap: onRetry),
    );
  }
  if (state?.hasMore ?? false) {
    values.add(
      ItemLinkValue(
        label: state!.isLoadingMore ? localizations.statusLoadingContent : localizations.actionLoadMore,
        onTap: state.isLoadingMore ? null : onLoadMore,
      ),
    );
  } else if (!hasError && !unknown && values.isEmpty) {
    return ItemMetadataRowData(
      label: localizations.navPlaylists,
      value: localizations.statusNoNamedItems(localizations.entityPlaylists),
    );
  }
  return ItemMetadataRowData(label: localizations.navPlaylists, values: values);
}
