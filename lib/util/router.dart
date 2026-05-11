import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/common/multi_book_entry_widget.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/screens/auth/sign_in.dart';
import 'package:yaabsa/screens/item/library_item_view.dart';
import 'package:yaabsa/screens/layout_home.dart';
import 'package:yaabsa/screens/main/author_detail_view.dart';
import 'package:yaabsa/screens/main/collection_detail_view.dart';
import 'package:yaabsa/screens/main/narrator_detail_view.dart';
import 'package:yaabsa/screens/main/playlist_detail_view.dart';
import 'package:yaabsa/screens/main/series_detail_view.dart';
import 'package:yaabsa/screens/player/play_history_view.dart';
import 'package:yaabsa/screens/player/player.dart';
import 'package:yaabsa/screens/player/subtitle_reading_mode.dart';
import 'package:yaabsa/screens/reader/reader.dart';
import 'package:yaabsa/screens/settings/android_auto/android_auto_library_settings.dart';
import 'package:yaabsa/screens/settings/android_auto/android_auto_podcast_library_settings.dart';
import 'package:yaabsa/screens/settings/android_auto_settings.dart';
import 'package:yaabsa/screens/settings/appearance_settings.dart';
import 'package:yaabsa/screens/settings/caching/caching_general_settings.dart';
import 'package:yaabsa/screens/settings/caching/caching_route_settings.dart';
import 'package:yaabsa/screens/settings/caching_settings.dart';
import 'package:yaabsa/screens/settings/library_settings.dart';
import 'package:yaabsa/screens/settings/player/global_player_settings.dart';
import 'package:yaabsa/screens/settings/player/player_settings.dart';
import 'package:yaabsa/screens/settings/player/player_settings_general.dart';
import 'package:yaabsa/screens/settings/player/player_settings_shake_controls.dart';
import 'package:yaabsa/screens/settings/player/player_settings_sleep_timer.dart';
import 'package:yaabsa/screens/settings/player/player_settings_smart_rewind.dart';
import 'package:yaabsa/screens/settings/player/player_settings_subtitles.dart';
import 'package:yaabsa/screens/settings/reader_settings.dart';
import 'package:yaabsa/screens/settings/server_connection_settings.dart';
import 'package:yaabsa/screens/settings/settings_screen.dart';
import 'package:yaabsa/screens/settings/theme_settings.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/handler/tray_handler.dart';

const String _bootRoutePath = '/boot';

class _ActiveUserIdNotifier extends ChangeNotifier {
  _ActiveUserIdNotifier() : _db = containerRef.read(appDatabaseProvider) {
    _subscription = _db.watchGlobalSetting('activeUserId').listen((setting) {
      _updateState(setting?.value, initialized: true);
    });
    unawaited(_loadInitialValue());
  }

  final AppDatabase _db;
  late final StreamSubscription<dynamic> _subscription;
  String? _activeUserId;
  bool _isInitialized = false;

  String? get activeUserId => _activeUserId;
  bool get isInitialized => _isInitialized;

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
    _activeUserId = nextUserId;
    _isInitialized = initialized;

