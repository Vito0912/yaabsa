import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/models/download_task_metadata.dart';
import 'package:yaabsa/models/internal_download.dart';
import 'package:yaabsa/util/download_destination.dart';

void main() {
  test('download task metadata retains the persisted path base', () {
    final metadata = DownloadTaskMetadata.fromJson(<String, dynamic>{
      'itemId': 'item-1',
      'userId': 'user-1',
      'expectedFileCount': 2.0,
      'fileIndex': 1.0,
      'fileKind': 'audio',
      'saf': false,
      'downloadBasePath': applicationDocumentsDownloadBase,
    });

    expect(metadata.expectedFileCount, 2);
    expect(metadata.fileIndex, 1);
    expect(metadata.downloadBasePath, applicationDocumentsDownloadBase);
    expect(metadata.toJson()['downloadBasePath'], applicationDocumentsDownloadBase);
  });

  test('legacy downloads without a base retain their stored paths', () async {
    final download = InternalDownload(
      item: null,
      episode: null,
      tracks: const [],
      saf: false,
      auxiliaryFilePaths: const ['/previous/container/yaabsa/item-1/book.epub'],
    );

    final resolved = await download.resolvePaths();

    expect(resolved.auxiliaryFilePaths, download.auxiliaryFilePaths);
  });

  test('SAF and absolute paths are never re-based', () async {
    const safPath = 'content://com.android.providers.media.documents/document/audio%3A42';
    const absolutePath = '/previous/container/yaabsa/item-1/book.m4b';

    expect(await resolveStoredDownloadPath(safPath, applicationDocumentsDownloadBase), safPath);
    expect(await resolveStoredDownloadPath(absolutePath, applicationDocumentsDownloadBase), absolutePath);
  });
}
