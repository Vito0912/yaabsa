import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/api/library/search_library.dart';
import 'package:yaabsa/components/common/inputs/styled_form_fields.dart';
import 'package:yaabsa/models/queue_source.dart';
import 'package:yaabsa/models/smart_download.dart';
import 'package:yaabsa/provider/common/collection_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/common/library_search_provider.dart';
import 'package:yaabsa/provider/common/playlist_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/library/smart_download_provider.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';

class _AutocompleteTextEditingController extends TextEditingController {
  void refreshOptions() {
    final current = value;
    value = current.copyWith(text: '${current.text}\u200B');
    value = current;
  }
}

class SmartDownloadsSettings extends ConsumerStatefulWidget {
  const SmartDownloadsSettings({super.key});

  static const String routeName = '/settings/library/smart-downloads';

  @override
  ConsumerState<SmartDownloadsSettings> createState() => _SmartDownloadsSettingsState();
}

class _SmartDownloadsSettingsState extends ConsumerState<SmartDownloadsSettings> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() => ref.read(smartDownloadManagerProvider.notifier).loadProfiles());
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final manager = ref.watch(smartDownloadManagerProvider);
    final notifier = ref.read(smartDownloadManagerProvider.notifier);

    return SettingsPageScaffold(
      title: 'Smart Downloads',
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        if (user == null)
          const Padding(padding: EdgeInsets.all(20), child: Text('Sign in to configure smart downloads.'))
        else ...[
          if (manager.error != null)
            Padding(padding: const EdgeInsets.all(16), child: Text('Last reconciliation failed: ${manager.error}')),
          _ProfileSection(
            profiles: manager.profiles,
            isBusy: manager.isReconciling,
            onAdd: () async {
              final profile = await _showProfileEditor(context, userId: user.id);
              if (profile != null) await notifier.saveProfile(profile);
            },
            onEdit: (profile) async {
              final edited = await _showProfileEditor(context, userId: user.id, initial: profile);
              if (edited != null) await notifier.saveProfile(edited);
            },
            onDelete: (profile) async {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Remove profile?'),
                  content: Text(
                    'Remove “${profile.name}” and delete its managed downloads? Downloads shared with another rule will be kept.',
                  ),
                  actions: [
                    TextButton(onPressed: () => context.pop(false), child: const Text('Cancel')),
                    FilledButton(onPressed: () => context.pop(true), child: const Text('Remove')),
                  ],
                ),
              );
              if (shouldDelete == true) await notifier.deleteProfile(profile.id, user.id);
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: OutlinedButton.icon(
              onPressed: manager.isReconciling ? null : () => notifier.reconcile(reason: 'manual refresh'),
              icon: manager.isReconciling
                  ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.sync_rounded),
              label: const Text('Reconcile now'),
            ),
          ),
        ],
      ],
    );
  }

  Future<SmartDownloadProfile?> _showProfileEditor(
    BuildContext context, {
    required String userId,
    SmartDownloadProfile? initial,
  }) {
    return showDialog<SmartDownloadProfile>(
      context: context,
      builder: (context) => _SmartDownloadProfileEditor(userId: userId, initial: initial),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({
    required this.profiles,
    required this.isBusy,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final List<SmartDownloadProfile> profiles;
  final bool isBusy;
  final VoidCallback onAdd;
  final ValueChanged<SmartDownloadProfile> onEdit;
  final ValueChanged<SmartDownloadProfile> onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 12, 8, 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            ListTile(
              title: const Text('Download rules'),
              subtitle: Text(
                profiles.isEmpty
                    ? 'No automatic download rules yet'
                    : '${profiles.length} active rule${profiles.length == 1 ? '' : 's'}',
              ),
              trailing: FilledButton.tonalIcon(
                onPressed: isBusy ? null : onAdd,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add'),
              ),
            ),
            if (profiles.isNotEmpty) const Divider(height: 1),
            for (final profile in profiles)
              ListTile(
                leading: Icon(profile.enabled ? Icons.download_done_rounded : Icons.pause_circle_outline_rounded),
                title: Text(profile.name),
                subtitle: Text('${profile.sources.length} sources · ${profile.policy.targetCount} items per source'),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') onEdit(profile);
                    if (value == 'delete') onDelete(profile);
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Remove')),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SmartDownloadProfileEditor extends StatefulWidget {
  const _SmartDownloadProfileEditor({required this.userId, this.initial});

  final String userId;
  final SmartDownloadProfile? initial;

  @override
  State<_SmartDownloadProfileEditor> createState() => _SmartDownloadProfileEditorState();
}

class _SmartDownloadProfileEditorState extends State<_SmartDownloadProfileEditor> {
  late final TextEditingController _nameController;
  late final TextEditingController _targetController;
  late final TextEditingController _ageController;
  late final TextEditingController _storageController;
  late final TextEditingController _deleteAfterController;
  late bool _enabled;
  late String _downloadType;
  late List<MediaSourceDescriptor> _sources;

  @override
  void initState() {
    super.initState();
    final profile = widget.initial;
    _nameController = TextEditingController(text: profile?.name ?? 'Offline queue');
    _targetController = TextEditingController(text: '${profile?.policy.targetCount ?? 3}');
    _ageController = TextEditingController(text: profile?.policy.maxAgeDays?.toString() ?? '');
    _storageController = TextEditingController(
      text: profile?.policy.maxStorageBytes == null ? '' : '${profile!.policy.maxStorageBytes! ~/ (1024 * 1024)}',
    );
    _deleteAfterController = TextEditingController(text: '${profile?.policy.deleteAfterHours ?? 24}');
    _enabled = profile?.enabled ?? true;
    _downloadType = profile?.policy.downloadType ?? 'audiobook';
    _sources = [...?profile?.sources];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    _ageController.dispose();
    _storageController.dispose();
    _deleteAfterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initial == null ? 'New smart-download profile' : 'Edit smart-download profile'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StyledTextField(label: 'Name', controller: _nameController),
              const SizedBox(height: 12),
              StyledTextField(
                label: 'Item count per source',
                controller: _targetController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              StyledTextField(
                label: 'Maximum age in days (optional)',
                controller: _ageController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              StyledTextField(
                label: 'Managed storage cap in MB (optional)',
                controller: _storageController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              StyledTextField(
                label: 'Keep completed downloads for hours',
                controller: _deleteAfterController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              YaabsaDropdownField<String>(
                label: 'Download types',
                value: _downloadType,
                items: const [
                  DropdownMenuItem(value: 'audiobook', child: Text('Audiobook')),
                  DropdownMenuItem(value: 'ebook', child: Text('Ebook')),
                  DropdownMenuItem(value: 'both', child: Text('Both')),
                ],
                onChanged: (value) => setState(() => _downloadType = value ?? 'audiobook'),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Enabled'),
                value: _enabled,
                onChanged: (value) => setState(() => _enabled = value),
              ),
              const Align(alignment: Alignment.centerLeft, child: Text('Selected sources')),
              for (final source in _sources)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.45)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.only(left: 12, right: 4),
                    title: Text(source.displayName ?? '${source.type.name} source'),
                    subtitle: Text(source.type.name),
                    trailing: IconButton(
                      tooltip: 'Remove source',
                      onPressed: () => setState(() => _sources.remove(source)),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ),
                ),
              TextButton.icon(onPressed: _addSource, icon: const Icon(Icons.add), label: const Text('Add source')),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }

  Future<void> _addSource() async {
    final source = await showDialog<MediaSourceDescriptor>(
      context: context,
      builder: (context) => const _SourceEditor(),
    );
    if (source != null && !_sources.contains(source)) setState(() => _sources.add(source));
  }

  void _save() {
    final name = _nameController.text.trim();
    final target = int.tryParse(_targetController.text.trim());
    if (name.isEmpty || target == null || target < 1 || target > 100) return;
    final age = int.tryParse(_ageController.text.trim());
    final storageMb = int.tryParse(_storageController.text.trim());
    final deleteAfterHours = int.tryParse(_deleteAfterController.text.trim()) ?? 24;
    if (deleteAfterHours < 0 || (age != null && age < 0) || (storageMb != null && storageMb < 0)) return;
    final profile = widget.initial;
    Navigator.of(context).pop(
      SmartDownloadProfile(
        id: profile?.id ?? 'smart_${DateTime.now().microsecondsSinceEpoch}',
        userId: widget.userId,
        name: name,
        enabled: _enabled,
        policy: SmartDownloadPolicy(
          targetCount: target,
          maxAgeDays: age,
          maxStorageBytes: storageMb == null ? null : storageMb * 1024 * 1024,
          deleteAfterHours: deleteAfterHours,
          downloadType: _downloadType,
        ),
        sources: _sources,
      ),
    );
  }
}

class _SourceEditor extends ConsumerStatefulWidget {
  const _SourceEditor();

  @override
  ConsumerState<_SourceEditor> createState() => _SourceEditorState();
}

class _SourceEditorState extends ConsumerState<_SourceEditor> {
  final _searchController = _AutocompleteTextEditingController();
  final _searchFocusNode = FocusNode();
  MediaSourceType _type = MediaSourceType.podcast;
  bool _descending = true;
  String? _libraryId;
  String? _selectedSourceId;
  String? _selectedSourceName;
  String _searchQuery = '';
  bool _autocompleteRefreshScheduled = false;
  bool _refreshingAutocomplete = false;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final libraries = ref.watch(userLibrariesProvider).value ?? const [];
    final selectedLibraryId = libraries.any((library) => library.id == _libraryId)
        ? _libraryId
        : libraries.firstOrNull?.id;
    if (_libraryId != selectedLibraryId) {
      _libraryId = selectedLibraryId;
    }
    final selectedLibrary = libraries.where((library) => library.id == selectedLibraryId).firstOrNull;
    final availableSourceTypes = _sourceTypesForLibrary(selectedLibrary?.mediaType);
    if (!availableSourceTypes.contains(_type)) {
      _type = availableSourceTypes.first;
      _searchController.clear();
      _searchQuery = '';
      _selectedSourceId = null;
      _selectedSourceName = null;
    }
    final availableSourceNames = <String, String>{};
    if (selectedLibraryId != null && _type == MediaSourceType.playlist) {
      for (final playlist in ref.watch(playlistsProvider(selectedLibraryId)).value?.items ?? const []) {
        availableSourceNames[playlist.id] = playlist.name;
      }
    } else if (selectedLibraryId != null && _type == MediaSourceType.collection) {
      for (final collection in ref.watch(collectionsProvider(selectedLibraryId)).value?.items ?? const []) {
        availableSourceNames[collection.id] = collection.name;
      }
    }

    final normalizedQuery = _searchQuery.trim();
    final searchAsync =
        normalizedQuery.isNotEmpty && (_type == MediaSourceType.podcast || _type == MediaSourceType.series)
        ? ref.watch(librarySearchProvider((query: normalizedQuery, limit: 3, libraryId: selectedLibraryId)))
        : null;
    final localSuggestions = availableSourceNames.entries
        .where(
          (entry) => normalizedQuery.isNotEmpty && entry.value.toLowerCase().contains(normalizedQuery.toLowerCase()),
        )
        .take(3)
        .toList(growable: false);
    final remoteSuggestions = _remoteSuggestions(searchAsync);
    final sourceSuggestions = [
      ...localSuggestions.map((entry) => (id: entry.key, name: entry.value)),
      ...remoteSuggestions,
    ];
    _scheduleAutocompleteRefresh();
    final canAddSource = _selectedSourceId?.trim().isNotEmpty == true && _libraryId?.trim().isNotEmpty == true;

    return AlertDialog(
      title: const Text('Add source'),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              YaabsaDropdownField<String>(
                label: 'Library',
                value: selectedLibraryId,
                items: [
                  for (final library in libraries) DropdownMenuItem(value: library.id, child: Text(library.name)),
                ],
                onChanged: (value) => setState(() {
                  _libraryId = value;
                  _searchController.clear();
                  _searchQuery = '';
                  _selectedSourceId = null;
                  _selectedSourceName = null;
                }),
              ),
              const SizedBox(height: 16),
              YaabsaDropdownField<MediaSourceType>(
                label: 'Source type',
                value: _type,
                items: [
                  for (final type in availableSourceTypes)
                    DropdownMenuItem(value: type, child: Text(type.name[0].toUpperCase() + type.name.substring(1))),
                ],
                onChanged: (value) => setState(() {
                  _type = value ?? MediaSourceType.podcast;
                  _searchController.clear();
                  _searchQuery = '';
                  _selectedSourceId = null;
                  _selectedSourceName = null;
                }),
              ),
              const SizedBox(height: 16),
              RawAutocomplete<({String id, String name})>(
                key: ValueKey('${_type.name}:${selectedLibraryId ?? ''}'),
                textEditingController: _searchController,
                focusNode: _searchFocusNode,
                displayStringForOption: (suggestion) => suggestion.name,
                optionsBuilder: (textEditingValue) {
                  final query = textEditingValue.text.trim().toLowerCase();
                  if (query.isEmpty) return const <({String id, String name})>[];
                  return sourceSuggestions;
                },
                onSelected: (suggestion) => setState(() {
                  _selectedSourceId = suggestion.id;
                  _selectedSourceName = suggestion.name;
                }),
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  return StyledTextField(
                    label: 'Search sources',
                    controller: controller,
                    focusNode: focusNode,
                    prefixIcon: const Icon(Icons.search_rounded),
                    textInputAction: TextInputAction.search,
                    onChanged: (value) {
                      if (_refreshingAutocomplete) return;
                      final isSelectedValue = _selectedSourceId != null && value.trim() == _selectedSourceName;
                      setState(() {
                        _searchQuery = value;
                        if (!isSelectedValue) {
                          _selectedSourceId = null;
                          _selectedSourceName = null;
                        }
                      });
                      _scheduleAutocompleteRefresh();
                    },
                    onSubmitted: (_) => onFieldSubmitted(),
                  );
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(10),
                      clipBehavior: Clip.antiAlias,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 220, minWidth: 280),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final suggestion = options.elementAt(index);
                            return ListTile(
                              dense: true,
                              title: Text(suggestion.name),
                              onTap: () => onSelected(suggestion),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              if (searchAsync?.isLoading ?? false) const LinearProgressIndicator(),
              if (searchAsync?.hasError ?? false)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text('Source search failed. Try a different search term.'),
                  ),
                ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Descending/feed direction'),
                value: _descending,
                onChanged: (value) => setState(() => _descending = value),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
        FilledButton(
          onPressed: canAddSource
              ? () {
                  final sourceId = _selectedSourceId!.trim();
                  final libraryId = _libraryId!.trim();
                  context.pop(
                    MediaSourceDescriptor(
                      type: _type,
                      sourceId: sourceId,
                      libraryId: libraryId,
                      displayName: _selectedSourceName,
                      descending: _descending,
                    ),
                  );
                }
              : null,
          child: const Text('Add'),
        ),
      ],
    );
  }

  List<({String id, String name})> _remoteSuggestions(AsyncValue<SearchLibrary?>? searchAsync) {
    final result = searchAsync?.asData?.value;
    if (result == null) {
      return const <({String id, String name})>[];
    }

    if (_type == MediaSourceType.series) {
      return (result.series ?? const [])
          .take(3)
          .map((entry) => (id: entry.series.id, name: entry.series.name))
          .toList(growable: false);
    }

    return (result.podcast ?? const [])
        .where((entry) => entry.libraryItem != null)
        .take(3)
        .map((entry) => (id: entry.libraryItem!.id, name: entry.libraryItem!.title))
        .toList(growable: false);
  }

  void _scheduleAutocompleteRefresh() {
    if (_autocompleteRefreshScheduled) return;
    _autocompleteRefreshScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autocompleteRefreshScheduled = false;
      if (!mounted) return;
      _refreshingAutocomplete = true;
      _searchController.refreshOptions();
      _refreshingAutocomplete = false;
    });
  }

  List<MediaSourceType> _sourceTypesForLibrary(String? mediaType) {
    return switch (mediaType?.trim().toLowerCase()) {
      'podcast' => const [MediaSourceType.podcast, MediaSourceType.playlist, MediaSourceType.collection],
      'book' => const [MediaSourceType.series, MediaSourceType.playlist, MediaSourceType.collection],
      _ => MediaSourceType.values,
    };
  }
}
