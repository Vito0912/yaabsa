import 'dart:async';

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
import 'package:yaabsa/screens/settings/android_auto_settings.dart';
import 'package:yaabsa/screens/reader/reader.dart';
import 'package:yaabsa/screens/settings/appearance_settings.dart';
import 'package:yaabsa/screens/settings/caching_settings.dart';
import 'package:yaabsa/screens/settings/global_player_settings.dart';
import 'package:yaabsa/screens/settings/library_settings.dart';
import 'package:yaabsa/screens/settings/player_settings.dart';
import 'package:yaabsa/screens/settings/reader_settings.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        GoRoute(path: GlobalPlayerSettings.routeName, builder: (context, state) => GlobalPlayerSettings()),
        GoRoute(path: PlayerSettings.routeName, builder: (context, state) => PlayerSettings()),
        GoRoute(path: AppearanceSettings.routeName, builder: (context, state) => AppearanceSettings()),
        GoRoute(path: CachingSettings.routeName, builder: (context, state) => CachingSettings()),
        GoRoute(path: LibrarySettings.routeName, builder: (context, state) => LibrarySettings()),
        GoRoute(path: AndroidAutoSettings.routeName, builder: (context, state) => AndroidAutoSettings()),
        GoRoute(path: ReaderSettings.routeName, builder: (context, state) => ReaderSettings()),
        // For player
        ShellRoute(
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return child;
          },
          routes: [
            GoRoute(path: '/', builder: (context, state) => LayoutHome()),
            // For anything that should show the app bar. Responsive
            ShellRoute(
              builder: (BuildContext context, GoRouterState state, Widget child) {
                return LayoutHome(child: child);
              },
              routes: [
                GoRoute(path: '/item/:id', builder: (context, state) => LibraryItemView(state.pathParameters['id']!)),
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
                    return CollectionDetailView(collectionId: state.pathParameters['id']!, initialEntry: initialEntry);
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
