import 'package:flutter/material.dart';

@immutable
class ExpressiveTabViewItem {
  const ExpressiveTabViewItem({required this.id, required this.label, required this.child, this.icon});

  final String id;
  final String label;
  final Widget child;
  final IconData? icon;
}

class ExpressiveTabView extends StatelessWidget {
  const ExpressiveTabView({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.tabBarScrollable = true,
    this.tabBarPadding = const EdgeInsets.symmetric(horizontal: 2),
    this.contentPadding = EdgeInsets.zero,
  }) : assert(tabs.length > 0, 'ExpressiveTabView requires at least one tab.');

  final List<ExpressiveTabViewItem> tabs;
  final int initialIndex;
  final bool tabBarScrollable;
  final EdgeInsetsGeometry tabBarPadding;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final labelStyle = Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600);
    final resolvedInitialIndex = tabs.isEmpty
        ? 0
        : initialIndex < 0
        ? 0
        : (initialIndex >= tabs.length ? tabs.length - 1 : initialIndex);

    return DefaultTabController(
      length: tabs.length,
      initialIndex: resolvedInitialIndex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: tabBarPadding,
            child: Transform.translate(
              offset: const Offset(0, -2),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.68),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.35)),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.08),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: TabBar(
                    isScrollable: tabBarScrollable,
                    tabAlignment: tabBarScrollable ? TabAlignment.start : TabAlignment.fill,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: EdgeInsets.zero,
                    labelColor: colorScheme.onSurface,
                    unselectedLabelColor: colorScheme.onSurfaceVariant,
                    labelStyle: labelStyle,
                    unselectedLabelStyle: labelStyle?.copyWith(fontWeight: FontWeight.w500),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                    splashBorderRadius: BorderRadius.circular(10),
                    indicator: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    tabs: [
                      for (final tab in tabs)
                        Tab(
                          height: tab.icon == null ? 34 : 40,
                          iconMargin: const EdgeInsets.only(bottom: 2),
                          icon: tab.icon == null ? null : Icon(tab.icon, size: 16),
                          text: tab.label,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: contentPadding,
              child: TabBarView(children: [for (final tab in tabs) tab.child]),
            ),
          ),
        ],
      ),
    );
  }
}