    if (changed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final _activeUserIdNotifier = _ActiveUserIdNotifier();

final globalRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: _activeUserIdNotifier,
  redirect: (context, state) {
    final activeUserId = _activeUserIdNotifier.activeUserId;
    final isBootRoute = state.matchedLocation == _bootRoutePath;
    final isLoginRoute = state.matchedLocation == '/add-user';

    if (!_activeUserIdNotifier.isInitialized) {
      return isBootRoute ? null : _bootRoutePath;
    }

    if (isBootRoute) {
      return activeUserId == null ? '/add-user' : '/';
    }

    if (activeUserId == null && !isLoginRoute) {
      return '/add-user';
    }

    return null;
  },
  routes: [
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
          return TrayManager(child);
        }
        return child;
      },
      routes: [
        GoRoute(path: _bootRoutePath, builder: (context, state) => const _AppStartupScreen()),
        GoRoute(path: '/add-user', builder: (context, state) => SignIn()),
        GoRoute(path: '/player', builder: (context, state) => Player()),
        GoRoute(
          path: '/ebook/:id',
          builder: (context, state) => Reader(itemId: state.pathParameters['id']!),
        ),
        GoRoute(path: PlayHistoryView.routeName, builder: (context, state) => PlayHistoryView()),
        ShellRoute(
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return child;
          },
          routes: [
            GoRoute(
              path: MainSettingsScreen.routeName,
              redirect: (context, state) => '/?tab=settings&intent=settings-main',
            ),
            ShellRoute(
              builder: (BuildContext context, GoRouterState state, Widget child) {
                return child;
              },
              routes: [
                GoRoute(path: '/', builder: (context, state) => LayoutHome()),
                ShellRoute(
                  builder: (BuildContext context, GoRouterState state, Widget child) {
                    return LayoutHome(child: child);
                  },
                  routes: [
                    GoRoute(path: AppearanceSettings.routeName, builder: (context, state) => AppearanceSettings()),
                    GoRoute(path: ThemeSettings.routeName, builder: (context, state) => const ThemeSettings()),
                    GoRoute(path: GlobalPlayerSettings.routeName, builder: (context, state) => GlobalPlayerSettings()),
                    GoRoute(path: LibrarySettings.routeName, builder: (context, state) => LibrarySettings()),
                    GoRoute(path: AndroidAutoSettings.routeName, builder: (context, state) => AndroidAutoSettings()),
                    GoRoute(path: CachingSettings.routeName, builder: (context, state) => CachingSettings()),
                    GoRoute(
                      path: ServerConnectionSettings.routeName,
                      builder: (context, state) => const ServerConnectionSettings(),
                    ),
                    GoRoute(
                      path: CachingGeneralSettings.routeName,
                      builder: (context, state) => CachingGeneralSettings(),
                    ),
                    GoRoute(path: CachingRouteSettings.routeName, builder: (context, state) => CachingRouteSettings()),
                    GoRoute(path: PlayerSettings.routeName, builder: (context, state) => PlayerSettings()),
                    GoRoute(path: ReaderSettings.routeName, builder: (context, state) => ReaderSettings()),
                    GoRoute(
                      path: PlayerSettingsGeneral.routeName,
                      builder: (context, state) => PlayerSettingsGeneral(),
                    ),
                    GoRoute(
                      path: PlayerSettingsSmartRewind.routeName,
                      builder: (context, state) => PlayerSettingsSmartRewind(),
                    ),
                    GoRoute(
                      path: PlayerSettingsSleepTimer.routeName,
                      builder: (context, state) => PlayerSettingsSleepTimer(),
                    ),
                    GoRoute(
                      path: PlayerSettingsSubtitles.routeName,
                      builder: (context, state) => PlayerSettingsSubtitles(),
                    ),
                    GoRoute(
                      path: PlayerSettingsShakeControls.routeName,
                      builder: (context, state) => PlayerSettingsShakeControls(),
                    ),
                    GoRoute(
                      path: AndroidAutoLibrarySettings.routeName,
                      builder: (context, state) => AndroidAutoLibrarySettings(),
                    ),
                    GoRoute(
                      path: AndroidAutoPodcastLibrarySettings.routeName,
                      builder: (context, state) => AndroidAutoPodcastLibrarySettings(),
                    ),
                    GoRoute(
                      path: '/item/:id',
                      builder: (context, state) => LibraryItemView(state.pathParameters['id']!),
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
                      builder: (context, state) =>
                          NarratorDetailView(narratorName: Uri.decodeComponent(state.pathParameters['name']!)),
                    ),
                    GoRoute(
                      path: '/collection/:id',
                      builder: (context, state) {
                        final extra = state.extra;
                        final initialEntry = extra is MultiBookEntryData ? extra : null;
                        return CollectionDetailView(
                          collectionId: state.pathParameters['id']!,
                          initialEntry: initialEntry,
                        );
                      },
                    ),
                    GoRoute(
                      path: '/playlist/:id',
                      builder: (context, state) {
                        final extra = state.extra;
                        final initialEntry = extra is MultiBookEntryData ? extra : null;
                        return PlaylistDetailView(playlistId: state.pathParameters['id']!, initialEntry: initialEntry);
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
        child: Center(child: const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 2.6))),
      ),
    );
  }
}
