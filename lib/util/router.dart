import 'package:buchshelfly/components/player/player.dart';
import 'package:buchshelfly/screens/auth/sign_in.dart';
import 'package:buchshelfly/screens/layout_home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final globalRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/add-user', builder: (context, state) => SignIn()),
    GoRoute(path: '/player', builder: (context, state) => Player()),
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return child;
      },
      routes: [
        // For player
        ShellRoute(
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return child;
          },
          routes: [
            GoRoute(path: '/', builder: (context, state) => LayoutHome()),
            // For anything that should show the app bar. Responsive
            /* ShellRoute(
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return LayoutHome(child: child);
          },
          routes: [

          ],
        ),*/
          ],
        ),

        // TODO: For big player (to not have the smaller player in the bottom)
      ],
    ),
  ],
);
