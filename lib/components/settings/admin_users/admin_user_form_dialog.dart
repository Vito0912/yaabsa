import 'package:flutter/material.dart';
import 'package:yaabsa/api/admin/admin_user_permissions.dart';
import 'package:yaabsa/api/admin/admin_user_upsert_request.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/components/common/inputs/expressive_dropdown.dart';
import 'package:yaabsa/components/settings/admin_users/admin_user_multi_select_card.dart';
import 'package:yaabsa/components/settings/admin_users/admin_user_permissions_editor.dart';
import 'package:yaabsa/util/globals.dart';

enum AdminUserFormMode { create, edit }

class AdminUserFormInitialValue {
  const AdminUserFormInitialValue({
    required this.username,
    required this.email,
    required this.type,
    required this.isActive,
    required this.permissions,
    required this.librariesAccessible,
    required this.itemTagsSelected,
    required this.hasLinkedOpenId,
  });

  final String username;
  final String? email;
  final String type;
  final bool isActive;
  final AdminUserPermissions permissions;
  final List<String> librariesAccessible;
  final List<String> itemTagsSelected;
  final bool hasLinkedOpenId;
}

Future<AdminUserUpsertRequest?> showAdminUserFormDialog(
  BuildContext context, {
  required AdminUserFormMode mode,
  required AdminUserFormInitialValue initialValue,
  required List<Library> availableLibraries,
  required List<String> availableTags,
  Future<bool> Function()? onUnlinkOpenId,
}) {
  return showDialog<AdminUserUpsertRequest>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return _AdminUserFormDialog(
        mode: mode,
        initialValue: initialValue,
        availableLibraries: availableLibraries,
        availableTags: availableTags,
        onUnlinkOpenId: onUnlinkOpenId,
      );
    },
  );
}

class _AdminUserFormDialog extends StatefulWidget {
  const _AdminUserFormDialog({
    required this.mode,
    required this.initialValue,
    required this.availableLibraries,
    required this.availableTags,
    this.onUnlinkOpenId,
  });

  final AdminUserFormMode mode;
  final AdminUserFormInitialValue initialValue;
  final List<Library> availableLibraries;
  final List<String> availableTags;
  final Future<bool> Function()? onUnlinkOpenId;

  @override
  State<_AdminUserFormDialog> createState() => _AdminUserFormDialogState();
}

class _AdminUserFormDialogState extends State<_AdminUserFormDialog> {
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  late String _type;
  late bool _isActive;
  late bool _hasLinkedOpenId;
  late AdminUserPermissions _permissions;
  late Set<String> _selectedLibraries;
  late Set<String> _selectedTags;

  bool _isSubmitting = false;
  bool _isUnlinking = false;
  bool _permissionsTouched = false;
  String? _usernameError;
  String? _emailError;
  String? _passwordError;
  String? _validationError;

  bool get _isCreateMode => widget.mode == AdminUserFormMode.create;

  bool get _isRootType => _type.trim().toLowerCase() == 'root';

