import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:background_downloader/background_downloader.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/logger.dart';

const applicationDocumentsDownloadBase = 'application-documents';
const systemDownloadsDownloadBase = 'system-downloads';

class DownloadTaskDestination {
  const DownloadTaskDestination._({
    required this.usesUriTask,
    required this.saf,
    this.directoryUri,
    this.baseDirectory,
    this.directory,
    this.storageBasePath,
  }) : assert(
         (usesUriTask && directoryUri != null) || (!usesUriTask && baseDirectory != null && directory != null),
         'DownloadTaskDestination must define either directoryUri or baseDirectory+directory',
       );

  const DownloadTaskDestination.uri({required Uri directoryUri, bool saf = true})
    : this._(usesUriTask: true, saf: saf, directoryUri: directoryUri);

  const DownloadTaskDestination.path({
    required BaseDirectory baseDirectory,
    required String directory,
    String? storageBasePath,
  }) : this._(
         usesUriTask: false,
         saf: false,
         baseDirectory: baseDirectory,
         directory: directory,
         storageBasePath: storageBasePath,
       );

  final bool usesUriTask;
  final bool saf;
  final Uri? directoryUri;
  final BaseDirectory? baseDirectory;
  final String? directory;
  final String? storageBasePath;
}

Future<String?> resolveDownloadBasePath(String? basePath) async {
  if (basePath == null || basePath.isEmpty || kIsWeb) {
    return null;
  }
  if (basePath == applicationDocumentsDownloadBase) {
    return (await getApplicationDocumentsDirectory()).path;
  }
  if (basePath == systemDownloadsDownloadBase) {
    return (await getDownloadsDirectory())?.path;
  }

  final uri = Uri.tryParse(basePath);
  if (uri?.scheme == 'file') {
    return uri!.toFilePath(windows: Platform.isWindows);
  }
  return basePath;
}

Future<String?> resolveStoredDownloadPath(String? path, String? basePath) async {
  if (path == null || path.trim().isEmpty || basePath == null || basePath.isEmpty) {
    return path;
  }

  final parsed = Uri.tryParse(path);
  if (parsed != null && parsed.scheme.isNotEmpty && parsed.scheme != 'file') {
    return path;
  }
  if (p.isAbsolute(path)) {
    return path;
  }

  final root = await resolveDownloadBasePath(basePath);
  if (root == null || root.isEmpty) {
    return path;
  }
  return p.join(root, path);
}

Future<String?> storeDownloadPath(String? path, String? basePath) async {
  if (path == null || path.trim().isEmpty || basePath == null || basePath.isEmpty) {
    return path;
  }

  final parsed = Uri.tryParse(path);
  if (parsed != null && parsed.scheme.isNotEmpty && parsed.scheme != 'file') {
    return path;
  }

  final root = await resolveDownloadBasePath(basePath);
  if (root == null || root.isEmpty) {
    return path;
  }

  final filePath = parsed?.scheme == 'file' ? parsed!.toFilePath(windows: Platform.isWindows) : path;
  if (!p.isWithin(root, filePath) && p.normalize(root) != p.normalize(filePath)) {
    return path;
  }
  return p.relative(filePath, from: root);
}

bool get supportsCustomDownloadLocation => !kIsWeb && (Platform.isAndroid || Platform.isLinux || Platform.isWindows);

bool get disablesCustomDownloadLocation => !kIsWeb && (Platform.isIOS || Platform.isMacOS);

bool get isFlatpakRuntime {
  if (kIsWeb || !Platform.isLinux) {
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

  return Uri.file(trimmed, windows: !kIsWeb && Platform.isWindows);
}

String encodeDesktopDownloadLocation(String directoryPath) {
  return Uri.file(directoryPath, windows: !kIsWeb && Platform.isWindows).toString();
}

String formatDownloadLocationForDisplay(String? rawValue) {
  final parsed = parseDownloadLocationSetting(rawValue);
  if (parsed == null) {
    return 'Default location';
  }

  if (parsed.scheme == 'file') {
    try {
      return parsed.toFilePath(windows: !kIsWeb && Platform.isWindows);
    } catch (_) {
      return parsed.toString();
    }
  }

  return parsed.toString();
}

Future<String> defaultDownloadLocationDescription() async {
  if (kIsWeb) {
    return 'Not supported on Web';
  }

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
  if (kIsWeb) {
    throw UnsupportedError('Downloads are not supported on Web');
  }
  final customLocation = parseDownloadLocationSetting(rawLocation);

  if (customLocation != null) {
    if (Platform.isAndroid) {
      final activatedUri = await downloader.uri.activate(customLocation);
      if (activatedUri == null) {
        throw Exception('The selected Android folder is no longer accessible. Please pick it again.');
      }

      return DownloadTaskDestination.uri(directoryUri: activatedUri);
    }

    if (Platform.isLinux || Platform.isWindows) {
      if (customLocation.scheme != 'file') {
        throw Exception('Custom download location must be a local folder on this platform.');
      }

      final rootPath = customLocation.toFilePath(windows: Platform.isWindows);
      return DownloadTaskDestination.path(
        baseDirectory: BaseDirectory.root,
        directory: p.join(rootPath, itemId),
        storageBasePath: customLocation.toString(),
      );
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
        storageBasePath: systemDownloadsDownloadBase,
      );
    }
  }

  return DownloadTaskDestination.path(
    baseDirectory: BaseDirectory.applicationDocuments,
    directory: '$appName/$itemId',
    storageBasePath: applicationDocumentsDownloadBase,
  );
}
