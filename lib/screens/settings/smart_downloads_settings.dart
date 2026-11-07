import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/common/inputs/styled_form_fields.dart';
import 'package:yaabsa/components/settings/smart_download_actions_card.dart';
import 'package:yaabsa/components/settings/smart_download_source_editor.dart';
import 'package:yaabsa/models/queue_source.dart';
import 'package:yaabsa/models/smart_download.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/library/smart_download_provider.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';

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
          SmartDownloadActionsCard(userId: user.id, isBusy: manager.isReconciling),
          _ProfileSection(
            profiles: manager.profiles,
            isBusy: manager.isReconciling,
            onAdd: () async {
              final profile = await _showProfileEditor(context, userId: user.id);
              if (profile != null) {
                await notifier.saveProfile(profile);
              }
            },
            onEdit: (profile) async {
              final edited = await _showProfileEditor(context, userId: user.id, initial: profile);
              if (edited != null) {
                await notifier.saveProfile(edited);
              }
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
              if (shouldDelete == true) {
                await notifier.deleteProfile(profile.id, user.id);
              }
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
                subtitle: Text(
                  '${profile.sources.length} sources · ${profile.policy.targetCount.clamp(1, 150)} items per source',
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit(profile);
                    }
                    if (value == 'delete') {
                      onDelete(profile);
                    }
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
  late bool _downloadTypeManuallySelected;
  late List<MediaSourceDescriptor> _sources;

  @override
  void initState() {
    super.initState();
    final profile = widget.initial;
    _nameController = TextEditingController(text: profile?.name ?? 'Offline queue');
    _targetController = TextEditingController(text: '${(profile?.policy.targetCount ?? 3).clamp(1, 150)}');
    _ageController = TextEditingController(text: profile?.policy.maxAgeDays?.toString() ?? '');
    _storageController = TextEditingController(
      text: profile?.policy.maxStorageBytes == null ? '' : '${profile!.policy.maxStorageBytes! ~/ (1024 * 1024)}',
    );
    _deleteAfterController = TextEditingController(text: '${profile?.policy.deleteAfterHours ?? 24}');
    _enabled = profile?.enabled ?? true;
    _downloadType = profile?.policy.downloadType ?? 'audiobook';
    _downloadTypeManuallySelected = profile != null;
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
                label: 'Item count per source (1–150)',
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
                label: 'Storage budget (MB, optional)',
                controller: _storageController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              StyledTextField(
                label: 'Keep finished books for hours',
                controller: _deleteAfterController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              YaabsaDropdownField<String>(
                label: 'Download types',
                value: _downloadType,
                items: const [
                  DropdownMenuItem(value: 'audiobook', child: Text('Audiobook/Episodes')),
                  DropdownMenuItem(value: 'ebook', child: Text('Ebook')),
                  DropdownMenuItem(value: 'both', child: Text('Both')),
                ],
                onChanged: (value) {
                  setState(() {
                    _downloadType = value ?? 'audiobook';
                    _downloadTypeManuallySelected = true;
                  });
                },
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
                    trailing: IconButton(
                      tooltip: 'Remove source',
                      onPressed: () {
                        setState(() {
                          _sources.remove(source);
                          _updateDefaultDownloadType();
                        });
                      },
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
      builder: (context) => const SmartDownloadSourceEditor(),
    );
    if (source == null || !mounted || _sources.contains(source)) {
      return;
    }

    setState(() {
      _sources.add(source);
      _updateDefaultDownloadType();
    });
  }

  void _updateDefaultDownloadType() {
    if (_downloadTypeManuallySelected) {
      return;
    }

    final hasReading = _sources.any((source) => source.type == MediaSourceType.continueReading);
    final hasOtherSources = _sources.any((source) => source.type != MediaSourceType.continueReading);
    if (hasReading && hasOtherSources) {
      _downloadType = 'both';
    } else if (hasReading) {
      _downloadType = 'ebook';
    } else {
      _downloadType = 'audiobook';
    }
  }

  void _save() {
    final name = _nameController.text.trim();
    final target = int.tryParse(_targetController.text.trim());
    if (name.isEmpty || target == null || target < 1 || target > 150) {
      return;
    }
    final age = int.tryParse(_ageController.text.trim());
    final storageMb = int.tryParse(_storageController.text.trim());
    final deleteAfterHours = int.tryParse(_deleteAfterController.text.trim()) ?? 24;
    if (deleteAfterHours < 0 || (age != null && age < 0) || (storageMb != null && storageMb < 0)) {
      return;
    }
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
