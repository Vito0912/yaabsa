import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/admin/admin_user.dart';
import 'package:yaabsa/api/admin/admin_user_permissions.dart';
import 'package:yaabsa/api/admin/admin_user_upsert_request.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/components/common/inputs/styled_form_fields.dart';
import 'package:yaabsa/components/common/tables/expressive_action_table.dart';
import 'package:yaabsa/components/settings/admin_users/admin_user_form_dialog.dart';
import 'package:yaabsa/components/settings/admin_users/admin_user_badge.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';

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

  String _formatEpoch(int? value) {
    if (value == null || value <= 0) {
      return 'Unknown';
    }

    final dt = DateTime.fromMillisecondsSinceEpoch(value);
    final year = dt.year.toString().padLeft(4, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
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

      _showMessage(updatedUser.isActive ? 'User enabled.' : 'User disabled.');
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
          title: const Text('Delete User'),
          content: Text('Delete user "${user.username}"? This cannot be undone.'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: OutlinedButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
              child: const Text('Delete'),
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
              child: const Text('Retry'),
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
          StyledTextField(
            label: 'Search users',
            hintText: 'Filter by username, role, or email',
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
                      ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.person_add_alt_1_rounded),
                  label: const Text('Add user'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: 'Refresh',
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
            label: 'Search users',
            hintText: 'Filter by username, role, or email',
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
          label: const Text('Refresh'),
        ),
        const SizedBox(width: 10),
        FilledButton.icon(
          onPressed: controlsDisabled ? null : _createUser,
          icon: _isCreatingUser
              ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.person_add_alt_1_rounded),
          label: const Text('Add user'),
        ),
      ],
    );
  }

  Widget _buildUsersSection({required String? activeUserId}) {
    final filteredUsers = _filteredUsers();

    return ExpressiveActionTable<AdminUser>(
      rows: filteredUsers,
      rowId: (user) => user.id,
      loading: _isLoading,
      busyRowIds: _busyUserIds,
      columns: [
        ExpressiveTableColumn<AdminUser>(
          id: 'user',
          label: 'User',
          width: 240,
          cellBuilder: (context, user) {
            final statusColor = user.isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline;

            return Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 6,
              runSpacing: 6,
              children: [
                Text(
                  user.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                AdminUserBadge(
                  label: user.isActive ? 'ACTIVE' : 'DISABLED',
                  color: statusColor,
                  icon: user.isActive ? Icons.check_circle_rounded : Icons.do_not_disturb_on_rounded,
                ),
                if (user.hasLinkedOpenId)
                  AdminUserBadge(
                    label: 'OPENID',
                    color: Theme.of(context).colorScheme.secondary,
                    icon: Icons.link_rounded,
                  ),
              ],
            );
          },
          mobileCellBuilder: (context, user) {
            final statusColor = user.isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline;
            final email = user.email?.trim();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    Text(
                      user.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    AdminUserBadge(
                      label: user.isActive ? 'ACTIVE' : 'DISABLED',
                      color: statusColor,
                      icon: user.isActive ? Icons.check_circle_rounded : Icons.do_not_disturb_on_rounded,
                    ),
                    if (user.hasLinkedOpenId)
                      AdminUserBadge(
                        label: 'OPENID',
                        color: Theme.of(context).colorScheme.secondary,
                        icon: Icons.link_rounded,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  (email?.isNotEmpty ?? false) ? (email ?? 'No email') : 'No email',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            );
          },
          tooltipBuilder: (user) => user.username,
        ),
        ExpressiveTableColumn<AdminUser>(
          id: 'type',
          label: 'Type',
          width: 100,
          alignment: ExpressiveTableCellAlignment.center,
          cellBuilder: (context, user) =>
              Text(user.type.toLowerCase(), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        ExpressiveTableColumn<AdminUser>(
          id: 'email',
          label: 'Email',
          width: 220,
          showOnMobile: false,
          cellBuilder: (context, user) {
            final email = user.email?.trim();
            return Text(
              (email?.isNotEmpty ?? false) ? (email ?? 'No email') : 'No email',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
        ExpressiveTableColumn<AdminUser>(
          id: 'created',
          label: 'Created',
          width: 148,
          showOnMobile: false,
          cellBuilder: (context, user) =>
              Text(_formatEpoch(user.createdAt), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        ExpressiveTableColumn<AdminUser>(
          id: 'last-seen',
          label: 'Last seen',
          width: 148,
          headerTooltip:
              'Last seen updates when the user connects via websocket. It may not reflect offline-listening syncs or third-party clients that do not use websockets.',
          cellBuilder: (context, user) =>
              Text(_formatEpoch(user.lastSeen), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
      actions: [
        ExpressiveTableAction<AdminUser>(
          icon: Icons.edit_outlined,
          tooltip: 'Edit user',
          tone: ExpressiveTableActionTone.primary,
          onPressed: _editUser,
        ),
        ExpressiveTableAction<AdminUser>(
          icon: Icons.power_settings_new_rounded,
          tooltip: 'Enable or disable user',
          isVisible: (user) => !user.isRoot,
          iconBuilder: (user) => user.isActive ? Icons.block_rounded : Icons.check_circle_outline_rounded,
          tooltipBuilder: (user) => user.isActive ? 'Disable user' : 'Enable user',
          onPressed: _toggleUserActive,
        ),
        ExpressiveTableAction<AdminUser>(
          icon: Icons.link_off_rounded,
          tooltip: 'Unlink OpenID',
          isVisible: (user) => user.hasLinkedOpenId,
          onPressed: (user) async {
            await _unlinkOpenId(user);
          },
        ),
        ExpressiveTableAction<AdminUser>(
          icon: Icons.delete_outline_rounded,
          tooltip: 'Delete user',
          tone: ExpressiveTableActionTone.danger,
          isEnabled: (user) => activeUserId != user.id,
          onPressed: (user) async {
            await _deleteUser(user, activeUserId: activeUserId);
          },
        ),
      ],
      emptyTitle: _searchQuery.trim().isEmpty
          ? 'No users found on this server.'
          : 'No users match your current search.',
      emptySubtitle: _searchQuery.trim().isEmpty
          ? 'Create users to manage access and permissions.'
          : 'Try a different username, role, or email filter.',
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return currentUserAsync.when(
      data: (currentUser) {
        if (currentUser == null) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text('No active user. Sign in to manage users.'),
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
              _buildUsersSection(activeUserId: currentUser.id),
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
