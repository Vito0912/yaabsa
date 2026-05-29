import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaabsa/api/admin/admin_api_key.dart';
import 'package:yaabsa/api/admin/create_admin_api_key_request.dart';
import 'package:yaabsa/api/admin/session_user_summary.dart';
import 'package:yaabsa/api/admin/update_admin_api_key_request.dart';
import 'package:yaabsa/components/common/inputs/expressive_dropdown.dart';
import 'package:yaabsa/components/common/inputs/styled_form_fields.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';

Future<CreateAdminApiKeyRequest?> showCreateAdminApiKeyDialog(
  BuildContext context, {
  required List<SessionUserSummary> users,
  required String initialUserId,
}) {
  return showDialog<CreateAdminApiKeyRequest>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _CreateAdminApiKeyDialog(users: users, initialUserId: initialUserId),
  );
}

Future<UpdateAdminApiKeyRequest?> showUpdateAdminApiKeyDialog(
  BuildContext context, {
  required AdminApiKey apiKey,
  required List<SessionUserSummary> users,
}) {
  return showDialog<UpdateAdminApiKeyRequest>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _UpdateAdminApiKeyDialog(apiKey: apiKey, users: users),
  );
}

class _CreateAdminApiKeyDialog extends StatefulWidget {
  const _CreateAdminApiKeyDialog({required this.users, required this.initialUserId});

  final List<SessionUserSummary> users;
  final String initialUserId;

  @override
  State<_CreateAdminApiKeyDialog> createState() => _CreateAdminApiKeyDialogState();
}

class _CreateAdminApiKeyDialogState extends State<_CreateAdminApiKeyDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _expiresDaysController;

  late String? _selectedUserId;
  bool _isActive = true;
  bool _neverExpires = true;

  String? _nameError;
  String? _userError;
  String? _expiresInError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _expiresDaysController = TextEditingController();

    final hasInitialUser = widget.users.any((user) => user.id == widget.initialUserId);
    _selectedUserId = hasInitialUser
        ? widget.initialUserId
        : widget.users.isNotEmpty
        ? widget.users.first.id
        : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _expiresDaysController.dispose();
    super.dispose();
  }

  List<YaabsaDropdownOption<String>> _userOptions() {
    final sortedUsers = List<SessionUserSummary>.from(widget.users)
      ..sort((left, right) {
        final byName = left.username.toLowerCase().compareTo(right.username.toLowerCase());
        if (byName != 0) {
          return byName;
        }
        return left.id.compareTo(right.id);
      });

    return sortedUsers
        .map(
          (user) => YaabsaDropdownOption<String>(
            value: user.id,
            label: user.username,
            labelWidget: _buildUserLabelWidget(context, user),
          ),
        )
        .toList(growable: false);
  }

  Widget _buildUserLabelWidget(BuildContext context, SessionUserSummary user) {
    return Text(user.username, overflow: TextOverflow.ellipsis);
  }

  String? _validateName(String value) {
    if (value.trim().isEmpty) {
      return 'Name is required.';
    }
    return null;
  }

  String? _validateSelectedUser(String? userId) {
    if (userId == null || userId.trim().isEmpty) {
      return 'Owner is required.';
    }
    return null;
  }

  String? _validateExpiresInDays(String value) {
    if (_neverExpires) {
      return null;
    }

    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Expires in days is required when expiration is enabled.';
    }

    final parsed = int.tryParse(trimmed);
    if (parsed == null || parsed <= 0) {
      return 'Enter a positive whole number of days.';
    }

    if (parsed > 36500) {
      return 'Use 36500 days or less.';
    }

    return null;
  }

  void _submit() {
    final nameError = _validateName(_nameController.text);
    final userError = _validateSelectedUser(_selectedUserId);
    final expiresInError = _validateExpiresInDays(_expiresDaysController.text);

    if (nameError != null || userError != null || expiresInError != null) {
      setState(() {
        _nameError = nameError;
        _userError = userError;
        _expiresInError = expiresInError;
      });
      return;
    }

    final expiresInDays = int.tryParse(_expiresDaysController.text.trim());
    final expiresInSeconds = _neverExpires ? null : expiresInDays! * 24 * 60 * 60;

    Navigator.of(context).pop(
      CreateAdminApiKeyRequest(
        name: _nameController.text.trim(),
        userId: _selectedUserId!,
        expiresIn: expiresInSeconds,
        isActive: _isActive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userOptions = _userOptions();

    return AlertDialog(
      title: const Text('Create API Key'),
      content: SizedBox(
        width: 540,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StyledTextField(
                label: 'Name',
                controller: _nameController,
                onChanged: (_) {
                  if (_nameError == null) {
                    return;
                  }
                  setState(() {
                    _nameError = _validateName(_nameController.text);
                  });
                },
                hintText: 'Example: Home Assistant Integration',
                errorText: _nameError,
              ),
              const SizedBox(height: 12),
              YaabsaExpressiveDropdownField<String>(
                value: _selectedUserId,
                options: userOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedUserId = value;
                    _userError = _validateSelectedUser(value);
                  });
                },
                decoration: yaabsaFieldDecoration(
                  context,
                  label: 'Owner',
                  hintText: 'Select key owner',
                ).copyWith(errorText: _userError),
              ),
              const SizedBox(height: 4),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('API key is active'),
                subtitle: const Text('Inactive keys cannot authenticate API requests.'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Never expires'),
                subtitle: const Text('Turn off to set an expiration in days.'),
                value: _neverExpires,
                onChanged: (value) {
                  setState(() {
                    _neverExpires = value;
                    if (_neverExpires) {
                      _expiresInError = null;
                    }
                  });
                },
              ),
              if (!_neverExpires)
                StyledTextField(
                  label: 'Expires in days',
                  controller: _expiresDaysController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  hintText: 'Example: 30',
                  errorText: _expiresInError,
                  onChanged: (_) {
                    if (_expiresInError == null) {
                      return;
                    }
                    setState(() {
                      _expiresInError = _validateExpiresInDays(_expiresDaysController.text);
                    });
                  },
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton.icon(onPressed: _submit, icon: const Icon(Icons.key_rounded), label: const Text('Create key')),
      ],
    );
  }
}

