import 'dart:async';

import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/socket_provider.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart' show appName, audioHandler, containerRef;
import 'package:yaabsa/util/aaos_service.dart';
import 'package:yaabsa/util/chrome_cast_service.dart';
import 'package:yaabsa/util/handler/tray_handler.dart' show TrayManager;
import 'package:yaabsa/util/init.dart' show Init;
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/router.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> _resumeLastPlayedOnStartup() async {
  try {
    await containerRef.read(currentUserProvider.future);
    await audioHandler.playLastPlayedIfEnabledOnStartup();
  } catch (e, s) {
    logger('Startup last-played resume failed: $e\\n$s', tag: 'Main', level: InfoLevel.warning);
  }
}

void main() {
  runZonedGuarded(
    () async {
      await Init.globals();
      final settingsManager = containerRef.read(settingsManagerProvider.notifier);
      await settingsManager.ensureInitialized();

      final startupLogLevelSetting = settingsManager.getGlobalSetting<String>(
        SettingKeys.appLogLevel,
        defaultValue: InfoLevel.warning.toString(),
      );
      appLoggerService.setMinimumLevel(InfoLevel.fromSettingValue(startupLogLevelSetting));

      unawaited(containerRef.read(currentUserProvider.future));
      unawaited(containerRef.read(serverStatusProvider.future));
      containerRef.read(absSocketClientProvider);
      Init.initLogger();
      audioHandler = await Init.initAudioHandler();
      unawaited(AaosService.instance.initialize());
      unawaited(ChromeCastService.ensureInitialized());
      TrayManager.update();

      Init.late();
      runApp(UncontrolledProviderScope(container: containerRef, child: MyApp()));
      unawaited(_resumeLastPlayedOnStartup());
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
    final appLogLevelSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.appLogLevel)).asData?.value;

    appLoggerService.setMinimumLevel(InfoLevel.fromSettingValue(appLogLevelSetting));

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
