import 'package:flutter/material.dart';

enum ItemMoreAction { markAsFinished, playHistory }

class ItemMoreActionsButton extends StatelessWidget {
  const ItemMoreActionsButton({
    super.key,
    required this.onActionSelected,
    this.enabled = true,
    this.tooltip = 'More actions',
  });

  final Future<void> Function(ItemMoreAction action) onActionSelected;
  final bool enabled;
  final String tooltip;

  Future<void> _openActionDialog(BuildContext context) async {
    final selectedAction = await showDialog<ItemMoreAction>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.task_alt_rounded),
                title: const Text('Mark As Finished'),
                onTap: () => Navigator.of(dialogContext).pop(ItemMoreAction.markAsFinished),
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
