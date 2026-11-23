import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/api/me/media_item_type.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/components/app/item/item_progress_actions.dart';

void main() {
  test('unchanged progress produces no update fields', () {
    final payload = buildChangedProgressPayload(
      existingProgress: _progress(),
      durationSeconds: 3600,
      currentTime: 900,
      progress: 0.25,
      isFinished: false,
      selectedFinishedDate: null,
      finishedAt: null,
    );

    expect(payload, isEmpty);
  });

  test('progress update includes only values that changed', () {
    final payload = buildChangedProgressPayload(
      existingProgress: _progress(),
      durationSeconds: 3600,
      currentTime: 960,
      progress: 0.2666666667,
      isFinished: false,
      selectedFinishedDate: null,
      finishedAt: null,
    );

    expect(payload, <String, dynamic>{'currentTime': 960.0, 'progress': 0.2666666667});
  });

  test('clearing completion sends the changed completion fields only', () {
    final finishedAt = DateTime(2026, 10, 17).millisecondsSinceEpoch;
    final payload = buildChangedProgressPayload(
      existingProgress: _progress(currentTime: 3600, progress: 1, isFinished: true, finishedAt: finishedAt),
      durationSeconds: 3600,
      currentTime: 3420,
      progress: 0.95,
      isFinished: false,
      selectedFinishedDate: null,
      finishedAt: null,
    );

    expect(payload, <String, dynamic>{
      'currentTime': 3420.0,
      'progress': 0.95,
      'isFinished': false,
      'finishedAt': null,
    });
  });
}

MediaProgress _progress({double currentTime = 900, double progress = 0.25, bool isFinished = false, int? finishedAt}) {
  return MediaProgress(
    id: 'progress-id',
    userId: 'user-id',
    libraryItemId: 'item-id',
    episodeId: null,
    mediaItemId: 'media-id',
    mediaItemType: MediaItemType.BOOK,
    duration: 3600,
    progress: progress,
    currentTime: currentTime,
    isFinished: isFinished,
    lastUpdate: null,
    startedAt: DateTime(2026, 10, 16).millisecondsSinceEpoch,
    finishedAt: finishedAt,
  );
}
