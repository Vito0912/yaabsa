import 'package:audio_service/audio_service.dart';
import 'package:buchshelfly/util/bg_audio_handler.dart';
import 'package:buchshelfly/util/globals.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'logger.dart';

class Init {
  static void initLogger() async {
    FlutterError.onError = (details) {
      logger('FlutterError: ${details.exceptionAsString()}', tag: 'FlutterError', level: InfoLevel.error);
      FlutterError.presentError(details);
    };
    logger('Logger initialized', tag: 'Init', level: InfoLevel.info);
  }

  static BGAudioHandler? _audioHandler;

  static Future<BGAudioHandler> initAudioHandler() async {
    if (_audioHandler != null) return _audioHandler!;
    _audioHandler = await AudioService.init(
      builder: () => BGAudioHandler(containerRef),
      config: AudioServiceConfig(
        androidNotificationChannelId: 'de.vito0912.buchshelfly.audio',
        androidNotificationChannelName: 'Playback',
        androidNotificationOngoing: false,
        androidStopForegroundOnPause: false,
        preloadArtwork: true,
      ),
    );
    JustAudioMediaKit.ensureInitialized(linux: true, windows: true);
    logger('AudioHandler initialized', tag: 'Init', level: InfoLevel.info);
    return _audioHandler!;
  }

  static Future<void> globals() async {
    WidgetsFlutterBinding.ensureInitialized();

    packageInfo = await PackageInfo.fromPlatform();
  }
}
