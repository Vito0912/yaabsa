import 'package:path/path.dart' as p;

class FileFormats {
  static const Set<String> audioExtensions = {
    'aac',
    'aax',
    'aif',
    'aiff',
    'alac',
    'ape',
    'flac',
    'm4a',
    'm4b',
    'mka',
    'mp3',
    'mp4',
    'mpc',
    'mpeg',
    'ogg',
    'oga',
    'opus',
    'wav',
    'wma',
    'webm',
  };

  static const Set<String> ebookExtensions = {'epub', 'pdf', 'mobi', 'azw', 'azw3', 'cbz', 'cbr', 'fb2', 'kf8'};

  static bool isEbook(String pathOrExt) {
    final clean = _normalize(pathOrExt);
    return ebookExtensions.contains(clean);
  }

  static bool isAudio(String pathOrExt) {
    final clean = _normalize(pathOrExt);
    return audioExtensions.contains(clean);
  }

  static String _normalize(String input) {
    String ext = input.trim().toLowerCase();
    if (ext.contains('.') || ext.contains('/')) {
      ext = p.extension(ext);
    }
    if (ext.startsWith('.')) {
      ext = ext.substring(1);
    }
    return ext;
  }
}
