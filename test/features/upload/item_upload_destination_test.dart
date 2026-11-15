import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/features/upload/item_upload_destination.dart';
import 'package:yaabsa/ui/previews/preview_fixtures.dart';

void main() {
  LibraryItem itemAt(String path, {bool isFile = false, String folderId = 'preview-folder'}) {
    return LibraryItem(
      id: 'book',
      ino: 'ino',
      libraryId: 'preview-library',
      folderId: folderId,
      path: path,
      isFile: isFile,
      media: null,
      libraryFiles: const [],
    );
  }

  ItemUploadDestination? resolve(LibraryItem item, {bool watcherDisabled = false}) {
    return ItemUploadDestination.resolve(
      item: item,
      library: previewUploadLibrary(),
      serverWatcherDisabled: watcherDisabled,
    );
  }

  test('uses actual directory names for one to three path levels', () {
    for (final path in ['Title', 'Author/Title', 'Author/Series/Title']) {
      final destination = resolve(itemAt('/audiobooks/$path'))!;
      expect(destination.title, 'Title');
      expect(destination.author, path.contains('/') ? 'Author' : '');
      expect(destination.series, path.contains('Series') ? 'Series' : '');
    }
  });

  test('rejects paths that cannot target an existing book directory', () {
    for (final path in [
      '/audiobooks',
      '/audiobooks/Author/Series/Title/Part',
      '/audiobooks-other/Title',
      '/elsewhere/Title',
      '/audiobooks/Author/Title.',
      '/audiobooks/Author/Title: Subtitle',
      '/audiobooks/Author/Two  Spaces',
      '/audiobooks/Author/CON',
    ]) {
      expect(resolve(itemAt(path)), isNull, reason: path);
    }
    expect(resolve(itemAt('/audiobooks/Title.mp3', isFile: true)), isNull);
    expect(resolve(itemAt('/audiobooks/Title', folderId: 'other-folder')), isNull);
  });

  test('recognizes watcher disabled at the server or library level', () {
    final item = itemAt('/audiobooks/Title');
    expect(resolve(item)!.requiresScan, isFalse);
    expect(resolve(item, watcherDisabled: true)!.requiresScan, isTrue);
    final library = previewUploadLibrary();
    final destination = ItemUploadDestination.resolve(
      item: item,
      library: library.copyWith(settings: library.settings.copyWith(disableWatcher: true)),
      serverWatcherDisabled: false,
    );
    expect(destination!.requiresScan, isTrue);
  });
}
