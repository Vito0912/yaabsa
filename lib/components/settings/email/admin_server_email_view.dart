import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/admin/admin_email_settings.dart';
import 'package:yaabsa/api/admin/session_user_summary.dart';
import 'package:yaabsa/api/admin/update_admin_email_ereader_devices_request.dart';
import 'package:yaabsa/api/admin/update_admin_email_settings_request.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';
import 'package:yaabsa/components/settings/email/admin_email_device_form_dialog.dart';
import 'package:yaabsa/components/settings/email/admin_email_devices_table.dart';
import 'package:yaabsa/components/settings/email/admin_email_settings_panel.dart';
import 'package:yaabsa/components/settings/email/admin_email_settings_validation.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';

class AdminServerEmailView extends ConsumerStatefulWidget {
  const AdminServerEmailView({super.key});

  @override
  ConsumerState<AdminServerEmailView> createState() => _AdminServerEmailViewState();
}

class _AdminServerEmailViewState extends ConsumerState<AdminServerEmailView> {
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fromAddressController = TextEditingController();
  final TextEditingController _testAddressController = TextEditingController();

  String? _activeUserId;

  bool _isLoading = true;
  bool _isSavingSettings = false;
  bool _isSendingTest = false;
  bool _isSavingDevices = false;

  bool _secure = true;
  bool _rejectUnauthorized = true;
  bool _obscurePassword = true;

  String? _errorMessage;
  String? _hostError;
  String? _portError;
  String? _fromAddressError;
  String? _testAddressError;

  AdminEmailSettings _settings = const AdminEmailSettings();
  List<AdminEmailEreaderDevice> _devices = const <AdminEmailEreaderDevice>[];
  List<SessionUserSummary> _users = const <SessionUserSummary>[];

  final Set<String> _busyDeviceIds = <String>{};

