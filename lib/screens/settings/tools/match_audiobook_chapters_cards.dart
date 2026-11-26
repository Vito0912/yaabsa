import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/cards/surface_card.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/inputs/expressive_dropdown.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/ui/components/settings/yaabsa_switch_tile.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/match_audiobook_chapters_tool.dart';

const List<YaabsaDropdownOption<String>> audibleMetadataProviderOptions = [
  YaabsaDropdownOption(value: 'audible.com', label: 'Audible.com'),
  YaabsaDropdownOption(value: 'audible.ca', label: 'Audible.ca'),
  YaabsaDropdownOption(value: 'audible.co.uk', label: 'Audible.co.uk'),
  YaabsaDropdownOption(value: 'audible.com.au', label: 'Audible.com.au'),
  YaabsaDropdownOption(value: 'audible.fr', label: 'Audible.fr'),
  YaabsaDropdownOption(value: 'audible.de', label: 'Audible.de'),
  YaabsaDropdownOption(value: 'audible.co.jp', label: 'Audible.co.jp'),
  YaabsaDropdownOption(value: 'audible.it', label: 'Audible.it'),
  YaabsaDropdownOption(value: 'audible.in', label: 'Audible.in'),
  YaabsaDropdownOption(value: 'audible.es', label: 'Audible.es'),
];

const List<String> audibleChapterRegions = ['US', 'CA', 'UK', 'AU', 'FR', 'DE', 'JP', 'IT', 'IN', 'ES'];

class MatchAudiobookChaptersOptionsCard extends StatelessWidget {
  const MatchAudiobookChaptersOptionsCard({
    super.key,
    required this.thresholdController,
    required this.thresholdError,
    required this.provider,
    required this.region,
    required this.searchForAsin,
    required this.useTracksAsChapters,
    required this.disableRateProtection,
    required this.isRunning,
    required this.onThresholdChanged,
    required this.onProviderChanged,
    required this.onRegionChanged,
    required this.onSearchForAsinChanged,
    required this.onUseTracksAsChaptersChanged,
    required this.onDisableRateProtectionChanged,
  });

  final TextEditingController thresholdController;
  final String? thresholdError;
  final String provider;
  final String region;
  final bool searchForAsin;
  final bool useTracksAsChapters;
  final bool disableRateProtection;
  final bool isRunning;
  final ValueChanged<String> onThresholdChanged;
  final ValueChanged<String?> onProviderChanged;
  final ValueChanged<String?> onRegionChanged;
  final ValueChanged<bool> onSearchForAsinChanged;
  final ValueChanged<bool> onUseTracksAsChaptersChanged;
  final ValueChanged<bool> onDisableRateProtectionChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return YaabsaSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StyledTextField(
            controller: thresholdController,
            enabled: !isRunning,
            label: l10n.fieldChapterThreshold,
            helperText: l10n.descriptionChapterThreshold,
            errorText: thresholdError,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: onThresholdChanged,
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final providerField = YaabsaExpressiveDropdownField<String>(
                value: provider,
                enabled: !isRunning,
                options: audibleMetadataProviderOptions,
                decoration: yaabsaFieldDecoration(context, label: l10n.fieldMetadataProvider),
                onChanged: isRunning ? null : onProviderChanged,
              );
              final regionField = YaabsaExpressiveDropdownField<String>(
                value: region,
                enabled: !isRunning,
                options: [for (final item in audibleChapterRegions) YaabsaDropdownOption(value: item, label: item)],
                decoration: yaabsaFieldDecoration(context, label: l10n.fieldRegion),
                onChanged: isRunning ? null : onRegionChanged,
              );

              if (constraints.maxWidth < 460) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [providerField, const SizedBox(height: 12), regionField],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: providerField),
                  const SizedBox(width: 12),
                  Expanded(child: regionField),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          YaabsaSwitchTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: searchForAsin,
            onChanged: isRunning ? null : onSearchForAsinChanged,
            title: Text(l10n.optionSearchForAsin),
            subtitle: Text(l10n.optionSearchForAsinDescription),
          ),
          YaabsaSwitchTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: useTracksAsChapters,
            onChanged: isRunning ? null : onUseTracksAsChaptersChanged,
            title: Text(l10n.optionUseTracksAsChapters),
            subtitle: Text(l10n.optionUseTracksAsChaptersDescription),
          ),
          YaabsaSwitchTile.adaptive(
            contentPadding: EdgeInsets.zero,
            value: disableRateProtection,
            onChanged: isRunning ? null : onDisableRateProtectionChanged,
            title: Text(l10n.optionDisableRateProtection),
            subtitle: Text(l10n.optionDisableRateProtectionDescription),
          ),
        ],
      ),
    );
  }
}

class MatchAudiobookChaptersProgressCard extends StatelessWidget {
  const MatchAudiobookChaptersProgressCard({
    super.key,
    required this.isRunning,
    required this.processed,
    required this.total,
    required this.result,
    required this.logs,
    required this.logScrollController,
  });

  final bool isRunning;
  final int processed;
  final int total;
  final MatchAudiobookChaptersToolResult? result;
  final List<String> logs;
  final ScrollController logScrollController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final currentResult = result;
    final progressValue = total > 0 ? (processed / total).clamp(0.0, 1.0) : null;

    String? summaryText;
    if (currentResult != null) {
      if (currentResult.cancelled) {
        summaryText = l10n.statusMatchChaptersCancelled(
          currentResult.results.length,
          currentResult.updatedBooks,
          currentResult.skippedBooks,
          currentResult.failedBooks,
        );
      } else {
        summaryText = l10n.statusMatchChaptersSummary(
          currentResult.updatedBooks,
          currentResult.skippedBooks,
          currentResult.failedBooks,
          currentResult.totalBooks,
        );
      }
    }

    return YaabsaSurfaceCard(
      color: colors.surfaceContainerLow,
      borderColor: colors.outlineVariant.withValues(alpha: 0.6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isRunning) ...[
            Text(
              total > 0 ? l10n.statusMatchingChaptersProgress(processed, total) : l10n.statusRunning,
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            YaabsaLinearProgressIndicator(value: progressValue, minHeight: 6),
          ],
          if (summaryText != null) ...[
            if (isRunning) const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  currentResult!.cancelled ? Icons.stop_circle_outlined : Icons.check_circle_outline_rounded,
                  color: currentResult.cancelled ? colors.tertiary : colors.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(summaryText, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
          if (logs.isNotEmpty) ...[
            const SizedBox(height: 12),
            YaabsaSurfaceCard(
              padding: const EdgeInsets.all(12),
              borderRadius: 12,
              color: colors.surface,
              borderColor: colors.outlineVariant.withValues(alpha: 0.45),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 260),
                child: ListView.separated(
                  controller: logScrollController,
                  shrinkWrap: true,
                  itemCount: logs.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    return SelectableText(
                      logs[index],
                      style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
