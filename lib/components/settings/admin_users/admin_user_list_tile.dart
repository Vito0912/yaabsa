import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/admin/admin_user.dart';
import 'package:yaabsa/components/settings/admin_users/admin_user_badge.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/menus/yaabsa_context_menu_button.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';
import 'package:yaabsa/util/l10n.dart';

enum AdminUserTileAction { edit, toggleActive, unlinkOpenId, delete }

class AdminUserListTile extends StatelessWidget {
  const AdminUserListTile({
    super.key,
    required this.user,
    required this.isBusy,
    required this.compactActions,
    required this.onEdit,
    required this.onToggleActive,
    required this.onDelete,
    this.onUnlinkOpenId,
  });

  final AdminUser user;
  final bool isBusy;
  final bool compactActions;
  final VoidCallback onEdit;
  final VoidCallback onToggleActive;
  final VoidCallback onDelete;
  final VoidCallback? onUnlinkOpenId;

  String _formatEpoch(int? value, AppLocalizations l10n) {
    if (value == null || value <= 0) {
      return l10n.statusUnknown;
    }

    return formatDateTimeLabel(DateTime.fromMillisecondsSinceEpoch(value));
  }

  int _typeRank(String type) {
    switch (type.trim().toLowerCase()) {
      case 'root':
        return 0;
      case 'admin':
        return 1;
      case 'user':
        return 2;
      case 'guest':
        return 3;
      default:
        return 4;
    }
  }

  Color _typeColor(BuildContext context) {
    final rank = _typeRank(user.type);
    final colorScheme = Theme.of(context).colorScheme;
    switch (rank) {
      case 0:
        return colorScheme.tertiary;
      case 1:
        return colorScheme.primary;
      case 2:
        return colorScheme.secondary;
      case 3:
        return colorScheme.outline;
      default:
        return colorScheme.outlineVariant;
    }
  }

  void _onActionSelected(AdminUserTileAction action) {
    switch (action) {
      case AdminUserTileAction.edit:
        onEdit();
        break;
      case AdminUserTileAction.toggleActive:
        onToggleActive();
        break;
      case AdminUserTileAction.unlinkOpenId:
        onUnlinkOpenId?.call();
        break;
      case AdminUserTileAction.delete:
        onDelete();
        break;
    }
  }

  Widget _buildCompactActions(BuildContext context) {
    final l10n = context.l10n;
    final canToggleActive = !user.isRoot;

    return YaabsaContextMenuButton<AdminUserTileAction>(
      enabled: !isBusy,
      onSelected: _onActionSelected,
      itemBuilder: (_) => <PopupMenuEntry<AdminUserTileAction>>[
        PopupMenuItem<AdminUserTileAction>(value: AdminUserTileAction.edit, child: Text(l10n.actionEdit)),
        if (canToggleActive)
          PopupMenuItem<AdminUserTileAction>(
            value: AdminUserTileAction.toggleActive,
            child: Text(user.isActive ? l10n.actionDisableUser : l10n.actionEnableUser),
          ),
        if (user.hasLinkedOpenId)
          PopupMenuItem<AdminUserTileAction>(
            value: AdminUserTileAction.unlinkOpenId,
            child: Text(l10n.actionUnlinkOpenId),
          ),
        PopupMenuItem<AdminUserTileAction>(
          value: AdminUserTileAction.delete,
          textStyle: const TextStyle(color: Colors.red),
          child: Text(l10n.actionDelete),
        ),
      ],
    );
  }

  Widget _buildWideActions(BuildContext context) {
    final l10n = context.l10n;
    return Align(
      alignment: Alignment.centerRight,
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: 8,
        runSpacing: 6,
        children: [
          OutlinedButton.icon(
            onPressed: isBusy ? null : onEdit,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: Text(l10n.actionEdit),
          ),
          if (!user.isRoot)
            OutlinedButton.icon(
              onPressed: isBusy ? null : onToggleActive,
              icon: Icon(user.isActive ? Icons.block_rounded : Icons.check_circle_outline_rounded, size: 18),
              label: Text(user.isActive ? l10n.actionDisableUser : l10n.actionEnableUser),
            ),
          YaabsaDeleteIconButton(tooltip: l10n.actionDelete, onPressed: isBusy ? null : onDelete),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final typeColor = _typeColor(context);
    final statusColor = user.isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline;
    final email = user.email?.trim();
    final emailLabel = email?.isNotEmpty == true ? email! : l10n.statusNoEmail;
    final createdLabel = l10n.adminUserCreatedDate(_formatEpoch(user.createdAt, l10n));
    final lastSeenLabel = l10n.adminUserLastSeenDate(_formatEpoch(user.lastSeen, l10n));
    final subtitleParts = <String>[emailLabel, createdLabel, lastSeenLabel];

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      Text(
                        user.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      AdminUserBadge(label: l10n.userRoleName(user.type.toLowerCase()).toUpperCase(), color: typeColor),
                      AdminUserBadge(
                        label: (user.isActive ? l10n.statusActive : l10n.statusDisabled).toUpperCase(),
                        color: statusColor,
                        icon: user.isActive ? Icons.check_circle_rounded : Icons.do_not_disturb_on_rounded,
                      ),
                      if (user.hasLinkedOpenId)
                        AdminUserBadge(
                          label: 'OPENID',
                          color: Theme.of(context).colorScheme.secondary,
                          icon: Icons.link_rounded,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (isBusy)
                  const SizedBox(width: 18, height: 18, child: YaabsaCircularProgressIndicator(strokeWidth: 2))
                else if (compactActions)
                  _buildCompactActions(context),
              ],
            ),
            const SizedBox(height: 6),
            Text(subtitleParts.join(' • '), style: Theme.of(context).textTheme.bodySmall),
            if (!compactActions) ...[const SizedBox(height: 10), _buildWideActions(context)],
          ],
        ),
      ),
    );
  }
}
