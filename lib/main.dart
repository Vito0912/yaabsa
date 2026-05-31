import 'dart:async';

import 'package:yaabsa/components/common/android_edge_to_edge_inset_guard.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/socket_provider.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart' show appName, audioHandler, containerRef;
import 'package:yaabsa/util/aaos_service.dart';
import 'package:yaabsa/util/app_theme.dart';
import 'package:yaabsa/util/handler/tray_handler.dart' show TrayManager;
import 'package:yaabsa/util/init.dart' show Init;
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/router.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> _resumeLastPlayedOnStartup() async {
  try {
    await containerRef.read(currentUserProvider.future);
    await audioHandler.playLastPlayedIfEnabledOnStartup();
  } catch (e, s) {
    logger('Startup last-played resume failed: $e\\n$s', tag: 'Main', level: InfoLevel.warning);
  }
}

int _parseColorChannelSetting(String? value, int fallback) {
  final parsed = int.tryParse(value ?? '');
  return (parsed ?? fallback).clamp(0, 255).toInt();
}

Future<void> _configureAndroidEdgeToEdge() async {
  if (defaultTargetPlatform != TargetPlatform.android) {
    return;
  }

  if (AaosService.instance.currentState.isAutomotiveDevice) {
    return;
  }

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
      await AaosService.instance.initialize();
      TrayManager.update();

      Init.late();
      await _configureAndroidEdgeToEdge();
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
    final appThemeModeSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.appThemeMode)).asData?.value;
    final appThemePresetSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.appThemePreset)).asData?.value;
    final customRedSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.appThemeCustomRed)).asData?.value;
    final customGreenSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.appThemeCustomGreen)).asData?.value;
    final customBlueSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.appThemeCustomBlue)).asData?.value;
    final appLogLevelSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.appLogLevel)).asData?.value;

    appLoggerService.setMinimumLevel(InfoLevel.fromSettingValue(appLogLevelSetting));

    final appThemeMode = AppThemeMode.fromSettingValue(appThemeModeSetting);
    final appThemePreset = AppThemePreset.fromSettingValue(appThemePresetSetting);
    final useAmoledDark = appThemeMode == AppThemeMode.amoled;
    final materialThemeMode = useAmoledDark ? ThemeMode.dark : toMaterialThemeMode(appThemeMode);

    final defaultRed = defaultSettings[SettingKeys.appThemeCustomRed] as int? ?? 15;
    final defaultGreen = defaultSettings[SettingKeys.appThemeCustomGreen] as int? ?? 118;
    final defaultBlue = defaultSettings[SettingKeys.appThemeCustomBlue] as int? ?? 110;

    final customSeedColor = Color.fromARGB(
      0xFF,
      _parseColorChannelSetting(customRedSetting, defaultRed),
      _parseColorChannelSetting(customGreenSetting, defaultGreen),
      _parseColorChannelSetting(customBlueSetting, defaultBlue),
    );

    return MaterialApp.router(
      routerConfig: globalRouter,
      title: appName,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        if (child == null) {
          return const SizedBox.shrink();
        }

        return AndroidEdgeToEdgeInsetGuard(child: child);
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      themeMode: materialThemeMode,
      theme: buildAppThemeData(
        brightness: Brightness.light,
        preset: appThemePreset,
        customSeedColor: customSeedColor,
        useAmoledDark: useAmoledDark,
      ),
      darkTheme: buildAppThemeData(
        brightness: Brightness.dark,
        preset: appThemePreset,
        customSeedColor: customSeedColor,
        useAmoledDark: useAmoledDark,
      ),
    );
  }
}
