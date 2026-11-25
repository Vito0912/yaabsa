import 'dart:async';

import 'package:flutter/foundation.dart' show LicenseEntryWithLineBreaks, LicenseRegistry;
import 'package:flutter/services.dart' show rootBundle;

import 'package:yaabsa/provider/core/socket_work_policy.dart';

import 'package:yaabsa/screens/wear/components/wear_activity_scope.dart';
import 'package:audio_service/audio_service.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/socket_provider.dart';
import 'package:yaabsa/provider/core/locale_provider.dart';
import 'package:yaabsa/screens/wear/wear_home_screen.dart';
import 'package:yaabsa/ui/theme/wear_theme.dart';
import 'package:yaabsa/util/app_theme.dart';
import 'package:yaabsa/util/audio_handler/wear_audio_handler.dart';
import 'package:yaabsa/util/globals.dart' show containerRef;
import 'package:yaabsa/util/init.dart' show Init;
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/logger.dart';

late final WearAudioHandler wearAudioHandler;

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      LicenseRegistry.addLicense(() async* {
        final notice = await rootBundle.loadString('assets/browse_icons/LICENSE');
        yield LicenseEntryWithLineBreaks(['Audiobookshelf library icons'], notice);
      });
      final imageCache = PaintingBinding.instance.imageCache;
      imageCache.maximumSize = 64;
      imageCache.maximumSizeBytes = 8 * 1024 * 1024;
      containerRef
          .read(socketPolicyProvider.notifier)
          .configure(
            const SocketWorkPolicy(hydrateAdminTasks: false, reconcileSmartDownloads: false, allowBackground: false),
          );
      await Init.globals();
      await containerRef.read(settingsManagerProvider.notifier).ensureInitialized();
      // Tracks reachability and replays offline progress syncs on reconnect.
      unawaited(containerRef.read(serverStatusProvider.future));
      // Receives progress updates pushed when other clients play.
      containerRef.read(absSocketClientProvider);
      Init.initLogger();
      wearAudioHandler = await AudioService.init(
        builder: () => WearAudioHandler(),
        config: AudioServiceConfig(
          androidNotificationChannelId: 'de.vito0912.yaabsa.wear.audio',
          androidNotificationChannelName: currentAppLocalizations().playbackTitle,
          androidNotificationIcon: 'drawable/ic_launcher_monochrome',
          androidNotificationOngoing: false,
          androidStopForegroundOnPause: false,
        ),
      );
      runApp(UncontrolledProviderScope(container: containerRef, child: const WearApp()));
    },
    (error, stack) {
      logger('Uncaught Dart error: $error\n$stack', tag: 'WearZoneError', level: InfoLevel.error);
    },
  );
}

class WearApp extends ConsumerWidget {
  const WearApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSelection = watchAppThemeSelection(ref);
    final locale = ref.watch(localeProvider);
    ref.watch(localeEffectsProvider);
    // The watch always uses the AMOLED dark variant of the shared app theme:
    // same palette as the phone app on a pure-black background.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: yaabsaLocalizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      theme: buildWearTheme(
        buildAppThemeData(
          brightness: Brightness.dark,
          preset: themeSelection.preset,
          customSeedColor: themeSelection.customSeedColor,
          useAmoledDark: true,
        ),
      ),
      builder: (context, child) => WearActivityHost(
        mediaStream: wearAudioHandler.mediaItem,
        currentMediaItem: () => wearAudioHandler.mediaItem.value,
        child: child ?? const SizedBox.shrink(),
      ),
      home: const WearHomeScreen(),
    );
  }
}
