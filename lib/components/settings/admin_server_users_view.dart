import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/admin/admin_user.dart';
import 'package:yaabsa/api/admin/admin_user_permissions.dart';
import 'package:yaabsa/api/admin/admin_user_upsert_request.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/components/settings/admin_users/admin_user_form_dialog.dart';
import 'package:yaabsa/components/settings/admin_users/admin_user_list_tile.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';

import 'package:yaabsa/generated/l10n.dart';

class AdminServerUsersView extends ConsumerStatefulWidget {
  const AdminServerUsersView({super.key});

  @override
  ConsumerState<AdminServerUsersView> createState() => _AdminServerUsersViewState();
}

class _AdminServerUsersViewState extends ConsumerState<AdminServerUsersView> {
  String? _activeUserId;
  bool _isLoading = true;
  bool _isCreatingUser = false;
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
      final usersFuture = api.getAdminApi().getUsersDetailed();
      final librariesFuture = api.getLibraryApi().getLibraries();
      final tagsFuture = api.getAdminApi().getTags();

      final usersResponse = await usersFuture;
      final librariesResponse = await librariesFuture;
      final tagsResponse = await tagsFuture;

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
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Failed to load users: $error';
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
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return;
    }

    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<bool> _unlinkOpenId(AdminUser user) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage('No active API client.');
      return false;
    }

    _setBusyForUser(user.id, true);
    try {
      final success = await api.getAdminApi().unlinkUserOpenId(user.id);
      if (!success) {
        _showMessage('Failed to unlink OpenID for ${user.username}.');
        return false;
      }

      _upsertUserInList(user.copyWith(hasOpenIdLink: false));
      if (_activeUserId == user.id) {
        ref.invalidate(currentUserProvider);
      }
      return true;
    } catch (error) {
      _showMessage('Failed to unlink OpenID for ${user.username}: $error');
      return false;
    } finally {
      _setBusyForUser(user.id, false);
    }
  }

  Future<void> _createUser() async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage('No active API client.');
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

    if (payload == null) {
      return;
    }

    _setCreating(true);
    try {
      final response = await api.getAdminApi().createUser(payload: payload);
      final createdUser = response.data;

      if (createdUser == null) {
        await _loadUserManagementData(showLoading: false);
      } else {
        _upsertUserInList(createdUser);
      }

      _showMessage('User created successfully.');
    } catch (error) {
      _showMessage('Failed to create user: $error');
    } finally {
      _setCreating(false);
    }
  }

  Future<void> _editUser(AdminUser user) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage('No active API client.');
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

    if (payload == null) {
      return;
    }

    _setBusyForUser(user.id, true);
    try {
      final response = await api.getAdminApi().updateUser(userId: user.id, payload: payload);
      final updatedUser = response.data;

      if (updatedUser == null) {
        await _loadUserManagementData(showLoading: false);
      } else {
        _upsertUserInList(updatedUser);
      }

      if (_activeUserId == user.id) {
        ref.invalidate(currentUserProvider);
      }

      _showMessage('User updated successfully.');
    } catch (error) {
      _showMessage('Failed to update user: $error');
    } finally {
      _setBusyForUser(user.id, false);
    }
  }

  Future<void> _toggleUserActive(AdminUser user) async {
    if (user.isRoot) {
      _showMessage('The root account cannot be disabled.');
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage('No active API client.');
      return;
    }

    _setBusyForUser(user.id, true);
    try {
      final payload = AdminUserUpsertRequest.fromUser(user).copyWith(isActive: !user.isActive);
      final response = await api.getAdminApi().updateUser(userId: user.id, payload: payload);
      final updatedUser = response.data ?? user.copyWith(isActive: !user.isActive);
      _upsertUserInList(updatedUser);

      if (_activeUserId == user.id) {
        ref.invalidate(currentUserProvider);
      }

      _showMessage(updatedUser.isActive ? S.current.commonUserEnabled : S.current.commonUserDisabled);
    } catch (error) {
      _showMessage('Failed to update user status: $error');
    } finally {
      _setBusyForUser(user.id, false);
    }
  }

  Future<void> _deleteUser(AdminUser user, {required String? activeUserId}) async {
    if (activeUserId == user.id) {
      _showMessage('You cannot delete the currently signed-in user.');
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage('No active API client.');
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.current.componentsSettingsAdminServerUsersViewDeleteUser),
          content: Text(S.current.componentsSettingsAdminServerUsersViewDeleteUserThisCannotBeUndone(user.username)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(S.current.componentsSettingsAdminServerUsersViewCancel),
            ),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: OutlinedButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
              child: Text(S.current.componentsSettingsAdminServerUsersViewDelete),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    _setBusyForUser(user.id, true);
    try {
      final deleted = await api.getAdminApi().deleteUser(user.id);
      if (!deleted) {
        _showMessage('Failed to delete user ${user.username}.');
        return;
      }

      _removeUserFromList(user.id);
      _showMessage('User deleted successfully.');
    } catch (error) {
      _showMessage('Failed to delete user: $error');
    } finally {
      _setBusyForUser(user.id, false);
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
              child: Text(S.current.componentsSettingsAdminServerUsersViewRetry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar({required bool compact}) {
    final controlsDisabled = _isLoading || _isCreatingUser;

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            enabled: !_isLoading,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              labelText: S.current.componentsSettingsAdminServerUsersViewSearchUsers,
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: controlsDisabled ? null : _createUser,
                  icon: _isCreatingUser
                      ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.person_add_alt_1_rounded),
                  label: Text(S.current.componentsSettingsAdminServerUsersViewAddUser),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: S.current.componentsSettingsAdminServerUsersViewRefresh,
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
          child: TextField(
            enabled: !_isLoading,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              labelText: S.current.componentsSettingsAdminServerUsersViewSearchUsers,
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        const SizedBox(width: 10),
        OutlinedButton.icon(
          onPressed: _isLoading ? null : () => unawaited(_loadUserManagementData(showLoading: true)),
          icon: const Icon(Icons.refresh_rounded),
          label: Text(S.current.componentsSettingsAdminServerUsersViewRefresh),
        ),
        const SizedBox(width: 10),
        FilledButton.icon(
          onPressed: controlsDisabled ? null : _createUser,
          icon: _isCreatingUser
              ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.person_add_alt_1_rounded),
          label: Text(S.current.componentsSettingsAdminServerUsersViewAddUser),
        ),
      ],
    );
  }

  Widget _buildUsersSection({required String? activeUserId, required bool compact}) {
    final filteredUsers = _filteredUsers();

    if (_isLoading && _users.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (filteredUsers.isEmpty) {
      return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Text(_users.isEmpty ? 'No users found on this server.' : 'No users match your current search.'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < filteredUsers.length; index++) ...[
          AdminUserListTile(
            user: filteredUsers[index],
            isBusy: _busyUserIds.contains(filteredUsers[index].id),
            compactActions: compact,
            onEdit: () => unawaited(_editUser(filteredUsers[index])),
            onToggleActive: () => unawaited(_toggleUserActive(filteredUsers[index])),
            onDelete: () => unawaited(_deleteUser(filteredUsers[index], activeUserId: activeUserId)),
            onUnlinkOpenId: filteredUsers[index].hasLinkedOpenId
                ? () {
                    unawaited(_unlinkOpenId(filteredUsers[index]));
                  }
                : null,
          ),
          if (index != filteredUsers.length - 1) const SizedBox(height: 10),
        ],
      ],
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
            child: Text(S.current.componentsSettingsAdminServerUsersViewNoActiveUserSignInTo),
          );
        }

        if (!_isAdminType(currentUser.type)) {
          return Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text(S.current.componentsSettingsAdminServerUsersViewThisPageRequiresAnAdminAccount),
          );
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
                const LinearProgressIndicator(minHeight: 2),
              ],
              const SizedBox(height: 10),
              _buildErrorCard(),
              if (_errorMessage?.isNotEmpty == true) const SizedBox(height: 10),
              _buildUsersSection(activeUserId: currentUser.id, compact: compact),
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
        child: Text(
          S.current.componentsSettingsAdminServerUsersViewFailedToLoadUserData(error),
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
