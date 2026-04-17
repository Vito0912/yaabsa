import 'dart:async';

import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart' show appName, audioHandler, containerRef;
import 'package:yaabsa/util/init.dart' show Init;
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/router.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runZonedGuarded(
    () async {
      await Init.globals();
      await containerRef.read(settingsManagerProvider.notifier).ensureInitialized();
      unawaited(containerRef.read(currentUserProvider.future));
      unawaited(containerRef.read(serverStatusProvider.future));
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
    final appThemeSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.appThemeMode)).asData?.value;
    final appTheme = appThemeSetting ?? (defaultSettings[SettingKeys.appThemeMode] as String);

    return MaterialApp.router(
      routerConfig: globalRouter,
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E),
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
