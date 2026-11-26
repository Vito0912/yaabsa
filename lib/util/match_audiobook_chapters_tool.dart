import 'dart:math' as math;

import 'package:yaabsa/api/json/value_parsers.dart';
import 'package:yaabsa/api/library/request/library_items_request.dart';
import 'package:yaabsa/api/library_items/audio_file.dart';
import 'package:yaabsa/api/library_items/chapter.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/features/upload/upload_metadata_parser.dart';

part 'match_audiobook_chapters_helpers.dart';

const int _chapterToolPageSize = 200;
const Duration _rateLimitDelay = Duration(milliseconds: 2000);
const Duration _cancelPollInterval = Duration(milliseconds: 100);

class MatchAudiobookChaptersOptions {
  const MatchAudiobookChaptersOptions({
    required this.chapterThreshold,
    required this.provider,
    required this.region,
    required this.searchForAsin,
    required this.useTracksAsChapters,
    required this.disableRateProtection,
  });

  final int chapterThreshold;
  final String provider;
  final String region;
  final bool searchForAsin;
  final bool useTracksAsChapters;
  final bool disableRateProtection;
}

class MatchAudiobookChaptersBookResult {
  const MatchAudiobookChaptersBookResult({
    required this.itemId,
    required this.title,
    required this.status,
    required this.comment,
    this.asin,
  });

  final String itemId;
  final String title;
  final String status;
  final String comment;
  final String? asin;
}

class MatchAudiobookChaptersToolResult {
  const MatchAudiobookChaptersToolResult({
    required this.totalBooks,
    required this.updatedBooks,
    required this.skippedBooks,
    required this.failedBooks,
    required this.cancelled,
    required this.results,
  });

  final int totalBooks;
  final int updatedBooks;
  final int skippedBooks;
  final int failedBooks;
  final bool cancelled;
  final List<MatchAudiobookChaptersBookResult> results;
}

enum _BookMatchOutcome { updated, skipped, failed }

typedef _BookMatchEntry = ({MatchAudiobookChaptersBookResult result, _BookMatchOutcome kind});

_BookMatchEntry _bookOutcome({
  required String itemId,
  required String title,
  required String status,
  required String comment,
  required _BookMatchOutcome kind,
  String? asin,
}) {
  return (
    result: MatchAudiobookChaptersBookResult(
      itemId: itemId,
      title: title,
      status: status,
      comment: comment,
      asin: asin,
    ),
    kind: kind,
  );
}

Future<MatchAudiobookChaptersToolResult> runMatchAudiobookChaptersTool({
  required ABSApi api,
  required String libraryId,
  required MatchAudiobookChaptersOptions options,
  void Function(String line)? onLog,
  void Function(int processed, int total)? onProgress,
  bool Function()? isCancelled,
}) async {
  final trimmedLibraryId = libraryId.trim();
  if (trimmedLibraryId.isEmpty) {
    throw ArgumentError('Library ID cannot be empty.');
  }
  if (options.chapterThreshold < 0) {
    throw ArgumentError('Chapter threshold must be 0 or greater.');
  }

  onLog?.call('Fetching library details for $trimmedLibraryId...');
  final libraryResponse = await api.getLibraryApi().getLibraryDetails(trimmedLibraryId);
  final library = libraryResponse.data?.library;
  if (library == null || library.mediaType.trim().toLowerCase() != 'book') {
    throw StateError('Library $trimmedLibraryId is not a valid book library.');
  }

  final items = await _fetchAllLibraryItems(api: api, libraryId: trimmedLibraryId);
  onLog?.call('Found ${items.length} books in "${library.name}".');

  final results = <MatchAudiobookChaptersBookResult>[];
  var updatedBooks = 0;
  var skippedBooks = 0;
  var failedBooks = 0;
  var cancelled = false;

  for (var index = 0; index < items.length; index++) {
    if (isCancelled?.call() == true) {
      cancelled = true;
      onLog?.call('Chapter matching cancelled.');
      break;
    }

    final item = items[index];
    final outcome = await _matchItemChapters(
      api: api,
      item: item,
      chapterThreshold: options.chapterThreshold,
      provider: options.provider,
      region: options.region,
      searchForAsin: options.searchForAsin,
      useTracksAsChapters: options.useTracksAsChapters,
      onLog: onLog,
    );

    results.add(outcome.result);
    switch (outcome.kind) {
      case _BookMatchOutcome.updated:
        updatedBooks += 1;
      case _BookMatchOutcome.skipped:
        skippedBooks += 1;
      case _BookMatchOutcome.failed:
        failedBooks += 1;
    }

    onProgress?.call(index + 1, items.length);

    if (index < items.length - 1 && !options.disableRateProtection) {
      final stoppedDuringWait = await _delayWithCancellation(isCancelled);
      if (stoppedDuringWait) {
        cancelled = true;
        onLog?.call('Chapter matching cancelled.');
        break;
      }
    }
  }

  return MatchAudiobookChaptersToolResult(
    totalBooks: items.length,
    updatedBooks: updatedBooks,
    skippedBooks: skippedBooks,
    failedBooks: failedBooks,
    cancelled: cancelled,
    results: results,
  );
}