  bool _isAdminType(String? type) => type == 'root' || type == 'admin';

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    _userController.dispose();
    _passwordController.dispose();
    _fromAddressController.dispose();
    _testAddressController.dispose();
    super.dispose();
  }

  List<AdminEmailEreaderDevice> _sortedDevices(List<AdminEmailEreaderDevice> devices) {
    final values = List<AdminEmailEreaderDevice>.from(devices);
    values.sort((a, b) {
      final nameCompare = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      if (nameCompare != 0) {
        return nameCompare;
      }
      return a.email.toLowerCase().compareTo(b.email.toLowerCase());
    });
    return values;
  }

  List<SessionUserSummary> _sortedUsers(List<SessionUserSummary> users) {
    final values = List<SessionUserSummary>.from(users);
    values.sort((a, b) {
      final usernameCompare = a.username.toLowerCase().compareTo(b.username.toLowerCase());
      if (usernameCompare != 0) {
        return usernameCompare;
      }
      return a.id.compareTo(b.id);
    });
    return values;
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _deviceRowId(AdminEmailEreaderDevice device) {
    return '${device.name.trim().toLowerCase()}::${device.email.trim().toLowerCase()}';
  }

  String? _normalizedField(TextEditingController controller) {
    return AdminEmailSettingsValidation.normalizeNullable(controller.text);
  }

  String? _normalizedSettingsValue(String? value) {
    return AdminEmailSettingsValidation.normalizeNullable(value ?? '');
  }

  int? _parsedPort() {
    return int.tryParse(_portController.text.trim());
  }

  bool get _hasSettingsChanges {
    if (_normalizedField(_hostController) != _normalizedSettingsValue(_settings.host)) {
      return true;
    }

    final parsedPort = _parsedPort();
    if (parsedPort == null || parsedPort != _settings.port) {
      return true;
    }

    if (_secure != _settings.secure) {
      return true;
    }

    if (_rejectUnauthorized != _settings.rejectUnauthorized) {
      return true;
    }

    if (_normalizedField(_userController) != _normalizedSettingsValue(_settings.user)) {
      return true;
    }

    if (_normalizedField(_passwordController) != _normalizedSettingsValue(_settings.pass)) {
      return true;
    }

    if (_normalizedField(_fromAddressController) != _normalizedSettingsValue(_settings.fromAddress)) {
      return true;
    }

    if (_normalizedField(_testAddressController) != _normalizedSettingsValue(_settings.testAddress)) {
      return true;
    }

    return false;
  }

  bool get _canSaveSettings => !_isLoading && !_isSavingSettings && !_isSendingTest && _hasSettingsChanges;

  bool get _canSendTestEmail {
    return !_isLoading &&
        !_isSavingSettings &&
        !_isSendingTest &&
        AdminEmailSettingsValidation.normalizeNullable(_hostController.text) != null;
  }

  bool _validateSettings({required bool showErrors}) {
    final hostError = AdminEmailSettingsValidation.validateHost(_hostController.text);
    final portError = AdminEmailSettingsValidation.validatePort(_portController.text);
    final fromAddressError = AdminEmailSettingsValidation.validateOptionalEmail(
      _fromAddressController.text,
      fieldLabel: 'From address',
    );
    final testAddressError = AdminEmailSettingsValidation.validateOptionalEmail(
      _testAddressController.text,
      fieldLabel: 'Test address',
    );

    if (showErrors) {
      setState(() {
        _hostError = hostError;
        _portError = portError;
        _fromAddressError = fromAddressError;
        _testAddressError = testAddressError;
      });
    }

    return hostError == null && portError == null && fromAddressError == null && testAddressError == null;
  }

  void _setBusyDevice(String rowId, bool busy) {
    setState(() {
      if (busy) {
        _busyDeviceIds.add(rowId);
      } else {
        _busyDeviceIds.remove(rowId);
      }
    });
  }

  void _handleSettingsFieldChanged() {
    setState(() {
      if (_hostError != null) {
        _hostError = AdminEmailSettingsValidation.validateHost(_hostController.text);
      }
      if (_portError != null) {
        _portError = AdminEmailSettingsValidation.validatePort(_portController.text);
      }
      if (_fromAddressError != null) {
        _fromAddressError = AdminEmailSettingsValidation.validateOptionalEmail(
          _fromAddressController.text,
          fieldLabel: 'From address',
        );
      }
      if (_testAddressError != null) {
        _testAddressError = AdminEmailSettingsValidation.validateOptionalEmail(
          _testAddressController.text,
          fieldLabel: 'Test address',
        );
      }
      _errorMessage = null;
    });
  }

  Future<void> _loadEmailData({required bool showLoading}) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'No active API client.';
      });
      return;
    }

    if (showLoading) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final settingsResponse = await api.getAdminApi().getEmailSettings();
      final usersResponse = await api.getAdminApi().getUsers();

      if (!mounted) {
        return;
      }

      final nextSettings = settingsResponse.data?.settings ?? const AdminEmailSettings();
      final nextDevices = _sortedDevices(nextSettings.ereaderDevices);
      final nextUsers = _sortedUsers(usersResponse.data?.users ?? const <SessionUserSummary>[]);

      setState(() {
        _settings = nextSettings.copyWith(ereaderDevices: nextDevices);
        _devices = nextDevices;
        _users = nextUsers;

        _hostController.text = nextSettings.host ?? '';
        _portController.text = '${nextSettings.port}';
        _userController.text = nextSettings.user ?? '';
        _passwordController.text = nextSettings.pass ?? '';
        _fromAddressController.text = nextSettings.fromAddress ?? '';
        _testAddressController.text = nextSettings.testAddress ?? '';

        _secure = nextSettings.secure;
        _rejectUnauthorized = nextSettings.rejectUnauthorized;

        _hostError = null;
        _portError = null;
        _fromAddressError = null;
        _testAddressError = null;

        _errorMessage = null;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = listManagementErrorMessage(error, fallback: 'Failed to load e-mail settings.');
        _isLoading = false;
      });
    }
  }

  UpdateAdminEmailSettingsRequest _buildSettingsUpdateRequest() {
    return UpdateAdminEmailSettingsRequest(
      host: _normalizedField(_hostController),
      port: _parsedPort(),
      secure: _secure,
      rejectUnauthorized: _rejectUnauthorized,
      user: _normalizedField(_userController),
      pass: _normalizedField(_passwordController),
      fromAddress: _normalizedField(_fromAddressController),
      testAddress: _normalizedField(_testAddressController),
    );
  }

  Future<bool> _saveEmailSettings({bool showSuccessMessage = true}) async {
    if (_isSavingSettings || _isLoading) {
      return false;
    }

    if (!_validateSettings(showErrors: true)) {
      return false;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      if (mounted) {
        setState(() {
          _errorMessage = 'No active API client.';
        });
      }
      return false;
    }

    setState(() {
      _isSavingSettings = true;
      _errorMessage = null;
    });

    try {
      final response = await api.getAdminApi().updateEmailSettings(payload: _buildSettingsUpdateRequest());
      final updatedSettings = response.data?.settings;

      if (!mounted) {
        return false;
      }

      if (updatedSettings != null) {
        final updatedDevices = _sortedDevices(updatedSettings.ereaderDevices);
        setState(() {
          _settings = updatedSettings.copyWith(ereaderDevices: updatedDevices);
          _devices = updatedDevices;

          _hostController.text = updatedSettings.host ?? '';
          _portController.text = '${updatedSettings.port}';
          _userController.text = updatedSettings.user ?? '';
          _passwordController.text = updatedSettings.pass ?? '';
          _fromAddressController.text = updatedSettings.fromAddress ?? '';
          _testAddressController.text = updatedSettings.testAddress ?? '';

          _secure = updatedSettings.secure;
          _rejectUnauthorized = updatedSettings.rejectUnauthorized;

          _hostError = null;
          _portError = null;
          _fromAddressError = null;
          _testAddressError = null;
          _errorMessage = null;
        });
      } else {
        await _loadEmailData(showLoading: false);
      }

      if (showSuccessMessage) {
        _showMessage('E-Mail settings saved.');
      }

      return true;
    } catch (error) {
      if (!mounted) {
        return false;
      }

      setState(() {
        _errorMessage = listManagementErrorMessage(error, fallback: 'Failed to save e-mail settings.');
      });
      return false;
    } finally {
      if (mounted) {
        setState(() {
          _isSavingSettings = false;
        });
      }
    }
  }

  Future<void> _sendTestEmail() async {
    if (_isSendingTest || _isLoading || _isSavingSettings) {
      return;
    }

    if (!_validateSettings(showErrors: true)) {
      return;
    }

    if (_hasSettingsChanges) {
      final saved = await _saveEmailSettings(showSuccessMessage: false);
      if (!saved) {
        return;
      }
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      if (mounted) {
        setState(() {
          _errorMessage = 'No active API client.';
        });
      }
      return;
    }

    setState(() {
      _isSendingTest = true;
      _errorMessage = null;
    });

    try {
      final success = await api.getAdminApi().sendEmailTest();

      if (!mounted) {
        return;
      }

      if (success) {
        _showMessage('Test e-mail sent.');
      } else {
        setState(() {
          _errorMessage = 'Failed to send test e-mail.';
        });
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = listManagementErrorMessage(error, fallback: 'Failed to send test e-mail.');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSendingTest = false;
        });
      }
    }
  }

  Future<bool> _saveEreaderDevices(
    List<AdminEmailEreaderDevice> devices, {
    required String successMessage,
    required String fallbackError,
  }) async {
    if (_isSavingDevices) {
      return false;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      if (mounted) {
        setState(() {
          _errorMessage = 'No active API client.';
        });
      }
      return false;
    }

    setState(() {
      _isSavingDevices = true;
      _errorMessage = null;
    });

    try {
      final response = await api.getAdminApi().updateEmailEreaderDevices(
        payload: UpdateAdminEmailEreaderDevicesRequest(ereaderDevices: devices),
      );

      if (!mounted) {
        return false;
      }

      final updatedDevices = _sortedDevices(response.data?.ereaderDevices ?? devices);
      setState(() {
        _devices = updatedDevices;
        _settings = _settings.copyWith(ereaderDevices: updatedDevices);
      });

      _showMessage(successMessage);
      return true;
    } catch (error) {
      if (!mounted) {
        return false;
      }

      setState(() {
        _errorMessage = listManagementErrorMessage(error, fallback: fallbackError);
      });
      return false;
    } finally {
      if (mounted) {
        setState(() {
          _isSavingDevices = false;
        });
      }
    }
  }

  Future<void> _addDevice() async {
    if (_isSavingDevices || _isLoading) {
      return;
    }

    final created = await showAdminEmailDeviceFormDialog(context: context, existingDevices: _devices, users: _users);

    if (created == null || !mounted) {
      return;
    }

    final nextDevices = <AdminEmailEreaderDevice>[..._devices, created];
    await _saveEreaderDevices(
      nextDevices,
      successMessage: 'E-Mail device added.',
      fallbackError: 'Failed to add e-mail device.',
    );
  }

  Future<void> _editDevice(AdminEmailEreaderDevice device) async {
    final rowId = _deviceRowId(device);
    _setBusyDevice(rowId, true);

    try {
      final updated = await showAdminEmailDeviceFormDialog(
        context: context,
        existingDevices: _devices,
        users: _users,
        initialDevice: device,
      );

      if (updated == null || !mounted) {
        return;
      }

      final index = _devices.indexWhere((entry) => _deviceRowId(entry) == rowId);
      if (index < 0) {
        return;
      }

      final nextDevices = List<AdminEmailEreaderDevice>.from(_devices);
      nextDevices[index] = updated;

      await _saveEreaderDevices(
        nextDevices,
        successMessage: 'E-Mail device updated.',
        fallbackError: 'Failed to update e-mail device.',
      );
    } finally {
      if (mounted) {
        _setBusyDevice(rowId, false);
      }
    }
  }

  Future<void> _deleteDevice(AdminEmailEreaderDevice device) async {
    final rowId = _deviceRowId(device);
    _setBusyDevice(rowId, true);

    try {
      final confirmed = await showListManagementDeleteDialog(
        context: context,
        title: 'Delete E-Mail Device',
        message: 'Delete ${device.name}? This removes it from send-to-device destinations.',
      );

      if (!confirmed || !mounted) {
        return;
      }

      final nextDevices = _devices.where((entry) => _deviceRowId(entry) != rowId).toList(growable: false);

      await _saveEreaderDevices(
        nextDevices,
        successMessage: 'E-Mail device deleted.',
        fallbackError: 'Failed to delete e-mail device.',
      );
    } finally {
      if (mounted) {
        _setBusyDevice(rowId, false);
      }
    }
  }

  Widget _buildErrorCard() {
    final message = _errorMessage;
    if (message == null || message.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.45),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
        child: Row(
          children: [
            Icon(Icons.error_outline_rounded, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
            const SizedBox(width: 10),
            TextButton(onPressed: () => unawaited(_loadEmailData(showLoading: true)), child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _buildDevicesToolbar({required bool compact}) {
    final addButton = FilledButton.icon(
      onPressed: _isLoading || _isSavingDevices ? null : () => unawaited(_addDevice()),
      icon: const Icon(Icons.add_rounded),
      label: const Text('Add Device'),
    );

    final refreshButton = OutlinedButton.icon(
      onPressed: _isLoading ? null : () => unawaited(_loadEmailData(showLoading: true)),
      icon: const Icon(Icons.refresh_rounded),
      label: const Text('Refresh'),
    );

    if (compact) {
      return Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.end, children: [refreshButton, addButton]);
    }

    return Row(children: [const Spacer(), refreshButton, const SizedBox(width: 8), addButton]);
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return currentUserAsync.when(
      data: (currentUser) {
        if (currentUser == null) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text('No active user. Sign in to manage e-mail settings.'),
          );
        }

        if (!_isAdminType(currentUser.type)) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text('This page requires an admin account.'),
          );
        }

        if (_activeUserId != currentUser.id) {
          _activeUserId = currentUser.id;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            unawaited(_loadEmailData(showLoading: true));
          });
        }

        final compact = context.isMobile;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isLoading && _devices.isNotEmpty) ...[
                const SizedBox(height: 8),
                const LinearProgressIndicator(minHeight: 2),
              ],
              const SizedBox(height: 10),
              _buildErrorCard(),
              if (_errorMessage?.isNotEmpty == true) const SizedBox(height: 10),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => _loadEmailData(showLoading: false),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      AdminEmailSettingsPanel(
                        hostController: _hostController,
                        portController: _portController,
                        userController: _userController,
                        passwordController: _passwordController,
                        fromAddressController: _fromAddressController,
                        testAddressController: _testAddressController,
                        secure: _secure,
                        rejectUnauthorized: _rejectUnauthorized,
                        obscurePassword: _obscurePassword,
                        isSavingSettings: _isSavingSettings,
                        isSendingTest: _isSendingTest,
                        canSaveSettings: _canSaveSettings,
                        canSendTest: _canSendTestEmail,
                        hostError: _hostError,
                        portError: _portError,
                        fromAddressError: _fromAddressError,
                        testAddressError: _testAddressError,
                        onHostChanged: (_) => _handleSettingsFieldChanged(),
                        onPortChanged: (_) => _handleSettingsFieldChanged(),
                        onUserChanged: (_) => _handleSettingsFieldChanged(),
                        onPasswordChanged: (_) => _handleSettingsFieldChanged(),
                        onFromAddressChanged: (_) => _handleSettingsFieldChanged(),
                        onTestAddressChanged: (_) => _handleSettingsFieldChanged(),
                        onSecureChanged: (value) {
                          setState(() {
                            _secure = value;
                            _errorMessage = null;
                          });
                        },
                        onRejectUnauthorizedChanged: (value) {
                          setState(() {
                            _rejectUnauthorized = value;
                            _errorMessage = null;
                          });
                        },
                        onObscurePasswordChanged: (value) {
                          setState(() {
                            _obscurePassword = value;
                          });
                        },
                        onSaveSettings: () => unawaited(_saveEmailSettings()),
                        onSendTestEmail: () => unawaited(_sendTestEmail()),
                      ),
                      const SizedBox(height: 12),
                      AdminEmailDevicesTable(
                        devices: _devices,
                        busyDeviceIds: _busyDeviceIds,
                        loading: _isLoading,
                        topActions: _buildDevicesToolbar(compact: compact),
                        onEdit: _editDevice,
                        onDelete: _deleteDevice,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Text('Failed to load user data: $error', style: TextStyle(color: Theme.of(context).colorScheme.error)),
      ),
    );
  }
}
