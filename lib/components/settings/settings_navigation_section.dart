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
    this.topPadding = 28,
    this.horizontalPadding = 8,
    this.showSectionTitle = true,
  }) : assert(items.length > 0 || settings.length > 0, 'Provide at least one navigation item or setting widget.');

  final String title;
  final List<SettingsNavigationItem> items;
  final List<Widget> settings;
  final double topPadding;
  final double horizontalPadding;
  final bool showSectionTitle;

  @override
  Widget build(BuildContext context) {
    final hasItems = items.isNotEmpty;
    final hasSettings = settings.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showSectionTitle) SettingsSectionTitle(title: title, topPadding: topPadding),
        if (hasItems)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: [
                  for (var index = 0; index < items.length; index++) ...[
                    _SettingsNavigationTile(item: items[index], isFirst: index == 0, isLast: index == items.length - 1),
                    if (index != items.length - 1)
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Theme.of(context).dividerColor.withValues(alpha: 0.12),
                        indent: 58,
                      ),
                  ],
                ],
              ),
            ),
          ),
        if (hasItems && hasSettings) const SizedBox(height: 8),
        if (hasSettings) Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: settings),
      ],
    );
  }
}

class _SettingsNavigationTile extends StatelessWidget {
  const _SettingsNavigationTile({required this.item, required this.isFirst, required this.isLast});

  final SettingsNavigationItem item;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = item.enabled && item.onTap != null;

    final subtitleParts = <String>[
      if (item.subtitle != null && item.subtitle!.isNotEmpty) item.subtitle!,
      if (!isEnabled && item.disabledReason != null && item.disabledReason!.isNotEmpty) item.disabledReason!,
    ];

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: isFirst ? const Radius.circular(16) : Radius.zero,
        bottom: isLast ? const Radius.circular(16) : Radius.zero,
      ),
    );

    return Material(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: isEnabled ? 0.5 : 0.35),
      shape: shape,
      child: InkWell(
        onTap: isEnabled ? item.onTap : null,
        customBorder: shape,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Icon(item.icon, color: isEnabled ? colorScheme.primary : colorScheme.onSurfaceVariant, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isEnabled ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (subtitleParts.isNotEmpty) ...[
                      const SizedBox(height: 2),
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
              item.trailing ??
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: colorScheme.onSurfaceVariant.withValues(alpha: isEnabled ? 0.6 : 0.38),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
