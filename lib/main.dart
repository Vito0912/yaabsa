import 'dart:async';

import 'package:yaabsa/components/common/android_edge_to_edge_inset_guard.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/socket_provider.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/wear/wear_providers.dart';
import 'package:yaabsa/util/globals.dart' show appName, audioHandler, containerRef, isAudioHandlerInitialized;
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
    await audioHandler.restoreLastPlayedMiniPlayerIfEnabled();
  } catch (e, s) {
    logger('Startup last-played resume failed: $e\\n$s', tag: 'Main', level: InfoLevel.warning);
  }
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
      isAudioHandlerInitialized = true;
      await AaosService.instance.initialize();
      TrayManager.update();

      Init.late();
      initPhoneWearHandler();
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
    final appLogLevelSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.appLogLevel)).asData?.value;

    appLoggerService.setMinimumLevel(InfoLevel.fromSettingValue(appLogLevelSetting));

    final themeSelection = watchAppThemeSelection(ref);

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
      themeMode: themeSelection.materialThemeMode,
      theme: themeSelection.themeData(Brightness.light),
      darkTheme: themeSelection.themeData(Brightness.dark),
    );
  }
}
