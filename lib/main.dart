import 'dart:async';

import 'package:buchshelfly/database/settings_manager.dart';
import 'package:buchshelfly/provider/core/server_status_provider.dart';
import 'package:buchshelfly/provider/core/user_providers.dart';
import 'package:buchshelfly/util/globals.dart' show appName, audioHandler, containerRef;
import 'package:buchshelfly/util/init.dart' show Init;
import 'package:buchshelfly/util/logger.dart';
import 'package:buchshelfly/util/router.dart';
import 'package:buchshelfly/util/setting_key.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runZonedGuarded(
    () async {
      await Init.globals();
      await containerRef.read(settingsManagerProvider.future);
      await containerRef.read(currentUserProvider.future);
      await containerRef.read(serverStatusProvider.future);
      Init.initLogger();
      audioHandler = await Init.initAudioHandler();

      Init.late();
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
    ref.watch(globalSettingByKeyProvider(SettingKeys.appThemeMode));
    final appTheme = ref.read(settingsManagerProvider.notifier).getGlobalSetting<String>(SettingKeys.appThemeMode);

    return MaterialApp.router(
      routerConfig: globalRouter,
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness:
              {
                AppThemeMode.dark.toString(): Brightness.dark,
                AppThemeMode.light.toString(): Brightness.light,
                AppThemeMode.system.toString(): Theme.of(context).brightness,
              }[appTheme] ??
              Brightness.light,
        ),
      ),
    );
  }
}