class _UpdateAdminApiKeyDialog extends StatefulWidget {
  const _UpdateAdminApiKeyDialog({required this.apiKey, required this.users});

  final AdminApiKey apiKey;
  final List<SessionUserSummary> users;

  @override
  State<_UpdateAdminApiKeyDialog> createState() => _UpdateAdminApiKeyDialogState();
}

class _UpdateAdminApiKeyDialogState extends State<_UpdateAdminApiKeyDialog> {
  late String? _selectedUserId;
  late bool _isActive;
  String? _validationError;

  List<YaabsaDropdownOption<String>> _userOptions() {
    final sortedUsers = List<SessionUserSummary>.from(widget.users)
      ..sort((left, right) {
        final byName = left.username.toLowerCase().compareTo(right.username.toLowerCase());
        if (byName != 0) {
          return byName;
        }
        return left.id.compareTo(right.id);
      });

    return sortedUsers
        .map(
          (user) => YaabsaDropdownOption<String>(
            value: user.id,
            label: user.username,
            labelWidget: _buildUserLabelWidget(context, user),
          ),
        )
        .toList(growable: false);
  }

  Widget _buildUserLabelWidget(BuildContext context, SessionUserSummary user) {
    return Text(user.username, overflow: TextOverflow.ellipsis);
  }

  @override
  void initState() {
    super.initState();
    _selectedUserId = widget.apiKey.userId;
    _isActive = widget.apiKey.isActive;
  }

  bool get _hasChanges {
    return _selectedUserId != widget.apiKey.userId || _isActive != widget.apiKey.isActive;
  }

  void _submit() {
    if (_selectedUserId == null || _selectedUserId!.trim().isEmpty) {
      setState(() {
        _validationError = 'Owner is required.';
      });
      return;
    }

    Navigator.of(context).pop(UpdateAdminApiKeyRequest(userId: _selectedUserId, isActive: _isActive));
  }

  @override
  Widget build(BuildContext context) {
    final currentOwner = widget.apiKey.user?.username ?? widget.apiKey.userId;

    return AlertDialog(
      title: const Text('Edit API Key'),
      content: SizedBox(
        width: 540,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(widget.apiKey.name, style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text('Current owner: $currentOwner'),
              ),
              const SizedBox(height: 6),
              YaabsaExpressiveDropdownField<String>(
                value: _selectedUserId,
                options: _userOptions(),
                onChanged: (value) {
                  setState(() {
                    _selectedUserId = value;
                    _validationError = null;
                  });
                },
                decoration: yaabsaFieldDecoration(context, label: 'Owner', hintText: 'Select key owner'),
              ),
              const SizedBox(height: 8),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('API key is active'),
                subtitle: const Text('Inactive keys cannot authenticate API requests.'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
              ),
              const SizedBox(height: 4),
              Text(
                widget.apiKey.expiresAt == null
                    ? 'Expires: Never'
                    : 'Expires: ${formatDateTimeLabel(widget.apiKey.expiresAt)}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              if (_validationError != null && _validationError!.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(_validationError!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton.icon(
          onPressed: _hasChanges ? _submit : null,
          icon: const Icon(Icons.save_outlined),
          label: const Text('Save changes'),
        ),
      ],
    );
  }
}
