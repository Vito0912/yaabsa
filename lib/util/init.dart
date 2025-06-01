import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/handler/bg_audio_handler.dart';
import 'package:yaabsa/util/handler/download_handler.dart';
import 'package:yaabsa/util/handler/shake_handler.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import 'package:sembast/sembast_io.dart' show databaseFactoryIo;

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
        androidNotificationChannelId: 'de.vito0912.yaabsa.audio',
        androidNotificationChannelName: 'Playback',
        androidNotificationOngoing: false,
        androidStopForegroundOnPause: false,
        preloadArtwork: true,
      ),
    );

    // TODO: Setting
    JustAudioMediaKit.prefetchPlaylist = true;

    JustAudioMediaKit.ensureInitialized(linux: true, windows: true);
    logger('AudioHandler initialized', tag: 'Init', level: InfoLevel.info);
    return _audioHandler!;
  }

  static Future<void> globals() async {
    WidgetsFlutterBinding.ensureInitialized();

    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, appName, 'cache.db'));
    await file.parent.create(recursive: true);

    cacheDb = await databaseFactoryIo.openDatabase(file.path);

    packageInfo = await PackageInfo.fromPlatform();
    downloadHandler = DownloadHandler(containerRef);
  }

  static Future<void> late() async {
    if (Platform.isAndroid || Platform.isIOS) {
      rewindShakeHandler = ShakeRewindHandler();
    } else {
      rewindShakeHandler = null;
    }
  }
}
