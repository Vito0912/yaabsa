import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

class AndroidSafHelper {
  AndroidSafHelper._();

  static const MethodChannel _channel = MethodChannel('de.vito0912.yaabsa/saf');

  static Future<Uri?> prepareDownloadFile({
    required Uri rootTreeUri,
    required String relativeDirectory,
    required String filename,
    String? mimeType,
  }) async {
    if (kIsWeb || !Platform.isAndroid || rootTreeUri.scheme != 'content') {
      return null;
    }

    final uriString = await _channel.invokeMethod<String>('prepareDownloadFile', {
      'rootTreeUri': rootTreeUri.toString(),
      'relativeDirectory': relativeDirectory,
      'filename': filename,
      'mimeType': mimeType,
    });

    if (uriString == null || uriString.isEmpty) {
      return null;
    }

    return Uri.tryParse(uriString);
  }

  static String packFilenameWithUri(String filename, Uri fileUri) {
    return ':::$filename::::::${fileUri.toString()}:::';
  }
}
