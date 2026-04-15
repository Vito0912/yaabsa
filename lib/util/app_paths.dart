import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart'
    show getApplicationCacheDirectory, getApplicationDocumentsDirectory, getApplicationSupportDirectory;

import 'globals.dart';

String? _resolveLinuxBasePath({required String envKey, required String dotFolderName}) {
  final envPath = Platform.environment[envKey];
  if (envPath != null && envPath.isNotEmpty) {
    return envPath;
  }

  final homePath = Platform.environment['HOME'];
  if (homePath == null || homePath.isEmpty) {
    return null;
  }

  return p.join(homePath, dotFolderName);
}

Future<Directory> resolveDefaultCacheDirectory() async {
  if (Platform.isLinux) {
    final basePath = _resolveLinuxBasePath(envKey: 'XDG_CACHE_HOME', dotFolderName: '.cache');
    if (basePath != null) {
      return Directory(p.join(basePath, appName));
    }
  }

  try {
    final cacheDirectory = await getApplicationCacheDirectory();
    return Directory(p.join(cacheDirectory.path, appName));
  } catch (_) {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    return Directory(p.join(documentsDirectory.path, appName, 'cache'));
  }
}

Future<Directory> resolveDefaultConfigDirectory() async {
  if (Platform.isLinux) {
    final basePath = _resolveLinuxBasePath(envKey: 'XDG_CONFIG_HOME', dotFolderName: '.config');
    if (basePath != null) {
      return Directory(p.join(basePath, appName));
    }
  }

  try {
    final supportDirectory = await getApplicationSupportDirectory();
    return Directory(p.join(supportDirectory.path, appName));
  } catch (_) {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    return Directory(p.join(documentsDirectory.path, appName, 'config'));
  }
}
