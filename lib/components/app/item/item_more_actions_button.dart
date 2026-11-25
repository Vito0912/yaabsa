import 'dart:async';

import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/ui/components/menus/yaabsa_context_menu_button.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/l10n.dart';

enum ItemMoreAction {
  editItem,
  quickMatch,
  manualMatch,
  markAsFinished,
  markAsUnfinished,
  setProgress,
  addToPlaylist,
  addToCollection,
  togglePin,
  deleteItem,
  playHistory,
  select,
}

class ItemMoreActionsButton extends StatelessWidget {
  const ItemMoreActionsButton({
    super.key,
    required this.onActionSelected,
    this.enabled = true,
    this.tooltip,
    this.showMarkAction = true,
    this.showEditItem = false,
    this.showMarkAsFinished = true,
    this.showMarkAsUnfinished = false,
    this.showSetProgress = false,
    this.showAddToPlaylist = false,
    this.showAddToCollection = false,
    this.manageMemberships = false,
    this.showDeleteItem = false,
    this.showQuickMatch = false,
    this.showManualMatch = false,
    this.showSelect = false,
    this.showPinAction = false,
    this.showPlayHistory = true,
    this.isPinned = false,
    this.shape = YaabsaActionButtonShape.rounded,
  });

  final Future<void> Function(ItemMoreAction action) onActionSelected;
  final bool enabled;
  final String? tooltip;
  final bool showMarkAction;
  final bool showEditItem;
  final bool showMarkAsFinished;
  final bool showMarkAsUnfinished;
  final bool showSetProgress;
  final bool showAddToPlaylist;
  final bool showAddToCollection;
  final bool manageMemberships;
  final bool showDeleteItem;
  final bool showQuickMatch;
  final bool showManualMatch;
  final bool showSelect;
  final bool showPinAction;
  final bool showPlayHistory;
  final bool isPinned;
  final YaabsaActionButtonShape shape;

  List<_ItemMoreActionOption> _actionOptions(AppLocalizations localizations, {bool desktop = false}) {
    return [
      if (showSelect)
        _ItemMoreActionOption(
          action: ItemMoreAction.select,
          label: localizations.actionSelect,
          icon: Icons.check_box_outlined,
        ),
      if (showEditItem)
        _ItemMoreActionOption(
          action: ItemMoreAction.editItem,
          label: localizations.actionEdit,
          icon: Icons.edit_rounded,
        ),
      if (showQuickMatch)
        _ItemMoreActionOption(
          action: ItemMoreAction.quickMatch,
          label: localizations.actionQuickMatch,
          icon: Icons.auto_fix_high_rounded,
        ),
      if (showManualMatch)
        _ItemMoreActionOption(
          action: ItemMoreAction.manualMatch,
          label: localizations.actionManualMatch,
          icon: Icons.manage_search_rounded,
        ),
      if (showPinAction)
        _ItemMoreActionOption(
          action: ItemMoreAction.togglePin,
          label: isPinned ? localizations.actionUnpinFromShelf : localizations.actionPinToShelf,
          icon: isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
        ),
      if (showMarkAction && desktop && showMarkAsFinished)
        _ItemMoreActionOption(
          action: ItemMoreAction.markAsFinished,
          label: localizations.actionMarkAsFinished,
          icon: Icons.task_alt_rounded,
        ),
      if (showMarkAction && desktop && showMarkAsUnfinished)
        _ItemMoreActionOption(
          action: ItemMoreAction.markAsUnfinished,
          label: localizations.actionMarkAsUnfinished,
          icon: Icons.remove_done_rounded,
        ),
      if (showSetProgress && desktop)
        _ItemMoreActionOption(
          action: ItemMoreAction.setProgress,
          label: localizations.actionSetProgress,
          icon: Icons.tune_rounded,
        ),
      if (showMarkAction && !desktop)
        _ItemMoreActionOption(
          action: showMarkAsUnfinished ? ItemMoreAction.markAsUnfinished : ItemMoreAction.markAsFinished,
          label: showMarkAsUnfinished ? localizations.actionMarkAsUnfinished : localizations.actionMarkAsFinished,
          icon: showMarkAsUnfinished ? Icons.remove_done_rounded : Icons.task_alt_rounded,
        ),
      if (showAddToPlaylist)
        _ItemMoreActionOption(
          action: ItemMoreAction.addToPlaylist,
          label: manageMemberships ? localizations.actionManagePlaylists : localizations.actionAddToPlaylist,
          icon: Icons.playlist_add_rounded,
        ),
      if (showAddToCollection)
        _ItemMoreActionOption(
          action: ItemMoreAction.addToCollection,
          label: manageMemberships ? localizations.actionManageCollections : localizations.actionAddToCollection,
          icon: Icons.collections_bookmark_outlined,
        ),
      if (showDeleteItem)
        _ItemMoreActionOption(
          action: ItemMoreAction.deleteItem,
          label: localizations.actionDelete,
          icon: Icons.delete_outline_rounded,
          isDestructive: true,
        ),
      if (showPlayHistory)
        _ItemMoreActionOption(
          action: ItemMoreAction.playHistory,
          label: localizations.navPlayHistory,
          icon: Icons.history_rounded,
        ),
    ];
  }

