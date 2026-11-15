import 'package:material_ui/material_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_data.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/components/app/item/editor/library_item_edit_overlay.dart';
import 'package:yaabsa/components/app/item/editor/open_library_item_editor_dialog.dart';
import 'package:yaabsa/components/app/item/item_delete_actions.dart';
import 'package:yaabsa/components/app/item/item_more_actions_button.dart';
import 'package:yaabsa/components/app/item/item_progress_actions.dart';
import 'package:yaabsa/components/app/item/match/library_item_quick_match_actions.dart';
import 'package:yaabsa/components/app/item/set_library_item_progress_dialog.dart';
import 'package:yaabsa/components/app/item/pinned_shelf_snackbar.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/library/pinned_shelf_provider.dart';
import 'package:yaabsa/screens/player/play_history_view.dart';
import 'package:yaabsa/util/home_navigation_preferences.dart';

Future<void> showLibraryItemContextMenu({
  required BuildContext context,
  required WidgetRef ref,
  required LibraryItem item,
  required Offset position,
  required bool canEdit,
  required bool canQuickMatch,
  required bool canDelete,
  required bool canAddToCollection,
  required String? currentUserId,
  required LibraryFilterData? filterData,
  required VoidCallback onEdit,
  required Future<void> Function() onAfterDelete,
}) async {
  final libraryId = item.libraryId;
  final episode = selectablePodcastEpisode(item);
  final progressKey = libraryItemSelectionKey(item);
  final currentProgress = ref.read(mediaProgressByKeyProvider(progressKey));
  final isFinished = currentProgress?.isFinished ?? false;
  final hasProgress = currentProgress != null;
  final mediaDuration = item.media?.duration(episodeId: episode?.id) ?? 0;
  final duration = mediaDuration > 0 ? mediaDuration : currentProgress?.duration ?? 0;
  final initialStartedDate = currentProgress == null
      ? DateTime.now()
      : DateTime.fromMillisecondsSinceEpoch(currentProgress.startedAt);
  final currentFinishedAt = currentProgress?.finishedAt;
  final initialFinishedDate = currentFinishedAt == null ? null : DateTime.fromMillisecondsSinceEpoch(currentFinishedAt);
  final canSetProgress = duration > 0 && (supportsFinishedProgressUpdates(item) || episode != null);
  final canPin = libraryId != null && libraryId.isNotEmpty && currentUserId != null;
  final isPinned = canPin
      ? ref
            .read(pinnedShelfControllerProvider.notifier)
            .isPinned(libraryId: libraryId, itemId: item.id, episodeId: episode?.id)
      : false;

  final actions = ItemMoreActionsButton(
    onActionSelected: (action) async {
      switch (action) {
        case ItemMoreAction.select:
          return;
        case ItemMoreAction.editItem:
          onEdit();
          return;
        case ItemMoreAction.quickMatch:
          await quickMatchSingleItem(context: context, ref: ref, item: item);
          return;
        case ItemMoreAction.manualMatch:
          await openSingleLibraryItemEditorDialog(
            context: context,
            item: item,
            filterData: filterData,
            initialTab: LibraryItemEditorTab.match,
          );
          return;
        case ItemMoreAction.markAsFinished:
          if (episode != null) {
            await markPodcastEpisodeAsFinished(context: context, ref: ref, item: item, episode: episode);
          } else {
            await markLibraryItemAsFinished(context: context, ref: ref, item: item);
          }
          return;
        case ItemMoreAction.markAsUnfinished:
          if (episode != null) {
            await markPodcastEpisodeAsUnfinished(context: context, ref: ref, item: item, episode: episode);
          } else {
            await markLibraryItemAsUnfinished(context: context, ref: ref, item: item);
          }
          return;
        case ItemMoreAction.setProgress:
          final selectedProgress = await showSetLibraryItemProgressDialog(
            context: context,
            initialProgress: currentProgress?.progress ?? 0,
            durationSeconds: duration,
            initialStartedDate: initialStartedDate,
            initialFinishedDate: initialFinishedDate,
          );
          if (!context.mounted || selectedProgress == null) {
            return;
          }
          await setLibraryItemProgress(
            context: context,
            ref: ref,
            item: item,
            episode: episode,
            progress: selectedProgress.progress,
            durationSeconds: duration,
            startedDate: selectedProgress.startedDate,
            finishedDate: selectedProgress.finishedDate,
          );
          return;
        case ItemMoreAction.addToPlaylist:
          await addLibraryItemToPlaylist(context: context, ref: ref, item: item, currentUserId: currentUserId);
          return;
        case ItemMoreAction.addToCollection:
          await addLibraryItemToCollection(context: context, ref: ref, item: item, canUpdate: canAddToCollection);
          return;
        case ItemMoreAction.togglePin:
          if (!canPin) {
            return;
          }
          try {
            final undo = await ref
                .read(pinnedShelfControllerProvider.notifier)
                .toggle(
                  libraryId: libraryId,
                  mediaType: HomeLibraryMediaType.fromLibraryMediaType(item.mediaType),
                  itemId: item.id,
                  episodeId: episode?.id,
                );
            if (context.mounted) {
              showPinnedShelfSnackBar(context: context, undo: undo);
            }
          } catch (error) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not update Pinned: $error')));
            }
          }
          return;
        case ItemMoreAction.deleteItem:
          await deleteAudiobookWithConfirmation(
            context: context,
            ref: ref,
            item: item,
            onSuccess: () => onAfterDelete(),
          );
          return;
        case ItemMoreAction.playHistory:
          context.push(PlayHistoryView.location(itemId: item.id, episodeId: episode?.id, itemTitle: item.title));
          return;
      }
    },
    showMarkAction: isBulkSelectableLibraryItem(item),
    showMarkAsFinished: !isFinished,
    showMarkAsUnfinished: hasProgress,
    showSetProgress: canSetProgress,
    showEditItem: canEdit,
    showQuickMatch: canQuickMatch && supportsFinishedProgressUpdates(item),
    showManualMatch: canQuickMatch && supportsFinishedProgressUpdates(item),
    showAddToPlaylist: canAddLibraryItemToPlaylist(item, currentUserId),
    showAddToCollection: canAddLibraryItemToCollection(item, canUpdate: canAddToCollection),
    showPinAction: canPin,
    isPinned: isPinned,
    showDeleteItem: canDelete && canDeleteAudiobook(item: item, hasDeletePermission: true),
  );

  await actions.showAt(context: context, globalPosition: position);
}
