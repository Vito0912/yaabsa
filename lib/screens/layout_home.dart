import 'package:buchshelfly/components/app/library_switcher.dart';
import 'package:buchshelfly/components/app/user_switcher.dart';
import 'package:buchshelfly/components/player/play_bar.dart';
import 'package:buchshelfly/screens/main/library_view.dart';
import 'package:buchshelfly/screens/main/personalized_view.dart';
import 'package:buchshelfly/screens/settings/settings_screen.dart';
import 'package:buchshelfly/util/globals.dart';
import 'package:flutter/material.dart';

enum _PageSource { internal, child }

class NavigationItemConfig {
  final IconData icon;
  final String label;
  final Widget page;

  NavigationItemConfig({required this.icon, required this.label, required this.page});
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
      ),
    );
  }
}

class LayoutHome extends StatefulWidget {
  const LayoutHome({super.key, this.child});

  final Widget? child;

  @override
  State<LayoutHome> createState() => _LayoutHomeState();
}

class _LayoutHomeState extends State<LayoutHome> {
  int _selectedIndex = 0;
  _PageSource _currentlyDisplayedPageSource = _PageSource.internal;

  late final List<NavigationItemConfig> _appBarItems;
  late final List<NavigationItemConfig> _advancedMenuItems;

  @override
  void initState() {
    super.initState();
    _appBarItems = [
      NavigationItemConfig(icon: Icons.home, label: "Shelf", page: const PersonalizedView()),
      NavigationItemConfig(icon: Icons.collections_bookmark_outlined, label: "Library", page: const LibraryView()),
      NavigationItemConfig(
        icon: Icons.search,
        label: "Search",
        page: const PlaceholderPage(title: "Search Page Content"),
      ),
    ];

    _advancedMenuItems = [
      NavigationItemConfig(icon: Icons.settings, label: "Settings", page: MainSettingsScreen()),
      NavigationItemConfig(
        icon: Icons.info_outline,
        label: "About",
        page: const PlaceholderPage(title: "About Page Content"),
      ),
    ];

    if (widget.child != null) {
      _currentlyDisplayedPageSource = _PageSource.child;
    } else {
      _currentlyDisplayedPageSource = _PageSource.internal;
    }
  }

  @override
  void didUpdateWidget(LayoutHome oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.child != oldWidget.child) {
      if (widget.child != null) {
        _currentlyDisplayedPageSource = _PageSource.child;
      } else {
        _currentlyDisplayedPageSource = _PageSource.internal;
      }
    }
  }

  void _onAppBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _currentlyDisplayedPageSource = _PageSource.internal;
    });
  }

  void _handleAdvancedItemTap(BuildContext context, String itemName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          final item = _advancedMenuItems.firstWhere((item) => item.label == itemName);
          return item.page;
        },
      ),
    );
  }

  Widget _buildSidebarItem(
    BuildContext context,
    NavigationItemConfig item, {
    required bool isSelected,
    required bool isDesktopOrTablet,
    required bool isDesktop,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedColor = colorScheme.primary;
    final unselectedColor = colorScheme.onSurfaceVariant;
    final itemColor = isSelected ? selectedColor : unselectedColor;

    if (isDesktop) {
      return Padding(
        padding: const EdgeInsets.all(0),
        child: ListTile(
          leading: Icon(item.icon, color: itemColor),
          title: Text(item.label, style: TextStyle(color: itemColor)),
          selected: isSelected,
          onTap: onTap,
          dense: true,
          selectedTileColor: selectedColor.withOpacity(0.1),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        ),
      );
    } else {
      return InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          color: isSelected ? selectedColor.withOpacity(0.1) : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, size: 28, color: itemColor),
              const SizedBox(height: 6),
              Text(
                item.label,
                style: TextStyle(fontSize: 12, color: itemColor),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildAdvancedMenuButton(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert),
      onSelected: (int index) {
        _onAppBarItemTapped(index);
      },
      itemBuilder: (BuildContext context) {
        return _advancedMenuItems.asMap().entries.map((entries) {
          final NavigationItemConfig item = entries.value;
          final int itemIndex = entries.key + _appBarItems.length;
          return PopupMenuItem<int>(
            value: itemIndex,
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

  Widget _buildMobileNavBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const double navBarHeight = 70.0;

    return Material(
      elevation: 4.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
          bottomLeft: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
        ),
      ),
      child: Container(
        height: navBarHeight,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
            bottomLeft: Radius.circular(24.0),
            bottomRight: Radius.circular(24.0),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ..._appBarItems.asMap().entries.map((entry) {
              int idx = entry.key;
              NavigationItemConfig item = entry.value;
              bool isSelected = _selectedIndex == idx;

              return Expanded(
                child: InkWell(
                  onTap: () => _onAppBarItemTapped(idx),
                  borderRadius: BorderRadius.circular(12.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.icon,
                          color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                          size: isSelected ? 26 : 22,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context, bool isMobile) {
    return SafeArea(
      top: true,
      bottom: false,
      left: false,
      right: false,
      child: Row(
        children: [
          const SizedBox(width: 16),
          UserSwitcher(),
          const Spacer(),
          LibrarySwitcher(),
          if (isMobile) _buildAdvancedMenuButton(context),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final bool isMobile = screenWidth < 600;
        final bool isDesktop = screenWidth >= 1200;

        Widget currentContent;
        if (_currentlyDisplayedPageSource == _PageSource.child && widget.child != null) {
          currentContent = widget.child!;
        } else {
          currentContent =
              _selectedIndex < _appBarItems.length
                  ? _appBarItems[_selectedIndex].page
                  : _advancedMenuItems[_selectedIndex - _appBarItems.length].page;
        }

        if (isMobile) {
          return Scaffold(
            body: Stack(
              children: [
                Column(children: [_appBar(context, true), Expanded(child: currentContent), PlayBar()]),
                SafeArea(
                  child: StreamBuilder<bool>(
                    stream: audioHandler.shouldShowPlayer,
                    builder: (context, snapshot) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: 24 + ((snapshot.hasData && snapshot.data!) ? 56 : 0),
                          right: 12,
                          left: 12,
                        ),
                        child: Align(alignment: Alignment.bottomCenter, child: _buildMobileNavBar(context)),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          Widget sidebar = Material(
            elevation: 2.0,
            child: Container(
              width: !isDesktop ? 90 : 260,
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children:
                          _appBarItems.asMap().entries.map((entry) {
                            int idx = entry.key;
                            NavigationItemConfig item = entry.value;
                            return _buildSidebarItem(
                              context,
                              item,
                              isSelected: _selectedIndex == idx,
                              isDesktopOrTablet: true,
                              isDesktop: isDesktop,
                              onTap: () => _onAppBarItemTapped(idx),
                            );
                          }).toList(),
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children:
                          _advancedMenuItems.asMap().entries.map((entry) {
                            int idx = entry.key + _appBarItems.length;
                            NavigationItemConfig item = entry.value;
                            return _buildSidebarItem(
                              context,
                              item,
                              isSelected: _selectedIndex == idx,
                              isDesktopOrTablet: true,
                              isDesktop: isDesktop,
                              onTap: () => _onAppBarItemTapped(idx),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );

          return Scaffold(
            body: Column(
              children: [
                SafeArea(child: _appBar(context, false)),
                Expanded(
                  child: Row(
                    children: [
                      sidebar,
                      Expanded(child: Column(children: [Expanded(child: currentContent), PlayBar()])),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
