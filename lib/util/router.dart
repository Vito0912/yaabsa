import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/auth_secret_store.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/auth/sign_in.dart';
import 'package:yaabsa/screens/item/library_item_view.dart';
import 'package:yaabsa/screens/layout_home.dart';
import 'package:yaabsa/screens/main/author_detail_view.dart';
import 'package:yaabsa/screens/main/collection_detail_view.dart';
import 'package:yaabsa/screens/main/narrator_detail_view.dart';
import 'package:yaabsa/screens/main/playlist_detail_view.dart';
import 'package:yaabsa/screens/main/series_detail_view.dart';
import 'package:yaabsa/screens/main/user_listening_sessions_view.dart';
import 'package:yaabsa/screens/player/play_history_view.dart';
import 'package:yaabsa/screens/player/player.dart';
import 'package:yaabsa/screens/player/subtitle_reading_mode.dart';
import 'package:yaabsa/screens/reader/reader.dart';
import 'package:yaabsa/features/settings/presentation/declarative_settings_page.dart';
import 'package:yaabsa/features/settings/presentation/settings_shell.dart';
import 'package:yaabsa/features/settings/registry/settings_registry.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/screens/settings/settings_screen.dart';
import 'package:yaabsa/util/aaos_service.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/desktop_navigation_history.dart';
import 'package:yaabsa/util/handler/tray_handler.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

const String _bootRoutePath = '/boot';

class _ActiveUserIdNotifier extends ChangeNotifier {
  _ActiveUserIdNotifier() : _db = containerRef.read(appDatabaseProvider) {
    _subscription = _db.watchGlobalSetting('activeUserId').listen((setting) {
      logger('[_ActiveUserIdNotifier] watchGlobalSetting emitted: ${setting?.value}', tag: 'Router');
      _updateState(setting?.value, initialized: true);
    });
    _currentUserSubscription = containerRef.listen<AsyncValue<User?>>(currentUserProvider, (previous, next) {
      if (isAuthSecretsUnavailableError(next.error)) {
        _updateKeyringUnavailable(true);
      } else if (next.hasValue) {
        _updateKeyringUnavailable(false);
      }
    }, fireImmediately: true);
    unawaited(_loadInitialValue());
  }

  final AppDatabase _db;
  late final StreamSubscription<dynamic> _subscription;
  late final ProviderSubscription<AsyncValue<User?>> _currentUserSubscription;
  String? _activeUserId;
  bool _isInitialized = false;
  bool _keyringUnavailable = false;

  String? get activeUserId => _activeUserId;
  bool get isInitialized => _isInitialized;
  bool get keyringUnavailable => _keyringUnavailable;

  Future<void> _loadInitialValue() async {
    if (_isInitialized) {
      return;
    }

    final initialUserId = (await _db.getGlobalSetting('activeUserId'))?.value;
    if (_isInitialized) {
      return;
    }

    _updateState(initialUserId, initialized: true);
  }

  void _updateState(String? nextUserId, {required bool initialized}) {
    final changed = _activeUserId != nextUserId || _isInitialized != initialized;
    logger(
      '[_ActiveUserIdNotifier] _updateState: currentActiveUserId=$_activeUserId, nextActiveUserId=$nextUserId, currentInitialized=$_isInitialized, nextInitialized=$initialized, changed=$changed',
      tag: 'Router',
    );
    _activeUserId = nextUserId;
    _isInitialized = initialized;

    if (changed) {
      logger('[_ActiveUserIdNotifier] calling notifyListeners()', tag: 'Router');
      notifyListeners();
    }
  }

