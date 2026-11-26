import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/libraries/library_metadata_precedence_editor.dart';
import 'package:yaabsa/components/settings/libraries/library_upsert_form_controller.dart';
import 'package:yaabsa/components/settings/libraries/library_upsert_form_helpers.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/ui/components/settings/yaabsa_switch_tile.dart';
import 'package:yaabsa/util/l10n.dart';

class LibraryUpsertScannerSection extends StatelessWidget {
  const LibraryUpsertScannerSection({super.key, required this.controller});

  final LibraryUpsertFormController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (controller.selectedMediaType != 'book') {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            l10n.messageScannerSettingsBookLibrariesOnly,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
      );
    }

    final localizedSources = localizeLibraryMetadataSources(controller.metadataSources, l10n);
    final controls = <Widget>[
      YaabsaSwitchTile.adaptive(
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.settingEnableFolderWatcher),
        subtitle: Text(l10n.settingEnableFolderWatcherDescription),
        value: controller.enableWatcher,
        onChanged: controller.setEnableWatcher,
      ),
      YaabsaSwitchTile.adaptive(
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.settingSkipMatchingBooksWithAsin),
        value: controller.skipMatchingMediaWithAsin,
        onChanged: controller.setSkipMatchingMediaWithAsin,
      ),
      YaabsaSwitchTile.adaptive(
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.settingSkipMatchingBooksWithIsbn),
        value: controller.skipMatchingMediaWithIsbn,
        onChanged: controller.setSkipMatchingMediaWithIsbn,
      ),
      const SizedBox(height: 8),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxHeight < 460) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...controls,
                  SizedBox(
                    height: 280,
                    child: LibraryMetadataPrecedenceEditor(
                      sources: localizedSources,
                      onReorderItem: controller.reorderMetadataSource,
                      onToggleSource: controller.toggleMetadataSource,
                      onResetToDefault: controller.resetMetadataSources,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...controls,
              Expanded(
                child: LibraryMetadataPrecedenceEditor(
                  sources: localizedSources,
                  onReorderItem: controller.reorderMetadataSource,
                  onToggleSource: controller.toggleMetadataSource,
                  onResetToDefault: controller.resetMetadataSources,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class LibraryUpsertScheduleSection extends StatelessWidget {
  const LibraryUpsertScheduleSection({super.key, required this.controller});

  final LibraryUpsertFormController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          YaabsaSwitchTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.settingEnableScheduledScans),
            subtitle: Text(l10n.settingScheduledScansDescription('0 0 * * 1')),
            value: controller.scheduleEnabled,
            onChanged: (value) => controller.setScheduleEnabled(value, l10n),
          ),
          const SizedBox(height: 8),
          StyledTextField(
            label: l10n.fieldCronExpression,
            controller: controller.autoScanCronController,
            hintText: '0 0 * * 1',
            enabled: controller.scheduleEnabled,
            errorText: controller.scheduleError,
            onChanged: (_) => controller.onCronChanged(l10n),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.hintDisableSchedulingToClearCron,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
