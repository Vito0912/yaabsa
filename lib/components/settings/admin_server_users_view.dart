import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/admin/admin_user.dart';
import 'package:yaabsa/api/admin/admin_user_permissions.dart';
import 'package:yaabsa/api/admin/admin_user_upsert_request.dart';
import 'package:yaabsa/api/admin/update_admin_authentication_settings_request.dart';
import 'package:yaabsa/api/magic/magic_config.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/components/settings/admin_users/admin_user_form_dialog.dart';
import 'package:yaabsa/components/settings/admin_users/admin_users_table_presentation.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/components/settings/admin_users/magic_config_dialog.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

class AdminServerUsersView extends ConsumerStatefulWidget {
  const AdminServerUsersView({super.key});

  @override
  ConsumerState<AdminServerUsersView> createState() => _AdminServerUsersViewState();
}

class _AdminServerUsersViewState extends ConsumerState<AdminServerUsersView> {
  String? _activeUserId;
  bool _isLoading = true;
  bool _isCreatingUser = false;
  bool _isCreatingAuthenticationCodeKey = false;
  bool _isDeletingAuthenticationCode = false;
  bool _authenticationCodeKeyLoaded = false;
  MagicConfigKeyMarker? _authenticationCodeKey;
  String _searchQuery = '';
  String? _errorMessage;

  final Set<String> _busyUserIds = <String>{};
  List<AdminUser> _users = const <AdminUser>[];
  List<Library> _libraries = const <Library>[];
  List<String> _tags = const <String>[];

  bool _isAdminType(String? userType) {
    final normalizedType = (userType ?? '').trim().toLowerCase();
    return normalizedType == 'admin' || normalizedType == 'root';
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

  List<AdminUser> _sortedUsers(List<AdminUser> users) {
    final sorted = List<AdminUser>.from(users);
    sorted.sort((left, right) {
      final byType = _typeRank(left.type).compareTo(_typeRank(right.type));
      if (byType != 0) {
        return byType;
      }

      final byName = left.username.toLowerCase().compareTo(right.username.toLowerCase());
      if (byName != 0) {
        return byName;
      }

      return left.id.compareTo(right.id);
    });
    return sorted;
  }

  List<Library> _sortedLibraries(List<Library> libraries) {
    final sorted = List<Library>.from(libraries);
    sorted.sort((left, right) {
      final byName = left.name.toLowerCase().compareTo(right.name.toLowerCase());
      if (byName != 0) {
        return byName;
      }
      return left.id.compareTo(right.id);
    });
    return sorted;
  }

  List<String> _sortedTags(List<String> tags) {
    final sorted = tags.map((entry) => entry.trim()).where((entry) => entry.isNotEmpty).toSet().toList();
    sorted.sort((left, right) => left.toLowerCase().compareTo(right.toLowerCase()));
    return sorted;
  }

  void _setBusyForUser(String userId, bool busy) {
    setState(() {
      if (busy) {
        _busyUserIds.add(userId);
      } else {
        _busyUserIds.remove(userId);
      }
    });
  }

  void _setCreating(bool creating) {
    setState(() {
      _isCreatingUser = creating;
    });
  }

  void _upsertUserInList(AdminUser user) {
    final nextUsers = [..._users];
    final index = nextUsers.indexWhere((entry) => entry.id == user.id);
    if (index >= 0) {
      nextUsers[index] = user;
    } else {
      nextUsers.add(user);
    }

    setState(() {
      _users = _sortedUsers(nextUsers);
    });
  }

  void _removeUserFromList(String userId) {
    setState(() {
      _users = _users.where((entry) => entry.id != userId).toList(growable: false);
    });
  }

  List<AdminUser> _filteredUsers() {
    final normalizedQuery = _searchQuery.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return _users;
    }

    return _users
        .where((user) {
          final email = user.email ?? '';
          final searchable = '${user.username} ${user.type} $email'.toLowerCase();
          return searchable.contains(normalizedQuery);
        })
        .toList(growable: false);
  }

  Future<void> _loadUserManagementData({bool showLoading = true}) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = context.l10n.errorNoActiveApiClient;
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
      final usersFuture = api.getAdminApi().getUsersDetailed();
      final librariesFuture = api.getLibraryApi().getLibraries();
      final tagsFuture = api.getAdminApi().getTags();

      final usersResponse = await usersFuture;
      final librariesResponse = await librariesFuture;
      final tagsResponse = await tagsFuture;