  void _updateKeyringUnavailable(bool unavailable) {
    if (_keyringUnavailable == unavailable) {
      return;
    }

    _keyringUnavailable = unavailable;
    logger(
      '[_ActiveUserIdNotifier] keyring unavailable state changed to $unavailable',
      tag: 'Router',
      level: InfoLevel.warning,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _currentUserSubscription.close();
    super.dispose();
  }
}

final _activeUserIdNotifier = _ActiveUserIdNotifier();

Page<void> _buildAdaptiveHomeShellPage(BuildContext context, GoRouterState state, Widget child) {
  return NoTransitionPage<void>(key: state.pageKey, child: child);
}

Page<void> _buildPersistentSettingsShellPage(BuildContext context, GoRouterState state, Widget child) {
  final matchedPage = SettingsRegistry.instance.findPageByRoute(state.uri.path);

  return NoTransitionPage<void>(
    key: const ValueKey<String>('settings-persistent-shell'),
    child: SettingsShell(
      initialPageId: matchedPage?.id,
      focusEntryId: state.uri.queryParameters['focus'],
      focusToken: state.uri.queryParameters['t'],
      detailChild: child,
    ),
  );
}

Page<void> _buildSettingsDetailPage(BuildContext context, GoRouterState state, String pageId) {
  final child = DeclarativeSettingsPage(
    pageId: pageId,
    focusEntryId: state.uri.queryParameters['focus'],
    focusToken: state.uri.queryParameters['t'],
  );

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS && context.isMobile) {
    return MaterialPage<void>(key: state.pageKey, child: child);
  }

  return NoTransitionPage<void>(key: state.pageKey, child: child);
}

final desktopNavigationHistory = DesktopNavigationHistory();

