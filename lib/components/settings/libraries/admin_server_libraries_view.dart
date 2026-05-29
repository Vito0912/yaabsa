import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/library/library_folder.dart';
import 'package:yaabsa/api/library/library_settings.dart';
import 'package:yaabsa/api/library/request/create_library_request.dart';
import 'package:yaabsa/api/library/request/library_folder_payload.dart';
import 'package:yaabsa/api/library/request/reorder_library_entry_request.dart';
import 'package:yaabsa/api/library/request/update_library_request.dart';
import 'package:yaabsa/api/library/request/update_library_settings_request.dart';
import 'package:yaabsa/components/common/inputs/styled_form_fields.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';
import 'package:yaabsa/components/common/tables/expressive_tile_list.dart';
import 'package:yaabsa/components/settings/libraries/library_upsert_form_dialog.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';

class AdminServerLibrariesView extends ConsumerStatefulWidget {
  const AdminServerLibrariesView({super.key});

  @override
  ConsumerState<AdminServerLibrariesView> createState() => _AdminServerLibrariesViewState();
}

class _AdminServerLibrariesViewState extends ConsumerState<AdminServerLibrariesView> {
  String? _activeUserId;

  bool _isLoading = true;
  bool _isCreating = false;
  bool _isSavingOrder = false;

  String _searchQuery = '';
  String? _errorMessage;

  List<Library> _libraries = const <Library>[];
  final Set<String> _busyLibraryIds = <String>{};

  bool _isAdminType(String? userType) {
    final normalized = (userType ?? '').trim().toLowerCase();
    return normalized == 'admin' || normalized == 'root';
  }

  void _showMessage(String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return;
    }

    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  void _invalidateLibraryProviders() {
    ref.invalidate(userLibrariesProvider);
    ref.invalidate(selectedLibraryProvider);
    ref.invalidate(selectedLibraryIdProvider);
  }

  List<Library> _sortedLibraries(List<Library> values) {
    final sorted = List<Library>.from(values);
    sorted.sort((left, right) {
      final byOrder = left.displayOrder.compareTo(right.displayOrder);
      if (byOrder != 0) {
        return byOrder;
      }

      final byName = left.name.toLowerCase().compareTo(right.name.toLowerCase());
      if (byName != 0) {
        return byName;
      }

      return left.id.compareTo(right.id);
    });
    return sorted;
  }

