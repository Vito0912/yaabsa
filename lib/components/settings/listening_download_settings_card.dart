import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/common/inputs/styled_form_fields.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/models/smart_download.dart';
import 'package:yaabsa/provider/library/smart_download_provider.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/util/globals.dart' show downloadHandler;

class ListeningDownloadSettingsCard extends ConsumerWidget {
  const ListeningDownloadSettingsCard({super.key, required this.userId, this.profile, required this.isBusy});

  final String userId;
  final SmartDownloadProfile? profile;
  final bool isBusy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policy = profile?.policy;
    final enabled = profile?.enabled ?? false;
    ref.watch(userSettingsWatcherProvider);
    final wifiOnly = ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<bool>(userId, SettingKeys.downloadOnlyOnWifi, defaultValue: true);

    final continueDownloads = ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<bool>(userId, SettingKeys.downloadContinueListeningAndSeries, defaultValue: false);

    Future<void> saveProfile(SmartDownloadProfile updated) async {
      try {
        if (updated.enabled) {
          await downloadHandler.prepareAutomaticDownloads();
        }
        if (!context.mounted) {
          return;
        }

        await ref.read(smartDownloadManagerProvider.notifier).saveProfile(updated);
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not save download rule: $error')));
        }
      }
    }

    Future<void> configure() async {
      final result = await showDialog<SmartDownloadProfile>(
        context: context,
        builder: (context) => _ListeningDownloadEditor(userId: userId, initial: profile),
      );
      if (result != null && context.mounted) {
        await saveProfile(result);
      }
    }

    return Card(
      margin: const EdgeInsets.fromLTRB(8, 12, 8, 0),
      child: Column(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.headphones_rounded),
            title: const Text('Download after listening'),
            subtitle: const Text('Keep books offline once you get into them.'),
            value: enabled,
            onChanged: isBusy
                ? null
                : (value) async {
                    final current = profile;
                    if (current == null) {
                      await configure();
                      return;
                    }

                    await saveProfile(current.copyWith(enabled: value));
                  },
          ),
          if (enabled && continueDownloads)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                'Continue Listening downloads are also enabled and can download books before this threshold.',
              ),
            ),
          if (policy != null)
            ListTile(
              title: Text(_triggerSummary(policy)),
              subtitle: Text(
                'Up to ${(policy.maxStorageBytes ?? 0) ~/ (1024 * 1024)} MB · Keep finished books for ${policy.deleteAfterHours} hours',
              ),
              trailing: const Icon(Icons.tune_rounded),
              onTap: isBusy ? null : configure,
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                wifiOnly
                    ? 'Uses Wi-Fi only. Applies to individual audiobooks played on this device.'
                    : 'Mobile data is allowed in Download settings. A complete audiobook can use substantial data.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _triggerSummary(SmartDownloadPolicy policy) {
  final value = policy.listeningThreshold;
  return switch (policy.listeningTrigger) {
    ListeningDownloadTrigger.minutes => 'After $value minutes of listening',
    ListeningDownloadTrigger.progress => 'At $value% book progress',
    null => 'Choose when to download',
  };
}

class _ListeningDownloadEditor extends StatefulWidget {
  const _ListeningDownloadEditor({required this.userId, this.initial});

  final String userId;
  final SmartDownloadProfile? initial;

  @override
  State<_ListeningDownloadEditor> createState() => _ListeningDownloadEditorState();
}

class _ListeningDownloadEditorState extends State<_ListeningDownloadEditor> {
  final _formKey = GlobalKey<FormState>();
  late ListeningDownloadTrigger _trigger;
  late final TextEditingController _threshold;
  late final TextEditingController _storage;
  late final TextEditingController _retention;

  @override
  void initState() {
    super.initState();
    final policy = widget.initial?.policy;
    _trigger = policy?.listeningTrigger ?? ListeningDownloadTrigger.minutes;
    _threshold = TextEditingController(text: '${policy?.listeningThreshold ?? 30}');
    _storage = TextEditingController(text: '${(policy?.maxStorageBytes ?? 2048 * 1024 * 1024) ~/ (1024 * 1024)}');
    _retention = TextEditingController(text: '${policy?.deleteAfterHours ?? 24}');
  }

  @override
  void dispose() {
    _threshold.dispose();
    _storage.dispose();
    _retention.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unit = switch (_trigger) {
      ListeningDownloadTrigger.minutes => 'Minutes listened',
      ListeningDownloadTrigger.progress => 'Book progress (%)',
    };
    final explanation = switch (_trigger) {
      ListeningDownloadTrigger.minutes =>
        'Counts playback on this device while enabled, excluding pauses, buffering and seeks.',
      ListeningDownloadTrigger.progress => 'Uses your position in the book. Seeking forward also counts.',
    };

    return AlertDialog(
      title: const Text('Download after listening'),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                YaabsaDropdownField<ListeningDownloadTrigger>(
                  label: 'Download when',
                  value: _trigger,
                  items: const [
                    DropdownMenuItem(value: ListeningDownloadTrigger.minutes, child: Text('Listening time')),
                    DropdownMenuItem(value: ListeningDownloadTrigger.progress, child: Text('Book progress')),
                  ],
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    setState(() {
                      _trigger = value;
                      _threshold.text = switch (value) {
                        ListeningDownloadTrigger.minutes => '30',
                        ListeningDownloadTrigger.progress => '10',
                      };
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _threshold,
                  decoration: InputDecoration(labelText: unit),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      _validateNumber(value, max: _trigger == ListeningDownloadTrigger.progress ? 99 : 10000),
                ),
                const SizedBox(height: 8),
                Text(explanation, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _storage,
                  decoration: const InputDecoration(labelText: 'Storage budget (MB)'),
                  keyboardType: TextInputType.number,
                  validator: (value) => _validateNumber(value),
                ),
                const SizedBox(height: 8),
                const Text('Books wait if they would exceed this rule’s budget.'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _retention,
                  decoration: const InputDecoration(labelText: 'Keep finished books for hours'),
                  keyboardType: TextInputType.number,
                  validator: (value) => _validateNumber(value, min: 0),
                ),
                const SizedBox(height: 16),
                const Text('Downloads the complete audiobook using your download location and Wi-Fi preference.'),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton(onPressed: _save, child: Text(widget.initial == null ? 'Enable' : 'Save')),
      ],
    );
  }

  String? _validateNumber(String? value, {int min = 1, int max = 1000000}) {
    final number = int.tryParse(value?.trim() ?? '');
    if (number == null || number < min || number > max) {
      return 'Enter a whole number from $min to $max';
    }
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      SmartDownloadProfile(
        id: widget.initial?.id ?? 'listening_threshold_${widget.userId}',
        userId: widget.userId,
        name: 'Download after listening',
        enabled: widget.initial?.enabled ?? true,
        policy: SmartDownloadPolicy(
          listeningTrigger: _trigger,
          listeningThreshold: int.parse(_threshold.text.trim()),
          maxStorageBytes: int.parse(_storage.text.trim()) * 1024 * 1024,
          deleteAfterHours: int.parse(_retention.text.trim()),
          downloadType: 'audiobook',
        ),
      ),
    );
  }
}
