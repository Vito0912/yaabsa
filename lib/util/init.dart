import 'package:audio_service/audio_service.dart';
import 'package:buchshelfly/util/bg_audio_handler.dart';
import 'package:flutter/foundation.dart';

import 'logger.dart';

class Init {
  static void initLogger() async {
    FlutterError.onError = (details) {
      logger(
        'FlutterError: ${details.exceptionAsString()}',
        tag: 'FlutterError',
        level: InfoLevel.error,
      );
      FlutterError.presentError(details);
    };
    logger('Logger initialized', tag: 'Init', level: InfoLevel.info);
  }

  static BGAudioHandler? _audioHandler;

  static Future<BGAudioHandler> initAudioHandler() async {
    if (_audioHandler != null) return _audioHandler!;
    _audioHandler = await AudioService.init(
      builder: () => BGAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'de.vito0912.buchshelfly.audio',
        androidNotificationChannelName: 'Playback',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
        preloadArtwork: true,
      ),
    );
    logger('AudioHandler initialized', tag: 'Init', level: InfoLevel.info);
    return _audioHandler!;
  }
}
