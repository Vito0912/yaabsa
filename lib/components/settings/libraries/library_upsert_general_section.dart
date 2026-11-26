import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/search/search_provider_option.dart';
import 'package:yaabsa/components/settings/libraries/library_folder_list_editor.dart';
import 'package:yaabsa/components/settings/libraries/library_upsert_form_controller.dart';
import 'package:yaabsa/components/settings/libraries/library_upsert_form_helpers.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/inputs/expressive_dropdown.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/ui/components/settings/yaabsa_switch_tile.dart';
import 'package:yaabsa/util/l10n.dart';

class LibraryUpsertGeneralSection extends StatelessWidget {
  const LibraryUpsertGeneralSection({
    super.key,
    required this.controller,
    required this.providerOptionsAsync,
    required this.onBrowseFolderPressed,
  });

  final LibraryUpsertFormController controller;
  final AsyncValue<List<SearchProviderOption>> providerOptionsAsync;
  final Future<void> Function() onBrowseFolderPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final providerOptions = buildLibraryProviderOptions(
      rawOptions: providerOptionsAsync.value ?? const <SearchProviderOption>[],
      mediaType: controller.selectedMediaType,
      selectedProvider: controller.selectedProvider,
    );
    final iconOptions = resolveLibraryIconOptions(controller.selectedIconName);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          YaabsaExpressiveDropdownField<String>(
            value: controller.selectedMediaType,
            options: buildLibraryMediaTypeOptions(l10n),
            onChanged: controller.isCreate ? (value) => controller.onMediaTypeChanged(value, l10n) : null,
            decoration: yaabsaFieldDecoration(
              context,
              label: l10n.fieldMediaType,
              hintText: controller.isCreate ? null : l10n.hintMediaTypeCannotBeChanged,
            ),
          ),
          const SizedBox(height: 10),
          StyledTextField(
            label: l10n.fieldLibrary,
            controller: controller.nameController,
            hintText: l10n.hintLibraryNameExample,
            errorText: controller.nameError,
            onChanged: (_) => controller.onNameChanged(l10n),
          ),
          const SizedBox(height: 10),
          if (providerOptionsAsync.isLoading && providerOptionsAsync.value == null)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: YaabsaLinearProgressIndicator(minHeight: 2),
            ),
          YaabsaExpressiveDropdownField<String>(
            value: controller.selectedProvider,
            options: providerOptions,
            onChanged: controller.onProviderChanged,
            decoration: yaabsaFieldDecoration(
              context,
              label: l10n.fieldMetadataProvider,
              hintText: l10n.hintSelectMetadataProvider,
            ),
          ),
          const SizedBox(height: 10),
          YaabsaExpressiveDropdownField<String>(
            value: controller.selectedIconName,
            options: iconOptions,
            onChanged: controller.onIconChanged,
            decoration: yaabsaFieldDecoration(
              context,
              label: l10n.fieldLibraryIcon,
              hintText: l10n.hintSelectLibraryIcon,
            ),
          ),
          const SizedBox(height: 12),
          LibraryFolderListEditor(
            folders: controller.folders,
            newFolderPathController: controller.newFolderPathController,
            onAddFolderPressed: () => controller.addFolderPath(controller.newFolderPathController.text, l10n),
            onRemoveFolderPressed: (folder) => controller.removeFolder(folder, l10n),
            onBrowseFolderPressed: onBrowseFolderPressed,
            isBrowsing: controller.isBrowsingFolders,
            errorText: controller.foldersError,
          ),
          const SizedBox(height: 12),
          Text(l10n.headingLibraryBehavior, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          YaabsaSwitchTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.settingUseSquareBookCovers),
            value: controller.useSquareBookCovers,
            onChanged: controller.setUseSquareBookCovers,
          ),
          if (controller.selectedMediaType == 'book') ...[
            YaabsaSwitchTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.settingAudiobooksOnly),
              value: controller.audiobooksOnly,
              onChanged: controller.setAudiobooksOnly,
            ),
            YaabsaSwitchTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.settingHideSingleBookSeries),
              value: controller.hideSingleBookSeries,
              onChanged: controller.setHideSingleBookSeries,
            ),
            YaabsaSwitchTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.settingOnlyShowLaterBooksInContinueSeries),
              value: controller.showLaterBooks,
              onChanged: controller.setShowLaterBooks,
            ),
            YaabsaSwitchTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.settingAllowScriptedEbookContent),
              value: controller.epubScriptedContent,
              onChanged: controller.setEpubScriptedContent,
            ),
            const SizedBox(height: 8),
            Text(l10n.headingMarkAsFinishedThreshold, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: YaabsaExpressiveDropdownField<String>(
                    value: controller.markAsFinishedMode,
                    options: [
                      YaabsaDropdownOption<String>(value: 'timeRemaining', label: l10n.optionTimeRemainingSeconds),
                      YaabsaDropdownOption<String>(value: 'percentComplete', label: l10n.optionPercentComplete),
                    ],
                    onChanged: (value) => controller.onMarkAsFinishedModeChanged(value, l10n),
                    decoration: yaabsaFieldDecoration(context, label: l10n.fieldMode),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 140,
                  child: StyledTextField(
                    label: controller.markAsFinishedMode == 'percentComplete' ? l10n.fieldPercent : l10n.fieldSeconds,
                    controller: controller.markAsFinishedValueController,
                    keyboardType: controller.markAsFinishedMode == 'percentComplete'
                        ? const TextInputType.numberWithOptions(decimal: true)
                        : TextInputType.number,
                    errorText: controller.markAsFinishedError,
                    onChanged: (_) => controller.onMarkAsFinishedValueChanged(l10n),
                  ),
                ),
              ],
            ),
          ],
          if (controller.selectedMediaType == 'podcast') ...[
            const SizedBox(height: 8),
            YaabsaExpressiveDropdownField<String>(
              value: controller.selectedPodcastRegion,
              options: buildPodcastRegionOptions(l10n),
              onChanged: controller.onPodcastRegionChanged,
              decoration: yaabsaFieldDecoration(context, label: l10n.fieldPodcastSearchRegion),
            ),
          ],
        ],
      ),
    );
  }
}
