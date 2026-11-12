import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/settings_backup.dart';

class SettingsBackupSettings extends ConsumerStatefulWidget {
  const SettingsBackupSettings({super.key});

  static const routeName = '/settings/backup';

  @override
  ConsumerState<SettingsBackupSettings> createState() => _SettingsBackupSettingsState();
}

class _SettingsBackupSettingsState extends ConsumerState<SettingsBackupSettings> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() operation) async {
    if (_busy) {
      return;
    }

    setState(() {
      _busy = true;
    });

    try {
      await operation();
    } on FormatException catch (error) {
      _showMessage(error.message);
    } catch (_) {
      _showMessage('Could not transfer settings. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _export() async {
    final backup = await ref.read(settingsManagerProvider.notifier).exportSettings();
    final date = DateTime.now().toIso8601String().substring(0, 10);
    final destination = await FilePicker.saveFile(
      dialogTitle: 'Export settings',
      fileName: 'yaabsa_settings_$date.json',
      bytes: Uint8List.fromList(utf8.encode(backup)),
    );

    if (destination != null) {
      _showMessage('Settings exported');
    }
  }

  Future<void> _import() async {
    final file = await FilePicker.pickFile(
      dialogTitle: 'Import settings',
      type: FileType.custom,
      allowedExtensions: const ['json'],
    );
    if (file == null) {
      return;
    }

    final fileLength = await file.length();
    if (fileLength != null && fileLength > SettingsBackup.maxBytes) {
      throw const FormatException('The settings backup is too large.');
    }

    final backup = SettingsBackup.decode(utf8.decode(await file.readAsBytes()));
    if (!mounted) {
      return;
    }

    final matchingUsers = await ref.read(settingsManagerProvider.notifier).matchingBackupUsers(backup.users);
    final userCount = matchingUsers.values.fold<int>(0, (count, settings) => count + settings.length);
    final skippedAccounts = backup.users.length - matchingUsers.length;
    final skippedAccountsLabel = skippedAccounts == 1 ? 'account' : 'accounts';
    if (!mounted) {
      return;
    }
    if (backup.global.isEmpty && userCount == 0) {
      _showMessage('No settings to import for saved accounts with matching user IDs');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.settings_backup_restore_rounded),
          title: const Text('Import settings?'),
          content: Text(
            '${backup.global.length} app settings and $userCount account settings will be restored.'
            '\n\nAccount settings are restored only for saved accounts with matching user IDs.'
            '${skippedAccounts > 0 ? '\n\n$skippedAccounts unmatched $skippedAccountsLabel will be skipped.' : ''}'
            '\n\nMatching settings will be replaced. Other settings will be kept.'
            '\n\nRestart the app after importing to apply all changes.',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Import')),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) {
      return;
    }

    await ref.read(settingsManagerProvider.notifier).importSettings(global: backup.global, users: backup.users);
    _showMessage('Settings imported. Restart the app to apply all changes.');
  }

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: 'Settings backup',
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        SettingsNavigationSection(
          title: 'Transfer settings',
          topPadding: 0,
          items: [
            SettingsNavigationItem(
              icon: Icons.file_upload_outlined,
              title: 'Export settings',
              enabled: !_busy,
              onTap: () => _run(_export),
            ),
            SettingsNavigationItem(
              icon: Icons.file_download_outlined,
              title: 'Import settings',
              enabled: !_busy,
              onTap: () => _run(_import),
            ),
          ],
        ),
        if (_busy)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
