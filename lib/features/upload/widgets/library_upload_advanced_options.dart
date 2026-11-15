import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/common/expressive_expandable_card.dart';
import 'package:yaabsa/features/upload/widgets/library_upload_bulk_field.dart';
import 'package:yaabsa/ui/components/cards/surface_card.dart';
import 'package:yaabsa/ui/components/settings/settings_switch_presentation.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

class LibraryUploadAdvancedOptions extends StatelessWidget {
  const LibraryUploadAdvancedOptions({
    super.key,
    required this.autoFetchMetadata,
    required this.autoAcceptMetadata,
    required this.autocompleteSeriesAndAuthors,
    required this.enabled,
    required this.canEditAutocomplete,
    required this.isAdminUser,
    required this.isLoadingAutocompleteSuggestions,
    required this.canApplyBulk,
    required this.bulkAuthorController,
    required this.bulkSeriesController,
    required this.onAutoFetchMetadataChanged,
    required this.onAutoAcceptMetadataChanged,
    required this.onAutocompleteChanged,
    required this.onApplyAuthor,
    required this.onApplySeries,
    this.initiallyExpanded = false,
  });

  final bool autoFetchMetadata;
  final bool autoAcceptMetadata;
  final bool autocompleteSeriesAndAuthors;
  final bool enabled;
  final bool canEditAutocomplete;
  final bool isAdminUser;
  final bool isLoadingAutocompleteSuggestions;
  final bool canApplyBulk;
  final TextEditingController bulkAuthorController;
  final TextEditingController bulkSeriesController;
  final ValueChanged<bool> onAutoFetchMetadataChanged;
  final ValueChanged<bool> onAutoAcceptMetadataChanged;
  final ValueChanged<bool> onAutocompleteChanged;
  final VoidCallback? onApplyAuthor;
  final VoidCallback? onApplySeries;
  final bool initiallyExpanded;

  static const _settingsCardWidth = 360.0;
  static const _cardSpacing = 10.0;
  static const _bulkCardHorizontalPadding = 32.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final inlineFieldWidth = LibraryUploadBulkField.minimumInlineWidthForTextScale(textScale);
    final minimumSideBySideWidth = _settingsCardWidth + _cardSpacing + _bulkCardHorizontalPadding + inlineFieldWidth;

    final settingsCard = YaabsaSurfaceCard(
      borderColor: colorScheme.outlineVariant.withValues(alpha: 0.55),
      child: _buildSettingsContent(context, colorScheme),
    );
    final bulkCard = YaabsaSurfaceCard(
      borderColor: colorScheme.outlineVariant.withValues(alpha: 0.55),
      child: _buildBulkContent(context),
    );

    return ExpressiveExpandableCard(
      title: 'Advanced options',
      icon: Icons.tune_rounded,
      margin: EdgeInsets.zero,
      initiallyExpanded: initiallyExpanded,
      childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            if (!constraints.maxWidth.isFinite || constraints.maxWidth < minimumSideBySideWidth) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  settingsCard,
                  const SizedBox(height: _cardSpacing),
                  bulkCard,
                ],
              );
            }

            return Row(
              key: const ValueKey<String>('uploadAdvancedOptionsSideBySide'),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: _settingsCardWidth, child: settingsCard),
                const SizedBox(width: _cardSpacing),
                Expanded(child: bulkCard),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildSettingsContent(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Settings', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        SettingsSwitchPresentation(
          label: 'Auto-fetch metadata',
          value: autoFetchMetadata,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          enabled: enabled,
          onChanged: onAutoFetchMetadataChanged,
        ),
        SettingsSwitchPresentation(
          label: 'Auto-accept metadata',
          value: autoAcceptMetadata,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          enabled: enabled,
          onChanged: onAutoAcceptMetadataChanged,
        ),
        SettingsSwitchPresentation(
          label: 'Autocomplete series and authors',
          value: autocompleteSeriesAndAuthors,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          enabled: canEditAutocomplete,
          onChanged: onAutocompleteChanged,
        ),
        if (!isAdminUser) ...[
          const SizedBox(height: 6),
          Text(
            'Requires admin role.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
        if (autocompleteSeriesAndAuthors && isLoadingAutocompleteSuggestions) ...[
          const SizedBox(height: 8),
          const YaabsaLinearProgressIndicator(minHeight: 2),
        ],
      ],
    );
  }

  Widget _buildBulkContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bulk update queue metadata',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        LibraryUploadBulkField(
          label: 'Author for all items',
          applyLabel: 'Apply author',
          controller: bulkAuthorController,
          enabled: enabled,
          onApply: canApplyBulk ? onApplyAuthor : null,
        ),
        const SizedBox(height: 10),
        LibraryUploadBulkField(
          label: 'Series for all items',
          applyLabel: 'Apply series',
          controller: bulkSeriesController,
          enabled: enabled,
          onApply: canApplyBulk ? onApplySeries : null,
        ),
      ],
    );
  }
}
