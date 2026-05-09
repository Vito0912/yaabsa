import 'package:flutter/material.dart';

enum ItemMoreAction { markAsFinished, markAsUnfinished, playHistory }

class ItemMoreActionsButton extends StatelessWidget {
  const ItemMoreActionsButton({
    super.key,
    required this.onActionSelected,
    this.enabled = true,
    this.tooltip = 'More actions',
    this.showMarkAction = true,
    this.showMarkAsUnfinished = false,
  });

  final Future<void> Function(ItemMoreAction action) onActionSelected;
  final bool enabled;
  final String tooltip;
  final bool showMarkAction;
  final bool showMarkAsUnfinished;

  Future<void> _openActionDialog(BuildContext context) async {
    final selectedAction = await showDialog<ItemMoreAction>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showMarkAction)
                ListTile(
                  leading: Icon(showMarkAsUnfinished ? Icons.remove_done_rounded : Icons.task_alt_rounded),
                  title: Text(showMarkAsUnfinished ? 'Mark As Unfinished' : 'Mark As Finished'),
                  onTap: () => Navigator.of(
                    dialogContext,
                  ).pop(showMarkAsUnfinished ? ItemMoreAction.markAsUnfinished : ItemMoreAction.markAsFinished),
                ),
              ListTile(
                leading: const Icon(Icons.history_rounded),
                title: const Text('Play History'),
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
      tooltip: tooltip,
      icon: const Icon(Icons.more_vert_rounded),
      visualDensity: VisualDensity.compact,
    );
  }
}
