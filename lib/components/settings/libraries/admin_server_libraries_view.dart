import 'dart:async';

import 'package:yaabsa/components/common/screen_refresh_indicator.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/library/library_folder.dart';
import 'package:yaabsa/api/library/library_settings.dart';
import 'package:yaabsa/api/library/request/create_library_request.dart';
import 'package:yaabsa/api/library/request/library_folder_payload.dart';
import 'package:yaabsa/api/library/request/reorder_library_entry_request.dart';
import 'package:yaabsa/api/library/request/update_library_request.dart';
import 'package:yaabsa/api/library/request/update_library_settings_request.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';
import 'package:yaabsa/components/common/tables/expressive_tile_list.dart';
import 'package:yaabsa/components/settings/libraries/library_upsert_form_dialog.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/menus/yaabsa_context_menu_button.dart';
import 'package:yaabsa/util/l10n.dart';

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
    if (!mounted) {
      return;
    }

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
    final l10n = context.l10n;
    final api = ref.read(absApiProvider);
    if (api == null) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = l10n.errorNoActiveApiClient;
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
        _errorMessage = listManagementErrorMessage(error, fallback: l10n.errorLoadLibrariesFailed);
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

    final l10n = context.l10n;
    final result = await showLibraryUpsertFormDialog(context);
    if (result == null) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage(l10n.errorNoActiveApiClient);
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
      _showMessage(l10n.statusLibraryCreated);
    } catch (error) {
      _showMessage(listManagementErrorMessage(error, fallback: l10n.errorCreateLibraryFailed));
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

    final l10n = context.l10n;
    final result = await showLibraryUpsertFormDialog(context, library: library);
    if (result == null) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage(l10n.errorNoActiveApiClient);
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
      _showMessage(l10n.statusNoChangesToSave);
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
      _showMessage(l10n.statusLibraryUpdated);
    } catch (error) {
      _showMessage(listManagementErrorMessage(error, fallback: l10n.errorUpdateLibraryFailed));
    } finally {
      _setLibraryBusy(library.id, false);
    }
  }

  Future<void> _scanLibrary(Library library, {required bool forceRescan}) async {
    if (_busyLibraryIds.contains(library.id)) {
      return;
    }

    final l10n = context.l10n;
    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage(l10n.errorNoActiveApiClient);
      return;
    }

    _setLibraryBusy(library.id, true);

    try {
      final success = await api.getLibraryApi().scanLibrary(library.id, forceRescan: forceRescan);
      if (!success) {
        _showMessage(l10n.errorStartLibraryScanFailed);
        return;
      }

      _showMessage(forceRescan ? l10n.statusLibraryForceRescanStarted : l10n.statusLibraryScanStarted);
    } catch (error) {
      _showMessage(listManagementErrorMessage(error, fallback: l10n.errorStartLibraryScanFailed));
    } finally {
      _setLibraryBusy(library.id, false);
    }
  }

  Future<void> _deleteLibrary(Library library) async {
    if (_busyLibraryIds.contains(library.id)) {
      return;
    }

    final l10n = context.l10n;
    final confirmed = await showListManagementDeleteDialog(
      context: context,
      title: l10n.headingDeleteLibrary,
      message: l10n.promptDeleteLibrary(library.name),
      confirmLabel: l10n.actionDelete,
    );

    if (!confirmed) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage(l10n.errorNoActiveApiClient);
      return;
    }

    _setLibraryBusy(library.id, true);

    try {
      await api.getLibraryApi().deleteLibrary(library.id);
      _removeLibrary(library.id);
      _invalidateLibraryProviders();
      _showMessage(l10n.statusLibraryDeleted);
    } catch (error) {
      _showMessage(listManagementErrorMessage(error, fallback: l10n.errorDeleteLibraryFailed));
    } finally {
      _setLibraryBusy(library.id, false);
    }
  }

  Future<void> _reorderLibraries(int oldIndex, int newIndex) async {
    if (_isSavingOrder || _libraries.length < 2) {
      return;
    }

    final l10n = context.l10n;
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
      _showMessage(l10n.errorNoActiveApiClient);
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
      _showMessage(l10n.statusLibraryOrderUpdated);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _libraries = previousOrder;
      });
      _showMessage(listManagementErrorMessage(error, fallback: l10n.errorSaveLibraryOrderFailed));
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

    final l10n = context.l10n;
    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage(l10n.errorNoActiveApiClient);
      return;
    }

    _setLibraryBusy(library.id, true);

    try {
      final success = await api.getLibraryApi().matchAllBooks(library.id);
      if (!success) {
        _showMessage(l10n.errorStartMatchAllMetadataFailed);
        return;
      }

      _showMessage(l10n.statusMatchAllMetadataStarted);
    } catch (error) {
      _showMessage(listManagementErrorMessage(error, fallback: l10n.errorStartMatchAllMetadataFailed));
    } finally {
      _setLibraryBusy(library.id, false);
    }
  }

  String _mediaTypeLabel(String mediaType) {
    return mediaType.toLowerCase() == 'podcast' ? context.l10n.mediaTypePodcast : context.l10n.mediaTypeAudiobook;
  }

  Widget _buildErrorCard() {
    final l10n = context.l10n;
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
            TextButton(onPressed: () => unawaited(_loadLibraries(showLoading: true)), child: Text(l10n.actionRetry)),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar({required bool compact, required int totalCount, required int filteredCount}) {
    final l10n = context.l10n;
    final summaryText = filteredCount == totalCount
        ? l10n.statusLibraryCount(totalCount)
        : l10n.statusLibraryFilteredCount(filteredCount, totalCount);

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StyledTextField(
            label: l10n.fieldSearchLibraries,
            hintText: l10n.hintSearchLibraries,
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
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton.filledTonal(
                tooltip: l10n.actionRefresh,
                onPressed: _isLoading ? null : () => unawaited(_loadLibraries(showLoading: true)),
                icon: const Icon(Icons.refresh_rounded),
              ),
              const SizedBox(width: 8),
              if (_isSavingOrder)
                const SizedBox(width: 14, height: 14, child: YaabsaCircularProgressIndicator(strokeWidth: 2)),
              const Spacer(),
              IconButton.filled(
                tooltip: l10n.actionAdd,
                onPressed: _isLoading || _isCreating ? null : _createLibrary,
                icon: _isCreating
                    ? const SizedBox(width: 14, height: 14, child: YaabsaCircularProgressIndicator(strokeWidth: 2))
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
                label: l10n.fieldSearchLibraries,
                hintText: l10n.hintSearchLibraries,
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
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: _isLoading ? null : () => unawaited(_loadLibraries(showLoading: true)),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.actionRefresh),
            ),
            const SizedBox(width: 10),
            if (_isSavingOrder) ...[
              const SizedBox(width: 14, height: 14, child: YaabsaCircularProgressIndicator(strokeWidth: 2)),
              const SizedBox(width: 8),
              Text(
                l10n.statusSavingLibraryOrder,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
            const Spacer(),
            FilledButton.icon(
              onPressed: _isLoading || _isCreating ? null : _createLibrary,
              icon: _isCreating
                  ? const SizedBox(width: 14, height: 14, child: YaabsaCircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.library_add_rounded),
              label: Text(l10n.actionAdd),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLibrariesList(List<Library> filteredLibraries, {required String? selectedLibraryId}) {
    final l10n = context.l10n;
    final canReorder =
        _searchQuery.trim().isEmpty &&
        !_isLoading &&
        !_isSavingOrder &&
        filteredLibraries.length == _libraries.length &&
        _libraries.length > 1;

    return ScreenRefreshIndicator(
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
            return const [SizedBox(width: 18, height: 18, child: YaabsaCircularProgressIndicator(strokeWidth: 2))];
          }

          return [
            FilledButton.tonal(
              onPressed: () => _scanLibrary(library, forceRescan: false),
              style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
              child: Text(l10n.actionScan),
            ),
            YaabsaContextMenuButton<String>(
              tooltip: l10n.headingLibraryActions,
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
                PopupMenuItem<String>(value: 'edit', child: Text(l10n.actionEdit)),
                PopupMenuItem<String>(value: 'scan-force', child: Text(l10n.actionForceRescan)),
                if (library.mediaType == 'book')
                  PopupMenuItem<String>(value: 'match-all', child: Text(l10n.actionMatchAllBooks)),
                const PopupMenuDivider(),
                PopupMenuItem<String>(value: 'delete', child: Text(l10n.actionDelete)),
              ],
              icon: const Icon(Icons.more_vert_rounded),
            ),
          ];
        },
        loading: _isLoading,
        emptyTitle: _searchQuery.trim().isEmpty ? l10n.statusNoLibrariesAvailable : l10n.statusNoLibrariesMatchSearch,
        emptySubtitle: _searchQuery.trim().isEmpty ? l10n.messageCreateLibraryToAddContent : l10n.hintAdjustSearchQuery,
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
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text(context.l10n.promptSignInForAdminAccess),
          );
        }

        if (!_isAdminType(currentUser.type)) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text(context.l10n.errorAdminRequired),
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
                const YaabsaLinearProgressIndicator(minHeight: 2),
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
        child: Center(child: YaabsaCircularProgressIndicator()),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Text(
          context.l10n.errorLoadAdminUserData(error.toString()),
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
