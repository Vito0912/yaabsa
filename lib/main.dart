import 'dart:async';

import 'package:buchshelfly/database/app_database.dart';
import 'package:buchshelfly/util/globals.dart' show appName, audioHandler, containerRef;
import 'package:buchshelfly/util/init.dart' show Init;
import 'package:buchshelfly/util/logger.dart';
import 'package:buchshelfly/util/router.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runZonedGuarded(
    () async {
      await containerRef.read(globalSettingsManagerProvider.future);
      await containerRef.read(userSettingsManagerProvider.future);
      Init.initLogger();
      audioHandler = await Init.initAudioHandler();
      await Init.globals();
      // Preload the database
      containerRef.read(appDatabaseProvider);
      runApp(UncontrolledProviderScope(container: containerRef, child: MyApp()));
    },
    (error, stack) {
      logger('Uncaught Dart error: $error\n$stack', tag: 'ZoneError', level: InfoLevel.error);
    },
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: globalRouter,
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark)),
    );
  }
}
