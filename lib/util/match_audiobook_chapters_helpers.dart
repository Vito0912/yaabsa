part of 'match_audiobook_chapters_tool.dart';

Future<_BookMatchEntry> _applyTracksAsChapters({
  required ABSApi api,
  required LibraryItem item,
  required int currentChaptersNum,
  required int chapterThreshold,
  required double bookDuration,
  void Function(String line)? onLog,
}) async {
  final bookId = item.id;
  final title = item.title;
  onLog?.call('Using audio tracks as chapters for "$title"...');

  List<AudioFile> audioFiles = item.media?.bookMedia?.audioFiles ?? const <AudioFile>[];
  var resolvedDuration = bookDuration;

  if (audioFiles.isEmpty) {
    try {
      final detailsResponse = await api.getLibraryItemApi().getLibraryItem(itemId: bookId);
      final details = detailsResponse.data;
      if (details == null) {
        onLog?.call('Failed to load audio files for "$title".');
        return _bookOutcome(
          itemId: bookId,
          title: title,
          status: 'TRACKS',
          comment: 'Tracks retrieval failed',
          kind: _BookMatchOutcome.failed,
        );
      }

      audioFiles = details.media?.bookMedia?.audioFiles ?? const <AudioFile>[];
      if (resolvedDuration <= 0) {
        resolvedDuration = details.media?.duration() ?? 0;
      }
    } catch (error) {
      onLog?.call('Error loading audio files for "$title": $error');
      return _bookOutcome(
        itemId: bookId,
        title: title,
        status: 'TRACKS',
        comment: 'Tracks retrieval failed',
        kind: _BookMatchOutcome.failed,
      );
    }
  }

  if (audioFiles.length <= 1) {
    onLog?.call('Skipping tracks fallback for "$title" (${audioFiles.length} track found).');
    return _bookOutcome(
      itemId: bookId,
      title: title,
      status: 'TRACKS',
      comment: 'Tracks retrieval failed',
      kind: _BookMatchOutcome.failed,
    );
  }

  final tracksNum = audioFiles.length;
  final shouldUpdate = currentChaptersNum == 0 || (currentChaptersNum - tracksNum).abs() > chapterThreshold;

  if (!shouldUpdate) {
    onLog?.call('Chapters are already up to date for "$title".');
    return _bookOutcome(
      itemId: bookId,
      title: title,
      status: 'FINISHED',
      comment: 'No chapters to update',
      kind: _BookMatchOutcome.skipped,
    );
  }

  final trackChapters = _buildChaptersFromTracks(audioFiles, resolvedDuration);
  try {
    await api.getLibraryItemApi().updateLibraryItemChapters(bookId, chapters: trackChapters);
    onLog?.call('Updated ${trackChapters.length} track chapters for "$title".');
    return _bookOutcome(
      itemId: bookId,
      title: title,
      status: 'FINISHED',
      comment: 'Tracks used as chapters',
      kind: _BookMatchOutcome.updated,
    );
  } catch (error) {
    onLog?.call('Failed to save track chapters for "$title": $error');
    return _bookOutcome(
      itemId: bookId,
      title: title,
      status: 'ERROR',
      comment: 'Chapters update failed',
      kind: _BookMatchOutcome.failed,
    );
  }
}

List<Chapter> _buildChaptersFromAsin(List<dynamic> rawChapters, double bookDuration) {
  final chapters = <Chapter>[];

  for (var index = 0; index < rawChapters.length; index++) {
    final entry = rawChapters[index];
    if (entry is! Map) {
      continue;
    }

    final startOffsetMs = jsonDoubleFromDynamic(entry['startOffsetMs']) ?? 0;
    final lengthMs = jsonDoubleFromDynamic(entry['lengthMs']) ?? 0;
    final start = math.max(0.0, startOffsetMs / 1000.0);
    final rawEnd = math.max(start, (startOffsetMs + lengthMs) / 1000.0);
    final end = bookDuration > 0 ? math.min(rawEnd, bookDuration) : rawEnd;

    if (bookDuration > 0 && start >= bookDuration) {
      break;
    }

    final rawTitle = jsonStringFromDynamic(entry['title'])?.trim();
    final title = (rawTitle == null || rawTitle.isEmpty) ? 'Chapter ${index + 1}' : rawTitle;

    chapters.add(Chapter(id: chapters.length, start: start, end: end, title: title));
  }

  return chapters;
}

List<Chapter> _buildChaptersFromTracks(List<AudioFile> audioFiles, double bookDuration) {
  final chapters = <Chapter>[];
  var currentTime = 0.0;

  for (var index = 0; index < audioFiles.length; index++) {
    final track = audioFiles[index];
    final duration = track.duration ?? 0;
    final filename = track.metadata.filename;
    final dotIndex = filename.lastIndexOf('.');
    final trackTitle = dotIndex > 0 ? filename.substring(0, dotIndex) : filename;

    final start = currentTime;
    final rawEnd = start + duration;
    final end = bookDuration > 0 ? math.min(rawEnd, bookDuration) : rawEnd;

    chapters.add(Chapter(id: index, start: start, end: end, title: trackTitle));

    currentTime += duration - 0.001;
    if (bookDuration > 0 && bookDuration < currentTime) {
      break;
    }
  }

  return chapters;
}

Future<List<LibraryItem>> _fetchAllLibraryItems({required ABSApi api, required String libraryId}) async {
  final allItems = <LibraryItem>[];
  var page = 0;

  while (true) {
    final request = LibraryItemsRequest(limit: _chapterToolPageSize, page: page);
    final response = await api.getLibraryApi().getLibraryItems(libraryId, request);
    final pageData = response.data;
    if (pageData == null || pageData.results.isEmpty) {
      break;
    }

    allItems.addAll(pageData.results);

    final total = pageData.total;
    if (total != null) {
      if (allItems.length >= total) {
        break;
      }
    } else if (pageData.results.length < _chapterToolPageSize) {
      break;
    }

    page += 1;
  }

  return allItems;
}

Future<bool> _delayWithCancellation(bool Function()? isCancelled) async {
  var remaining = _rateLimitDelay;
  while (remaining > Duration.zero) {
    if (isCancelled?.call() == true) {
      return true;
    }

    final step = remaining > _cancelPollInterval ? _cancelPollInterval : remaining;
    await Future<void>.delayed(step);
    remaining -= step;
  }

  return isCancelled?.call() == true;
}
