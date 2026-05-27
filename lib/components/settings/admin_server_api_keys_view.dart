import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/admin/admin_api_key.dart';
import 'package:yaabsa/api/admin/session_user_summary.dart';
import 'package:yaabsa/components/common/inputs/styled_form_fields.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';
import 'package:yaabsa/components/settings/api_keys/admin_api_key_form_dialog.dart';
import 'package:yaabsa/components/settings/api_keys/admin_api_key_table.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';

class AdminServerApiKeysView extends ConsumerStatefulWidget {
  const AdminServerApiKeysView({super.key});

  @override
  ConsumerState<AdminServerApiKeysView> createState() => _AdminServerApiKeysViewState();
}

class _AdminServerApiKeysViewState extends ConsumerState<AdminServerApiKeysView> {
  String? _activeUserId;
  bool _isLoading = true;
  bool _isCreating = false;
  String _searchQuery = '';
  String? _errorMessage;

  final Set<String> _busyApiKeyIds = <String>{};

  List<AdminApiKey> _apiKeys = const <AdminApiKey>[];
  List<SessionUserSummary> _users = const <SessionUserSummary>[];

  bool _isAdminType(String? userType) {
    final normalized = (userType ?? '').trim().toLowerCase();
    return normalized == 'admin' || normalized == 'root';
  }

  bool _isRootType(String? userType) {
    return (userType ?? '').trim().toLowerCase() == 'root';
  }

  List<AdminApiKey> _sortedApiKeys(List<AdminApiKey> values) {
    final sorted = List<AdminApiKey>.from(values);
    sorted.sort((left, right) {
      final leftCreatedAt = left.createdAt;
      final rightCreatedAt = right.createdAt;
      if (leftCreatedAt != null && rightCreatedAt != null) {
        final byDate = rightCreatedAt.compareTo(leftCreatedAt);
        if (byDate != 0) {
          return byDate;
        }
      }

      final byName = left.name.toLowerCase().compareTo(right.name.toLowerCase());
      if (byName != 0) {
        return byName;
      }

      return left.id.compareTo(right.id);
    });
    return sorted;
  }

  List<SessionUserSummary> _sortedUsers(List<SessionUserSummary> values) {
    final sorted = List<SessionUserSummary>.from(values);
    sorted.sort((left, right) {
      final byName = left.username.toLowerCase().compareTo(right.username.toLowerCase());
      if (byName != 0) {
        return byName;
      }
      return left.id.compareTo(right.id);
    });
    return sorted;
  }

  List<SessionUserSummary> _availableOwners({required bool isRootUser}) {
    if (isRootUser) {
      return _users;
    }

    return _users.where((user) => (user.type ?? '').trim().toLowerCase() != 'root').toList(growable: false);
  }

  void _showMessage(String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return;
    }

    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  void _upsertApiKey(AdminApiKey apiKey) {
    final next = [..._apiKeys];
    final index = next.indexWhere((entry) => entry.id == apiKey.id);
    if (index >= 0) {
      next[index] = apiKey;
    } else {
      next.add(apiKey);
    }

    setState(() {
      _apiKeys = _sortedApiKeys(next);
    });
  }

  void _removeApiKey(String id) {
    setState(() {
      _apiKeys = _apiKeys.where((entry) => entry.id != id).toList(growable: false);
    });
  }

  void _setBusyRow(String id, bool busy) {
    setState(() {
      if (busy) {
        _busyApiKeyIds.add(id);
      } else {
        _busyApiKeyIds.remove(id);
      }
    });
  }

  List<AdminApiKey> _filteredApiKeys() {
    final normalizedQuery = _searchQuery.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return _apiKeys;
    }

