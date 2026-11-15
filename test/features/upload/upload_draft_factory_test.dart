import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:yaabsa/features/upload/library_upload_models.dart';
import 'package:yaabsa/features/upload/upload_draft_factory.dart';

void main() {
  group('UploadDraftFactory', () {
    test('book selections create separate drafts and ignore sidecars', () {
      final factory = UploadDraftFactory(isBookLibrary: true, libraryName: 'Audiobooks');
      final files = [
        factory.classifyFile(absolutePath: '/uploads/First_Book.m4b', relativePath: 'First_Book.m4b'),
        factory.classifyFile(absolutePath: '/uploads/Second Book.epub', relativePath: 'Second Book.epub'),
        factory.classifyFile(absolutePath: '/uploads/cover.jpg', relativePath: 'cover.jpg'),
      ];
      var nextId = 1;

      final drafts = factory.buildDirectFileItems(files, nextId: () => nextId++);

      expect(drafts, hasLength(2));
      expect(drafts.map((draft) => draft.id), [1, 2]);
      expect(drafts.map((draft) => draft.title), ['First Book', 'Second Book']);
      expect(drafts.every((draft) => draft.itemFiles.length == 1), isTrue);
      expect(drafts.first.message, contains('sidecar files were ignored'));
      expect(drafts.first.otherFiles, isEmpty);
    });

    test('podcast selections keep supported sidecars with the audio', () {
      final factory = UploadDraftFactory(isBookLibrary: false, libraryName: 'Podcasts');
      final files = [
        factory.classifyFile(absolutePath: '/uploads/Episode_01.mp3', relativePath: 'Episode_01.mp3'),
        factory.classifyFile(absolutePath: '/uploads/cover.png', relativePath: 'cover.png'),
        factory.classifyFile(absolutePath: '/uploads/archive.bin', relativePath: 'archive.bin'),
      ];
      var nextId = 4;

      final drafts = factory.buildDirectFileItems(files, nextId: () => nextId++);

      expect(drafts, hasLength(1));
      expect(drafts.single.id, 4);
      expect(drafts.single.title, 'Episode 01');
      expect(drafts.single.itemFiles.single.kind, UploadFileKind.item);
      expect(drafts.single.otherFiles.single.fileName, 'cover.png');
      expect(drafts.single.ignoredFiles.single.fileName, 'archive.bin');
    });

    test('plain text metadata files can be uploaded without media files', () {
      final factory = UploadDraftFactory(isBookLibrary: true, libraryName: 'Audiobooks');
      final files = [
        factory.classifyFile(absolutePath: '/uploads/metadata.txt', relativePath: 'metadata.txt'),
        factory.classifyFile(absolutePath: '/uploads/unsupported.bin', relativePath: 'unsupported.bin'),
      ];
      var nextId = 1;

      final drafts = factory.buildDirectFileItems(files, nextId: () => nextId++);

      expect(drafts, hasLength(1));
      expect(drafts.single.title, 'metadata');
      expect(drafts.single.itemFiles, isEmpty);
      expect(drafts.single.otherFiles.single.fileName, 'metadata.txt');
      expect(drafts.single.ignoredFiles.single.fileName, 'unsupported.bin');
    });

    test('folder selection reads title, author, series, and matching sidecars', () async {
      final temporaryDirectory = await Directory.systemTemp.createTemp('yaabsa_upload_draft_');
      addTearDown(() => temporaryDirectory.delete(recursive: true));
      final authorDirectory = Directory(p.join(temporaryDirectory.path, 'Alex Morgan'));
      final titleDirectory = Directory(p.join(authorDirectory.path, 'Tide Stories', 'The Quiet Harbor'));
      await titleDirectory.create(recursive: true);
      final audioFile = File(p.join(titleDirectory.path, 'chapter_01.mp3'));
      final coverFile = File(p.join(titleDirectory.path, 'cover.jpg'));
      final ignoredFile = File(p.join(titleDirectory.path, 'notes.bin'));
      await audioFile.writeAsBytes([1]);
      await coverFile.writeAsBytes([2]);
      await ignoredFile.writeAsBytes([3]);

      final factory = UploadDraftFactory(isBookLibrary: true, libraryName: 'Audiobooks');
      final draft = await factory.buildFolderItem(
        authorDirectory.path,
        existingAbsolutePaths: const {},
        nextId: () => 9,
      );

      expect(draft, isNotNull);
      expect(draft!.id, 9);
      expect(draft.author, 'Alex Morgan');
      expect(draft.series, 'Tide Stories');
      expect(draft.title, 'The Quiet Harbor');
      expect(draft.itemFiles.single.absolutePath, audioFile.path);
      expect(draft.otherFiles.single.absolutePath, coverFile.path);
      expect(draft.ignoredFiles.single.absolutePath, ignoredFile.path);
    });

    test('folder selection skips files that are already queued', () async {
      final temporaryDirectory = await Directory.systemTemp.createTemp('yaabsa_upload_existing_');
      addTearDown(() => temporaryDirectory.delete(recursive: true));
      final audioFile = File(p.join(temporaryDirectory.path, 'Already_Queued.mp3'));
      await audioFile.writeAsBytes([1]);
      final factory = UploadDraftFactory(isBookLibrary: true, libraryName: 'Audiobooks');

      final draft = await factory.buildFolderItem(
        temporaryDirectory.path,
        existingAbsolutePaths: {audioFile.path},
        nextId: () => 1,
      );

      expect(draft, isNull);
    });
  });
}
