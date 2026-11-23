import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/library/library_folder.dart';
import 'package:yaabsa/api/library_items/library_item.dart';

@immutable
class ItemUploadDestination {
  const ItemUploadDestination._({
    required this.itemId,
    required this.itemTitle,
    required this.folder,
    required this.title,
    required this.author,
    required this.series,
    required this.requiresScan,
    required this.existingFileNames,
  });

  final String itemId;
  final String itemTitle;
  final LibraryFolder folder;
  final String title;
  final String author;
  final String series;
  final bool requiresScan;
  final Set<String> existingFileNames;

  static ItemUploadDestination? resolve({
    required LibraryItem item,
    required Library library,
    required bool serverWatcherDisabled,
  }) {
    final itemPath = item.path;
    if (item.isFile != false ||
        item.isMissing == true ||
        itemPath == null ||
        library.mediaType != 'book' ||
        item.libraryId != library.id) {
      return null;
    }

    for (final folder in library.folders ?? const <LibraryFolder>[]) {
      if (folder.id != item.folderId) {
        continue;
      }

      final usesWindowsPaths = folder.fullPath.contains('\\') || RegExp(r'^[a-zA-Z]:/').hasMatch(folder.fullPath);
      final paths = p.Context(style: usesWindowsPaths ? p.Style.windows : p.Style.posix);
      if (!paths.isAbsolute(folder.fullPath) ||
          !paths.isAbsolute(itemPath) ||
          !paths.isWithin(folder.fullPath, itemPath)) {
        continue;
      }

      final relativePath = paths.relative(itemPath, from: folder.fullPath);
      final segments = paths.split(relativePath);
      if (segments.isEmpty || segments.length > 3 || !segments.every(_isPreservedByUpload)) {
        return null;
      }

      return ItemUploadDestination._(
        existingFileNames: Set.unmodifiable([
          for (final file in item.libraryFiles ?? [])
            if (file.metadata.relPath == file.metadata.filename) file.metadata.filename,
        ]),
        itemId: item.id,
        itemTitle: item.title,
        folder: folder,
        title: segments.last,
        author: segments.length > 1 ? segments.first : '',
        series: segments.length == 3 ? segments[1] : '',
        requiresScan: serverWatcherDisabled || library.settings.disableWatcher == true,
      );
    }

    return null;
  }

  static bool _isPreservedByUpload(String segment) {
    final illegal = RegExp(r'[/?<>\\:*|"\x00-\x1f\x80-\x9f]');
    final reserved = RegExp(r'^(con|prn|aux|nul|com[0-9]|lpt[0-9])(\..*)?$', caseSensitive: false);
    final combiningMarks = RegExp(r'[\u0300-\u036f\u1100-\u11ff\u1ab0-\u1aff\u1dc0-\u1dff\u20d0-\u20ff\ufe20-\ufe2f]');

    return segment.isNotEmpty &&
        segment.length <= 127 &&
        segment.trim() == segment &&
        !segment.endsWith('.') &&
        !illegal.hasMatch(segment) &&
        !reserved.hasMatch(segment) &&
        !combiningMarks.hasMatch(segment) &&
        segment.replaceAll(RegExp(r'\s+'), ' ') == segment;
  }
}
