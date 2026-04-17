import 'package:flutter/material.dart';
import 'package:yaabsa/components/app/download_status.dart';
import 'package:yaabsa/components/app/library_switcher.dart';
import 'package:yaabsa/components/app/user_switcher.dart';
import 'package:yaabsa/screens/layout_home/navigation_item_config.dart';

class LayoutHomeMobileAppBar extends StatelessWidget {
  const LayoutHomeMobileAppBar({
    super.key,
    required this.isSearchExpanded,
    required this.searchController,
    required this.searchQuery,
    required this.advancedMenuItems,
    required this.advancedMenuStartIndex,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
    required this.onExpandSearch,
    required this.onCollapseSearch,
    required this.onClearSearch,
    required this.onAdvancedItemSelected,
  });

  final bool isSearchExpanded;
  final TextEditingController searchController;
  final String searchQuery;
  final List<NavigationItemConfig> advancedMenuItems;
  final int advancedMenuStartIndex;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback onExpandSearch;
  final VoidCallback onCollapseSearch;
  final VoidCallback onClearSearch;
  final ValueChanged<int> onAdvancedItemSelected;

  @override
  Widget build(BuildContext context) {
    if (isSearchExpanded) {
      return SafeArea(
        top: true,
        bottom: false,
        left: false,
        right: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
          child: Row(
            children: [
              _IconContainerButton(icon: Icons.arrow_back_rounded, onTap: onCollapseSearch),
              const SizedBox(width: 6),
              Expanded(
                child: _LayoutHomeSearchField(
                  controller: searchController,
                  searchQuery: searchQuery,
                  isMobile: true,
                  autofocus: true,
                  onChanged: onSearchChanged,
                  onSubmitted: onSearchSubmitted,
                  onClear: onClearSearch,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      top: true,
      bottom: false,
      left: false,
      right: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
        child: Row(
          children: [
            const UserSwitcher(),
            const SizedBox(width: 6),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _IconContainerButton(icon: Icons.search_rounded, onTap: onExpandSearch),
                      const SizedBox(width: 6),
                      const DownloadStatus(),
                      const SizedBox(width: 4),
                      const LibrarySwitcher(),
                      const SizedBox(width: 2),
                      _buildAdvancedMenuButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedMenuButton(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert),
      onSelected: (index) => onAdvancedItemSelected(index + advancedMenuStartIndex),
      itemBuilder: (BuildContext context) {
        return advancedMenuItems.asMap().entries.map((entry) {
          final NavigationItemConfig item = entry.value;
          return PopupMenuItem<int>(
            value: entry.key,
            child: Row(
              children: [
                Icon(item.icon, color: Theme.of(context).iconTheme.color ?? Theme.of(context).colorScheme.onSurface),
                const SizedBox(width: 12),
                Text(item.label),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}

class LayoutHomeNonMobileAppBar extends StatelessWidget {
  const LayoutHomeNonMobileAppBar({
    super.key,
    required this.isTablet,
    required this.isSidebarCollapsed,
    required this.searchController,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
    required this.onClearSearch,
    required this.onSidebarToggle,
  });

  final bool isTablet;
  final bool isSidebarCollapsed;
  final TextEditingController searchController;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback onClearSearch;
  final VoidCallback onSidebarToggle;

  @override
  Widget build(BuildContext context) {
    final searchMaxWidth = isTablet ? 280.0 : 380.0;

    return SafeArea(
      top: true,
      bottom: false,
      left: false,
      right: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 6, 8, 6),
        child: Row(
          children: [
            IconButton(
              tooltip: isSidebarCollapsed ? 'Expand sidebar' : 'Collapse sidebar',
              onPressed: onSidebarToggle,
              icon: Icon(isSidebarCollapsed ? Icons.arrow_right : Icons.arrow_left),
            ),
            const SizedBox(width: 4),
            const UserSwitcher(),
            const SizedBox(width: 8),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: searchMaxWidth),
                  child: _LayoutHomeSearchField(
                    controller: searchController,
                    searchQuery: searchQuery,
                    isMobile: false,
                    onChanged: onSearchChanged,
                    onSubmitted: onSearchSubmitted,
                    onClear: onClearSearch,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Align(
                alignment: Alignment.centerRight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [DownloadStatus(), SizedBox(width: 4), LibrarySwitcher()],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LayoutHomeSearchField extends StatelessWidget {
  const _LayoutHomeSearchField({
    required this.controller,
    required this.searchQuery,
    required this.isMobile,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String searchQuery;
  final bool isMobile;
  final bool autofocus;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        textInputAction: TextInputAction.search,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: 'Search this library',
          isDense: true,
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(tooltip: 'Clear search', onPressed: onClear, icon: const Icon(Icons.close_rounded))
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          filled: true,
        ),
        style: TextStyle(fontSize: isMobile ? 14 : 15),
      ),
    );
  }
}

class _IconContainerButton extends StatelessWidget {
  const _IconContainerButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}
