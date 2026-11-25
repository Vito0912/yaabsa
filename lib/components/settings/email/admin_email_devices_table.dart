import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/admin/admin_email_settings.dart';
import 'package:yaabsa/components/common/tables/expressive_action_table.dart';
import 'package:yaabsa/components/settings/email/admin_email_device_availability.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:intl/intl.dart';

class AdminEmailDevicesTable extends StatelessWidget {
  const AdminEmailDevicesTable({
    super.key,
    required this.devices,
    required this.busyDeviceIds,
    required this.onEdit,
    required this.onDelete,
    this.loading = false,
    this.topActions,
  });

  final List<AdminEmailEreaderDevice> devices;
  final Set<String> busyDeviceIds;
  final Future<void> Function(AdminEmailEreaderDevice device) onEdit;
  final Future<void> Function(AdminEmailEreaderDevice device) onDelete;
  final bool loading;
  final Widget? topActions;

  String _accessLabel(BuildContext context, AdminEmailEreaderDevice device) {
    final normalizedAvailability = normalizeAdminEmailAvailabilityOption(device.availabilityOption);
    if (normalizedAvailability == adminEmailAvailabilitySpecificUsers) {
      return context.l10n.emailDeviceAccessWithUserCount(
        adminEmailAvailabilityLabel(normalizedAvailability),
        device.users.length,
      );
    }
    return adminEmailAvailabilityLabel(normalizedAvailability);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ExpressiveActionTable<AdminEmailEreaderDevice>(
      rows: devices,
      columns: [
        ExpressiveTableColumn<AdminEmailEreaderDevice>(
          id: 'name',
          label: l10n.fieldDevice,
          width: 180,
          cellBuilder: (context, device) => Text(device.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        ExpressiveTableColumn<AdminEmailEreaderDevice>(
          id: 'email',
          label: l10n.fieldEmail,
          width: 240,
          cellBuilder: (context, device) => Text(device.email, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        ExpressiveTableColumn<AdminEmailEreaderDevice>(
          id: 'access',
          label: l10n.fieldAccessibleBy,
          width: 160,
          cellBuilder: (context, device) =>
              Text(_accessLabel(context, device), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        ExpressiveTableColumn<AdminEmailEreaderDevice>(
          id: 'users',
          label: l10n.labelUsers,
          width: 80,
          showOnMobile: false,
          alignment: ExpressiveTableCellAlignment.end,
          cellBuilder: (context, device) =>
              Text(NumberFormat.decimalPattern(l10n.localeName).format(device.users.length)),
        ),
      ],
      topActions: topActions,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      rowId: (device) => '${device.name.trim().toLowerCase()}::${device.email.trim().toLowerCase()}',
      busyRowIds: busyDeviceIds,
      actions: [
        ExpressiveTableAction<AdminEmailEreaderDevice>(
          icon: Icons.edit_outlined,
          tooltip: l10n.actionEdit,
          tone: ExpressiveTableActionTone.primary,
          onPressed: onEdit,
        ),
        ExpressiveTableAction<AdminEmailEreaderDevice>(
          icon: Icons.delete_outline_rounded,
          tooltip: l10n.actionDelete,
          tone: ExpressiveTableActionTone.danger,
          onPressed: onDelete,
        ),
      ],
      loading: loading,
      emptyTitle: l10n.statusNoEreaderDevicesFound,
      emptySubtitle: l10n.messageAddEreaderDeviceDestination,
    );
  }
}
