import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/settings_backup.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

class SettingsBackupSettings extends ConsumerStatefulWidget {
  const SettingsBackupSettings({super.key});

  static const routeName = '/settings/backup';

  @override
  ConsumerState<SettingsBackupSettings> createState() => _SettingsBackupSettingsState();
}

class _SettingsBackupSettingsState extends ConsumerState<SettingsBackupSettings> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() operation) async {
    final l10n = context.l10n;

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
      _showMessage(l10n.errorOperationFailed(l10n.operationTransferSettings, l10n.errorUnknown));
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
    final l10n = context.l10n;
    final backup = await ref.read(settingsManagerProvider.notifier).exportSettings();
    final date = DateTime.now().toIso8601String().substring(0, 10);
    final destination = await FilePicker.saveFile(
      dialogTitle: l10n.actionExport,
      fileName: 'yaabsa_settings_$date.json',
      bytes: Uint8List.fromList(utf8.encode(backup)),
    );

    if (destination != null) {
      _showMessage(l10n.statusSettingsExported);
    }
  }

  Future<void> _import() async {
    final l10n = context.l10n;
    final file = await FilePicker.pickFile(
      dialogTitle: l10n.actionImport,
      type: FileType.custom,
      allowedExtensions: const ['json'],
    );
    if (file == null) {
      return;
    }

    final fileLength = await file.length();
    if (fileLength != null && fileLength > SettingsBackup.maxBytes) {
      throw FormatException(l10n.errorSettingsBackupTooLarge);
    }

    final backup = SettingsBackup.decode(utf8.decode(await file.readAsBytes()));
    if (!mounted) {
      return;
    }

    final matchingUsers = await ref.read(settingsManagerProvider.notifier).matchingBackupUsers(backup.users);
    final userCount = matchingUsers.values.fold<int>(0, (count, settings) => count + settings.length);
    final skippedAccounts = backup.users.length - matchingUsers.length;
    if (!mounted) {
      return;
    }
    if (backup.global.isEmpty && userCount == 0) {
      _showMessage(l10n.statusNoMatchingSettingsToImport);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.settings_backup_restore_rounded),
          title: Text(context.l10n.settingsBackupImportPrompt),
          content: Text(context.l10n.settingsImportConfirmation(backup.global.length, userCount, skippedAccounts)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text(context.l10n.actionCancel)),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(context.l10n.actionImport)),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) {
      return;
    }

    await ref.read(settingsManagerProvider.notifier).importSettings(global: backup.global, users: backup.users);
    if (!mounted) {
      return;
    }

    _showMessage(l10n.statusSettingsImportedRestart);
  }

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: context.l10n.settingsBackupTitle,
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        SettingsNavigationSection(
          title: context.l10n.headingTransferSettings,
          topPadding: 0,
          items: [
            SettingsNavigationItem(
              icon: Icons.file_upload_outlined,
              title: context.l10n.actionExport,
              enabled: !_busy,
              onTap: () => _run(_export),
            ),
            SettingsNavigationItem(
              icon: Icons.file_download_outlined,
              title: context.l10n.actionImport,
              enabled: !_busy,
              onTap: () => _run(_import),
            ),
          ],
        ),
        if (_busy)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: YaabsaCircularProgressIndicator()),
          ),
      ],
    );
  }
}
