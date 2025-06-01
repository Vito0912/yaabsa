import 'package:yaabsa/screens/auth/sign_in.dart';
import 'package:yaabsa/screens/item/library_item_view.dart';
import 'package:yaabsa/screens/layout_home.dart';
import 'package:yaabsa/screens/player/play_history_view.dart';
import 'package:yaabsa/screens/player/player.dart';
import 'package:yaabsa/screens/reader/reader.dart';
import 'package:yaabsa/screens/settings/appearance_settings.dart';
import 'package:yaabsa/screens/settings/caching_settings.dart';
import 'package:yaabsa/screens/settings/global_player_settings.dart';
import 'package:yaabsa/screens/settings/library_settings.dart';
import 'package:yaabsa/screens/settings/player_settings.dart';
import 'package:yaabsa/screens/settings/reader_settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final globalRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/add-user', builder: (context, state) => SignIn()),
    GoRoute(path: '/player', builder: (context, state) => Player()),
    GoRoute(path: '/ebook/:id', builder: (context, state) => Reader(itemId: state.pathParameters['id']!)),
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
              ],
            ),
          ],
        ),

        // TODO: For big player (to not have the smaller player in the bottom)
      ],
    ),
  ],
);
