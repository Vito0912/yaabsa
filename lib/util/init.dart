import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/device_capabilities.dart';
import 'package:yaabsa/util/handler/bg_audio_handler.dart';
import 'package:yaabsa/util/handler/download_handler.dart';
import 'package:yaabsa/util/handler/shake_handler.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:sembast/sembast_io.dart' show databaseFactoryIo;
import 'package:audio_service_mpris/audio_service_mpris.dart';

import 'app_paths.dart';
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

  static String? _resolveFlatpakLibmpvPath() {
    if (!Platform.isLinux || !Platform.environment.containsKey('FLATPAK_ID')) {
      return null;
    }

    logger('Resolving Flatpak libmpv path', tag: 'Init', level: InfoLevel.info);

    const candidates = ['/app/lib/libmpv.so.1', '/app/lib/libmpv.so.2', '/app/lib/libmpv.so'];

    for (final candidate in candidates) {
      if (File(candidate).existsSync()) {
        return candidate;
      }
    }

    return null;
  }

  static Future<BGAudioHandler> initAudioHandler() async {
    if (_audioHandler != null) return _audioHandler!;

    if (Platform.isLinux) {
      AudioServiceMpris.registerWith();
    }

    final libmpvPath = _resolveFlatpakLibmpvPath();
    if (libmpvPath != null) {
      logger('Using Flatpak libmpv at $libmpvPath', tag: 'Init', level: InfoLevel.info);
    }
    JustAudioMediaKit.ensureInitialized(linux: true, windows: true, libmpv: libmpvPath);

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
    logger('AudioHandler initialized', tag: 'Init', level: InfoLevel.info);
    return _audioHandler!;
  }

  static Future<void> globals() async {
    WidgetsFlutterBinding.ensureInitialized();

    final cacheFolder = await resolveDefaultCacheDirectory();
    final file = File(p.join(cacheFolder.path, 'cache.db'));
    await file.parent.create(recursive: true);

    cacheDb = await databaseFactoryIo.openDatabase(file.path);

    packageInfo = await PackageInfo.fromPlatform();
    downloadHandler = DownloadHandler(containerRef);
  }

  static Future<void> late() async {
    if (DeviceCapabilities.supportsShakeActions) {
      rewindShakeHandler = ShakeRewindHandler();
    } else {
      rewindShakeHandler = null;
    }
  }
}
