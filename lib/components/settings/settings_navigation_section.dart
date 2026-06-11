import 'package:flutter/material.dart';
import 'package:yaabsa/components/settings/settings_section_title.dart';

class SettingsNavigationItem {
  const SettingsNavigationItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.disabledReason,
    this.onTap,
    this.trailing,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? disabledReason;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool enabled;
}

class SettingsNavigationSection extends StatelessWidget {
  const SettingsNavigationSection({
    super.key,
    required this.title,
    this.items = const [],
    this.settings = const [],
    this.children = const [],
    this.topPadding = 28,
    this.horizontalPadding = 8,
    this.showSectionTitle = true,
  }) : assert(
         items.length > 0 || settings.length > 0 || children.length > 0,
         'Provide at least one navigation item, setting widget, or child.',
       );

  final String title;
  final List<SettingsNavigationItem> items;
  final List<Widget> settings;
  final List<Widget> children;
  final double topPadding;
  final double horizontalPadding;
  final bool showSectionTitle;

  BorderRadius _getBorderRadius(int index, int total) {
    if (total == 1) {
      return BorderRadius.circular(24);
    }
    if (index == 0) {
      return const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
        bottomLeft: Radius.circular(4),
        bottomRight: Radius.circular(4),
      );
    }
    if (index == total - 1) {
      return const BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(4),
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      );
    }
    return BorderRadius.circular(4);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Widget> allItems = [
      for (var index = 0; index < items.length; index++) _SettingsNavigationTile(item: items[index]),
      ...settings,
      ...children,
    ];

    if (allItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showSectionTitle) SettingsSectionTitle(title: title, topPadding: topPadding),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              for (var index = 0; index < allItems.length; index++)
                Padding(
                  padding: EdgeInsets.only(bottom: index == allItems.length - 1 ? 0 : 2),
                  child: ClipRRect(
                    borderRadius: _getBorderRadius(index, allItems.length),
                    child: Material(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      child: allItems[index],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsNavigationTile extends StatelessWidget {
  const _SettingsNavigationTile({required this.item});

  final SettingsNavigationItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = item.enabled && item.onTap != null;

    final subtitleParts = <String>[
      if (item.subtitle != null && item.subtitle!.isNotEmpty) item.subtitle!,
      if (!isEnabled && item.disabledReason != null && item.disabledReason!.isNotEmpty) item.disabledReason!,
    ];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? item.onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(
                item.icon,
                color: isEnabled ? colorScheme.primary : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                size: 22,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isEnabled ? colorScheme.onSurface : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                    ),
                    if (subtitleParts.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitleParts.join('\n'),
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.78)),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              item.trailing ??
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: isEnabled ? 0.6 : 0.38),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
