import 'dart:async';

import 'package:yaabsa/components/app/upload/library_upload_panel.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/screens/automotive/aaos_settings_scaffold.dart';
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
import 'package:yaabsa/screens/main/podcast_add_view.dart';
import 'package:yaabsa/screens/main/search_view.dart';
import 'package:yaabsa/screens/main/series_view.dart';
import 'package:yaabsa/screens/main/stats_view.dart';
import 'package:yaabsa/screens/player/play_bar.dart';
import 'package:yaabsa/screens/settings/settings_screen.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/multi_select_app_bar_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/home_navigation_preferences.dart';
import 'package:yaabsa/util/server_management_preferences.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/util/aaos_service.dart';

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

  static const String openUploadQueryKey = 'openUpload';
  static const String openUploadQueryValue = '1';
  static const String uploadIntentQueryKey = 'uploadIntent';

  final Widget? child;

  static String uploadModeLocation({String tab = 'settings'}) {
    final intent = DateTime.now().microsecondsSinceEpoch.toString();
    return Uri(
      path: '/',
      queryParameters: {
        'tab': tab,
        'intent': intent,
        openUploadQueryKey: openUploadQueryValue,
        uploadIntentQueryKey: intent,
      },
    ).toString();
  }

  @override
  ConsumerState<LayoutHome> createState() => _LayoutHomeState();
}

class _LayoutHomeState extends ConsumerState<LayoutHome> {
  int _selectedIndex = -1;
  String? _lastSelectedLabel;
  String? _lastConsumedTabIntent;
  String? _lastConsumedUploadIntent;
  _PageSource _currentlyDisplayedPageSource = _PageSource.internal;
  String? _bootstrappedUserId;
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  String _searchQuery = '';
  int? _searchLimit = 5;
  bool _isMobileSearchExpanded = false;
  bool _isSidebarCollapsed = false;
  bool _isUploadPageVisible = false;
  bool _isUploadInProgress = false;
  bool _didRequestAaosMediaCenterLaunch = false;

  late final NavigationItemConfig _downloadsMenuItem;
  late final List<NavigationItemConfig> _advancedMenuItems;