  Future<void> _loadLibraries({bool showLoading = true}) async {
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
      final response = await api.getLibraryApi().getLibraries();
      final libraries = _sortedLibraries(response.data?.libraries ?? const <Library>[]);

      if (!mounted) {
        return;
      }

      setState(() {
        _libraries = libraries;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = listManagementErrorMessage(error, fallback: 'Failed to load libraries.');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _upsertLibrary(Library library) {
    final next = [..._libraries];
    final index = next.indexWhere((entry) => entry.id == library.id);
    if (index >= 0) {
      next[index] = library;
    } else {
      next.add(library);
    }

    setState(() {
      _libraries = _sortedLibraries(next);
    });
  }

  void _removeLibrary(String libraryId) {
    setState(() {
      _libraries = _libraries.where((entry) => entry.id != libraryId).toList(growable: false);
    });
  }

  void _setLibraryBusy(String libraryId, bool isBusy) {
    setState(() {
      if (isBusy) {
        _busyLibraryIds.add(libraryId);
      } else {
        _busyLibraryIds.remove(libraryId);
      }
    });
  }

  bool _hasFolderChanges(Library library, List<LibraryFolderPayload> nextFolders) {
    final currentFolders = library.folders ?? const <LibraryFolder>[];
    if (currentFolders.length != nextFolders.length) {
      return true;
    }

    for (var index = 0; index < currentFolders.length; index++) {
      final current = currentFolders[index];
      final next = nextFolders[index];
      final nextId = next.id?.trim() ?? '';
      final nextPath = (next.fullPath ?? next.path ?? '').trim();

      if (nextId != current.id.trim() || nextPath != current.fullPath.trim()) {
        return true;
      }
    }

    return false;
  }

  bool _jsonPayloadEquals(Object? left, Object? right) {
    if (identical(left, right)) {
      return true;
    }

    if (left is num && right is num) {
      return left.toDouble() == right.toDouble();
    }

    if (left is List && right is List) {
      if (left.length != right.length) {
        return false;
      }

      for (var index = 0; index < left.length; index++) {
        if (!_jsonPayloadEquals(left[index], right[index])) {
          return false;
        }
      }

      return true;
    }

    if (left is Map && right is Map) {
      if (left.length != right.length) {
        return false;
      }

      for (final key in left.keys) {
        if (!right.containsKey(key)) {
          return false;
        }

        if (!_jsonPayloadEquals(left[key], right[key])) {
          return false;
        }
      }

      return true;
    }

    return left == right;
  }

  UpdateLibrarySettingsRequest? _buildSettingsPatch({required LibrarySettings current, required LibrarySettings next}) {
    final currentJson = current.toJson();
    final nextJson = next.toJson();
    final changedSettings = <String, dynamic>{};

    final keys = <String>{...currentJson.keys, ...nextJson.keys};
    for (final key in keys) {
      final currentValue = currentJson[key];
      final nextValue = nextJson[key];

      if (_jsonPayloadEquals(currentValue, nextValue)) {
        continue;
      }

      changedSettings[key] = nextValue;
    }

    return changedSettings.isEmpty ? null : UpdateLibrarySettingsRequest.fromJson(changedSettings);
  }

  Future<void> _createLibrary() async {
    if (_isCreating) {
      return;
    }

    final result = await showLibraryUpsertFormDialog(context);
    if (result == null) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage('No active API client.');
      return;
    }

    final icon = result.icon.trim();

    setState(() {
      _isCreating = true;
    });

    try {
      final request = CreateLibraryRequest(
        name: result.name,
        mediaType: result.mediaType,
        provider: result.provider,
        icon: icon.isEmpty ? null : icon,
        folders: result.folders,
        settings: result.settings,
      );

      final response = await api.getLibraryApi().createLibrary(request);
      final createdLibrary = response.data;

      if (createdLibrary == null) {
        await _loadLibraries(showLoading: false);
      } else {
        _upsertLibrary(createdLibrary);
      }

      _invalidateLibraryProviders();
      _showMessage('Library created successfully.');
    } catch (error) {
      _showMessage(listManagementErrorMessage(error, fallback: 'Failed to create library.'));
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  Future<void> _editLibrary(Library library) async {
    if (_busyLibraryIds.contains(library.id)) {
      return;
    }

    final result = await showLibraryUpsertFormDialog(context, library: library);
    if (result == null) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage('No active API client.');
      return;
    }

    final nextName = result.name.trim();
    final nextProvider = result.provider.trim();
    final nextIcon = result.icon.trim();

    final changedName = nextName != library.name ? nextName : null;
    final changedProvider = nextProvider != library.provider ? nextProvider : null;
    final changedIcon = nextIcon != library.icon ? nextIcon : null;
    final changedFolders = _hasFolderChanges(library, result.folders) ? result.folders : null;
    final changedSettings = _buildSettingsPatch(current: library.settings, next: result.settings);

    if (changedName == null &&
        changedProvider == null &&
        changedIcon == null &&
        changedFolders == null &&
        changedSettings == null) {
      _showMessage('No changes to save.');
      return;
    }

    _setLibraryBusy(library.id, true);

    try {
      final request = UpdateLibraryRequest(
        name: changedName,
        provider: changedProvider,
        icon: changedIcon,
        folders: changedFolders,
        settings: changedSettings,
      );

      final response = await api.getLibraryApi().updateLibrary(library.id, request);
      final updatedLibrary = response.data;

      if (updatedLibrary == null) {
        await _loadLibraries(showLoading: false);
      } else {
        _upsertLibrary(updatedLibrary);
      }

      _invalidateLibraryProviders();
      _showMessage('Library updated successfully.');
    } catch (error) {
      _showMessage(listManagementErrorMessage(error, fallback: 'Failed to update library.'));
    } finally {
      _setLibraryBusy(library.id, false);
    }
  }

  Future<void> _scanLibrary(Library library, {required bool forceRescan}) async {
    if (_busyLibraryIds.contains(library.id)) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage('No active API client.');
      return;
    }

    _setLibraryBusy(library.id, true);

    try {
      final success = await api.getLibraryApi().scanLibrary(library.id, forceRescan: forceRescan);
      if (!success) {
        _showMessage('Failed to start library scan.');
        return;
      }

      _showMessage(forceRescan ? 'Force rescan started.' : 'Library scan started.');
    } catch (error) {
      _showMessage(listManagementErrorMessage(error, fallback: 'Failed to start library scan.'));
    } finally {
      _setLibraryBusy(library.id, false);
    }
  }

  Future<void> _deleteLibrary(Library library) async {
    if (_busyLibraryIds.contains(library.id)) {
      return;
    }

    final confirmed = await showListManagementDeleteDialog(
      context: context,
      title: 'Delete library?',
      message: 'Delete "${library.name}"? This action cannot be undone.',
      confirmLabel: 'Delete',
    );

    if (!confirmed) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage('No active API client.');
      return;
    }

    _setLibraryBusy(library.id, true);

    try {
      await api.getLibraryApi().deleteLibrary(library.id);
      _removeLibrary(library.id);
      _invalidateLibraryProviders();
      _showMessage('Library deleted.');
    } catch (error) {
      _showMessage(listManagementErrorMessage(error, fallback: 'Failed to delete library.'));
    } finally {
      _setLibraryBusy(library.id, false);
    }
  }

  Future<void> _reorderLibraries(int oldIndex, int newIndex) async {
    if (_isSavingOrder || _libraries.length < 2) {
      return;
    }

    final previousOrder = List<Library>.from(_libraries);
    final reordered = List<Library>.from(_libraries);
    final movedLibrary = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, movedLibrary);

    setState(() {
      _libraries = reordered;
      _isSavingOrder = true;
    });

    final api = ref.read(absApiProvider);
    if (api == null) {
      if (!mounted) {
        return;
      }

      setState(() {
        _libraries = previousOrder;
        _isSavingOrder = false;
      });
      _showMessage('No active API client.');
      return;
    }

    try {
      final entries = [
        for (var index = 0; index < reordered.length; index++)
          ReorderLibraryEntryRequest(id: reordered[index].id, newOrder: index + 1),
      ];

      final response = await api.getLibraryApi().reorderLibraries(entries);
      final serverLibraries = response.data?.libraries;

      if (!mounted) {
        return;
      }

      setState(() {
        _libraries = _sortedLibraries(serverLibraries == null || serverLibraries.isEmpty ? reordered : serverLibraries);
      });

      _invalidateLibraryProviders();
      _showMessage('Library order updated.');
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _libraries = previousOrder;
      });
      _showMessage(listManagementErrorMessage(error, fallback: 'Failed to save library order.'));
    } finally {
      if (mounted) {
        setState(() {
          _isSavingOrder = false;
        });
      }
    }
  }

  List<Library> _filteredLibraries() {
    final normalizedQuery = _searchQuery.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return _libraries;
    }

    return _libraries
        .where((library) {
          final foldersText = (library.folders ?? const <LibraryFolder>[])
              .map((folder) => folder.fullPath)
              .join(' ')
              .toLowerCase();

          final searchable = '${library.name} ${library.mediaType} ${library.provider} ${library.icon} $foldersText'
              .toLowerCase();
          return searchable.contains(normalizedQuery);
        })
        .toList(growable: false);
  }

  IconData? _iconForName(String iconName) {
    switch (iconName.trim().toLowerCase()) {
      default:
        return null;
    }
  }

  Future<void> _matchAllBooks(Library library) async {
    if (_busyLibraryIds.contains(library.id) || library.mediaType != 'book') {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage('No active API client.');
      return;
    }

    _setLibraryBusy(library.id, true);

    try {
      final success = await api.getLibraryApi().matchAllBooks(library.id);
      if (!success) {
        _showMessage('Failed to start match-all job.');
        return;
      }

      _showMessage('Started match-all metadata job.');
    } catch (error) {
      _showMessage(listManagementErrorMessage(error, fallback: 'Failed to start match-all metadata job.'));
    } finally {
      _setLibraryBusy(library.id, false);
    }
  }

  String _mediaTypeLabel(String mediaType) {
    return mediaType.toLowerCase() == 'podcast' ? 'Podcast' : 'Book';
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
            TextButton(onPressed: () => unawaited(_loadLibraries(showLoading: true)), child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar({required bool compact, required int totalCount, required int filteredCount}) {
    final summaryText = filteredCount == totalCount
        ? '$totalCount libraries'
        : '$filteredCount of $totalCount libraries';

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StyledTextField(
            label: 'Search libraries',
            hintText: 'Filter by name, provider, media type, or path',
            prefixIcon: const Icon(Icons.search_rounded),
            enabled: !_isLoading,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 8),
          Text(
            summaryText,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton.filledTonal(
                tooltip: 'Refresh',
                onPressed: _isLoading ? null : () => unawaited(_loadLibraries(showLoading: true)),
                icon: const Icon(Icons.refresh_rounded),
              ),
              const SizedBox(width: 8),
              if (_isSavingOrder)
                const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
              const Spacer(),
              IconButton.filled(
                tooltip: 'Add library',
                onPressed: _isLoading || _isCreating ? null : _createLibrary,
                icon: _isCreating
                    ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.library_add_rounded),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: StyledTextField(
                label: 'Search libraries',
                hintText: 'Filter by name, provider, media type, or path',
                prefixIcon: const Icon(Icons.search_rounded),
                enabled: !_isLoading,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Text(
              summaryText,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: _isLoading ? null : () => unawaited(_loadLibraries(showLoading: true)),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Refresh'),
            ),
            const SizedBox(width: 10),
            if (_isSavingOrder) ...[
              const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
              const SizedBox(width: 8),
              Text(
                'Saving order...',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
            const Spacer(),
            FilledButton.icon(
              onPressed: _isLoading || _isCreating ? null : _createLibrary,
              icon: _isCreating
                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.library_add_rounded),
              label: const Text('Add library'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLibrariesList(List<Library> filteredLibraries, {required String? selectedLibraryId}) {
    final canReorder =
        _searchQuery.trim().isEmpty &&
        !_isLoading &&
        !_isSavingOrder &&
        filteredLibraries.length == _libraries.length &&
        _libraries.length > 1;

    return RefreshIndicator(
      onRefresh: () => _loadLibraries(showLoading: false),
      child: ExpressiveTileList<Library>(
        items: filteredLibraries,
        itemId: (library) => library.id,
        titleBuilder: (library) => library.name,
        subtitleBuilder: (library) => _mediaTypeLabel(library.mediaType),
        leadingIconBuilder: (library) => _iconForName(library.icon),
        isSelected: (library) => selectedLibraryId != null && selectedLibraryId == library.id,
        onReorderItem: canReorder ? _reorderLibraries : null,
        trailingBuilder: (context, library) {
          if (_busyLibraryIds.contains(library.id)) {
            return const [SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))];
          }

          return [
            FilledButton.tonal(
              onPressed: () => _scanLibrary(library, forceRescan: false),
              style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
              child: const Text('Scan'),
            ),
            PopupMenuButton<String>(
              tooltip: 'Library actions',
              onSelected: (value) {
                if (value == 'edit') {
                  unawaited(_editLibrary(library));
                  return;
                }

                if (value == 'scan-force') {
                  unawaited(_scanLibrary(library, forceRescan: true));
                  return;
                }

                if (value == 'match-all') {
                  unawaited(_matchAllBooks(library));
                  return;
                }

                if (value == 'delete') {
                  unawaited(_deleteLibrary(library));
                  return;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<String>(value: 'edit', child: Text('Edit library')),
                const PopupMenuItem<String>(value: 'scan-force', child: Text('Force rescan')),
                if (library.mediaType == 'book')
                  const PopupMenuItem<String>(value: 'match-all', child: Text('Match all books')),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(value: 'delete', child: Text('Delete library')),
              ],
              icon: const Icon(Icons.more_vert_rounded),
            ),
          ];
        },
        loading: _isLoading,
        emptyTitle: _searchQuery.trim().isEmpty
            ? 'No libraries available on this server.'
            : 'No libraries match your search query.',
        emptySubtitle: _searchQuery.trim().isEmpty
            ? 'Create a library to add books or podcasts.'
            : 'Try adjusting your search query.',
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final selectedLibraryIdAsync = ref.watch(selectedLibraryIdProvider);

    return currentUserAsync.when(
      data: (currentUser) {
        if (currentUser == null) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text('No active user. Sign in to manage libraries.'),
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
          _searchQuery = '';
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            unawaited(_loadLibraries(showLoading: true));
          });
        }

        final filteredLibraries = _filteredLibraries();
        final compact = context.isMobile;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isLoading && _libraries.isNotEmpty) ...[
                const SizedBox(height: 8),
                const LinearProgressIndicator(minHeight: 2),
              ],
              const SizedBox(height: 10),
              _buildErrorCard(),
              if (_errorMessage?.isNotEmpty == true) const SizedBox(height: 10),
              _buildToolbar(compact: compact, totalCount: _libraries.length, filteredCount: filteredLibraries.length),
              const SizedBox(height: 12),
              Expanded(child: _buildLibrariesList(filteredLibraries, selectedLibraryId: selectedLibraryIdAsync.value)),
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