  Future<void> _openActionDialog(BuildContext context) async {
    final options = _actionOptions(context.l10n);
    final selectedAction = await showDialog<ItemMoreAction>(
      context: context,
      useRootNavigator: false,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          scrollable: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final option in options)
                ListTile(
                  leading: Icon(option.icon, color: option.isDestructive ? colorScheme.error : null),
                  title: Text(option.label, style: option.isDestructive ? TextStyle(color: colorScheme.error) : null),
                  onTap: () => Navigator.of(dialogContext).pop(option.action),
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

  List<M3EMenuNode> _buildDesktopMenuNodes(BuildContext context) {
    final options = _actionOptions(context.l10n, desktop: true);
    final optionsByAction = {for (final option in options) option.action: option};
    final nodes = <M3EMenuNode>[];

    final selectOption = optionsByAction[ItemMoreAction.select];
    if (selectOption != null) {
      nodes.add(_menuEntry(context, selectOption));
    }

    final editEntries = _submenuEntries(context, optionsByAction, [
      ItemMoreAction.editItem,
      ItemMoreAction.quickMatch,
      ItemMoreAction.manualMatch,
    ]);
    if (editEntries.isNotEmpty) {
      nodes.add(
        M3EMenuSubmenu(label: context.l10n.actionEdit, leading: const Icon(Icons.edit_rounded), children: editEntries),
      );
    }

    for (final action in [ItemMoreAction.togglePin]) {
      final option = optionsByAction[action];
      if (option != null) {
        nodes.add(_menuEntry(context, option));
      }
    }

    final progressEntries = _submenuEntries(context, optionsByAction, [
      ItemMoreAction.markAsFinished,
      ItemMoreAction.markAsUnfinished,
      ItemMoreAction.setProgress,
    ]);
    if (progressEntries.isNotEmpty) {
      nodes.add(
        M3EMenuSubmenu(
          label: context.l10n.fieldProgress,
          leading: const Icon(Icons.tune_rounded),
          children: progressEntries,
        ),
      );
    }

    final addToEntries = _submenuEntries(context, optionsByAction, [
      ItemMoreAction.addToPlaylist,
      ItemMoreAction.addToCollection,
    ]);
    if (addToEntries.isNotEmpty) {
      nodes.add(
        M3EMenuSubmenu(label: context.l10n.actionAdd, leading: const Icon(Icons.add_rounded), children: addToEntries),
      );
    }

    for (final action in [ItemMoreAction.deleteItem, ItemMoreAction.playHistory]) {
      final option = optionsByAction[action];
      if (option != null) {
        nodes.add(_menuEntry(context, option));
      }
    }

    return nodes;
  }

  List<M3EMenuNode> _submenuEntries(
    BuildContext context,
    Map<ItemMoreAction, _ItemMoreActionOption> optionsByAction,
    List<ItemMoreAction> actions,
  ) {
    final entries = <M3EMenuNode>[];

    for (final action in actions) {
      final option = optionsByAction[action];
      if (option == null) {
        continue;
      }

      entries.add(_menuEntry(context, option));
    }

    return entries;
  }

  M3EMenuEntry _menuEntry(BuildContext context, _ItemMoreActionOption option) {
    final colorScheme = Theme.of(context).colorScheme;

    return M3EMenuEntry(
      label: option.label,
      value: option.action,
      leading: Icon(option.icon, color: option.isDestructive ? colorScheme.error : null),
      isDestructive: option.isDestructive,
    );
  }

  Future<void> showAt({required BuildContext context, required Offset globalPosition}) async {
    if (!enabled) {
      return;
    }

    final selection = await showYaabsaContextMenuAt<ItemMoreAction>(
      context: context,
      globalPosition: globalPosition,
      children: _buildDesktopMenuNodes(context),
      variant: M3EMenuVariant.baseline,
      constraints: BoxConstraints(
        maxWidth: 240,
        maxHeight: (MediaQuery.sizeOf(context).height - 32).clamp(0.0, double.infinity).toDouble(),
      ),
    );

    if (!context.mounted || selection == null) {
      return;
    }

    await onActionSelected(selection);
  }

  @override
  Widget build(BuildContext context) {
    final resolvedTooltip = tooltip ?? context.l10n.actionMoreActions;

    if (context.isDesktop) {
      final menuMaxHeight = (MediaQuery.sizeOf(context).height - 32).clamp(0.0, double.infinity).toDouble();

      return YaabsaContextMenuButton<ItemMoreAction>(
        tooltip: resolvedTooltip,
        enabled: enabled,
        icon: const Icon(Icons.more_vert_rounded),
        iconSize: 19,
        triggerVariant: YaabsaActionButtonVariant.filledTonal,
        triggerShape: shape,
        menuVariant: M3EMenuVariant.baseline,
        constraints: BoxConstraints(maxWidth: 240, maxHeight: menuMaxHeight),
        menuNodeBuilder: _buildDesktopMenuNodes,
        onSelected: (action) {
          unawaited(onActionSelected(action));
        },
      );
    }

    return YaabsaActionIconButton(
      icon: Icons.more_vert_rounded,
      variant: YaabsaActionButtonVariant.filledTonal,
      shape: shape,
      enabled: enabled,
      onPressed: () => _openActionDialog(context),
      tooltip: resolvedTooltip,
    );
  }
}

class _ItemMoreActionOption {
  const _ItemMoreActionOption({
    required this.action,
    required this.label,
    required this.icon,
    this.isDestructive = false,
  });

  final ItemMoreAction action;
  final String label;
  final IconData icon;
  final bool isDestructive;
}
