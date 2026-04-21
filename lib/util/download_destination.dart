import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/logger.dart';

class DownloadTaskDestination {
  const DownloadTaskDestination._({
    required this.usesUriTask,
    required this.saf,
    this.directoryUri,
    this.baseDirectory,
    this.directory,
  }) : assert(
         (usesUriTask && directoryUri != null) || (!usesUriTask && baseDirectory != null && directory != null),
         'DownloadTaskDestination must define either directoryUri or baseDirectory+directory',
       );

  const DownloadTaskDestination.uri({required Uri directoryUri, bool saf = true})
    : this._(usesUriTask: true, saf: saf, directoryUri: directoryUri);

  const DownloadTaskDestination.path({required BaseDirectory baseDirectory, required String directory})
    : this._(usesUriTask: false, saf: false, baseDirectory: baseDirectory, directory: directory);

  final bool usesUriTask;
  final bool saf;
  final Uri? directoryUri;
  final BaseDirectory? baseDirectory;
  final String? directory;
}

bool get supportsCustomDownloadLocation => Platform.isAndroid || Platform.isLinux || Platform.isWindows;

bool get disablesCustomDownloadLocation => Platform.isIOS || Platform.isMacOS;

bool get isFlatpakRuntime {
  if (!Platform.isLinux) {
    return false;
  }
  return Platform.environment.containsKey('FLATPAK_ID') ||
      Platform.environment['container'] == 'flatpak' ||
      Platform.environment['CONTAINER'] == 'flatpak';
}

Uri? parseDownloadLocationSetting(String? rawValue) {
  if (rawValue == null) {
    return null;
  }

  final trimmed = rawValue.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  final parsed = Uri.tryParse(trimmed);
  if (parsed != null && parsed.scheme.isNotEmpty) {
    return parsed;
  }

  return Uri.file(trimmed, windows: Platform.isWindows);
}

String encodeDesktopDownloadLocation(String directoryPath) {
  return Uri.file(directoryPath, windows: Platform.isWindows).toString();
}

String formatDownloadLocationForDisplay(String? rawValue) {
  final parsed = parseDownloadLocationSetting(rawValue);
  if (parsed == null) {
    return 'Default location';
  }

  if (parsed.scheme == 'file') {
    try {
      return parsed.toFilePath(windows: Platform.isWindows);
    } catch (_) {
      return parsed.toString();
    }
  }

  return parsed.toString();
}

Future<String> defaultDownloadLocationDescription() async {
  if (Platform.isLinux || Platform.isWindows) {
    final downloadsDir = await getDownloadsDirectory();
    if (downloadsDir != null) {
      return 'System Downloads: ${downloadsDir.path}';
    }
    return 'App documents folder (fallback)';
  }

  if (Platform.isAndroid) {
    return 'App documents folder (private app storage)';
  }

  if (Platform.isIOS || Platform.isMacOS) {
    return 'App documents folder (sandboxed by OS)';
  }

  return 'App documents folder';
}

Future<DownloadTaskDestination> resolveDownloadTaskDestination(
  FileDownloader downloader,
  String? rawLocation,
  String itemId,
) async {
  final customLocation = parseDownloadLocationSetting(rawLocation);

  if (customLocation != null) {
    if (Platform.isAndroid) {
      final activatedUri = await downloader.uri.activate(customLocation);
      if (activatedUri == null) {
        throw Exception('The selected Android folder is no longer accessible. Please pick it again.');
      }

      final itemDirectory = await downloader.uri.createDirectory(activatedUri, '$itemId', persistedUriPermission: true);

      return DownloadTaskDestination.uri(directoryUri: itemDirectory);
    }

    if (Platform.isLinux || Platform.isWindows) {
      if (customLocation.scheme != 'file') {
        throw Exception('Custom download location must be a local folder on this platform.');
      }

      final rootPath = customLocation.toFilePath(windows: Platform.isWindows);
      return DownloadTaskDestination.path(baseDirectory: BaseDirectory.root, directory: p.join(rootPath, itemId));
    }

    logger(
      'Ignoring custom download location on unsupported platform',
      tag: 'DownloadDestination',
      level: InfoLevel.warning,
    );
  }

  if (Platform.isLinux || Platform.isWindows) {
    final downloadsDir = await getDownloadsDirectory();
    if (downloadsDir != null) {
      return DownloadTaskDestination.path(
        baseDirectory: BaseDirectory.root,
        directory: p.join(downloadsDir.path, appName, itemId),
      );
    }
  }

  return DownloadTaskDestination.path(baseDirectory: BaseDirectory.applicationDocuments, directory: '$appName/$itemId');
}
