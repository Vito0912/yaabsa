import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/settings/yaabsa_switch_tile.dart';
import 'package:flutter/services.dart';
import 'package:yaabsa/components/common/expressive_expandable_card.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

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
    final l10n = context.l10n;

    return ExpressiveExpandableCard(
      title: l10n.headingBackupConfiguration,
      subtitle: l10n.messageBackupConfiguration,
      icon: Icons.tune_rounded,
      initiallyExpanded: false,
      onExpansionChanged: onConfigurationExpandedChanged,
      children: [
        if (!showEditBackupPath) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  backupLocation.trim().isEmpty ? l10n.statusBackupLocationUnavailable : backupLocation,
                  style: theme.textTheme.bodyMedium,
                  softWrap: true,
                ),
              ),
              IconButton(
                tooltip: canEditBackupPath ? l10n.actionEdit : l10n.statusBackupLocationEnvironmentManaged,
                onPressed: canEditBackupPath ? onTogglePathEditing : null,
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),
        ] else ...[
          StyledTextField(
            label: l10n.fieldBackupLocationPath,
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
                    ? const SizedBox(width: 14, height: 14, child: YaabsaCircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.save_outlined),
                label: Text(l10n.actionSave),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: isSavingBackupPath ? null : onCancelPathEditing,
                child: Text(l10n.actionCancel),
              ),
            ],
          ),
        ],
        const SizedBox(height: 8),
        YaabsaSwitchTile.adaptive(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          title: Text(l10n.settingAutomaticBackupsEnabled),
          value: enableAutomaticBackups,
          onChanged: isUpdatingSettings ? null : onAutomaticBackupsChanged,
        ),
        if (enableAutomaticBackups)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: StyledTextField(
              label: l10n.fieldCronExpression,
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
              label: l10n.fieldBackupsToKeep,
              controller: backupsToKeepController,
              enabled: !isUpdatingSettings,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              errorText: backupsToKeepError,
              hintText: '2',
              onChanged: onBackupsToKeepChanged,
            );
            final maxBackupSizeField = StyledTextField(
              label: l10n.fieldMaximumBackupSize(l10n.byteUnitGigabytes),
              controller: maxBackupSizeController,
              enabled: !isUpdatingSettings,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              errorText: maxBackupSizeError,
              hintText: '1',
              helperText: l10n.messageZeroBackupSizeUnlimited,
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
                ? const SizedBox(width: 14, height: 14, child: YaabsaCircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.save_outlined),
            label: Text(l10n.actionSave),
          ),
        ),
      ],
    );
  }
}
