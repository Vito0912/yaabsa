import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/socket_provider.dart';
import 'package:yaabsa/screens/wear/wear_home_screen.dart';
import 'package:yaabsa/util/audio_handler/wear_audio_handler.dart';
import 'package:yaabsa/util/globals.dart' show containerRef;
import 'package:yaabsa/util/init.dart' show Init;
import 'package:yaabsa/util/logger.dart';

late final WearAudioHandler wearAudioHandler;

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Init.globals();
      await containerRef.read(settingsManagerProvider.notifier).ensureInitialized();
      // Tracks reachability and replays offline progress syncs on reconnect.
      unawaited(containerRef.read(serverStatusProvider.future));
      // Receives progress updates pushed when other clients play.
      containerRef.read(absSocketClientProvider);
      Init.initLogger();
      wearAudioHandler = await AudioService.init(
        builder: () => WearAudioHandler(),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'de.vito0912.yaabsa.wear.audio',
          androidNotificationChannelName: 'Playback',
          androidNotificationIcon: 'drawable/ic_launcher_monochrome',
          androidNotificationOngoing: false,
          androidStopForegroundOnPause: false,
        ),
      );
      runApp(
        UncontrolledProviderScope(
          container: containerRef,
          child: MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData.dark(), home: const WearHomeScreen()),
        ),
      );
    },
    (error, stack) {
      logger('Uncaught Dart error: $error\n$stack', tag: 'WearZoneError', level: InfoLevel.error);
    },
  );
}