Future<MatchAudiobookChaptersBookResult> quickMatchSingleBookChapters({
  required ABSApi api,
  required String itemId,
  String provider = 'audible.com',
  String region = 'US',
  bool searchForAsin = true,
  bool useTracksAsChapters = false,
}) async {
  final trimmedItemId = itemId.trim();
  if (trimmedItemId.isEmpty) {
    throw ArgumentError('Item ID cannot be empty.');
  }

  final response = await api.getLibraryItemApi().getLibraryItem(itemId: trimmedItemId);
  final item = response.data;
  if (item == null) {
    throw StateError('Library item $trimmedItemId was not found.');
  }

  final outcome = await _matchItemChapters(
    api: api,
    item: item,
    chapterThreshold: -1,
    provider: provider,
    region: region,
    searchForAsin: searchForAsin,
    useTracksAsChapters: useTracksAsChapters,
  );

  return outcome.result;
}

Future<_BookMatchEntry> _matchItemChapters({
  required ABSApi api,
  required LibraryItem item,
  required int chapterThreshold,
  required String provider,
  required String region,
  required bool searchForAsin,
  required bool useTracksAsChapters,
  void Function(String line)? onLog,
}) async {
  final bookId = item.id;
  final bookMedia = item.media?.bookMedia;
  final title = item.title;
  final authors = (item.authorString ?? bookMedia?.metadata.authorName ?? '').trim();
  final bookDuration = item.media?.duration() ?? 0;
  final currentChaptersNum = bookMedia?.numChapters ?? bookMedia?.chapters?.length ?? 0;

  onLog?.call('Processing "$title"...');

  var asin = bookMedia?.metadata.asin?.trim();
  var asinLookupAttempted = false;

  if ((asin == null || asin.isEmpty) && searchForAsin) {
    asinLookupAttempted = true;
    onLog?.call('Searching for ASIN for "$title"...');

    try {
      final searchResponse = await api.getUploadApi().searchMetadata(
        mediaType: 'book',
        title: title,
        author: authors.isEmpty ? null : authors,
        provider: provider,
        libraryItemId: bookId,
      );
      final bestMatch = UploadMetadataParser.firstResult(searchResponse.data);
      final candidateAsin = jsonStringFromDynamic(bestMatch?['asin'])?.trim();
      if (candidateAsin != null && candidateAsin.isNotEmpty) {
        asin = candidateAsin;
        onLog?.call('ASIN found for "$title": $asin');
      } else {
        onLog?.call('No ASIN found in metadata search for "$title".');
      }
    } catch (error) {
      onLog?.call('ASIN search failed for "$title": $error');
    }
  }

  if (asin == null || asin.isEmpty) {
    if (useTracksAsChapters) {
      return _applyTracksAsChapters(
        api: api,
        item: item,
        currentChaptersNum: currentChaptersNum,
        chapterThreshold: chapterThreshold,
        bookDuration: bookDuration,
        onLog: onLog,
      );
    }

    final comment = asinLookupAttempted ? 'ASIN retrieval failed' : 'No ASIN available';
    onLog?.call('Skipping "$title" ($comment).');
    return _bookOutcome(
      itemId: bookId,
      title: title,
      status: 'NO_ASIN',
      comment: comment,
      kind: asinLookupAttempted ? _BookMatchOutcome.failed : _BookMatchOutcome.skipped,
    );
  }

  onLog?.call('Fetching chapters for ASIN $asin...');
  final Map<String, dynamic> chapterSearchData;
  try {
    chapterSearchData = await api.getLibraryItemApi().searchChapters(asin: asin, region: region);
  } catch (error) {
    onLog?.call('No chapters found for "$title": $error');
    return _bookOutcome(
      itemId: bookId,
      title: title,
      status: 'ERROR',
      comment: 'No chapters found',
      asin: asin,
      kind: _BookMatchOutcome.failed,
    );
  }

  final rawChapters = chapterSearchData['chapters'];
  if (rawChapters is! List || rawChapters.isEmpty) {
    onLog?.call('No chapters returned for "$title".');
    return _bookOutcome(
      itemId: bookId,
      title: title,
      status: 'ERROR',
      comment: 'No chapters found',
      asin: asin,
      kind: _BookMatchOutcome.failed,
    );
  }

  final foundChaptersNum = rawChapters.length;
  final shouldUpdate = currentChaptersNum == 0 || (currentChaptersNum - foundChaptersNum).abs() > chapterThreshold;

  if (!shouldUpdate) {
    onLog?.call('Chapters are already up to date for "$title" ($currentChaptersNum chapters).');
    return _bookOutcome(
      itemId: bookId,
      title: title,
      status: 'FINISHED',
      comment: 'No chapters to update',
      asin: asin,
      kind: _BookMatchOutcome.skipped,
    );
  }

  final newChapters = _buildChaptersFromAsin(rawChapters, bookDuration);
  if (newChapters.isEmpty) {
    onLog?.call('Parsed chapter list was empty for "$title".');
    return _bookOutcome(
      itemId: bookId,
      title: title,
      status: 'ERROR',
      comment: 'No valid chapters found',
      asin: asin,
      kind: _BookMatchOutcome.failed,
    );
  }

  try {
    await api.getLibraryItemApi().updateLibraryItemChapters(bookId, chapters: newChapters);
    onLog?.call('Updated ${newChapters.length} chapters for "$title".');
    return _bookOutcome(
      itemId: bookId,
      title: title,
      status: 'FINISHED',
      comment: 'Chapters updated',
      asin: asin,
      kind: _BookMatchOutcome.updated,
    );
  } catch (error) {
    onLog?.call('Failed to save chapters for "$title": $error');
    return _bookOutcome(
      itemId: bookId,
      title: title,
      status: 'ERROR',
      comment: 'Chapters update failed',
      asin: asin,
      kind: _BookMatchOutcome.failed,
    );
  }
}
