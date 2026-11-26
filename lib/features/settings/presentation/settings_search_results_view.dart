import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/features/settings/model/settings_availability.dart';
import 'package:yaabsa/features/settings/search/settings_search_engine.dart';
import 'package:yaabsa/features/settings/widgets/settings_scope_badge.dart';
import 'package:yaabsa/util/l10n.dart';

class SettingsSearchResultsView extends ConsumerWidget {
  const SettingsSearchResultsView({
    super.key,
    required this.query,
    required this.results,
    required this.onResultSelected,
    this.compact = false,
  });

  final String query;
  final List<SettingsSearchResult> results;
  final ValueChanged<SettingsSearchResult> onResultSelected;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded, size: 48, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
              const SizedBox(height: 12),
              Text(
                l10n.searchNoResultsFor(query.trim()),
                style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SettingsNavigationSection(
      title: l10n.searchResults,
      topPadding: 8,
      horizontalPadding: compact ? 0 : 8,
      items: [
        for (final result in results)
          SettingsNavigationItem(
            icon: result.icon,
            title: result.title,
            subtitle: _buildSubtitle(result),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SettingsScopeBadge(scope: result.scope),
                const SizedBox(width: 4),
                Icon(Icons.chevron_right_rounded, size: 20, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
              ],
            ),
            onTap: () {
              final override = result.onTapOverride;
              if (override != null) {
                override(context, ref);
                return;
              }
              onResultSelected(result);
            },
          ),
      ],
    );
  }

  String _buildSubtitle(SettingsSearchResult result) {
    final lines = <String>[
      result.categoryPath,
      if (result.description != null && result.description!.isNotEmpty) result.description!,
      if (result.availability is SettingsDisabled) (result.availability as SettingsDisabled).reason,
    ];

    return lines.join('\n');
  }
}
