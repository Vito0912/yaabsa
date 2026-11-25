import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/settings/yaabsa_switch_tile.dart';
import 'package:yaabsa/api/admin/admin_user_permissions.dart';
import 'package:yaabsa/api/admin/admin_user_upsert_request.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/ui/components/inputs/expressive_dropdown.dart';
import 'package:yaabsa/components/settings/admin_users/admin_user_permissions_editor.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/lists/multi_select_list_card.dart';
import 'package:yaabsa/util/l10n.dart';

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

  List<YaabsaMultiSelectOption> _libraryOptions() {
    final libraries = List<Library>.from(widget.availableLibraries)
      ..sort((left, right) => left.name.toLowerCase().compareTo(right.name.toLowerCase()));

    return libraries
        .map((library) => YaabsaMultiSelectOption(id: library.id, label: library.name, subtitle: library.mediaType))
        .toList(growable: false);
  }

  List<YaabsaMultiSelectOption> _tagOptions() {
    final tags = widget.availableTags.map((entry) => entry.trim()).where((entry) => entry.isNotEmpty).toSet().toList()
      ..sort((left, right) => left.toLowerCase().compareTo(right.toLowerCase()));

    return tags.map((tag) => YaabsaMultiSelectOption(id: tag, label: tag)).toList(growable: false);
  }

  List<String> _normalizedSelection(Set<String> selection) {
    final values = selection.map((entry) => entry.trim()).where((entry) => entry.isNotEmpty).toSet().toList();
    values.sort((left, right) => left.toLowerCase().compareTo(right.toLowerCase()));
    return values;
  }

  String? _validateUsername(String value) {
    if (value.trim().isEmpty) {
      return currentAppLocalizations().validationUsernameRequired;
    }
    return null;
  }

  String? _validateEmail(String value) {
    final email = value.trim();
    if (email.isEmpty) {
      return null;
    }
    if (!email.contains('@')) {
      return currentAppLocalizations().errorEmailInvalid;
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (!_isCreateMode) {
      return null;
    }
    if (value.trim().isEmpty) {
      return currentAppLocalizations().errorPasswordRequiredForNewUser;
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
        _validationError = currentAppLocalizations().errorUnlinkOpenId;
      }
    });

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger != null) {
      final l10n = currentAppLocalizations();
      messenger.showSnackBar(SnackBar(content: Text(success ? l10n.statusOpenIdLinkRemoved : l10n.errorUnlinkOpenId)));
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
    final l10n = context.l10n;
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
                Text(
                  l10n.accountLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                StyledTextField(
                  controller: _usernameController,
                  enabled: !_isSubmitting,
                  onChanged: (_) => _revalidateUsername(),
                  textInputAction: TextInputAction.next,
                  label: l10n.fieldUsername,
                  errorText: _usernameError,
                ),
                const SizedBox(height: 12),
                StyledTextField(
                  controller: _emailController,
                  enabled: !_isSubmitting,
                  onChanged: (_) => _revalidateEmail(),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  label: l10n.fieldEmail,
                  errorText: _emailError,
                ),
                const SizedBox(height: 12),
                YaabsaExpressiveDropdownField<String>(
                  value: _type,
                  decoration: InputDecoration(
                    labelText: l10n.fieldAccountType,
                    helperText: _canEditType ? null : l10n.errorRootAccountTypeLocked,
                  ),
                  options: accountTypeOptions
                      .toList()
                      .map(
                        (type) => YaabsaDropdownOption<String>(
                          value: type,
                          label: type == 'root'
                              ? l10n.userRoleReservedName(l10n.userRoleName(type))
                              : l10n.userRoleName(type),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (_isSubmitting || !_canEditType) ? null : _onTypeChanged,
                ),
                const SizedBox(height: 8),
                YaabsaSwitchTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.settingUserActive),
                  subtitle: Text(_isRootType ? l10n.statusRootAccountAlwaysActive : l10n.settingUserActiveDescription),
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
                StyledTextField(
                  controller: _passwordController,
                  enabled: !_isSubmitting,
                  onChanged: (_) => _revalidatePassword(),
                  obscureText: true,
                  label: _isCreateMode ? l10n.fieldPassword : l10n.fieldNewPassword,
                  helperText: _isCreateMode ? null : l10n.promptLeavePasswordEmptyToKeepCurrent,
                  errorText: _passwordError,
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
    final l10n = context.l10n;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.headingLibraryAndTagAccess,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            YaabsaSwitchTile.adaptive(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.permissionAccessAllLibraries),
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
              YaabsaMultiSelectListCard(
                title: l10n.navLibraries,
                options: _libraryOptions(),
                selectedIds: _selectedLibraries,
                enabled: !_isSubmitting,
                emptyMessage: l10n.statusNoLibrariesFound,
                onSelectionChanged: (next) {
                  setState(() {
                    _selectedLibraries = next;
                  });
                },
              ),
            const SizedBox(height: 8),
            YaabsaSwitchTile.adaptive(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.permissionAccessAllTags),
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
              YaabsaSwitchTile.adaptive(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.settingInvertSelectedTags),
                subtitle: Text(l10n.settingInvertSelectedTagsDescription),
                value: _permissions.selectedTagsNotAccessible,
                onChanged: _isSubmitting
                    ? null
                    : (value) {
                        _updatePermissions(_permissions.copyWith(selectedTagsNotAccessible: value), touched: true);
                      },
              ),
            if (!_permissions.accessAllTags)
              YaabsaMultiSelectListCard(
                title: l10n.fieldTags,
                options: _tagOptions(),
                selectedIds: _selectedTags,
                enabled: !_isSubmitting,
                emptyMessage: l10n.statusNoTagsFound,
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
    final l10n = context.l10n;
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
                      _isCreateMode ? l10n.actionAddUser : l10n.headingEditUser,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.actionClose,
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
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: YaabsaCircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.link_off_rounded),
                      label: Text(l10n.actionUnlinkOpenId),
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed: (_isSubmitting || _isUnlinking) ? null : () => Navigator.of(context).pop(),
                    child: Text(l10n.actionCancel),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: (_isSubmitting || _isUnlinking) ? null : _submit,
                    icon: _isSubmitting
                        ? const SizedBox(width: 14, height: 14, child: YaabsaCircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.save_outlined),
                    label: Text(_isCreateMode ? l10n.actionCreate : l10n.actionSave),
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
