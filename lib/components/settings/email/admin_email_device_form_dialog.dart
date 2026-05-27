import 'package:flutter/material.dart';
import 'package:yaabsa/api/admin/admin_email_settings.dart';
import 'package:yaabsa/api/admin/session_user_summary.dart';
import 'package:yaabsa/components/common/inputs/expressive_dropdown.dart';
import 'package:yaabsa/components/common/inputs/styled_form_fields.dart';
import 'package:yaabsa/components/settings/email/admin_email_device_availability.dart';
import 'package:yaabsa/components/settings/email/admin_email_settings_validation.dart';

Future<AdminEmailEreaderDevice?> showAdminEmailDeviceFormDialog({
  required BuildContext context,
  required List<AdminEmailEreaderDevice> existingDevices,
  required List<SessionUserSummary> users,
  AdminEmailEreaderDevice? initialDevice,
}) {
  return showDialog<AdminEmailEreaderDevice>(
    context: context,
    builder: (dialogContext) =>
        _AdminEmailDeviceFormDialog(existingDevices: existingDevices, users: users, initialDevice: initialDevice),
  );
}

class _AdminEmailDeviceFormDialog extends StatefulWidget {
  const _AdminEmailDeviceFormDialog({required this.existingDevices, required this.users, this.initialDevice});

  final List<AdminEmailEreaderDevice> existingDevices;
  final List<SessionUserSummary> users;
  final AdminEmailEreaderDevice? initialDevice;

  @override
  State<_AdminEmailDeviceFormDialog> createState() => _AdminEmailDeviceFormDialogState();
}

class _AdminEmailDeviceFormDialogState extends State<_AdminEmailDeviceFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  late String _availabilityOption;
  late Set<String> _selectedUserIds;

  String? _nameError;
  String? _emailError;
  String? _usersError;

  bool get _isEditing => widget.initialDevice != null;

  List<SessionUserSummary> get _sortedUsers {
    final users = List<SessionUserSummary>.from(widget.users);
    users.sort((a, b) {
      final usernameCompare = a.username.toLowerCase().compareTo(b.username.toLowerCase());
      if (usernameCompare != 0) {
        return usernameCompare;
      }
      return a.id.compareTo(b.id);
    });
    return users;
  }

  @override
  void initState() {
    super.initState();
    final initialDevice = widget.initialDevice;
    _nameController = TextEditingController(text: initialDevice?.name ?? '');
    _emailController = TextEditingController(text: initialDevice?.email ?? '');
    _availabilityOption = normalizeAdminEmailAvailabilityOption(initialDevice?.availabilityOption);
    _selectedUserIds = <String>{...initialDevice?.users ?? const <String>[]};
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String? _validateName(String value) {
    final validationError = AdminEmailSettingsValidation.validateDeviceName(value);
    if (validationError != null) {
      return validationError;
    }

    final normalizedName = value.trim().toLowerCase();
    final initialName = widget.initialDevice?.name.trim().toLowerCase();
    final duplicate = widget.existingDevices.any((device) {
      final existingName = device.name.trim().toLowerCase();
      if (initialName != null && existingName == initialName) {
        return false;
      }
      return existingName == normalizedName;
    });

    if (duplicate) {
      return 'Device name already exists.';
    }

    return null;
  }

  String? _validateSpecificUsers() {
    if (normalizeAdminEmailAvailabilityOption(_availabilityOption) != adminEmailAvailabilitySpecificUsers) {
      return null;
    }
    if (_selectedUserIds.isEmpty) {
      return 'Select at least one user for specific-user access.';
    }
    return null;
  }

  void _handleTextChanged() {
    setState(() {
      if (_nameError != null) {
        _nameError = _validateName(_nameController.text);
      }
      if (_emailError != null) {
        _emailError = AdminEmailSettingsValidation.validateDeviceEmail(_emailController.text);
      }
      if (_usersError != null) {
        _usersError = _validateSpecificUsers();
      }
    });
  }

  void _toggleUser(String userId, bool selected) {
    setState(() {
      if (selected) {
        _selectedUserIds.add(userId);
      } else {
        _selectedUserIds.remove(userId);
      }
      if (_usersError != null) {
        _usersError = _validateSpecificUsers();
      }
    });
  }

  void _submit() {
    final nameError = _validateName(_nameController.text);
    final emailError = AdminEmailSettingsValidation.validateDeviceEmail(_emailController.text);
    final usersError = _validateSpecificUsers();

    setState(() {
      _nameError = nameError;
      _emailError = emailError;
      _usersError = usersError;
    });

    if (nameError != null || emailError != null || usersError != null) {
      return;
    }

    final normalizedAvailability = normalizeAdminEmailAvailabilityOption(_availabilityOption);
    final selectedUsers = normalizedAvailability == adminEmailAvailabilitySpecificUsers
        ? (_selectedUserIds.toList()..sort())
        : const <String>[];

    final result = AdminEmailEreaderDevice(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      availabilityOption: normalizedAvailability,
      users: selectedUsers,
    );

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final sortedUsers = _sortedUsers;
    final showSpecificUsers =
        normalizeAdminEmailAvailabilityOption(_availabilityOption) == adminEmailAvailabilitySpecificUsers;

    return AlertDialog(
      title: Text(_isEditing ? 'Edit E-Mail Device' : 'Add E-Mail Device'),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StyledTextField(
                label: 'Device Name',
                controller: _nameController,
                hintText: 'Kindle',
                errorText: _nameError,
                onChanged: (_) => _handleTextChanged(),
              ),
              const SizedBox(height: 10),
              StyledTextField(
                label: 'Device Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: 'kindle@kindle.com',
                errorText: _emailError,
                onChanged: (_) => _handleTextChanged(),
              ),
              const SizedBox(height: 10),
              YaabsaExpressiveDropdownField<String>(
                value: normalizeAdminEmailAvailabilityOption(_availabilityOption),
                decoration: yaabsaFieldDecoration(context, label: 'Accessible By'),
                options: [
                  for (final option in adminEmailAvailabilityOptions)
                    YaabsaDropdownOption<String>(value: option, label: adminEmailAvailabilityLabel(option)),
                ],
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    _availabilityOption = normalizeAdminEmailAvailabilityOption(value);
                    if (_usersError != null) {
                      _usersError = _validateSpecificUsers();
                    }
                  });
                },
              ),
              if (showSpecificUsers) ...[
                const SizedBox(height: 10),
                Text('Allowed Users', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 6),
                if (sortedUsers.isEmpty)
                  Text(
                    'No users available.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 220),
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            for (final user in sortedUsers)
                              FilterChip(
                                label: Text(user.username),
                                selected: _selectedUserIds.contains(user.id),
                                onSelected: (selected) => _toggleUser(user.id, selected),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (_usersError != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    _usersError!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton.icon(
          onPressed: _submit,
          icon: Icon(_isEditing ? Icons.save_outlined : Icons.add_rounded),
          label: Text(_isEditing ? 'Save Device' : 'Add Device'),
        ),
      ],
    );
  }
}
