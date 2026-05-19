import 'package:flutter/material.dart';

import 'package:yaabsa/generated/l10n.dart';

enum ItemMoreAction {
  editItem,
  quickMatch,
  manualMatch,
  markAsFinished,
  markAsUnfinished,
  addToPlaylist,
  addToCollection,
  deleteItem,
  playHistory,
}

class ItemMoreActionsButton extends StatelessWidget {
  const ItemMoreActionsButton({
    super.key,
    required this.onActionSelected,
    this.enabled = true,
    this.tooltip,
    this.showMarkAction = true,
    this.showEditItem = false,
    this.showMarkAsUnfinished = false,
    this.showAddToPlaylist = false,
    this.showAddToCollection = false,
    this.showDeleteItem = false,
    this.showQuickMatch = false,
    this.showManualMatch = false,
  });

  final Future<void> Function(ItemMoreAction action) onActionSelected;
  final bool enabled;
  final String? tooltip;
  final bool showMarkAction;
  final bool showEditItem;
  final bool showMarkAsUnfinished;
  final bool showAddToPlaylist;
  final bool showAddToCollection;
  final bool showDeleteItem;
  final bool showQuickMatch;
  final bool showManualMatch;

  Future<void> _openActionDialog(BuildContext context) async {
    final selectedAction = await showDialog<ItemMoreAction>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showEditItem)
                ListTile(
                  leading: const Icon(Icons.edit_rounded),
                  title: Text(S.current.componentsAppItemItemMoreActionsButtonEditItem),
                  onTap: () => Navigator.of(dialogContext).pop(ItemMoreAction.editItem),
                ),
              if (showQuickMatch)
                ListTile(
                  leading: const Icon(Icons.auto_fix_high_rounded),
                  title: Text(S.current.componentsAppItemItemMoreActionsButtonQuickMatch),
                  onTap: () => Navigator.of(dialogContext).pop(ItemMoreAction.quickMatch),
                ),
              if (showManualMatch)
                ListTile(
                  leading: const Icon(Icons.manage_search_rounded),
                  title: Text(S.current.componentsAppItemItemMoreActionsButtonManualMatch),
                  onTap: () => Navigator.of(dialogContext).pop(ItemMoreAction.manualMatch),
                ),
              if (showMarkAction)
                ListTile(
                  leading: Icon(showMarkAsUnfinished ? Icons.remove_done_rounded : Icons.task_alt_rounded),
                  title: Text(
                    showMarkAsUnfinished
                        ? S.current.componentsAppItemItemMoreActionsButtonMarkAsUnfinished
                        : S.current.componentsAppItemItemMoreActionsButtonMarkAsFinished,
                  ),
                  onTap: () => Navigator.of(
                    dialogContext,
                  ).pop(showMarkAsUnfinished ? ItemMoreAction.markAsUnfinished : ItemMoreAction.markAsFinished),
                ),
              if (showAddToPlaylist)
                ListTile(
                  leading: const Icon(Icons.playlist_add_rounded),
                  title: Text(S.current.componentsAppItemItemMoreActionsButtonAddToPlaylist),
                  onTap: () => Navigator.of(dialogContext).pop(ItemMoreAction.addToPlaylist),
                ),
              if (showAddToCollection)
                ListTile(
                  leading: const Icon(Icons.collections_bookmark_outlined),
                  title: Text(S.current.componentsAppItemItemMoreActionsButtonAddToCollection),
                  onTap: () => Navigator.of(dialogContext).pop(ItemMoreAction.addToCollection),
                ),
              if (showDeleteItem)
                ListTile(
                  leading: Icon(Icons.delete_outline_rounded, color: Theme.of(dialogContext).colorScheme.error),
                  title: Text(
                    S.current.componentsAppItemItemMoreActionsButtonDeleteAudiobook,
                    style: TextStyle(color: Theme.of(dialogContext).colorScheme.error),
                  ),
                  onTap: () => Navigator.of(dialogContext).pop(ItemMoreAction.deleteItem),
                ),
              ListTile(
                leading: const Icon(Icons.history_rounded),
                title: Text(S.current.componentsAppItemItemMoreActionsButtonPlayHistory),
                onTap: () => Navigator.of(dialogContext).pop(ItemMoreAction.playHistory),
              ),
            ],
          ),
        );
      },
    );

    if (!context.mounted || selectedAction == null) {
      return;
    }

    await onActionSelected(selectedAction);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: enabled ? () => _openActionDialog(context) : null,
      tooltip: tooltip ?? S.current.componentsAppItemItemMoreActionsButtonMoreActions,
      icon: const Icon(Icons.more_vert_rounded),
      visualDensity: VisualDensity.compact,
    );
  }
}
