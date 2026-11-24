import 'dart:async';

import 'package:yaabsa/components/common/android_edge_to_edge_inset_guard.dart';
import 'package:yaabsa/components/common/app_startup_view.dart';
import 'package:yaabsa/components/common/desktop_navigation_controls.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/core/socket_provider.dart';
import 'package:yaabsa/provider/library/smart_download_provider.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/core/oidc_provider.dart';
import 'package:yaabsa/provider/wear/wear_providers.dart';
import 'package:yaabsa/util/globals.dart'
    show appName, audioHandler, containerRef, isAudioHandlerInitialized, packageInfo;
import 'package:yaabsa/util/aaos_service.dart';
import 'package:yaabsa/util/app_theme.dart';
import 'package:yaabsa/util/changelog.dart';
import 'package:yaabsa/util/handler/tray_handler.dart' show TrayManager;
import 'package:yaabsa/util/handler/desktop_window_state.dart';
import 'package:yaabsa/util/init.dart' show Init;
import 'package:yaabsa/util/reader/reader_speech_providers.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/router.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> _resumeLastPlayedOnStartup() async {
  try {
    if (AaosService.instance.currentState.isAutomotiveDevice) {
      return;
    }

    await containerRef.read(currentUserProvider.future);

    if (isAudioHandlerInitialized) {
      await audioHandler.playLastPlayedIfEnabledOnStartup();
    }
  } catch (e, s) {
    logger('Startup last-played resume failed: $e\n$s', tag: 'Main', level: InfoLevel.warning);
  }
}

Future<void> _configureAndroidEdgeToEdge() async {
  if (defaultTargetPlatform != TargetPlatform.android) {
    return;
  }

  if (AaosService.instance.currentState.isAutomotiveDevice) {
    return;
  }

  try {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge).timeout(const Duration(seconds: 2));
  } catch (e, s) {
    logger('Failed to configure edge-to-edge UI: $e\n$s', tag: 'Main', level: InfoLevel.warning);
  }
}

void main() {
  runZonedGuarded(
    () async {
      await Init.globals();

      final settingsManager = containerRef.read(settingsManagerProvider.notifier);

      await settingsManager.ensureInitialized();

      try {
        await Changelog.prepareStartup(settingsManager, packageInfo.version);
      } catch (error, stack) {
        logger('Changelog initialization failed: $error\n$stack', tag: 'Changelog', level: InfoLevel.warning);
      }

      registerReaderSpeechProviders(containerRef);

      final startupLogLevelSetting = settingsManager.getGlobalSetting<String>(
        SettingKeys.appLogLevel,
        defaultValue: InfoLevel.warning.toString(),
      );

      appLoggerService.setMinimumLevel(InfoLevel.fromSettingValue(startupLogLevelSetting));

      unawaited(containerRef.read(currentUserProvider.future));
      unawaited(containerRef.read(serverStatusProvider.future));
      containerRef.read(absSocketClientProvider);
      containerRef.read(oidcStateProvider.notifier).initializeDeepLinkListener();
      Init.initLogger();

      await DesktopWindowState.initialize(settingsManager);

      final initialization = _initializePlayback();
      unawaited(
        initialization.catchError((Object error, StackTrace stack) {
          logger('Startup initialization failed: $error\n$stack', tag: 'Main', level: InfoLevel.error);
        }),
      );

      runApp(
        UncontrolledProviderScope(
          container: containerRef,
          child: MyApp(initialization: initialization),
        ),
      );
    },
    (error, stack) {
      logger('Uncaught Dart error: $error\n$stack', tag: 'ZoneError', level: InfoLevel.error);
    },
  );
}

Future<void> _initializePlayback() async {
  final handler = await Init.initAudioHandler();

  audioHandler = handler;
  unawaited(handler.restoreLastPlayedMiniPlayerIfEnabled());

  try {
    await AaosService.instance.initialize().timeout(const Duration(seconds: 2));
  } catch (error, stack) {
    logger('AaosService initialization failed: $error\n$stack', tag: 'Main', level: InfoLevel.error);
  }

  await Init.late();

  if (!AaosService.instance.currentState.isAutomotiveDevice) {
    initPhoneWearHandler();
  }

  WidgetsBinding.instance.addPostFrameCallback((_) {
    unawaited(
      _finishPlaybackStartup().catchError((Object error, StackTrace stack) {
        logger('Post-frame startup failed: $error\n$stack', tag: 'Main', level: InfoLevel.error);
      }),
    );
  });
}

Future<void> _finishPlaybackStartup() async {
  await TrayManager.update();
  await _configureAndroidEdgeToEdge();
  containerRef.read(smartDownloadManagerProvider.notifier).markAppReady();
  unawaited(_resumeLastPlayedOnStartup());
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key, required this.initialization});

  final Future<void> initialization;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLogLevelSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.appLogLevel)).asData?.value;

    appLoggerService.setMinimumLevel(InfoLevel.fromSettingValue(appLogLevelSetting));

    final themeSelection = watchAppThemeSelection(ref);

    return FutureBuilder<void>(
      future: initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done || snapshot.hasError) {
          return MaterialApp(
            title: appName,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: [...GlobalMaterialLocalizations.delegates, FlutterQuillLocalizations.delegate],
            themeMode: themeSelection.materialThemeMode,
            theme: themeSelection.themeData(Brightness.light),
            darkTheme: themeSelection.themeData(Brightness.dark),
            home: AppStartupView(error: snapshot.error),
          );
        }

        return const _ReadyApp();
      },
    );
  }
}

class _ReadyApp extends ConsumerWidget {
  const _ReadyApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSelection = watchAppThemeSelection(ref);

    ref.watch(mediaProgressProvider);

    return MaterialApp.router(
      routerConfig: globalRouter,
      title: appName,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        if (child == null) {
          return const SizedBox.shrink();
        }

        return ScaffoldMessenger(
          child: DesktopNavigationControls(
            router: globalRouter,
            history: desktopNavigationHistory,
            child: AndroidEdgeToEdgeInsetGuard(child: child),
          ),
        );
      },
      localizationsDelegates: [...GlobalMaterialLocalizations.delegates, FlutterQuillLocalizations.delegate],
      themeMode: themeSelection.materialThemeMode,
      theme: themeSelection.themeData(Brightness.light),
      darkTheme: themeSelection.themeData(Brightness.dark),
    );
  }
}