  @override
  void initState() {
    super.initState();
    _downloadsMenuItem = const NavigationItemConfig(icon: Icons.download, label: "Downloads", page: Downloads());
    _advancedMenuItems = const [
      NavigationItemConfig(icon: Icons.bar_chart_rounded, label: "Stats", page: StatsView()),
      NavigationItemConfig(icon: Icons.settings, label: "Settings", page: MainSettingsScreen()),
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

  HomeNavigationPreferences _resolvePrimaryPreferences({required String? userId, required String? libraryMediaType}) {
    final mediaType = HomeLibraryMediaType.fromLibraryMediaType(libraryMediaType);
    if (userId == null) {
      return HomeNavigationPreferencesCodec.defaultsFor(mediaType);
    }

    final settingKey = HomeNavigationPreferencesCodec.settingKeyFor(mediaType);
    final encodedDefault = HomeNavigationPreferencesCodec.defaultEncodedFor(mediaType);

    final rawSettingValue = ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<String>(userId, settingKey, defaultValue: encodedDefault);

    return HomeNavigationPreferencesCodec.decode(rawSettingValue, mediaType);
  }

  List<NavigationItemConfig> _visiblePrimaryItems({
    required HomeNavigationPreferences preferences,
    required bool isAdminUser,
  }) {
    final views = <HomePrimaryView>[];
    for (final view in preferences.visibleViews) {
      if (view == HomePrimaryView.podcastAdd && !isAdminUser) {
        continue;
      }
      views.add(view);
    }
    return views.map(_navigationItemForPrimaryView).toList(growable: false);
  }

  NavigationItemConfig _navigationItemForPrimaryView(HomePrimaryView view) {
    return NavigationItemConfig(icon: view.icon, label: view.label, page: _pageForPrimaryView(view));
  }

  Widget _pageForPrimaryView(HomePrimaryView view) {
    switch (view) {
      case HomePrimaryView.shelf:
        return const PersonalizedView();
      case HomePrimaryView.library:
        return const LibraryView();
      case HomePrimaryView.podcastAdd:
        return const PodcastAddView();
      case HomePrimaryView.collections:
        return const CollectionView();
      case HomePrimaryView.playlists:
        return const PlaylistView();
      case HomePrimaryView.series:
        return const SeriesView();
      case HomePrimaryView.authors:
        return const AuthorsView();
      case HomePrimaryView.narrators:
        return const NarratorsView();
    }
  }

  int _defaultPrimaryIndex(List<NavigationItemConfig> primaryItems, HomeNavigationPreferences primaryPreferences) {
    final mappedDefaultIndex = primaryItems.indexWhere((item) => item.label == primaryPreferences.defaultView.label);
    if (mappedDefaultIndex >= 0) {
      return mappedDefaultIndex;
    }

    if (primaryItems.isNotEmpty) {
      return 0;
    }

    return -1;
  }

  Widget _resolveCurrentContent(
    int selectedIndex,
    List<NavigationItemConfig> primaryItems,
    List<NavigationItemConfig> advancedMenuItems,
  ) {
    if (_currentlyDisplayedPageSource == _PageSource.child && widget.child != null) {
      return widget.child!;
    }
    if (_searchQuery.isNotEmpty) {
      return SearchView(query: _searchQuery, limit: _searchLimit);
    }
    if (selectedIndex < primaryItems.length) {
      return primaryItems[selectedIndex].page;
    }

    final advancedIndex = selectedIndex - primaryItems.length;
    if (advancedIndex >= 0 && advancedIndex < advancedMenuItems.length) {
      return advancedMenuItems[advancedIndex].page;
    }

    return primaryItems.first.page;
  }

  bool _isAdminType(String? userType) {
    final normalized = (userType ?? '').trim().toLowerCase();
    return normalized == 'admin' || normalized == 'root';
  }

  SidebarVariant _sidebarVariantFor({required bool isTablet, required bool isCollapsed}) {
    if (isCollapsed) {
      return SidebarVariant.collapsed;
    }
    return isTablet ? SidebarVariant.tabletExpanded : SidebarVariant.desktopExpanded;
  }

  void _onAppBarItemTapped(int index) {
    unawaited(_onAppBarItemTappedAsync(index));
  }

  Future<void> _onAppBarItemTappedAsync(int index) async {
    final canLeaveUploadPage = await _confirmLeaveUploadPageIfNeeded();
    if (!canLeaveUploadPage) {
      return;
    }

    final selectedLibrary = ref.read(selectedLibraryProvider);
    final currentUser = ref.read(currentUserProvider).value;
    final primaryPreferences = _resolvePrimaryPreferences(
      userId: currentUser?.id,
      libraryMediaType: selectedLibrary?.mediaType,
    );
    final primaryItems = _visiblePrimaryItems(
      preferences: primaryPreferences,
      isAdminUser: _isAdminType(currentUser?.type),
    );
    final canDownload = ref.read(currentUserProvider).value?.permissions.download ?? false;
    final advancedItems = _visibleAdvancedMenuItems(canDownload: canDownload);
    final combined = <NavigationItemConfig>[...primaryItems, ...advancedItems];

    if (index < 0 || index >= combined.length) {
      return;
    }

    final label = combined[index].label;

    final tabIntent = index < primaryItems.length
        ? (HomePrimaryView.fromLabel(label)?.tabIntent ?? _tabIntentForLabel(label))
        : _tabIntentForLabel(label);

    setState(() {
      _selectedIndex = index;
      _lastSelectedLabel = label;
      _currentlyDisplayedPageSource = _PageSource.internal;
      _searchQuery = '';
      _searchLimit = 5;
      _searchController.clear();
      _isMobileSearchExpanded = false;
      _isUploadPageVisible = false;
      _isUploadInProgress = false;
    });

    _syncRouteToTab(tabIntent);
  }

  String _tabIntentForLabel(String label) {
    final mappedPrimaryView = HomePrimaryView.fromLabel(label);
    if (mappedPrimaryView != null) {
      return mappedPrimaryView.tabIntent;
    }

    return switch (label) {
      'Downloads' => 'downloads',
      'Stats' => 'stats',
      'Settings' => 'settings',
      _ => 'shelf',
    };
  }

  void _syncRouteToTab(String tabIntent) {
    final uri = GoRouterState.of(context).uri;
    final currentTab = uri.queryParameters['tab'] ?? 'shelf';
    final isOnRootRoute = uri.path == '/';

    if (isOnRootRoute && currentTab == tabIntent) {
      return;
    }

    context.go('/?tab=$tabIntent&intent=${DateTime.now().microsecondsSinceEpoch}');
  }

  void _submitSearch(String value) {
    unawaited(_submitSearchAsync(value));
  }

  Future<void> _submitSearchAsync(String value) async {
    if (_isUploadPageVisible) {
      final canLeaveUploadPage = await _confirmLeaveUploadPageIfNeeded();
      if (!canLeaveUploadPage) {
        return;
      }
    }

    final query = value.trim();
    _searchDebounce?.cancel();
    setState(() {
      _currentlyDisplayedPageSource = _PageSource.internal;
      _searchQuery = query;
      _searchLimit = null;
      _isUploadPageVisible = false;
      _isUploadInProgress = false;
    });
  }

  void _onSearchChanged(String value) {
    if (_isUploadPageVisible) {
      return;
    }

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 250), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _currentlyDisplayedPageSource = _PageSource.internal;
        _searchQuery = value.trim();
        _searchLimit = 5;
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
      _searchLimit = 5;
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

  void _onUploadProgressChanged(bool isUploading) {
    if (!mounted || _isUploadInProgress == isUploading) {
      return;
    }

    setState(() {
      _isUploadInProgress = isUploading;
    });
  }

  Future<bool> _confirmLeaveUploadPageIfNeeded() async {
    if (!_isUploadPageVisible || !_isUploadInProgress) {
      return true;
    }

    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Leave upload page?'),
          content: const Text('Leaving this page now cancels active uploads. Continue?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Stay here')),
            FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Leave page')),
          ],
        );
      },
    );

    return shouldLeave == true;
  }

  void _openOrCloseUploadPage() {
    unawaited(_openOrCloseUploadPageAsync());
  }

  Future<void> _openOrCloseUploadPageAsync() async {
    if (_isUploadPageVisible) {
      final canLeave = await _confirmLeaveUploadPageIfNeeded();
      if (!canLeave || !mounted) {
        return;
      }

      setState(() {
        _isUploadPageVisible = false;
        _isUploadInProgress = false;
      });
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isUploadPageVisible = true;
      _currentlyDisplayedPageSource = _PageSource.internal;
      _searchQuery = '';
      _searchLimit = 5;
      _searchController.clear();
      _isMobileSearchExpanded = false;
    });
  }

  Widget _wrapWithUploadPageBackHandling(Widget child) {
    return PopScope(
      canPop: !_isUploadPageVisible,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop || !_isUploadPageVisible) {
          return;
        }

        final canLeave = await _confirmLeaveUploadPageIfNeeded();
        if (!canLeave || !mounted) {
          return;
        }

        setState(() {
          _isUploadPageVisible = false;
          _isUploadInProgress = false;
        });
      },
      child: child,
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
    if (_isBootstrapping()) {
      return const _LayoutHomeStartupScreen();
    }

    final currentUser = ref.watch(currentUserProvider).value;

    if (AaosService.instance.currentState.isAutomotiveDevice) {
      final aaosQuery = GoRouterState.of(context).uri.queryParameters;
      final isSettingsRoute = aaosQuery['tab'] == 'settings';

      if (widget.child != null) {
        return AaosSettingsScaffold(backTarget: AaosSettingsBackTarget.settingsHome, child: widget.child!);
      }

      if (isSettingsRoute) {
        return const AaosSettingsScaffold(backTarget: AaosSettingsBackTarget.mediaCenter, child: MainSettingsScreen());
      }

      if (currentUser != null && !_didRequestAaosMediaCenterLaunch) {
        _didRequestAaosMediaCenterLaunch = true;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!mounted) {
            return;
          }

          final launched = await AaosService.instance.launchMediaCenter(finishActivity: true);
          if (!mounted || launched) {
            return;
          }
        });
      }

      if (currentUser != null) {
        return const _LayoutHomeStartupScreen();
      }

      return const AaosSettingsScaffold(backTarget: AaosSettingsBackTarget.mediaCenter, child: MainSettingsScreen());
    }

    final bool isMobile = context.isMobile;
    final bool isTablet = context.isTablet;
    final selectedLibrary = ref.watch(selectedLibraryProvider);
    ref.watch(userSettingsWatcherProvider);
    final serverManagementPreferences = readServerManagementPreferences(ref, currentUser?.id);
    final canUpload =
        selectedLibrary != null &&
        (currentUser?.permissions.upload ?? false) &&
        serverManagementPreferences.uploadItemsEnabled;

    if (!canUpload && _isUploadPageVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _isUploadPageVisible = false;
          _isUploadInProgress = false;
        });
      });
    }

    final primaryPreferences = _resolvePrimaryPreferences(
      userId: currentUser?.id,
      libraryMediaType: selectedLibrary?.mediaType,
    );
    final primaryItems = _visiblePrimaryItems(
      preferences: primaryPreferences,
      isAdminUser: _isAdminType(currentUser?.type),
    );
    final canDownload = currentUser?.permissions.download ?? false;
    final advancedMenuItems = _visibleAdvancedMenuItems(canDownload: canDownload);

    final queryParameters = GoRouterState.of(context).uri.queryParameters;
    final tabIntent = queryParameters['tab'];
    final intentKey = queryParameters['intent'] ?? tabIntent;
    if (tabIntent != null && intentKey != null && intentKey != _lastConsumedTabIntent) {
      final targetPrimaryView = HomePrimaryView.fromTabIntent(tabIntent);
      final targetLabel =
          targetPrimaryView?.label ??
          switch (tabIntent) {
            'downloads' => 'Downloads',
            'stats' => 'Stats',
            'settings' => 'Settings',
            _ => primaryPreferences.defaultView.label,
          };

      final navigationItems = <NavigationItemConfig>[...primaryItems, ...advancedMenuItems];
      final targetIndex = navigationItems.indexWhere((item) => item.label == targetLabel);
      final fallbackIndex = _defaultPrimaryIndex(primaryItems, primaryPreferences);
      _lastConsumedTabIntent = intentKey;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _selectedIndex = targetIndex >= 0 ? targetIndex : (fallbackIndex >= 0 ? fallbackIndex : 0);
          _currentlyDisplayedPageSource = _PageSource.internal;
          _isUploadPageVisible = false;
          _isUploadInProgress = false;
          _lastSelectedLabel = navigationItems.isNotEmpty
              ? (targetIndex >= 0
                    ? navigationItems[targetIndex].label
                    : (fallbackIndex >= 0 ? navigationItems[fallbackIndex].label : navigationItems.first.label))
              : _lastSelectedLabel;
        });
      });
    }

    final shouldOpenUploadMode = queryParameters[LayoutHome.openUploadQueryKey] == LayoutHome.openUploadQueryValue;
    final uploadIntent = queryParameters[LayoutHome.uploadIntentQueryKey];
    if (shouldOpenUploadMode && uploadIntent != null && uploadIntent != _lastConsumedUploadIntent) {
      _lastConsumedUploadIntent = uploadIntent;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !canUpload) {
          return;
        }

        setState(() {
          _isUploadPageVisible = true;
          _currentlyDisplayedPageSource = _PageSource.internal;
          _searchQuery = '';
          _searchLimit = 5;
          _searchController.clear();
          _isMobileSearchExpanded = false;
        });
      });
    }

    final combinedItems = <NavigationItemConfig>[...primaryItems, ...advancedMenuItems];
    final maxIndex = combinedItems.length - 1;

    int computeSafeSelectedIndex() {
      if (_selectedIndex >= 0 && _selectedIndex <= maxIndex) {
        final matchesTrackedLabel =
            _lastSelectedLabel == null || combinedItems[_selectedIndex].label == _lastSelectedLabel;
        if (matchesTrackedLabel) {
          return _selectedIndex;
        }
      }

      if (_lastSelectedLabel != null) {
        final mapped = combinedItems.indexWhere((it) => it.label == _lastSelectedLabel);
        if (mapped >= 0) return mapped;
      }

      final fallbackPrimaryIndex = _defaultPrimaryIndex(primaryItems, primaryPreferences);
      if (fallbackPrimaryIndex >= 0) {
        return fallbackPrimaryIndex;
      }

      return maxIndex >= 0 ? 0 : 0;
    }

    final safeSelectedIndex = computeSafeSelectedIndex();

    if (_selectedIndex != safeSelectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _selectedIndex = safeSelectedIndex;
          _lastSelectedLabel = combinedItems.isNotEmpty ? combinedItems[safeSelectedIndex].label : _lastSelectedLabel;
        });
      });
    }

    final bool canExpandSidebar = !isMobile;
    final bool isSidebarCollapsed = !canExpandSidebar || _isSidebarCollapsed;
    final SidebarVariant sidebarVariant = _sidebarVariantFor(isTablet: isTablet, isCollapsed: isSidebarCollapsed);
    final resolvedContent = _resolveCurrentContent(safeSelectedIndex, primaryItems, advancedMenuItems);
    final Widget currentContent = (canUpload && _isUploadPageVisible)
        ? LibraryUploadPanel(
            selectedLibrary: selectedLibrary,
            onClose: _openOrCloseUploadPage,
            onUploadingChanged: _onUploadProgressChanged,
          )
        : resolvedContent;
    final multiSelectAppBarState = ref.watch(multiSelectAppBarProvider);

    if (isMobile) {
      return _wrapWithUploadPageBackHandling(
        Scaffold(
          body: Column(
            children: [
              if (multiSelectAppBarState != null)
                LayoutHomeMultiSelectAppBar(state: multiSelectAppBarState)
              else
                LayoutHomeMobileAppBar(
                  isSearchExpanded: _isMobileSearchExpanded,
                  searchController: _searchController,
                  searchQuery: _searchQuery,
                  advancedMenuItems: advancedMenuItems,
                  advancedMenuStartIndex: primaryItems.length,
                  onSearchChanged: _onSearchChanged,
                  onSearchSubmitted: _submitSearch,
                  onExpandSearch: _expandMobileSearch,
                  onCollapseSearch: _collapseMobileSearch,
                  onClearSearch: _clearSearch,
                  onAdvancedItemSelected: _onAppBarItemTapped,
                  showUploadAction: canUpload,
                  onUploadSelected: canUpload ? _openOrCloseUploadPage : null,
                ),

              Expanded(child: currentContent),
              StreamBuilder<bool>(
                stream: audioHandler.shouldShowPlayer,
                initialData: audioHandler.shouldShowPlayerNow,
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
                        items: primaryItems,
                        selectedIndex: safeSelectedIndex,
                        onItemTap: _onAppBarItemTapped,
                      ),
                    ),
                  );
                },
              ),
              const PlayBar(includeBottomSafeArea: true, attachedToBottom: true),
            ],
          ),
        ),
      );
    }

    return _wrapWithUploadPageBackHandling(
      Scaffold(
        body: Row(
          children: [
            SafeArea(
              top: true,
              bottom: false,
              left: true,
              right: false,
              child: LayoutHomeSidebar(
                variant: sidebarVariant,
                selectedIndex: safeSelectedIndex,
                primaryItems: primaryItems,
                secondaryItems: advancedMenuItems,
                onItemTap: _onAppBarItemTapped,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  if (multiSelectAppBarState != null)
                    LayoutHomeMultiSelectAppBar(
                      state: multiSelectAppBarState,
                      showSidebarToggle: true,
                      isSidebarCollapsed: isSidebarCollapsed,
                      onSidebarToggle: () => _setSidebarCollapsed(!isSidebarCollapsed),
                    )
                  else
                    LayoutHomeNonMobileAppBar(
                      isTablet: isTablet,
                      isSidebarCollapsed: isSidebarCollapsed,
                      searchController: _searchController,
                      searchQuery: _searchQuery,
                      onSearchChanged: _onSearchChanged,
                      onSearchSubmitted: _submitSearch,
                      onClearSearch: _clearSearch,
                      onSidebarToggle: () => _setSidebarCollapsed(!isSidebarCollapsed),
                      showUploadButton: canUpload,
                      onUploadPressed: canUpload ? _openOrCloseUploadPage : null,
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