    return _apiKeys
        .where((apiKey) {
          final ownerUsername = apiKey.user?.username ?? '';
          final ownerType = apiKey.user?.type ?? '';
          final searchable = '${apiKey.name} ${apiKey.description ?? ''} $ownerUsername $ownerType'.toLowerCase();
          return searchable.contains(normalizedQuery);
        })
        .toList(growable: false);
  }

  Future<void> _loadApiKeysData({bool showLoading = true}) async {
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
      final apiKeysResponse = await api.getAdminApi().getApiKeys();
      final usersResponse = await api.getAdminApi().getUsers();

      if (!mounted) {
        return;
      }

      setState(() {
        _apiKeys = _sortedApiKeys(apiKeysResponse.data?.apiKeys ?? const <AdminApiKey>[]);
        _users = _sortedUsers(usersResponse.data?.users ?? const <SessionUserSummary>[]);
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Failed to load API keys: $error';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showCreatedKeyDialog(AdminApiKey apiKey) async {
    final createdToken = apiKey.apiKey?.trim();
    if (createdToken == null || createdToken.isEmpty || !mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('API Key Created'),
          content: SizedBox(
            width: 560,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Copy this API key now. For security reasons it is only shown once.'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.34)),
                  ),
                  child: SelectableText(
                    createdToken,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
            FilledButton.icon(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: createdToken));
                if (!context.mounted) {
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('API key copied.')));
              },
              icon: const Icon(Icons.copy_rounded),
              label: const Text('Copy'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createApiKey({required String currentUserId, required bool isRootUser}) async {
    if (_isCreating) {
      return;
    }

    final owners = _availableOwners(isRootUser: isRootUser);
    if (owners.isEmpty) {
      _showMessage('No eligible users available to own an API key.');
      return;
    }

    final hasCurrentUser = owners.any((user) => user.id == currentUserId);
    final initialOwnerId = hasCurrentUser ? currentUserId : owners.first.id;

    final payload = await showCreateAdminApiKeyDialog(context, users: owners, initialUserId: initialOwnerId);
    if (payload == null) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage('No active API client.');
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      final response = await api.getAdminApi().createApiKey(payload: payload);
      final createdApiKey = response.data?.apiKey;

      if (createdApiKey == null) {
        await _loadApiKeysData(showLoading: false);
      } else {
        _upsertApiKey(createdApiKey);
      }

      _showMessage('API key created successfully.');
      if (createdApiKey != null) {
        await _showCreatedKeyDialog(createdApiKey);
      }
    } catch (error) {
      final message = listManagementErrorMessage(error, fallback: 'Failed to create API key.');
      _showMessage(message);
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  Future<void> _editApiKey(AdminApiKey apiKey, {required bool isRootUser}) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage('No active API client.');
      return;
    }

    final owners = _availableOwners(isRootUser: isRootUser);
    if (owners.isEmpty) {
      _showMessage('No eligible users available to own an API key.');
      return;
    }

    final isRootOwnedKey = (apiKey.user?.type ?? '').trim().toLowerCase() == 'root';
    if (!isRootUser && isRootOwnedKey) {
      _showMessage('Root-owned API keys can only be edited by root users.');
      return;
    }

    _setBusyRow(apiKey.id, true);
    try {
      final payload = await showUpdateAdminApiKeyDialog(context, apiKey: apiKey, users: owners);
      if (payload == null) {
        return;
      }

      final response = await api.getAdminApi().updateApiKey(apiKeyId: apiKey.id, payload: payload);
      final updatedApiKey = response.data?.apiKey;
      if (updatedApiKey == null) {
        await _loadApiKeysData(showLoading: false);
      } else {
        _upsertApiKey(updatedApiKey);
      }

      _showMessage('API key updated successfully.');
    } catch (error) {
      final message = listManagementErrorMessage(error, fallback: 'Failed to update API key.');
      _showMessage(message);
    } finally {
      _setBusyRow(apiKey.id, false);
    }
  }

  Future<void> _deleteApiKey(AdminApiKey apiKey) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage('No active API client.');
      return;
    }

    final confirmed = await showListManagementDeleteDialog(
      context: context,
      title: 'Delete API key?',
      message: 'Delete API key "${apiKey.name}"? This action cannot be undone.',
    );

    if (!confirmed) {
      return;
    }

    _setBusyRow(apiKey.id, true);
    try {
      final deleted = await api.getAdminApi().deleteApiKey(apiKey.id);
      if (!deleted) {
        _showMessage('Failed to delete API key.');
        return;
      }

      _removeApiKey(apiKey.id);
      _showMessage('API key deleted.');
    } catch (error) {
      final message = listManagementErrorMessage(error, fallback: 'Failed to delete API key.');
      _showMessage(message);
    } finally {
      _setBusyRow(apiKey.id, false);
    }
  }

  Widget _buildToolbar({
    required bool compact,
    required String currentUserId,
    required bool isRootUser,
    required bool canCreate,
  }) {
    final addButtonEnabled = !_isLoading && !_isCreating && canCreate;

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StyledTextField(
            label: 'Search API keys',
            hintText: 'Filter by name or owner',
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton.filledTonal(
                tooltip: 'Refresh',
                onPressed: _isLoading ? null : () => unawaited(_loadApiKeysData(showLoading: true)),
                icon: const Icon(Icons.refresh_rounded),
              ),
              const SizedBox(width: 6),
              IconButton.filled(
                tooltip: 'Add API key',
                onPressed: addButtonEnabled
                    ? () => _createApiKey(currentUserId: currentUserId, isRootUser: isRootUser)
                    : null,
                icon: _isCreating
                    ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.vpn_key_rounded),
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
            label: 'Search API keys',
            hintText: 'Filter by name, owner, or status',
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
          onPressed: _isLoading ? null : () => unawaited(_loadApiKeysData(showLoading: true)),
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Refresh'),
        ),
        const SizedBox(width: 10),
        FilledButton.icon(
          onPressed: addButtonEnabled
              ? () => _createApiKey(currentUserId: currentUserId, isRootUser: isRootUser)
              : null,
          icon: _isCreating
              ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.add_rounded),
          label: const Text('Add API Key'),
        ),
      ],
    );
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
            TextButton(onPressed: () => unawaited(_loadApiKeysData(showLoading: true)), child: const Text('Retry')),
          ],
        ),
      ),
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
            child: Text('No active user. Sign in to manage API keys.'),
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
            unawaited(_loadApiKeysData(showLoading: true));
          });
        }

        final filteredApiKeys = _filteredApiKeys();
        final compact = context.isMobile;
        final isRootUser = _isRootType(currentUser.type);
        final availableOwners = _availableOwners(isRootUser: isRootUser);

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isLoading && _apiKeys.isNotEmpty) ...[
                const SizedBox(height: 8),
                const LinearProgressIndicator(minHeight: 2),
              ],
              const SizedBox(height: 10),
              _buildErrorCard(),
              if (_errorMessage?.isNotEmpty == true) const SizedBox(height: 10),
              if (availableOwners.isEmpty && !_isLoading)
                Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Text(
                      isRootUser
                          ? 'No server users are available yet.'
                          : 'No eligible non-root users available to assign API keys.',
                    ),
                  ),
                ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => _loadApiKeysData(showLoading: false),
                  child: AdminApiKeyTable(
                    apiKeys: filteredApiKeys,
                    busyApiKeyIds: _busyApiKeyIds,
                    onEdit: (apiKey) => _editApiKey(apiKey, isRootUser: isRootUser),
                    onDelete: _deleteApiKey,
                    loading: _isLoading,
                    topActions: _buildToolbar(
                      compact: compact,
                      currentUserId: currentUser.id,
                      isRootUser: isRootUser,
                      canCreate: availableOwners.isNotEmpty,
                    ),
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