final globalRouter = GoRouter(
  observers: [desktopNavigationHistory.createObserver()],
  initialLocation: '/',
  refreshListenable: _activeUserIdNotifier,
  redirect: (context, state) {
    final activeUserId = _activeUserIdNotifier.activeUserId;
    final isBootRoute = state.matchedLocation == _bootRoutePath;
    final isLoginRoute = state.matchedLocation == '/add-user';

    if (!_activeUserIdNotifier.isInitialized) {
      return isBootRoute ? null : _bootRoutePath;
    }

    if (_activeUserIdNotifier.keyringUnavailable && !isLoginRoute) {
      return '/add-user?keyringLocked=1';
    }

    if (isBootRoute) {
      return activeUserId == null ? '/add-user' : '/';
    }

    if (activeUserId == null && !isLoginRoute) {
      return '/add-user';
    }

    if (AaosService.instance.currentState.isAutomotiveDevice) {
      final loc = state.matchedLocation;
      final isSettingsRoute = loc == MainSettingsScreen.routeName || loc.startsWith('/settings/');

      if (loc != '/' && !isLoginRoute && !isSettingsRoute) {
        return '/?tab=settings';
      }
    }

    return null;
  },
  routes: [
    ShellRoute(
      observers: [desktopNavigationHistory.createObserver()],
      builder: (BuildContext context, GoRouterState state, Widget child) {
        if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
          return TrayManager(child);
        }
        return child;
      },
      routes: [
        GoRoute(path: _bootRoutePath, builder: (context, state) => const _AppStartupScreen()),
        GoRoute(path: '/add-user', builder: (context, state) => SignIn()),
        GoRoute(
          path: '/player',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 320),
            reverseTransitionDuration: const Duration(milliseconds: 260),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final curvedAnimation = CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              );

              return SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(curvedAnimation),
                child: RepaintBoundary(child: child),
              );
            },
            child: const Player(),
          ),
        ),
        GoRoute(
          path: '/ebook/:id',
          builder: (context, state) => Reader(itemId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: PlayHistoryView.routeName,
          builder: (context, state) {
            final itemId = state.uri.queryParameters['itemId'];
            final episodeId = state.uri.queryParameters['episodeId'];
            final itemTitle = state.uri.queryParameters['itemTitle'];
            return PlayHistoryView(itemId: itemId, episodeId: episodeId, itemTitle: itemTitle);
          },
        ),
        ShellRoute(
          observers: [desktopNavigationHistory.createObserver()],
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return child;
          },
          routes: [
            GoRoute(
              path: MainSettingsScreen.routeName,
              redirect: (context, state) => '/?tab=settings&intent=settings-main',
            ),
            ShellRoute(
              observers: [desktopNavigationHistory.createObserver()],
              builder: (BuildContext context, GoRouterState state, Widget child) {
                return child;
              },
              routes: [
                GoRoute(path: '/', builder: (context, state) => LayoutHome()),
                ShellRoute(
                  observers: [desktopNavigationHistory.createObserver()],
                  pageBuilder: (BuildContext context, GoRouterState state, Widget child) {
                    return _buildAdaptiveHomeShellPage(context, state, LayoutHome(child: child));
                  },
                  routes: [
                    ShellRoute(
                      observers: [desktopNavigationHistory.createObserver()],
                      pageBuilder: (BuildContext context, GoRouterState state, Widget child) {
                        return _buildPersistentSettingsShellPage(context, state, child);
                      },
                      routes: [
                        for (final page in SettingsRegistry.instance.allPages)
                          if (page.registerRoute)
                            GoRoute(
                              path: page.route,
                              pageBuilder: (context, state) => _buildSettingsDetailPage(context, state, page.id),
                            ),
                        GoRoute(
                          path: SettingsRoutes.legacyCachingGeneral,
                          redirect: (context, state) => SettingsRoutes.caching,
                        ),
                        GoRoute(
                          path: SettingsRoutes.legacyGlobalPlayer,
                          redirect: (context, state) => SettingsRoutes.playerStartupBackground,
                        ),
                      ],
                    ),
                    GoRoute(
                      path: '/item/:id',
                      builder: (context, state) => LibraryItemView(
                        state.pathParameters['id']!,
                        initialEditorTab: state.uri.queryParameters['editor'],
                        initialEpisodeId: state.uri.queryParameters['episodeId'],
                      ),
                    ),
                    GoRoute(
                      path: SubtitleReadingModeView.routeName,
                      builder: (context, state) => const SubtitleReadingModeView(),
                    ),
                    GoRoute(
                      path: '/author/:id',
                      builder: (context, state) => AuthorDetailView(authorId: state.pathParameters['id']!),
                    ),
                    GoRoute(
                      path: '/narrator/:name',
                      builder: (context, state) => NarratorDetailView(narratorName: state.pathParameters['name']!),
                    ),
                    GoRoute(
                      path: '/collection/:id',
                      builder: (context, state) {
                        final extra = state.extra;
                        final initialEntry = extra is MultiBookEntryData ? extra : null;
                        return CollectionDetailView(
                          collectionId: state.pathParameters['id']!,
                          libraryId: state.uri.queryParameters['libraryId'],
                          initialEntry: initialEntry,
                        );
                      },
                    ),
                    GoRoute(
                      path: '/playlist/:id',
                      builder: (context, state) {
                        final extra = state.extra;
                        final initialEntry = extra is MultiBookEntryData ? extra : null;
                        return PlaylistDetailView(
                          playlistId: state.pathParameters['id']!,
                          libraryId: state.uri.queryParameters['libraryId'],
                          initialEntry: initialEntry,
                        );
                      },
                    ),
                    GoRoute(
                      path: '/series/:id',
                      builder: (context, state) {
                        final extra = state.extra;
                        final initialEntry = extra is MultiBookEntryData ? extra : null;
                        return SeriesDetailView(seriesId: state.pathParameters['id']!, initialEntry: initialEntry);
                      },
                    ),
                    GoRoute(
                      path: UserListeningSessionsView.routeName,
                      pageBuilder: (context, state) {
                        const child = UserListeningSessionsView();
                        if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS && context.isMobile) {
                          return MaterialPage<void>(key: state.pageKey, child: child);
                        }

                        return NoTransitionPage<void>(key: state.pageKey, child: child);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

class _AppStartupScreen extends StatelessWidget {
  const _AppStartupScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: const SizedBox(width: 28, height: 28, child: YaabsaCircularProgressIndicator(strokeWidth: 2.6)),
        ),
      ),
    );
  }
}
