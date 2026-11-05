import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/list/playlist.dart';
import 'package:yaabsa/components/app/item/book_list_membership_dialog.dart';
import 'package:yaabsa/provider/common/playlist_provider.dart';
import 'package:yaabsa/util/playlist_membership.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

Future<void> showBookPlaylistMembershipDialog({required BuildContext context, required LibraryItem item}) async {
  if (item.libraryId == null || item.libraryId!.isEmpty) {
    return;
  }
  final saved = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => BookPlaylistMembershipDialog(item: item),
  );
  if (saved == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Playlists updated.')));
  }
}

class BookPlaylistMembershipDialog extends ConsumerWidget {
  const BookPlaylistMembershipDialog({super.key, required this.item});

  final LibraryItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryId = item.libraryId!;
    final userId = ref.watch(currentUserProvider).value?.id;
    final lists = ref.watch(playlistsProvider(libraryId));
    return BookListMembershipDialog<Playlist>(
      entries: lists.whenData((state) {
        if (state.error != null) {
          throw state.error!;
        }
        return state.items.where((entry) => entry.libraryId == libraryId).toList(growable: false);
      }),
      hasNextPage: lists.value?.hasNextPage ?? false,
      isLoadingNextPage: lists.value?.isLoadingNextPage ?? false,
      nextPageError: lists.value?.nextPageError,
      onLoadMore: () => ref.read(playlistsProvider(libraryId).notifier).loadNextPage(),
      allowed: userId != null && userId.isNotEmpty,
      plural: 'playlists',
      bookTitle: item.title,
      id: (entry) => entry.id,
      name: (entry) => entry.name,
      membership: (entry) => switch (playlistMembership(entry, item.id)) {
        PlaylistMembership.present => true,
        PlaylistMembership.absent => false,
        PlaylistMembership.unknown => null,
      },
      sameRevision: samePlaylistMembershipRevision,
      canRetryEntry: (entry) => !hasCompletePlaylistItems(entry),
      disabledReason: (entry) {
        if (!canEditPlaylistMembership(entry, userId)) {
          return 'Only your own playlists can be edited.';
        }
        if (!hasCompletePlaylistItems(entry)) {
          return 'Full item list unavailable.';
        }
        return null;
      },
      confirmSave: (original, selected) async {
        final deleted = original
            .where(
              (entry) =>
                  !selected.contains(entry.id) &&
                  entry.items?.length == 1 &&
                  playlistMembership(entry, item.id) == PlaylistMembership.present,
            )
            .map((entry) => entry.name)
            .toList();
        if (deleted.isEmpty) {
          return true;
        }
        return await showDialog<bool>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                scrollable: true,
                title: const Text('Delete empty playlists?'),
                content: Text(
                  'Removing this book will leave these playlists empty. Audiobookshelf will delete them:\n\n${deleted.join('\n')}',
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('Cancel')),
                  FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: const Text('Continue')),
                ],
              ),
            ) ??
            false;
      },
      onReload: () => ref.read(playlistsProvider(libraryId).notifier).refresh(requireServer: true),
      onSave: (original, selected) => ref
          .read(playlistsProvider(libraryId).notifier)
          .updateBookMemberships(bookId: item.id, original: original, selectedIds: selected),
    );
  }
}
