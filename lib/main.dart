import 'dart:async';

import 'package:buchshelfly/components/app/server_status.dart';
import 'package:buchshelfly/screens/auth/sign_in.dart';
import 'package:buchshelfly/screens/home_screen.dart';
import 'package:buchshelfly/util/globals.dart' show audioHandler;
import 'package:buchshelfly/util/init.dart' show Init;
import 'package:buchshelfly/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'components/player/play_bar.dart' show PlayBar;

void main() async {
  Init.initLogger();
  audioHandler = await Init.initAudioHandler();

  runZonedGuarded(
    () {
      runApp(const ProviderScope(child: MyApp()));
    },
    (error, stack) {
      logger(
        'Uncaught Dart error: $error\n$stack',
        tag: 'ZoneError',
        level: InfoLevel.error,
      );
    },
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Buchshelfly'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    // The 'context' used here is MyApp's context due to lexical scoping
                    Navigator.of(
                      context, // This 'context' is from MyApp.build()
                      rootNavigator: true,
                    ).push(
                      MaterialPageRoute(builder: (context) => const SignIn()),
                    );
                  },
                ),
                ServerStatus()
              ],
            ),
            body: Column(
              children: [Expanded(child: const HomeScreen()), const PlayBar()],
            ),
          );
        },
      ),
    );
  }
}