      MagicConfigKeyMarker? authenticationCodeKey;
      try {
        final settings = (await api.getAdminApi().getAuthenticationSettings()).data;
        authenticationCodeKey =
            MagicConfigKeyMarker.extract(settings?.authLoginCustomMessage) ??
            MagicConfigKeyMarker.fromSerializedName(
              MagicConfigKeyMarker.extractFromSanitizedHtml(settings?.authLoginCustomMessage),
            );
      } catch (_) {}

      final users = _sortedUsers(List<AdminUser>.from(usersResponse.data?.users ?? const <AdminUser>[]));
      final libraries = _sortedLibraries(List<Library>.from(librariesResponse.data?.libraries ?? const <Library>[]));
      final tags = _sortedTags(tagsResponse.data?.tags ?? const <String>[]);

      if (!mounted) {
        return;
      }

      setState(() {
        _users = users;
        _libraries = libraries;
        _tags = tags;
        _authenticationCodeKey = authenticationCodeKey;
        _authenticationCodeKeyLoaded = true;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = context.l10n.errorOperationFailed(context.l10n.operationLoadUsers, error.toString());
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return;
    }

    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<MagicConfigKeyMarker?> _ensureMagicKey() async {
    final l10n = context.l10n;
    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage(l10n.errorNoActiveApiClient);
      return null;
    }

    final settingsResponse = await api.getAdminApi().getAuthenticationSettings();
    final settings = settingsResponse.data;
    final existingMarker =
        MagicConfigKeyMarker.extract(settings?.authLoginCustomMessage) ??
        MagicConfigKeyMarker.fromSerializedName(
          MagicConfigKeyMarker.extractFromSanitizedHtml(settings?.authLoginCustomMessage),
        );
    if (existingMarker != null) {
      if (mounted) {
        setState(() {
          _authenticationCodeKey = existingMarker;
          _authenticationCodeKeyLoaded = true;
        });
      }
      return existingMarker;
    }

    if (!mounted) {
      return null;
    }
    final shouldGenerate = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.titleCreateAuthenticationCodeKey),
        content: Text(context.l10n.messageCreateAuthenticationCodeKey),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(context.l10n.actionCancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(context.l10n.actionCreate)),
        ],
      ),
    );
    if (shouldGenerate != true) {
      return null;
    }

    final marker = MagicConfigKeyMarker.generate();
    await api.getAdminApi().updateAuthenticationSettings(
      payload: UpdateAdminAuthenticationSettingsRequest(
        authLoginCustomMessage: MagicConfigKeyMarker.appendToHtml(settings?.authLoginCustomMessage, marker),
      ),
    );
    final savedSettings = (await api.getAdminApi().getAuthenticationSettings()).data;
    final savedMarker =
        MagicConfigKeyMarker.extract(savedSettings?.authLoginCustomMessage) ??
        MagicConfigKeyMarker.fromSerializedName(
          MagicConfigKeyMarker.extractFromSanitizedHtml(savedSettings?.authLoginCustomMessage),
        );
    if (savedMarker == null || savedMarker.encodedKey != marker.encodedKey) {
      if (mounted) {
        _showMessage(l10n.errorAuthenticationCodeKeyNotPreserved);
      }
      return null;
    }
    if (mounted) {
      setState(() {
        _authenticationCodeKey = savedMarker;
        _authenticationCodeKeyLoaded = true;
      });
    }
    return savedMarker;
  }

  Future<void> _createAuthenticationCodeKey() async {
    final l10n = context.l10n;
    if (_isCreatingAuthenticationCodeKey) {
      return;
    }

    setState(() {
      _isCreatingAuthenticationCodeKey = true;
    });
    try {
      final marker = await _ensureMagicKey();
      if (mounted && marker != null) {
        _showMessage(l10n.statusAuthenticationCodeKeyCreated);
      }
    } catch (error) {
      if (mounted) {
        _showMessage(l10n.errorOperationFailed(l10n.operationCreateAuthenticationCode, error.toString()));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingAuthenticationCodeKey = false;
        });
      }
    }
  }

  Future<void> _showMagicConfig({
    required String username,
    required String? password,
    required bool allowPassword,
  }) async {
    final l10n = context.l10n;
    final currentUser = await ref.read(currentUserProvider.future);
    final server = currentUser?.server;
    if (server == null) {
      _showMessage(l10n.errorActiveAccountNoServerAddress);
      return;
    }

    final serverUrl = server.externalUrl;
    if (!mounted) {
      return;
    }
    await showMagicConfigDialog(
      context,
      serverUrl: serverUrl,
      localServerUrl: server.localUrl,
      username: username,
      password: password,
      headers: Map<String, String>.from(server.headers ?? const <String, String>{}),
      allowPassword: allowPassword,
      ensureMarker: _ensureMagicKey,
    );
  }

  Future<void> _deleteAuthenticationCode() async {
    final l10n = context.l10n;
    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage(l10n.errorNoActiveApiClient);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.titleDeleteAuthenticationCodeKey),
        content: Text(context.l10n.messageDeleteAuthenticationCodeKey),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(context.l10n.actionCancel)),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: Text(context.l10n.actionDeleteAuthenticationCodeKey),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) {
      return;
    }

    setState(() {
      _isDeletingAuthenticationCode = true;
    });
    try {
      final settings = (await api.getAdminApi().getAuthenticationSettings()).data;
      final marker =
          MagicConfigKeyMarker.extract(settings?.authLoginCustomMessage) ??
          MagicConfigKeyMarker.fromSerializedName(
            MagicConfigKeyMarker.extractFromSanitizedHtml(settings?.authLoginCustomMessage),
          );
      if (marker == null) {
        if (mounted) {
          setState(() {
            _authenticationCodeKey = null;
            _authenticationCodeKeyLoaded = true;
          });
        }
        if (mounted) {
          _showMessage(l10n.statusNoAuthenticationCodeKeyConfigured);
        }
        return;
      }

      await api.getAdminApi().updateAuthenticationSettings(
        payload: UpdateAdminAuthenticationSettingsRequest(
          authLoginCustomMessage: MagicConfigKeyMarker.visibleHtml(settings?.authLoginCustomMessage),
        ),
      );
      if (mounted) {
        setState(() {
          _authenticationCodeKey = null;
          _authenticationCodeKeyLoaded = true;
        });
      }
      if (mounted) {
        _showMessage(l10n.statusAuthenticationCodeKeyDeleted);
      }
    } catch (error) {
      if (mounted) {
        _showMessage(l10n.errorOperationFailed(l10n.operationDeleteAuthenticationCode, error.toString()));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeletingAuthenticationCode = false;
        });
      }
    }
  }

  Future<bool> _unlinkOpenId(AdminUser user) async {
    final l10n = context.l10n;
    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage(l10n.errorNoActiveApiClient);
      return false;
    }

    _setBusyForUser(user.id, true);
    try {
      final success = await api.getAdminApi().unlinkUserOpenId(user.id);
      if (!mounted) {
        return false;
      }

      if (!success) {
        _showMessage(l10n.errorUnlinkOpenIdUser(user.username));
        return false;
      }

      _upsertUserInList(user.copyWith(hasOpenIdLink: false));
      if (_activeUserId == user.id) {
        ref.invalidate(currentUserProvider);
      }
      return true;
    } catch (error) {
      if (mounted) {
        _showMessage(l10n.errorOperationFailed(l10n.operationUnlinkOpenId, '${user.username}: $error'));
      }
      return false;
    } finally {
      if (mounted) {
        _setBusyForUser(user.id, false);
      }
    }
  }

  Future<void> _createUser() async {
    final l10n = context.l10n;
    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage(l10n.errorNoActiveApiClient);
      return;
    }

    final defaults = defaultAdminUserPermissionsForType('user');
    final payload = await showAdminUserFormDialog(
      context,
      mode: AdminUserFormMode.create,
      availableLibraries: _libraries,
      availableTags: _tags,
      initialValue: AdminUserFormInitialValue(
        username: '',
        email: null,
        type: 'user',
        isActive: true,
        permissions: defaults,
        librariesAccessible: const <String>[],
        itemTagsSelected: const <String>[],
        hasLinkedOpenId: false,
      ),
    );

    if (!mounted || payload == null) {
      return;
    }

    _setCreating(true);
    try {
      final response = await api.getAdminApi().createUser(payload: payload);
      if (!mounted) {
        return;
      }

      final createdUser = response.data;

      if (createdUser == null) {
        await _loadUserManagementData(showLoading: false);
      } else {
        _upsertUserInList(createdUser);
      }

      await _showMagicConfig(username: payload.username, password: payload.password, allowPassword: true);
      if (mounted) {
        _showMessage(l10n.statusUserCreated);
      }
    } catch (error) {
      if (mounted) {
        _showMessage(l10n.errorOperationFailed(l10n.operationCreateUser, error.toString()));
      }
    } finally {
      if (mounted) {
        _setCreating(false);
      }
    }
  }

  Future<void> _editUser(AdminUser user) async {
    final l10n = context.l10n;
    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage(l10n.errorNoActiveApiClient);
      return;
    }

    final payload = await showAdminUserFormDialog(
      context,
      mode: AdminUserFormMode.edit,
      availableLibraries: _libraries,
      availableTags: _tags,
      onUnlinkOpenId: user.hasLinkedOpenId ? () => _unlinkOpenId(user) : null,
      initialValue: AdminUserFormInitialValue(
        username: user.username,
        email: user.email,
        type: user.type,
        isActive: user.isActive,
        permissions: user.permissions,
        librariesAccessible: user.librariesAccessible,
        itemTagsSelected: user.itemTagsSelected,
        hasLinkedOpenId: user.hasLinkedOpenId,
      ),
    );

    if (!mounted || payload == null) {
      return;
    }

    _setBusyForUser(user.id, true);
    try {
      final response = await api.getAdminApi().updateUser(userId: user.id, payload: payload);
      if (!mounted) {
        return;
      }

      final updatedUser = response.data;

      if (updatedUser == null) {
        await _loadUserManagementData(showLoading: false);
      } else {
        _upsertUserInList(updatedUser);
      }

      if (_activeUserId == user.id) {
        ref.invalidate(currentUserProvider);
      }

      _showMessage(l10n.statusUserUpdated);
    } catch (error) {
      if (mounted) {
        _showMessage(l10n.errorOperationFailed(l10n.operationUpdateUser, error.toString()));
      }
    } finally {
      if (mounted) {
        _setBusyForUser(user.id, false);
      }
    }
  }

  Future<void> _toggleUserActive(AdminUser user) async {
    final l10n = context.l10n;
    if (user.isRoot) {
      _showMessage(l10n.statusRootAccountAlwaysActive);
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage(l10n.errorNoActiveApiClient);
      return;
    }

    _setBusyForUser(user.id, true);
    try {
      final payload = AdminUserUpsertRequest.fromUser(user).copyWith(isActive: !user.isActive);
      final response = await api.getAdminApi().updateUser(userId: user.id, payload: payload);
      if (!mounted) {
        return;
      }

      final updatedUser = response.data ?? user.copyWith(isActive: !user.isActive);
      _upsertUserInList(updatedUser);

      if (_activeUserId == user.id) {
        ref.invalidate(currentUserProvider);
      }

      _showMessage(updatedUser.isActive ? l10n.statusUserEnabled : l10n.statusUserDisabled);
    } catch (error) {
      if (mounted) {
        _showMessage(l10n.errorOperationFailed(l10n.operationUpdateUserStatus, error.toString()));
      }
    } finally {
      if (mounted) {
        _setBusyForUser(user.id, false);
      }
    }
  }

  Future<void> _deleteUser(AdminUser user, {required String? activeUserId}) async {
    final l10n = context.l10n;
    if (activeUserId == user.id) {
      _showMessage(l10n.errorCannotDeleteCurrentUser);
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage(l10n.errorNoActiveApiClient);
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.l10n.titleDeleteUser),
          content: Text(context.l10n.promptDeleteUser(user.username)),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(context.l10n.actionCancel)),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: OutlinedButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
              child: Text(context.l10n.actionDelete),
            ),
          ],
        );
      },
    );

    if (!mounted || shouldDelete != true) {
      return;
    }

    _setBusyForUser(user.id, true);
    try {
      final deleted = await api.getAdminApi().deleteUser(user.id);
      if (!mounted) {
        return;
      }

      if (!deleted) {
        _showMessage(l10n.errorDeleteUserFailed(user.username));
        return;
      }

      _removeUserFromList(user.id);
      _showMessage(l10n.statusUserDeleted);
    } catch (error) {
      if (mounted) {
        _showMessage(l10n.errorOperationFailed(l10n.operationDeleteUser, error.toString()));
      }
    } finally {
      if (mounted) {
        _setBusyForUser(user.id, false);
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
        child: Row(
          children: [
            Icon(Icons.error_outline_rounded, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () => unawaited(_loadUserManagementData(showLoading: true)),
              child: Text(context.l10n.actionRetry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar({required bool compact}) {
    final controlsDisabled =
        _isLoading || _isCreatingUser || _isCreatingAuthenticationCodeKey || _isDeletingAuthenticationCode;
    final hasAuthenticationCode = _authenticationCodeKey != null;
    final authenticationCodeActionLabel = hasAuthenticationCode
        ? context.l10n.actionDeleteAuthenticationCodeKey
        : context.l10n.actionCreateAuthenticationCode;
    final authenticationCodeActionIcon = hasAuthenticationCode ? Icons.delete_sweep_outlined : Icons.qr_code_2_rounded;
    final authenticationCodeAction = hasAuthenticationCode ? _deleteAuthenticationCode : _createAuthenticationCodeKey;

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StyledTextField(
            label: context.l10n.labelSearchUsers,
            hintText: context.l10n.hintFilterUsers,
            prefixIcon: const Icon(Icons.search_rounded),
            enabled: !_isLoading,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: controlsDisabled ? null : _createUser,
                  icon: _isCreatingUser
                      ? const SizedBox(width: 14, height: 14, child: YaabsaCircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.person_add_alt_1_rounded),
                  label: Text(context.l10n.actionAddUser),
                ),
              ),
              const SizedBox(width: 8),
              if (_authenticationCodeKeyLoaded)
                IconButton(
                  tooltip: authenticationCodeActionLabel,
                  onPressed: controlsDisabled ? null : authenticationCodeAction,
                  icon: Icon(authenticationCodeActionIcon),
                  color: hasAuthenticationCode
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
                ),
              const SizedBox(width: 4),
              IconButton(
                tooltip: context.l10n.actionRefresh,
                onPressed: _isLoading ? null : () => unawaited(_loadUserManagementData(showLoading: true)),
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: StyledTextField(
            label: context.l10n.labelSearchUsers,
            hintText: context.l10n.hintFilterUsers,
            prefixIcon: const Icon(Icons.search_rounded),
            enabled: !_isLoading,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        const SizedBox(width: 10),
        OutlinedButton.icon(
          onPressed: _isLoading ? null : () => unawaited(_loadUserManagementData(showLoading: true)),
          icon: const Icon(Icons.refresh_rounded),
          label: Text(context.l10n.actionRefresh),
        ),
        const SizedBox(width: 10),
        FilledButton.icon(
          onPressed: controlsDisabled ? null : _createUser,
          icon: _isCreatingUser
              ? const SizedBox(width: 14, height: 14, child: YaabsaCircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.person_add_alt_1_rounded),
          label: Text(context.l10n.actionAddUser),
        ),
        const SizedBox(width: 10),
        if (_authenticationCodeKeyLoaded)
          OutlinedButton.icon(
            onPressed: controlsDisabled ? null : authenticationCodeAction,
            style: OutlinedButton.styleFrom(
              foregroundColor: hasAuthenticationCode
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
            ),
            icon: Icon(authenticationCodeActionIcon),
            label: Text(authenticationCodeActionLabel),
          ),
      ],
    );
  }

  Widget _buildUsersSection({required String? activeUserId}) {
    return AdminUsersTablePresentation(
      users: _filteredUsers(),
      activeUserId: activeUserId,
      busyUserIds: _busyUserIds,
      isLoading: _isLoading,
      searchQuery: _searchQuery,
      onCreateAuthenticationCode: (user) =>
          _showMagicConfig(username: user.username, password: null, allowPassword: false),
      onEditUser: _editUser,
      onToggleUserActive: _toggleUserActive,
      onUnlinkOpenId: (user) async {
        await _unlinkOpenId(user);
      },
      onDeleteUser: (user) => _deleteUser(user, activeUserId: activeUserId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return currentUserAsync.when(
      data: (currentUser) {
        if (currentUser == null) {
          return Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text(context.l10n.promptSignInForAdminAccess),
          );
        }

        if (!_isAdminType(currentUser.type)) {
          return Padding(padding: EdgeInsets.fromLTRB(20, 8, 20, 0), child: Text(context.l10n.errorAdminRequired));
        }

        if (_activeUserId != currentUser.id) {
          _activeUserId = currentUser.id;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            unawaited(_loadUserManagementData(showLoading: true));
          });
        }

        final compact = context.isMobile;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildToolbar(compact: compact),
              if (_isLoading && _users.isNotEmpty) ...[
                const SizedBox(height: 8),
                const YaabsaLinearProgressIndicator(minHeight: 2),
              ],
              const SizedBox(height: 10),
              _buildErrorCard(),
              if (_errorMessage?.isNotEmpty == true) const SizedBox(height: 10),
              _buildUsersSection(activeUserId: currentUser.id),
            ],
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: YaabsaCircularProgressIndicator()),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Text(
          context.l10n.errorOperationFailed(context.l10n.operationLoadUser, error.toString()),
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
