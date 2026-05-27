import 'package:flutter/material.dart';
import 'package:yaabsa/api/admin/admin_email_settings.dart';
import 'package:yaabsa/components/common/tables/expressive_action_table.dart';
import 'package:yaabsa/components/settings/email/admin_email_device_availability.dart';

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

  String _accessLabel(AdminEmailEreaderDevice device) {
    final normalizedAvailability = normalizeAdminEmailAvailabilityOption(device.availabilityOption);
    if (normalizedAvailability == adminEmailAvailabilitySpecificUsers) {
      return '${adminEmailAvailabilityLabel(normalizedAvailability)} (${device.users.length})';
    }
    return adminEmailAvailabilityLabel(normalizedAvailability);
  }

  @override
  Widget build(BuildContext context) {
    return ExpressiveActionTable<AdminEmailEreaderDevice>(
      rows: devices,
      columns: [
        ExpressiveTableColumn<AdminEmailEreaderDevice>(
          id: 'name',
          label: 'Device',
          width: 180,
          cellBuilder: (context, device) => Text(device.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        ExpressiveTableColumn<AdminEmailEreaderDevice>(
          id: 'email',
          label: 'Email',
          width: 240,
          cellBuilder: (context, device) => Text(device.email, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        ExpressiveTableColumn<AdminEmailEreaderDevice>(
          id: 'access',
          label: 'Accessible By',
          width: 160,
          cellBuilder: (context, device) => Text(_accessLabel(device), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        ExpressiveTableColumn<AdminEmailEreaderDevice>(
          id: 'users',
          label: 'Users',
          width: 80,
          showOnMobile: false,
          alignment: ExpressiveTableCellAlignment.end,
          cellBuilder: (context, device) => Text('${device.users.length}'),
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
          tooltip: 'Edit device',
          tone: ExpressiveTableActionTone.primary,
          onPressed: onEdit,
        ),
        ExpressiveTableAction<AdminEmailEreaderDevice>(
          icon: Icons.delete_outline_rounded,
          tooltip: 'Delete device',
          tone: ExpressiveTableActionTone.danger,
          onPressed: onDelete,
        ),
      ],
      loading: loading,
      emptyTitle: 'No e-reader devices found',
      emptySubtitle: 'Add at least one destination to enable send-to-device email delivery.',
    );
  }
}
