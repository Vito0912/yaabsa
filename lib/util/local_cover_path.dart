import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:path/path.dart' as p;
import 'package:yaabsa/util/logger.dart';

Uri? parseCoverPathUri(String? rawPath) {
  if (rawPath == null) {
    return null;
  }

  final trimmed = rawPath.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  if (Platform.isWindows && RegExp(r'^[a-zA-Z]:[\\/]').hasMatch(trimmed)) {
    return Uri.file(trimmed, windows: true);
  }

  final parsed = Uri.tryParse(trimmed);
  if (parsed == null) {
    return null;
  }

  if (parsed.scheme.isEmpty) {
    return Uri.file(trimmed, windows: Platform.isWindows);
  }

  return parsed;
}

Future<String?> resolveDisplayCoverPath(String? rawPath, {required String cacheKey}) async {
  final parsedUri = parseCoverPathUri(rawPath);
  if (parsedUri == null) {
    return null;
  }

  if (parsedUri.scheme == 'file') {
    try {
      return parsedUri.toFilePath(windows: Platform.isWindows);
    } catch (_) {
      return rawPath?.trim();
    }
  }

  if (parsedUri.scheme != 'content') {
    return parsedUri.toString();
  }

  final downloader = FileDownloader();

  try {
    final activatedUri = await downloader.uri.activate(parsedUri) ?? parsedUri;

    if (activatedUri.scheme == 'file') {
      try {
        return activatedUri.toFilePath(windows: Platform.isWindows);
      } catch (_) {
        return activatedUri.toString();
      }
    }

    final safeKey = cacheKey.replaceAll(RegExp(r'[^A-Za-z0-9_.-]'), '_');
    final resolvedKey = safeKey.isEmpty ? '${cacheKey.hashCode.abs()}' : safeKey;
    final tempFile = File(p.join(Directory.systemTemp.path, 'yaabsa_cover_$resolvedKey.img'));

    await tempFile.parent.create(recursive: true);
    final copiedUri = await downloader.uri.copyFile(activatedUri, tempFile.uri);

    if (copiedUri == null && !await tempFile.exists()) {
      return null;
    }

    final resolvedUri = copiedUri ?? tempFile.uri;
    if (resolvedUri.scheme == 'file') {
      try {
        return resolvedUri.toFilePath(windows: Platform.isWindows);
      } catch (_) {
        return tempFile.path;
      }
    }

    return resolvedUri.toString();
  } catch (e, s) {
    logger(
      'Failed to resolve local cover path for $parsedUri: $e\n$s',
      tag: 'LocalCoverPath',
      level: InfoLevel.warning,
    );
    return rawPath?.trim();
  }
}
