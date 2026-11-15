import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/admin/admin_user.dart';
import 'package:yaabsa/components/common/tables/expressive_action_table.dart';
import 'package:yaabsa/components/settings/admin_users/admin_user_badge.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';

class AdminUsersTablePresentation extends StatelessWidget {
  const AdminUsersTablePresentation({
    super.key,
    required this.users,
    required this.activeUserId,
    required this.busyUserIds,
    required this.isLoading,
    required this.searchQuery,
    required this.onCreateAuthenticationCode,
    required this.onEditUser,
    required this.onToggleUserActive,
    required this.onUnlinkOpenId,
    required this.onDeleteUser,
  });

  final List<AdminUser> users;
  final String? activeUserId;
  final Set<String> busyUserIds;
  final bool isLoading;
  final String searchQuery;
  final Future<void> Function(AdminUser user) onCreateAuthenticationCode;
  final Future<void> Function(AdminUser user) onEditUser;
  final Future<void> Function(AdminUser user) onToggleUserActive;
  final Future<void> Function(AdminUser user) onUnlinkOpenId;
  final Future<void> Function(AdminUser user) onDeleteUser;

  @override
  Widget build(BuildContext context) {
    final hasSearchQuery = searchQuery.trim().isNotEmpty;

    return ExpressiveActionTable<AdminUser>(
      rows: users,
      rowId: (user) => user.id,
      loading: isLoading,
      busyRowIds: busyUserIds,
      columns: [
        ExpressiveTableColumn<AdminUser>(
          id: 'user',
          label: 'User',
          width: 240,
          cellBuilder: (context, user) => _AdminUserIdentity(user: user),
          mobileCellBuilder: (context, user) => _AdminUserIdentity(user: user, showEmail: true),
          tooltipBuilder: (user) => user.username,
        ),
        ExpressiveTableColumn<AdminUser>(
          id: 'type',
          label: 'Type',
          width: 100,
          alignment: ExpressiveTableCellAlignment.center,
          cellBuilder: (context, user) =>
              Text(user.type.toLowerCase(), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        ExpressiveTableColumn<AdminUser>(
          id: 'email',
          label: 'Email',
          width: 220,
          showOnMobile: false,
          cellBuilder: (context, user) => Text(_emailFor(user), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        ExpressiveTableColumn<AdminUser>(
          id: 'created',
          label: 'Created',
          width: 148,
          showOnMobile: false,
          cellBuilder: (context, user) =>
              Text(_formatAdminUserDate(user.createdAt), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        ExpressiveTableColumn<AdminUser>(
          id: 'last-seen',
          label: 'Last seen',
          width: 148,
          headerTooltip: 'Last seen updates when the user connects via websocket. It may not reflect offline-listening syncs or third-party clients that do not use websockets.',
          cellBuilder: (context, user) =>
              Text(_formatAdminUserDate(user.lastSeen), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
      actions: [
        ExpressiveTableAction<AdminUser>(
          icon: Icons.qr_code_2_rounded,
          tooltip: 'Create Authentication Code',
          onPressed: onCreateAuthenticationCode,
        ),
        ExpressiveTableAction<AdminUser>(icon: Icons.edit_outlined, tooltip: 'Edit user', onPressed: onEditUser),
        ExpressiveTableAction<AdminUser>(
          icon: Icons.power_settings_new_rounded,
          tooltip: 'Enable or disable user',
          isVisible: (user) => !user.isRoot,
          iconBuilder: (user) => user.isActive ? Icons.block_rounded : Icons.check_circle_outline_rounded,
          tooltipBuilder: (user) => user.isActive ? 'Disable user' : 'Enable user',
          onPressed: onToggleUserActive,
        ),
        ExpressiveTableAction<AdminUser>(
          icon: Icons.link_off_rounded,
          tooltip: 'Unlink OpenID',
          isVisible: (user) => user.hasLinkedOpenId,
          onPressed: onUnlinkOpenId,
        ),
        ExpressiveTableAction<AdminUser>(
          icon: Icons.delete_outline_rounded,
          tooltip: 'Delete user',
          tone: ExpressiveTableActionTone.danger,
          isEnabled: (user) => activeUserId != user.id,
          onPressed: onDeleteUser,
        ),
      ],
      emptyTitle: hasSearchQuery ? 'No users match your current search.' : 'No users found on this server.',
      emptySubtitle: hasSearchQuery
          ? 'Try a different username, role, or email filter.'
          : 'Create users to manage access and permissions.',
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      actionButtonVariant: YaabsaActionButtonVariant.outlined,
      actionButtonShape: YaabsaActionButtonShape.rounded,
    );
  }
}

class _AdminUserIdentity extends StatelessWidget {
  const _AdminUserIdentity({required this.user, this.showEmail = false});

  final AdminUser user;
  final bool showEmail;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = user.isActive ? colorScheme.primary : colorScheme.outline;
    final identity = Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      runSpacing: 6,
      children: [
        Text(
          user.username,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        AdminUserBadge(
          label: user.isActive ? 'ACTIVE' : 'DISABLED',
          color: statusColor,
          icon: user.isActive ? Icons.check_circle_rounded : Icons.do_not_disturb_on_rounded,
        ),
        if (user.hasLinkedOpenId)
          AdminUserBadge(label: 'OPENID', color: colorScheme.secondary, icon: Icons.link_rounded),
      ],
    );

    if (!showEmail) {
      return identity;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        identity,
        const SizedBox(height: 4),
        Text(
          _emailFor(user),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

String _emailFor(AdminUser user) {
  final email = user.email?.trim();
  if (email == null || email.isEmpty) {
    return 'No email';
  }

  return email;
}

String _formatAdminUserDate(int? value) {
  if (value == null || value <= 0) {
    return 'Unknown';
  }

  final date = DateTime.fromMillisecondsSinceEpoch(value);
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$year-$month-$day $hour:$minute';
}
