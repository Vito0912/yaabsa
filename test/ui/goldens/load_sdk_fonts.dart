import 'dart:io';

import 'package:flutter/services.dart';

Future<void> loadSdkFonts() async {
  var directory = File(Platform.resolvedExecutable).parent;
  Directory? fonts;
  while (true) {
    final candidate = Directory('${directory.path}/bin/cache/artifacts/material_fonts');
    if (candidate.existsSync()) {
      fonts = candidate;
      break;
    }
    final parent = directory.parent;
    if (parent.path == directory.path) {
      throw StateError('Run golden tests through the pinned Flutter SDK to load its bundled fonts.');
    }
    directory = parent;
  }

  for (final entry in {'Roboto': 'Roboto-Regular.ttf', 'MaterialIcons': 'MaterialIcons-Regular.otf'}.entries) {
    final bytes = await File('${fonts.path}/${entry.value}').readAsBytes();
    final loader = FontLoader(entry.key);
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
    await loader.load();
  }
}
