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

  static bool _isContainerRuntime() {
    return Platform.environment.containsKey('CONTAINER') ||
        Platform.environment.containsKey('container') ||
        Platform.environment.containsKey('FLATPAK_ID');
  }

  static bool _isSnapRuntime() {
    final snapRoot = Platform.environment['SNAP'];
    return snapRoot != null && snapRoot.isNotEmpty;
  }

  static String? _snapRoot() {
    final snapRoot = Platform.environment['SNAP'];
    if (snapRoot == null || snapRoot.isEmpty) {
      return null;
    }

    return snapRoot;
  }

  static String? _discoverLibmpvPath() {
    final searchDirectories = <String>{'/app/lib', '/app/lib64', '/app/yaabsa/lib'};

    final snapRoot = _snapRoot();
    if (snapRoot != null) {
      searchDirectories.add('$snapRoot/usr/lib/x86_64-linux-gnu');
    }

    for (final searchDirectory in searchDirectories) {
      final directory = Directory(searchDirectory);
      if (!directory.existsSync()) {
        continue;
      }

      try {
        final matches =
            directory
                .listSync(followLinks: true)
                .whereType<File>()
                .map((file) => file.path)
                .where((path) => p.basename(path).startsWith('libmpv.so'))
                .toList()
              ..sort((a, b) => a.length.compareTo(b.length));

        if (matches.isNotEmpty) {
          return matches.first;
        }
      } catch (e) {
        logger('Failed to scan $searchDirectory for libmpv: $e', tag: 'Init', level: InfoLevel.warning);
      }
    }

    return null;
  }

  static String? _resolveLibmpvPath() {
    if (!Platform.isLinux) {
      return null;
    }

    final configuredPath = Platform.environment['LIBMPV_LIBRARY_PATH'];
    if (configuredPath != null && configuredPath.isNotEmpty) {
      if (!p.isAbsolute(configuredPath) || File(configuredPath).existsSync()) {
        logger('Using libmpv path from environment: $configuredPath', tag: 'Init', level: InfoLevel.info);
        return configuredPath;
      }

      logger('Configured libmpv path does not exist: $configuredPath', tag: 'Init', level: InfoLevel.warning);
    }

    if (!_isContainerRuntime()) {
      if (!_isSnapRuntime()) {
        logger('No Flatpak or Snap runtime detected', tag: 'Init', level: InfoLevel.debug);
        return null;
      }

      logger('Running as Snap', tag: 'Init', level: InfoLevel.debug);
    } else {
      logger('Running as Flatpak', tag: 'Init', level: InfoLevel.debug);
    }

    final fallbackCandidates = <String>['/app/lib/libmpv.so', '/app/lib64/libmpv.so'];

    final snapRoot = _snapRoot();
    if (snapRoot != null) {
      fallbackCandidates.addAll(<String>['$snapRoot/usr/lib/x86_64-linux-gnu/libmpv.so.2']);
    }

    for (final candidate in fallbackCandidates) {
      if (File(candidate).existsSync()) {
        return candidate;
      }
    }

    final discoveredPath = _discoverLibmpvPath();
    if (discoveredPath != null) {
      logger('Discovered libmpv path: $discoveredPath', tag: 'Init', level: InfoLevel.info);
      return discoveredPath;
    }

    logger('Libmpv path is not available', tag: 'Init', level: InfoLevel.error);

    return null;
  }

  static Future<BGAudioHandler> initAudioHandler() async {
    if (_audioHandler != null) return _audioHandler!;

    if (Platform.isLinux) {
      AudioServiceMpris.registerWith();
    }

    final libmpvPath = _resolveLibmpvPath();
    if (libmpvPath != null) {
      logger('Using libmpv at $libmpvPath', tag: 'Init', level: InfoLevel.info);
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
