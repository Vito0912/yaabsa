import 'dart:convert';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<List<MediaItem>> prepareAndroidCarArtwork(List<MediaItem> items, {required String packageName}) async {
  if (kIsWeb || !Platform.isAndroid) {
    return items;
  }

  return Future.wait(
    items.map((item) async {
      final uri = item.artUri;
      if (uri == null || uri.scheme != 'file') {
        return item;
      }

      try {
        final source = File.fromUri(uri);
        final stat = await source.stat();
        if (stat.type != FileSystemEntityType.file) {
          return item.copyWith(artUri: null);
        }

        final name = sha256
            .convert(utf8.encode('$uri:${stat.modified.microsecondsSinceEpoch}:${stat.size}'))
            .toString();
        final cache = await getTemporaryDirectory();
        final directory = await Directory(p.join(cache.path, 'shared_covers')).create(recursive: true);
        final destination = File(p.join(directory.path, name));

        if (!await destination.exists()) {
          final temporary = await directory.createTemp('cover_');
          try {
            final copy = await source.copy(p.join(temporary.path, name));
            await copy.rename(destination.path);
          } finally {
            await temporary.delete(recursive: true);
          }
        }

        final authority = packageName.isNotEmpty ? '$packageName.covers' : 'de.vito0912.yaabsa.covers';
        return item.copyWith(
          artUri: Uri(scheme: 'content', host: authority, pathSegments: ['local', name]),
        );
      } on FileSystemException {
        return item.copyWith(artUri: null);
      } on ArgumentError {
        return item.copyWith(artUri: null);
      }
    }),
  );
}
