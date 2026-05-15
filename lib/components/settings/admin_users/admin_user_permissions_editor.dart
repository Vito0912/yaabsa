import 'package:flutter/material.dart';
import 'package:yaabsa/api/admin/admin_user_permissions.dart';

class AdminUserPermissionsEditor extends StatelessWidget {
  const AdminUserPermissionsEditor({
    super.key,
    required this.permissions,
    required this.onChanged,
    this.enabled = true,
  });

  final AdminUserPermissions permissions;
  final ValueChanged<AdminUserPermissions> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Permissions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            _PermissionSwitch(
              label: 'Can download',
              value: permissions.download,
              enabled: enabled,
              onChanged: (value) => onChanged(permissions.copyWith(download: value)),
            ),
            _PermissionSwitch(
              label: 'Can update',
              value: permissions.update,
              enabled: enabled,
              onChanged: (value) => onChanged(permissions.copyWith(update: value)),
            ),
            _PermissionSwitch(
              label: 'Can delete',
              value: permissions.delete,
              enabled: enabled,
              onChanged: (value) => onChanged(permissions.copyWith(delete: value)),
            ),
            _PermissionSwitch(
              label: 'Can upload',
              value: permissions.upload,
              enabled: enabled,
              onChanged: (value) => onChanged(permissions.copyWith(upload: value)),
            ),
            _PermissionSwitch(
              label: 'Can create eReader devices',
              value: permissions.createEreader,
              enabled: enabled,
              onChanged: (value) => onChanged(permissions.copyWith(createEreader: value)),
            ),
            _PermissionSwitch(
              label: 'Can access explicit content',
              value: permissions.accessExplicitContent,
              enabled: enabled,
              onChanged: (value) => onChanged(permissions.copyWith(accessExplicitContent: value)),
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionSwitch extends StatelessWidget {
  const _PermissionSwitch({required this.label, required this.value, required this.onChanged, this.enabled = true});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      value: value,
      onChanged: enabled ? onChanged : null,
    );
  }
}
