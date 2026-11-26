import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:yaabsa/features/upload/upload_draft_factory.dart';
import 'package:yaabsa/features/upload/upload_file_access.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('de.vito0912.yaabsa/upload_saf');
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
  });

  test('SAF drafts use display names and preserve grouping and duplicate detection', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'inspectTree') {
        return {'uri': 'content://books/root', 'name': 'Author'};
      }
      if (call.method == 'listDirectory') {
        final uri = (call.arguments as Map)['uri'];
        if (uri == 'content://books/root') {
          return [
            {'uri': 'content://books/series', 'name': 'Series', 'isDirectory': true},
          ];
        }
        if (uri == 'content://books/series') {
          return [
            {'uri': 'content://books/title', 'name': 'Title', 'isDirectory': true},
          ];
        }
        return [
          {'uri': 'content://books/opaque-1', 'name': 'chapter.mp3', 'isDirectory': false},
          {'uri': 'content://books/opaque-2', 'name': 'cover.jpg', 'isDirectory': false},
          {'uri': 'content://books/opaque-3', 'name': 'existing.mp3', 'isDirectory': false},
        ];
      }
      fail('Unexpected method: ${call.method}');
    });

    final factory = UploadDraftFactory(isBookLibrary: true, libraryName: 'Books');
    final draft = await factory.buildFolderItem(
      'content://books/tree/root',
      existingAbsolutePaths: {'content://books/opaque-3'},
      nextId: () => 1,
    );

    expect(draft, isNotNull);
    expect(draft!.author, 'Author');
    expect(draft.series, 'Series');
    expect(draft.title, 'Title');
    expect(draft.itemFiles.single.fileName, 'chapter.mp3');
    expect(draft.itemFiles.single.absolutePath, 'content://books/opaque-1');
    expect(draft.itemFiles.single.relativePath, p.join('Author', 'Series', 'Title', 'chapter.mp3'));
    expect(draft.otherFiles.single.fileName, 'cover.jpg');
  });

  test('SAF multipart streams reopen for retries and close after completion', () async {
    var opens = 0;
    var closes = 0;
    var reads = 0;
    messenger.setMockMethodCallHandler(channel, (call) async {
      switch (call.method) {
        case 'fileLength':
          return 3;
        case 'openFile':
          opens++;
          reads = 0;
          return opens;
        case 'readFile':
          reads++;
          return reads == 1 ? Uint8List.fromList([1, 2, 3]) : Uint8List(0);
        case 'closeFile':
          closes++;
          return null;
      }
      fail('Unexpected method: ${call.method}');
    });

    final access = UploadFileAccess();
    final multipart = await access.multipartFile(
      location: 'content://books/audio',
      filename: 'chapter.mp3',
      cancelToken: CancelToken(),
    );
    expect(opens, 0);
    expect(multipart.filename, 'chapter.mp3');
    expect(multipart.length, 3);
    expect(await multipart.finalize().expand((bytes) => bytes).toList(), [1, 2, 3]);
    expect(await multipart.clone().finalize().expand((bytes) => bytes).toList(), [1, 2, 3]);
    await access.close();
    expect(opens, 2);
    expect(closes, 2);
  });

  test('SAF cancellation closes an open stream', () async {
    final token = CancelToken();
    var closes = 0;
    messenger.setMockMethodCallHandler(channel, (call) async {
      switch (call.method) {
        case 'fileLength':
          return 3;
        case 'openFile':
          return 1;
        case 'readFile':
          token.cancel('Canceled');
          return Uint8List.fromList([1, 2, 3]);
        case 'closeFile':
          closes++;
          return null;
      }
      fail('Unexpected method: ${call.method}');
    });

    final access = UploadFileAccess();
    final multipart = await access.multipartFile(
      location: 'content://books/audio',
      filename: 'chapter.mp3',
      cancelToken: token,
    );
    await expectLater(multipart.finalize().drain<void>(), throwsA(isA<DioException>()));
    await access.close();
    expect(closes, 1);
  });

  test('SAF read failures and changed file sizes release their handles', () async {
    for (final failRead in [true, false]) {
      var closes = 0;
      messenger.setMockMethodCallHandler(channel, (call) async {
        switch (call.method) {
          case 'fileLength':
            return 3;
          case 'openFile':
            return 1;
          case 'readFile':
            if (failRead) {
              throw PlatformException(code: 'permission_denied');
            }
            return Uint8List(0);
          case 'closeFile':
            closes++;
            return null;
        }
        fail('Unexpected method: ${call.method}');
      });

      final access = UploadFileAccess();
      final multipart = await access.multipartFile(
        location: 'content://books/audio',
        filename: 'chapter.mp3',
        cancelToken: CancelToken(),
      );
      final matcher = failRead ? isA<PlatformException>() : isA<FileSystemException>();
      await expectLater(multipart.finalize().drain<void>(), throwsA(matcher));
      await access.close();
      expect(closes, 1);
    }
  });
}
