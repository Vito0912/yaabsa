import 'package:flutter/material.dart';
import 'package:yaabsa/screens/layout_home/navigation_item_config.dart';

enum SidebarVariant { collapsed, tabletExpanded, desktopExpanded }

class LayoutHomeSidebar extends StatelessWidget {
  static const double collapsedWidth = 72;
  static const double tabletExpandedWidth = 112;
  static const double desktopExpandedWidth = 224;

  const LayoutHomeSidebar({
    super.key,
    required this.variant,
    required this.selectedIndex,
    required this.primaryItems,
    required this.secondaryItems,
    required this.onItemTap,
  });

  final SidebarVariant variant;
  final int selectedIndex;
  final List<NavigationItemConfig> primaryItems;
  final List<NavigationItemConfig> secondaryItems;
  final ValueChanged<int> onItemTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: _widthForVariant(variant),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 8),
                children: primaryItems.asMap().entries.map((entry) {
                  final int idx = entry.key;
                  return _buildSidebarItem(
                    context,
                    item: entry.value,
                    variant: variant,
                    isSelected: selectedIndex == idx,
                    onTap: () => onItemTap(idx),
                  );
                }).toList(),
              ),
            ),
            const Divider(height: 1, thickness: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: secondaryItems.asMap().entries.map((entry) {
                  final int idx = entry.key + primaryItems.length;
                  return _buildSidebarItem(
                    context,
                    item: entry.value,
                    variant: variant,
                    isSelected: selectedIndex == idx,
                    onTap: () => onItemTap(idx),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _widthForVariant(SidebarVariant variant) {
    switch (variant) {
      case SidebarVariant.collapsed:
        return collapsedWidth;
      case SidebarVariant.tabletExpanded:
        return tabletExpandedWidth;
      case SidebarVariant.desktopExpanded:
        return desktopExpandedWidth;
    }
  }

  Widget _buildSidebarItem(
    BuildContext context, {
    required NavigationItemConfig item,
    required SidebarVariant variant,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedColor = colorScheme.primary;
    final unselectedColor = colorScheme.onSurfaceVariant;
    final itemColor = isSelected ? selectedColor : unselectedColor;

    switch (variant) {
      case SidebarVariant.desktopExpanded:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isSelected ? selectedColor.withValues(alpha: 0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(item.icon, color: itemColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyle(color: itemColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      case SidebarVariant.tabletExpanded:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? selectedColor.withValues(alpha: 0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(item.icon, size: 22, color: itemColor),
                  const SizedBox(height: 2),
                  Text(
                    item.label,
                    style: TextStyle(color: itemColor, fontSize: 11),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      case SidebarVariant.collapsed:
        return Tooltip(
          message: item.label,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? selectedColor.withValues(alpha: 0.12) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, size: 22, color: itemColor),
              ),
            ),
          ),
        );
    }
  }
}
