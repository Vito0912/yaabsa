import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:yaabsa/api/library_items/audio_file.dart';
import 'package:yaabsa/api/library_items/chapter.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/routes/abs_api.dart';

class ChapterEditorConflict implements Exception {
  const ChapterEditorConflict();
}

List<AudioFile> chapterEditorAudioFiles(LibraryItem item) {
  return (item.media?.bookMedia?.audioFiles ?? const <AudioFile>[]).where((file) => file.exclude != true).toList()
    ..sort((left, right) => (left.index ?? 0).compareTo(right.index ?? 0));
}

double chapterEditorDuration(LibraryItem item, List<AudioFile> files) {
  final duration = item.media?.bookMedia?.duration;
  if (duration != null && duration.isFinite && duration > 0) {
    return duration;
  }

  return files.fold<double>(0, (total, file) {
    final duration = file.duration ?? 0;
    return duration.isFinite && duration > 0 ? total + duration : total;
  });
}

Future<LibraryItem> loadChapterEditorItem({
  required ABSApi api,
  required String itemId,
  required CancelToken cancelToken,
}) async {
  final response = await api.getLibraryItemApi().getLibraryItem(
    itemId: itemId,
    cancelToken: cancelToken,
    extra: {'doNotCache': true},
  );
  final item = response.data;
  if (item == null || item.media?.bookMedia == null) {
    throw StateError('Could not load the audiobook.');
  }

  return item;
}

Future<LibraryItem> saveChapterEditorDraft({
  required ABSApi api,
  required String itemId,
  required List<Chapter> baseline,
  required double duration,
  required List<Chapter> chapters,
  required CancelToken cancelToken,
}) async {
  final fresh = await loadChapterEditorItem(api: api, itemId: itemId, cancelToken: cancelToken);
  final currentDuration = chapterEditorDuration(fresh, chapterEditorAudioFiles(fresh));
  if (!listEquals(fresh.media?.bookMedia?.chapters ?? const <Chapter>[], baseline) || currentDuration != duration) {
    throw const ChapterEditorConflict();
  }

  await api.getLibraryItemApi().updateLibraryItemChapters(itemId, chapters: chapters, cancelToken: cancelToken);
  final media = fresh.media!;
  return fresh.copyWith(
    media: media.copyWith(
      bookMedia: media.bookMedia!.copyWith(chapters: chapters, numChapters: chapters.length),
    ),
  );
}
