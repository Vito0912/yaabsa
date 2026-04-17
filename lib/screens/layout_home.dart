import 'dart:async';

import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/screens/main/downloads.dart';
import 'package:yaabsa/screens/main/collection_view.dart';
import 'package:yaabsa/screens/layout_home/layout_home_app_bars.dart';
import 'package:yaabsa/screens/layout_home/layout_home_mobile_nav_bar.dart';
import 'package:yaabsa/screens/layout_home/layout_home_sidebar.dart';
import 'package:yaabsa/screens/layout_home/navigation_item_config.dart';
import 'package:yaabsa/screens/main/library_view.dart';
import 'package:yaabsa/screens/main/personalized_view.dart';
import 'package:yaabsa/screens/main/playlist_view.dart';
import 'package:yaabsa/screens/main/search_view.dart';
import 'package:yaabsa/screens/main/series_view.dart';
import 'package:yaabsa/screens/player/play_bar.dart';
import 'package:yaabsa/screens/settings/settings_screen.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:flutter/material.dart';

enum _PageSource { internal, child }

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
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  String _searchQuery = '';
  bool _isMobileSearchExpanded = false;
  bool _isSidebarCollapsed = false;

  late final List<NavigationItemConfig> _appBarItems;
  late final List<NavigationItemConfig> _advancedMenuItems;

  @override
  void initState() {
    super.initState();
    _appBarItems = const [
      NavigationItemConfig(icon: Icons.home, label: "Shelf", page: PersonalizedView()),
      NavigationItemConfig(icon: Icons.collections_bookmark_outlined, label: "Library", page: LibraryView()),
      NavigationItemConfig(icon: Icons.collections_outlined, label: "Collections", page: CollectionView()),
      NavigationItemConfig(icon: Icons.playlist_play_rounded, label: "Playlists", page: PlaylistView()),
      NavigationItemConfig(icon: Icons.view_column_outlined, label: "Series", page: SeriesView()),
    ];

    _advancedMenuItems = const [
      NavigationItemConfig(icon: Icons.download, label: "Downloads", page: Downloads()),
      NavigationItemConfig(icon: Icons.settings, label: "Settings", page: MainSettingsScreen()),
      NavigationItemConfig(
        icon: Icons.info_outline,
        label: "About",
        page: PlaceholderPage(title: "About Page Content"),
      ),
    ];

    _currentlyDisplayedPageSource = _pageSourceFor(widget.child);

    final settings = containerRef.read(settingsManagerProvider.notifier);
    _isSidebarCollapsed = settings.getGlobalSetting<bool>(SettingKeys.sidebarCollapsed);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(LayoutHome oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.child != oldWidget.child) {
      _currentlyDisplayedPageSource = _pageSourceFor(widget.child);
    }
  }

  _PageSource _pageSourceFor(Widget? child) => child == null ? _PageSource.internal : _PageSource.child;

  Widget _resolveCurrentContent() {
    if (_currentlyDisplayedPageSource == _PageSource.child && widget.child != null) {
      return widget.child!;
    }
    if (_searchQuery.isNotEmpty) {
      return SearchView(query: _searchQuery);
    }
    if (_selectedIndex < _appBarItems.length) {
      return _appBarItems[_selectedIndex].page;
    }
    return _advancedMenuItems[_selectedIndex - _appBarItems.length].page;
  }

  SidebarVariant _sidebarVariantFor({required bool isTablet, required bool isCollapsed}) {
    if (isCollapsed) {
      return SidebarVariant.collapsed;
    }
    return isTablet ? SidebarVariant.tabletExpanded : SidebarVariant.desktopExpanded;
  }

  void _onAppBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _currentlyDisplayedPageSource = _PageSource.internal;
      _searchQuery = '';
      _searchController.clear();
      _isMobileSearchExpanded = false;
    });
  }

  void _submitSearch(String value) {
    final query = value.trim();
    _searchDebounce?.cancel();
    setState(() {
      _currentlyDisplayedPageSource = _PageSource.internal;
      _searchQuery = query;
    });
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 250), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _currentlyDisplayedPageSource = _PageSource.internal;
        _searchQuery = value.trim();
      });
    });
  }

  void _expandMobileSearch() {
    setState(() {
      _isMobileSearchExpanded = true;
    });
  }

  void _collapseMobileSearch() {
    setState(() {
      _isMobileSearchExpanded = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
  }

  void _setSidebarCollapsed(bool isCollapsed) {
    setState(() {
      _isSidebarCollapsed = isCollapsed;
    });

    unawaited(
      containerRef
          .read(settingsManagerProvider.notifier)
          .setGlobalSetting<bool>(SettingKeys.sidebarCollapsed, isCollapsed),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = context.isMobile;
    final bool isTablet = context.isTablet;
    final bool canExpandSidebar = !isMobile;
    final bool isSidebarCollapsed = !canExpandSidebar || _isSidebarCollapsed;
    final SidebarVariant sidebarVariant = _sidebarVariantFor(isTablet: isTablet, isCollapsed: isSidebarCollapsed);
    final Widget currentContent = _resolveCurrentContent();

    if (isMobile) {
      return Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                LayoutHomeMobileAppBar(
                  isSearchExpanded: _isMobileSearchExpanded,
                  searchController: _searchController,
                  searchQuery: _searchQuery,
                  advancedMenuItems: _advancedMenuItems,
                  advancedMenuStartIndex: _appBarItems.length,
                  onSearchChanged: _onSearchChanged,
                  onSearchSubmitted: _submitSearch,
                  onExpandSearch: _expandMobileSearch,
                  onCollapseSearch: _collapseMobileSearch,
                  onClearSearch: _clearSearch,
                  onAdvancedItemSelected: _onAppBarItemTapped,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(child: currentContent),
                      const SizedBox(height: 86),
                    ],
                  ),
                ),
                const PlayBar(),
              ],
            ),
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
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: LayoutHomeMobileNavBar(
                        items: _appBarItems,
                        selectedIndex: _selectedIndex,
                        onItemTap: _onAppBarItemTapped,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            top: true,
            bottom: false,
            left: true,
            right: false,
            child: LayoutHomeSidebar(
              variant: sidebarVariant,
              selectedIndex: _selectedIndex,
              primaryItems: _appBarItems,
              secondaryItems: _advancedMenuItems,
              onItemTap: _onAppBarItemTapped,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                LayoutHomeNonMobileAppBar(
                  isTablet: isTablet,
                  isSidebarCollapsed: isSidebarCollapsed,
                  searchController: _searchController,
                  searchQuery: _searchQuery,
                  onSearchChanged: _onSearchChanged,
                  onSearchSubmitted: _submitSearch,
                  onClearSearch: _clearSearch,
                  onSidebarToggle: () => _setSidebarCollapsed(!isSidebarCollapsed),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(child: currentContent),
                      const PlayBar(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
