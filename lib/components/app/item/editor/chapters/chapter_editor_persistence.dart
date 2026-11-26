import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:yaabsa/api/library_items/audio_file.dart';
import 'package:yaabsa/api/library_items/chapter.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/app/item/editor/chapters/chapter_editor_draft.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';
import 'package:yaabsa/l10n/generated/app_localizations.dart';
import 'package:yaabsa/util/match_audiobook_chapters_tool.dart';

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

List<ChapterEditorValue> chapterEditorValues(List<Chapter> chapters) {
  return chapters.map((chapter) => (start: chapter.start, title: chapter.title)).toList(growable: false);
}

List<Chapter> chapterEditorBuildChapters(ChapterEditorDraft draft) {
  return draft
      .values()
      .map((value) => Chapter(id: value.id, start: value.start, end: value.end, title: value.title))
      .toList(growable: false);
}

List<ChapterEditorValue> chapterEditorValuesFromTracks(List<AudioFile> files) {
  var offset = 0.0;
  final chapters = <ChapterEditorValue>[];
  for (final file in files) {
    final duration = file.duration ?? 0;
    if (duration <= 0 || !duration.isFinite) {
      continue;
    }

    final title = file.metadata.filename.replaceFirst(RegExp(r'\.[^.]+$'), '');
    chapters.add((start: offset, title: title));
    offset += duration;
  }

  return chapters;
}

Future<({LibraryItem? refreshedItem, String feedback, bool isError})> runChapterEditorQuickMatch({
  required ABSApi api,
  required String itemId,
  required AppLocalizations l10n,
  required CancelToken cancelToken,
}) async {
  try {
    final result = await quickMatchSingleBookChapters(api: api, itemId: itemId);
    if (result.status == 'FINISHED' && result.comment != 'No chapters to update') {
      final fresh = await loadChapterEditorItem(api: api, itemId: itemId, cancelToken: cancelToken);
      return (refreshedItem: fresh, feedback: l10n.statusSingleBookChaptersUpdated(result.title), isError: false);
    }

    if (result.status == 'FINISHED') {
      return (refreshedItem: null, feedback: l10n.statusSingleBookChaptersUnchanged(result.title), isError: false);
    }

    return (refreshedItem: null, feedback: l10n.errorSingleBookChaptersFailed(result.comment), isError: false);
  } catch (error) {
    final fallback = l10n.errorSingleBookChaptersFailed(error.toString());
    return (refreshedItem: null, feedback: listManagementErrorMessage(error, fallback: fallback), isError: true);
  }
}

Future<({LibraryItem? updated, List<Chapter>? savedChapters, String? message, bool conflict})>
persistChapterEditorDraft({
  required ABSApi api,
  required String itemId,
  required List<Chapter> baseline,
  required double duration,
  required ChapterEditorDraft draft,
  required CancelToken cancelToken,
  required AppLocalizations l10n,
}) async {
  final chapters = chapterEditorBuildChapters(draft);
  try {
    final updated = await saveChapterEditorDraft(
      api: api,
      itemId: itemId,
      baseline: baseline,
      duration: duration,
      chapters: chapters,
      cancelToken: cancelToken,
    );
    return (updated: updated, savedChapters: chapters, message: l10n.statusChaptersSaved, conflict: false);
  } on ChapterEditorConflict {
    return (updated: null, savedChapters: null, message: l10n.statusChapterSaveConflict, conflict: true);
  } catch (error) {
    final fallback = l10n.errorOperationFailed(l10n.operationSaveChapters, error.toString());
    return (
      updated: null,
      savedChapters: null,
      message: listManagementErrorMessage(error, fallback: fallback),
      conflict: false,
    );
  }
}

Future<({LibraryItem? item, String? error})> reloadChapterEditorItem({
  required ABSApi api,
  required String itemId,
  required CancelToken cancelToken,
  required AppLocalizations l10n,
}) async {
  try {
    final fresh = await loadChapterEditorItem(api: api, itemId: itemId, cancelToken: cancelToken);
    return (item: fresh, error: null);
  } catch (error) {
    final fallback = l10n.errorOperationFailed(l10n.operationReloadChapters, error.toString());
    return (item: null, error: listManagementErrorMessage(error, fallback: fallback));
  }
}
