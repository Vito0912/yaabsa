import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaabsa/components/common/expressive_expandable_card.dart';
import 'package:yaabsa/components/common/inputs/styled_form_fields.dart';

class AdminBackupSettingsPanel extends StatelessWidget {
  const AdminBackupSettingsPanel({
    super.key,
    required this.backupLocation,
    required this.backupPathEnvSet,
    required this.showEditBackupPath,
    required this.isSavingBackupPath,
    required this.isUpdatingSettings,
    required this.enableAutomaticBackups,
    required this.backupPathController,
    required this.cronExpressionController,
    required this.backupsToKeepController,
    required this.maxBackupSizeController,
    required this.backupPathError,
    required this.cronExpressionError,
    required this.backupsToKeepError,
    required this.maxBackupSizeError,
    required this.onTogglePathEditing,
    required this.onCancelPathEditing,
    required this.onSaveBackupPath,
    required this.onConfigurationExpandedChanged,
    required this.onAutomaticBackupsChanged,
    required this.onSaveBackupSettings,
    required this.onBackupPathChanged,
    required this.onCronChanged,
    required this.onBackupsToKeepChanged,
    required this.onMaxBackupSizeChanged,
  });

  final String backupLocation;
  final bool backupPathEnvSet;
  final bool showEditBackupPath;
  final bool isSavingBackupPath;
  final bool isUpdatingSettings;
  final bool enableAutomaticBackups;

  final TextEditingController backupPathController;
  final TextEditingController cronExpressionController;
  final TextEditingController backupsToKeepController;
  final TextEditingController maxBackupSizeController;

  final String? backupPathError;
  final String? cronExpressionError;
  final String? backupsToKeepError;
  final String? maxBackupSizeError;

  final VoidCallback onTogglePathEditing;
  final VoidCallback onCancelPathEditing;
  final VoidCallback onSaveBackupPath;
  final ValueChanged<bool> onConfigurationExpandedChanged;
  final ValueChanged<bool> onAutomaticBackupsChanged;
  final VoidCallback onSaveBackupSettings;
  final ValueChanged<String> onBackupPathChanged;
  final ValueChanged<String> onCronChanged;
  final ValueChanged<String> onBackupsToKeepChanged;
  final ValueChanged<String> onMaxBackupSizeChanged;

  @override
  Widget build(BuildContext context) {
    final canEditBackupPath = !backupPathEnvSet;
    final theme = Theme.of(context);

    return ExpressiveExpandableCard(
      title: 'Backup Configuration',
      subtitle: 'Storage path, schedule, and retention',
      icon: Icons.tune_rounded,
      initiallyExpanded: false,
      onExpansionChanged: onConfigurationExpandedChanged,
      children: [
        if (!showEditBackupPath) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  backupLocation.trim().isEmpty ? 'Backup location unavailable.' : backupLocation,
                  style: theme.textTheme.bodyMedium,
                  softWrap: true,
                ),
              ),
              IconButton(
                tooltip: canEditBackupPath ? 'Edit backup location' : 'Backup location locked',
                onPressed: canEditBackupPath ? onTogglePathEditing : null,
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
        ] else ...[
          StyledTextField(
            label: 'Backup location path',
            controller: backupPathController,
            enabled: canEditBackupPath && !isSavingBackupPath,
            hintText: '/metadata/backups',
            errorText: backupPathError,
            onChanged: onBackupPathChanged,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              FilledButton.icon(
                onPressed: canEditBackupPath && !isSavingBackupPath ? onSaveBackupPath : null,
                icon: isSavingBackupPath
                    ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.save_outlined),
                label: const Text('Save Path'),
              ),
              const SizedBox(width: 8),
              OutlinedButton(onPressed: isSavingBackupPath ? null : onCancelPathEditing, child: const Text('Cancel')),
            ],
          ),
        ],
        const SizedBox(height: 8),
        SwitchListTile.adaptive(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          title: const Text('Enable automatic backups'),
          value: enableAutomaticBackups,
          onChanged: isUpdatingSettings ? null : onAutomaticBackupsChanged,
        ),
        if (enableAutomaticBackups)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: StyledTextField(
              label: 'Cron expression',
              controller: cronExpressionController,
              enabled: !isUpdatingSettings,
              hintText: '30 1 * * *',
              errorText: cronExpressionError,
              onChanged: onCronChanged,
            ),
          ),
        LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 520;
            final backupsToKeepField = StyledTextField(
              label: 'Backups to keep',
              controller: backupsToKeepController,
              enabled: !isUpdatingSettings,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              errorText: backupsToKeepError,
              hintText: '2',
              onChanged: onBackupsToKeepChanged,
            );
            final maxBackupSizeField = StyledTextField(
              label: 'Max backup size (GB)',
              controller: maxBackupSizeController,
              enabled: !isUpdatingSettings,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              errorText: maxBackupSizeError,
              hintText: '1',
              helperText: 'Use 0 for unlimited size.',
              onChanged: onMaxBackupSizeChanged,
            );

            if (stacked) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [backupsToKeepField, const SizedBox(height: 6), maxBackupSizeField],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: backupsToKeepField),
                const SizedBox(width: 8),
                Expanded(child: maxBackupSizeField),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: isUpdatingSettings ? null : onSaveBackupSettings,
            icon: isUpdatingSettings
                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.save_outlined),
            label: const Text('Save Backup Settings'),
          ),
        ),
      ],
    );
  }
}
