import 'dart:async';

import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/screens/main/downloads.dart';
import 'package:yaabsa/screens/main/collection_view.dart';
import 'package:yaabsa/screens/main/authors_view.dart';
import 'package:yaabsa/screens/layout_home/layout_home_app_bars.dart';
import 'package:yaabsa/screens/layout_home/layout_home_mobile_nav_bar.dart';
import 'package:yaabsa/screens/layout_home/layout_home_sidebar.dart';
import 'package:yaabsa/screens/layout_home/navigation_item_config.dart';
import 'package:yaabsa/screens/main/library_view.dart';
import 'package:yaabsa/screens/main/narrators_view.dart';
import 'package:yaabsa/screens/main/personalized_view.dart';
import 'package:yaabsa/screens/main/playlist_view.dart';
import 'package:yaabsa/screens/main/search_view.dart';
import 'package:yaabsa/screens/main/series_view.dart';
import 'package:yaabsa/screens/player/play_bar.dart';
import 'package:yaabsa/screens/settings/settings_screen.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

class LayoutHome extends ConsumerStatefulWidget {
  const LayoutHome({super.key, this.child});

  final Widget? child;

  @override
  ConsumerState<LayoutHome> createState() => _LayoutHomeState();
}

class _LayoutHomeState extends ConsumerState<LayoutHome> {
  int _selectedIndex = 0;
  String? _lastConsumedTabIntent;
  _PageSource _currentlyDisplayedPageSource = _PageSource.internal;
  String? _bootstrappedUserId;
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  String _searchQuery = '';
  bool _isMobileSearchExpanded = false;
  bool _isSidebarCollapsed = false;

  late final List<NavigationItemConfig> _appBarItems;
  late final NavigationItemConfig _downloadsMenuItem;
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
      NavigationItemConfig(icon: Icons.person_outline_rounded, label: "Authors", page: AuthorsView()),
      NavigationItemConfig(icon: Icons.record_voice_over_rounded, label: "Narrators", page: NarratorsView()),
    ];

    _downloadsMenuItem = const NavigationItemConfig(icon: Icons.download, label: "Downloads", page: Downloads());
    _advancedMenuItems = const [
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

  List<NavigationItemConfig> _visibleAdvancedMenuItems({required bool canDownload}) {
    if (!canDownload) {
      return _advancedMenuItems;
    }
    return [_downloadsMenuItem, ..._advancedMenuItems];
  }

  Widget _resolveCurrentContent(List<NavigationItemConfig> advancedMenuItems) {
    if (_currentlyDisplayedPageSource == _PageSource.child && widget.child != null) {
      return widget.child!;
    }
    if (_searchQuery.isNotEmpty) {
      return SearchView(query: _searchQuery);
    }
    if (_selectedIndex < _appBarItems.length) {
      return _appBarItems[_selectedIndex].page;
    }

    final advancedIndex = _selectedIndex - _appBarItems.length;
    if (advancedIndex >= 0 && advancedIndex < advancedMenuItems.length) {
      return advancedMenuItems[advancedIndex].page;
    }

    return _appBarItems.first.page;
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

  bool _isBootstrapping() {
    final currentUserAsync = ref.watch(currentUserProvider);
    if (currentUserAsync.isLoading && !currentUserAsync.hasValue) {
      return true;
    }

    if (currentUserAsync.hasError) {
      return false;
    }

    final currentUser = currentUserAsync.value;
    if (currentUser == null) {
      _bootstrappedUserId = null;
      return false;
    }

    final userId = currentUser.id;
    if (_bootstrappedUserId == userId) {
      return false;
    }

    final librariesAsync = ref.watch(userLibrariesProvider);
    final selectedLibraryIdAsync = ref.watch(selectedLibraryIdProvider);

    if (librariesAsync.hasError || selectedLibraryIdAsync.hasError) {
      _bootstrappedUserId = userId;
      return false;
    }

    if ((librariesAsync.isLoading && !librariesAsync.hasValue) ||
        (selectedLibraryIdAsync.isLoading && !selectedLibraryIdAsync.hasValue)) {
      return true;
    }

    final libraries = librariesAsync.value ?? const [];
    final selectedLibraryId = selectedLibraryIdAsync.value;

    if (libraries.isNotEmpty && selectedLibraryId == null) {
      return true;
    }

    _bootstrappedUserId = userId;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final queryParameters = GoRouterState.of(context).uri.queryParameters;
    final tabIntent = queryParameters['tab'];
    final intentKey = queryParameters['intent'] ?? tabIntent;
    if (tabIntent != null && intentKey != null && intentKey != _lastConsumedTabIntent) {
      final targetIndex = switch (tabIntent) {
        'library' => 1,
        'collections' => 2,
        'playlists' => 3,
        'series' => 4,
        'authors' => 5,
        'narrators' => 6,
        _ => 0,
      };
      _lastConsumedTabIntent = intentKey;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _selectedIndex = targetIndex;
          _currentlyDisplayedPageSource = _PageSource.internal;
        });
      });
    }

    if (_isBootstrapping()) {
      return const _LayoutHomeStartupScreen();
    }

    final bool isMobile = context.isMobile;
    final bool isTablet = context.isTablet;
    final canDownload = ref.watch(currentUserProvider).value?.permissions.download ?? false;
    final advancedMenuItems = _visibleAdvancedMenuItems(canDownload: canDownload);
    final bool canExpandSidebar = !isMobile;
    final bool isSidebarCollapsed = !canExpandSidebar || _isSidebarCollapsed;
    final SidebarVariant sidebarVariant = _sidebarVariantFor(isTablet: isTablet, isCollapsed: isSidebarCollapsed);
    final Widget currentContent = _resolveCurrentContent(advancedMenuItems);

    if (isMobile) {
      return Scaffold(
        body: Column(
          children: [
            LayoutHomeMobileAppBar(
              isSearchExpanded: _isMobileSearchExpanded,
              searchController: _searchController,
              searchQuery: _searchQuery,
              advancedMenuItems: advancedMenuItems,
              advancedMenuStartIndex: _appBarItems.length,
              onSearchChanged: _onSearchChanged,
              onSearchSubmitted: _submitSearch,
              onExpandSearch: _expandMobileSearch,
              onCollapseSearch: _collapseMobileSearch,
              onClearSearch: _clearSearch,
              onAdvancedItemSelected: _onAppBarItemTapped,
            ),

            Expanded(child: currentContent),
            StreamBuilder<bool>(
              stream: audioHandler.shouldShowPlayer,
              initialData: audioHandler.player.playerState.playing,
              builder: (context, snapshot) {
                final showPlayer = snapshot.data == true;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: LayoutHomeMobileNavBar.horizontalMargin),
                  child: SafeArea(
                    top: false,
                    left: false,
                    right: false,
                    bottom: !showPlayer,
                    minimum: EdgeInsets.only(bottom: showPlayer ? 8 : LayoutHomeMobileNavBar.floatingBottomMargin),
                    child: LayoutHomeMobileNavBar(
                      items: _appBarItems,
                      selectedIndex: _selectedIndex,
                      onItemTap: _onAppBarItemTapped,
                    ),
                  ),
                );
              },
            ),
            const PlayBar(includeBottomSafeArea: true, attachedToBottom: true),
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
              secondaryItems: advancedMenuItems,
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

class _LayoutHomeStartupScreen extends StatelessWidget {
  const _LayoutHomeStartupScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(child: const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 2.6))),
      ),
    );
  }
}