  bool get _canEditType {
    final normalizedType = widget.initialValue.type.trim().toLowerCase();
    return normalizedType != 'root';
  }

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.initialValue.username);
    _emailController = TextEditingController(text: widget.initialValue.email ?? '');
    _passwordController = TextEditingController();

    _type = widget.initialValue.type.trim().toLowerCase();
    _isActive = _type == 'root' ? true : widget.initialValue.isActive;
    _hasLinkedOpenId = widget.initialValue.hasLinkedOpenId;
    _permissions = widget.initialValue.permissions;
    _selectedLibraries = widget.initialValue.librariesAccessible.map((entry) => entry.trim()).toSet();
    _selectedTags = widget.initialValue.itemTagsSelected.map((entry) => entry.trim()).toSet();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  List<AdminUserSelectableOption> _libraryOptions() {
    final libraries = List<Library>.from(widget.availableLibraries)
      ..sort((left, right) => left.name.toLowerCase().compareTo(right.name.toLowerCase()));

    return libraries
        .map((library) => AdminUserSelectableOption(id: library.id, label: library.name, subtitle: library.mediaType))
        .toList(growable: false);
  }

  List<AdminUserSelectableOption> _tagOptions() {
    final tags = widget.availableTags.map((entry) => entry.trim()).where((entry) => entry.isNotEmpty).toSet().toList()
      ..sort((left, right) => left.toLowerCase().compareTo(right.toLowerCase()));

    return tags.map((tag) => AdminUserSelectableOption(id: tag, label: tag)).toList(growable: false);
  }

  List<String> _normalizedSelection(Set<String> selection) {
    final values = selection.map((entry) => entry.trim()).where((entry) => entry.isNotEmpty).toSet().toList();
    values.sort((left, right) => left.toLowerCase().compareTo(right.toLowerCase()));
    return values;
  }

  String? _validateUsername(String value) {
    if (value.trim().isEmpty) {
      return 'Username is required.';
    }
    return null;
  }

  String? _validateEmail(String value) {
    final email = value.trim();
    if (email.isEmpty) {
      return null;
    }
    if (!email.contains('@')) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (!_isCreateMode) {
      return null;
    }
    if (value.trim().isEmpty) {
      return 'Password is required when creating a user.';
    }
    return null;
  }

  void _revalidateUsername() {
    if (_usernameError == null) {
      return;
    }
    setState(() {
      _usernameError = _validateUsername(_usernameController.text);
    });
  }

  void _revalidateEmail() {
    if (_emailError == null) {
      return;
    }
    setState(() {
      _emailError = _validateEmail(_emailController.text);
    });
  }

  void _revalidatePassword() {
    if (_passwordError == null) {
      return;
    }
    setState(() {
      _passwordError = _validatePassword(_passwordController.text);
    });
  }

  void _updatePermissions(AdminUserPermissions nextValue, {bool touched = true}) {
    setState(() {
      _permissions = nextValue;
      if (touched) {
        _permissionsTouched = true;
      }
    });
  }

  void _onTypeChanged(String? value) {
    if (value == null) {
      return;
    }

    setState(() {
      _type = value;
      if (_type == 'root') {
        _isActive = true;
      }
      if (_isCreateMode && !_permissionsTouched) {
        final defaults = defaultAdminUserPermissionsForType(value);
        _permissions = defaults;
      }
    });
  }

  Future<void> _unlinkOpenId() async {
    final unlinkCallback = widget.onUnlinkOpenId;
    if (unlinkCallback == null || _isUnlinking || !_hasLinkedOpenId) {
      return;
    }

    setState(() {
      _isUnlinking = true;
      _validationError = null;
    });

    bool success = false;
    try {
      success = await unlinkCallback.call();
    } catch (_) {
      success = false;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isUnlinking = false;
      if (success) {
        _hasLinkedOpenId = false;
      } else {
        _validationError = 'Failed to unlink OpenID.';
      }
    });

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger != null) {
      messenger.showSnackBar(SnackBar(content: Text(success ? 'OpenID link removed.' : 'Could not unlink OpenID.')));
    }
  }

  Future<void> _submit() async {
    final usernameText = _usernameController.text;
    final emailText = _emailController.text;
    final passwordText = _passwordController.text;

    final usernameError = _validateUsername(usernameText);
    final emailError = _validateEmail(emailText);
    final passwordError = _validatePassword(passwordText);

    if (usernameError != null || emailError != null || passwordError != null) {
      setState(() {
        _usernameError = usernameError;
        _emailError = emailError;
        _passwordError = passwordError;
        _validationError = null;
      });
      return;
    }

    final username = usernameText.trim();
    final email = emailText.trim();
    final password = passwordText.trim();

    setState(() {
      _usernameError = null;
      _emailError = null;
      _passwordError = null;
      _isSubmitting = true;
      _validationError = null;
    });

    final libraries = _normalizedSelection(_selectedLibraries);
    final tags = _normalizedSelection(_selectedTags);
    final resolvedIsActive = _isRootType ? true : _isActive;

    final request = AdminUserUpsertRequest(
      username: username,
      password: password.isEmpty ? null : password,
      email: email.isEmpty ? null : email,
      type: _type,
      isActive: resolvedIsActive,
      permissions: _permissions.copyWith(librariesAccessible: libraries, itemTagsSelected: tags),
      librariesAccessible: libraries,
      itemTagsSelected: tags,
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(request);
  }

  Widget _buildAccountAndPermissionsSection(BuildContext context) {
    final accountTypeOptions = <String>{'admin', 'user', 'guest'};
    if (_type == 'root' || widget.initialValue.type.trim().toLowerCase() == 'root') {
      accountTypeOptions.add('root');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Account', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                TextField(
                  controller: _usernameController,
                  enabled: !_isSubmitting,
                  onChanged: (_) => _revalidateUsername(),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: const OutlineInputBorder(),
                    errorText: _usernameError,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _emailController,
                  enabled: !_isSubmitting,
                  onChanged: (_) => _revalidateEmail(),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: const OutlineInputBorder(),
                    errorText: _emailError,
                  ),
                ),
                const SizedBox(height: 12),
                YaabsaExpressiveDropdownField<String>(
                  value: _type,
                  decoration: InputDecoration(
                    labelText: 'Account type',
                    border: const OutlineInputBorder(),
                    helperText: _canEditType ? null : 'Root account type cannot be changed.',
                  ),
                  options: accountTypeOptions
                      .toList()
                      .map(
                        (type) =>
                            YaabsaDropdownOption<String>(value: type, label: type == 'root' ? 'root (reserved)' : type),
                      )
                      .toList(growable: false),
                  onChanged: (_isSubmitting || !_canEditType) ? null : _onTypeChanged,
                ),
                const SizedBox(height: 8),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('User is active'),
                  subtitle: Text(
                    _isRootType ? 'Root account is always active.' : 'Disabled users cannot log in or access content.',
                  ),
                  value: _isRootType ? true : _isActive,
                  onChanged: (_isSubmitting || _isRootType)
                      ? null
                      : (value) {
                          setState(() {
                            _isActive = value;
                          });
                        },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  enabled: !_isSubmitting,
                  onChanged: (_) => _revalidatePassword(),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: _isCreateMode ? 'Password' : 'New password',
                    helperText: _isCreateMode ? null : 'Leave empty to keep current password.',
                    border: const OutlineInputBorder(),
                    errorText: _passwordError,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        AdminUserPermissionsEditor(
          permissions: _permissions,
          enabled: !_isSubmitting,
          onChanged: (value) => _updatePermissions(value, touched: true),
        ),
      ],
    );
  }

  Widget _buildAccessSection(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Library and Tag Access',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            SwitchListTile.adaptive(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('Can access all libraries'),
              value: _permissions.accessAllLibraries,
              onChanged: _isSubmitting
                  ? null
                  : (value) {
                      _updatePermissions(_permissions.copyWith(accessAllLibraries: value), touched: true);
                      if (value) {
                        setState(() {
                          _selectedLibraries.clear();
                        });
                      }
                    },
            ),
            if (!_permissions.accessAllLibraries)
              AdminUserMultiSelectCard(
                title: 'Libraries',
                options: _libraryOptions(),
                selectedIds: _selectedLibraries,
                enabled: !_isSubmitting,
                emptyMessage: 'No libraries available.',
                onSelectionChanged: (next) {
                  setState(() {
                    _selectedLibraries = next;
                  });
                },
              ),
            const SizedBox(height: 8),
            SwitchListTile.adaptive(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('Can access all tags'),
              value: _permissions.accessAllTags,
              onChanged: _isSubmitting
                  ? null
                  : (value) {
                      _updatePermissions(_permissions.copyWith(accessAllTags: value), touched: true);
                      if (value) {
                        setState(() {
                          _selectedTags.clear();
                        });
                      }
                    },
            ),
            if (!_permissions.accessAllTags)
              SwitchListTile.adaptive(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: const Text('Invert selected tags'),
                subtitle: const Text('When enabled, selected tags are blocked instead of allowed.'),
                value: _permissions.selectedTagsNotAccessible,
                onChanged: _isSubmitting
                    ? null
                    : (value) {
                        _updatePermissions(_permissions.copyWith(selectedTagsNotAccessible: value), touched: true);
                      },
              ),
            if (!_permissions.accessAllTags)
              AdminUserMultiSelectCard(
                title: 'Tags',
                options: _tagOptions(),
                selectedIds: _selectedTags,
                enabled: !_isSubmitting,
                emptyMessage: 'No tags available.',
                onSelectionChanged: (next) {
                  setState(() {
                    _selectedTags = next;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.9;
    final isMobile = context.isMobile;
    final isDesktop = context.isDesktop;
    final maxWidth = isMobile
        ? 560.0
        : isDesktop
        ? 1080.0
        : 780.0;

    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _isCreateMode ? 'Add User' : 'Edit User',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: (_isSubmitting || _isUnlinking) ? null : () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isMobile) ...[
                      _buildAccountAndPermissionsSection(context),
                      const SizedBox(height: 12),
                      _buildAccessSection(context),
                    ] else if (!isDesktop) ...[
                      _buildAccountAndPermissionsSection(context),
                      const SizedBox(height: 12),
                      _buildAccessSection(context),
                    ] else
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final panelWidth = ((constraints.maxWidth - 16) / 2).clamp(360.0, 520.0);

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: panelWidth, child: _buildAccountAndPermissionsSection(context)),
                              const SizedBox(width: 16),
                              SizedBox(width: panelWidth, child: _buildAccessSection(context)),
                            ],
                          );
                        },
                      ),
                    if (_validationError?.isNotEmpty == true) ...[
                      const SizedBox(height: 10),
                      Text(_validationError ?? '', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Row(
                children: [
                  if (!_isCreateMode && _hasLinkedOpenId)
                    OutlinedButton.icon(
                      onPressed: (_isSubmitting || _isUnlinking || widget.onUnlinkOpenId == null)
                          ? null
                          : _unlinkOpenId,
                      icon: _isUnlinking
                          ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.link_off_rounded),
                      label: const Text('Unlink OpenID'),
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed: (_isSubmitting || _isUnlinking) ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: (_isSubmitting || _isUnlinking) ? null : _submit,
                    icon: _isSubmitting
                        ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.save_outlined),
                    label: Text(_isCreateMode ? 'Create user' : 'Save changes'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
