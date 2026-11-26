import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/features/settings/model/settings_availability.dart';
import 'package:yaabsa/features/settings/model/settings_spec.dart';
import 'package:yaabsa/features/settings/presentation/settings_entry_renderer.dart';
import 'package:yaabsa/features/settings/registry/settings_registry.dart';

typedef SettingsRootPageSelectedCallback = void Function(SettingsPageSpec page);

List<Widget> buildSinglePaneRootSections({
  required SettingsRegistry registry,
  required SettingsContext settingsContext,
  required SettingsRootPageSelectedCallback onOpenPage,
}) {
  final sections = <Widget>[];

  for (final group in registry.rootGroups) {
    if (!group.availability(settingsContext).isVisible) {
      continue;
    }

    if (group.id == 'about_support') {
      final aboutSection = _buildSinglePaneAboutSection(
        group: group,
        registry: registry,
        settingsContext: settingsContext,
        onOpenPage: onOpenPage,
      );
      if (aboutSection != null) {
        sections.add(aboutSection);
      }
      continue;
    }

    final items = <SettingsNavigationItem>[];
    for (final pageId in group.pageIds) {
      final page = registry.findPageById(pageId);
      if (page == null) {
        continue;
      }

      final pageAvailability = registry.resolvePageAvailability(page, settingsContext);
      if (!pageAvailability.isVisible) {
        continue;
      }

      final isEnabled = pageAvailability.isEnabled;
      items.add(
        SettingsNavigationItem(
          icon: page.icon,
          title: page.title(settingsContext),
          subtitle: page.subtitle?.call(settingsContext),
          disabledReason: pageAvailability.disabledReason,
          enabled: isEnabled,
          onTap: isEnabled ? () => onOpenPage(page) : null,
        ),
      );
    }

    if (items.isEmpty) {
      continue;
    }

    sections.add(SettingsNavigationSection(title: group.title(settingsContext), items: items));
  }

  return sections;
}

Widget? _buildSinglePaneAboutSection({
  required SettingsRootGroupSpec group,
  required SettingsRegistry registry,
  required SettingsContext settingsContext,
  required SettingsRootPageSelectedCallback onOpenPage,
}) {
  final entryWidgets = <Widget>[];

  for (final pageId in group.pageIds) {
    final page = registry.findPageById(pageId);
    if (page == null) {
      continue;
    }

    final pageAvailability = registry.resolvePageAvailability(page, settingsContext);
    if (!pageAvailability.isVisible) {
      continue;
    }

    if (page.onExternalTap != null) {
      final isEnabled = pageAvailability.isEnabled;
      entryWidgets.add(
        SettingsNavigationTile(
          item: SettingsNavigationItem(
            icon: page.icon,
            title: page.title(settingsContext),
            subtitle: page.subtitle?.call(settingsContext),
            disabledReason: pageAvailability.disabledReason,
            enabled: isEnabled,
            trailing: Builder(
              builder: (context) {
                final colorScheme = Theme.of(context).colorScheme;
                return Icon(
                  Icons.open_in_new_rounded,
                  size: 18,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: isEnabled ? 0.6 : 0.38),
                );
              },
            ),
            onTap: isEnabled ? () => onOpenPage(page) : null,
          ),
        ),
      );
      continue;
    }

    for (final section in page.sections) {
      final sectionAvailability = SettingsRegistry.combineAvailability(
        pageAvailability,
        section.availability(settingsContext),
      );
      if (!sectionAvailability.isVisible) {
        continue;
      }

      for (final entry in section.entries) {
        final entryAvailability = SettingsRegistry.combineAvailability(
          sectionAvailability,
          entry.availability(settingsContext),
        );
        if (!entryAvailability.isVisible) {
          continue;
        }

        entryWidgets.add(
          SettingsEntryRenderer(
            entry: entry,
            settingsContext: settingsContext,
            availability: entryAvailability,
            focused: false,
          ),
        );
      }
    }
  }

  if (entryWidgets.isEmpty) {
    return null;
  }

  return SettingsNavigationSection(title: group.title(settingsContext), settings: entryWidgets);
}

List<Widget> buildTwoPaneRootGroups({
  required SettingsRegistry registry,
  required SettingsContext settingsContext,
  required String activeRootPageId,
  required SettingsRootPageSelectedCallback onOpenPage,
}) {
  final sections = <Widget>[];

  for (final group in registry.rootGroups) {
    if (!group.availability(settingsContext).isVisible) {
      continue;
    }

    final tiles = <Widget>[];
    for (final pageId in group.pageIds) {
      final page = registry.findPageById(pageId);
      if (page == null) {
        continue;
      }

      final pageAvailability = registry.resolvePageAvailability(page, settingsContext);
      if (!pageAvailability.isVisible) {
        continue;
      }

      final isSelected = page.id == activeRootPageId;
      tiles.add(
        _TwoPaneCategoryTile(
          page: page,
          title: page.title(settingsContext),
          disabledReason: pageAvailability.disabledReason,
          enabled: pageAvailability.isEnabled,
          selected: isSelected,
          external: page.onExternalTap != null || !page.registerRoute,
          onTap: pageAvailability.isEnabled ? () => onOpenPage(page) : null,
        ),
      );
    }

    if (tiles.isEmpty) {
      continue;
    }

    sections.add(
      SettingsNavigationSection(
        title: group.title(settingsContext),
        topPadding: sections.isEmpty ? 8 : 20,
        horizontalPadding: 0,
        settings: tiles,
      ),
    );
  }

  return sections;
}

class _TwoPaneCategoryTile extends StatelessWidget {
  const _TwoPaneCategoryTile({
    required this.page,
    required this.title,
    required this.disabledReason,
    required this.enabled,
    required this.selected,
    required this.external,
    required this.onTap,
  });

  final SettingsPageSpec page;
  final String title;
  final String? disabledReason;
  final bool enabled;
  final bool selected;
  final bool external;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEnabled = enabled && onTap != null;

    final Color iconColor;
    final Color textColor;
    if (selected) {
      iconColor = colorScheme.onSecondaryContainer;
      textColor = colorScheme.onSecondaryContainer;
    } else if (isEnabled) {
      iconColor = colorScheme.primary;
      textColor = colorScheme.onSurface;
    } else {
      iconColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.38);
      textColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.6);
    }

    return Material(
      color: selected ? colorScheme.secondaryContainer : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(page.icon, color: iconColor, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                    if (!isEnabled && disabledReason != null && disabledReason!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        disabledReason!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.78),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (external) ...[
                const SizedBox(width: 8),
                Icon(Icons.open_in_new_rounded, size: 16, color: iconColor.withValues(alpha: 0.8)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
