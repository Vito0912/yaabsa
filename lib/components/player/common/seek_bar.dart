import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/me/bookmark.dart';
import 'package:yaabsa/components/player/common/seek_bar_row.dart';
import 'package:yaabsa/components/player/common/seek_bar_slider.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/provider/player/user_bookmarks_provider.dart';
import 'package:yaabsa/util/extensions.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/setting_key.dart';

class SeekBar extends ConsumerWidget {
  const SeekBar({
    super.key,
    this.trackHeight = 10.0,
    this.timeLabelsBelow = false,
    this.showTimeLabels = true,
    this.timeLabelFontSize = 12.0,
    this.previewLabelFontSize,
  });

  final double trackHeight;
  final bool timeLabelsBelow;
  final bool showTimeLabels;
  final double timeLabelFontSize;
  final double? previewLabelFontSize;

  String _formatDuration(Duration? duration) {
    if (duration == null) {
      return '--:--';
    }

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }

    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  InternalChapter? _getCurrentChapter(List<InternalChapter> chapters, Duration currentPosition) {
    final mediaChapter = audioHandler.currentMediaItem?.getChapterForDuration(currentPosition);
    if (mediaChapter != null) {
      return mediaChapter;
    }

    if (chapters.isEmpty) {
      return null;
    }

    for (final chapter in chapters) {
      final chapterStart = chapter.start.toDuration;
      final chapterEnd = chapter.end.toDuration;
      if (currentPosition >= chapterStart && currentPosition < chapterEnd) {
        return chapter;
      }
    }

    final lastChapter = chapters.last;
    if (currentPosition >= lastChapter.end.toDuration) {
      return lastChapter;
    }

    if (currentPosition < chapters.first.start.toDuration) {
      return chapters.first;
    }

    return null;
  }

  String _buildSeekPreviewTooltip(Duration position, List<InternalChapter> chapters) {
    final chapter = _getCurrentChapter(chapters, position);
    final chapterTitle = chapter?.title.trim() ?? '';
    if (chapterTitle.isEmpty) {
      return _formatDuration(position);
    }

    return '${_formatDuration(position)} - $chapterTitle';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seekBarModeSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.playerSeekBarMode));
    final markerModeSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.playerSeekBarMarkerMode));
    final bookmarks = ref.watch(userBookmarksProvider).value ?? const <Bookmark>[];

    final configuredMode = PlayerSeekBarMode.fromSettingValue(seekBarModeSetting.asData?.value);
    final markerMode = SeekBarMarkerMode.fromSettingValue(markerModeSetting.asData?.value);

    final positionStream = audioHandler.positionStream;
    final totalDurationStream = audioHandler.durationStream;
    final chaptersStream = audioHandler.chaptersStream;

    return StreamBuilder<Duration>(
      stream: totalDurationStream,
      builder: (context, totalDurationSnapshot) {
        final totalDuration = totalDurationSnapshot.data ?? Duration.zero;
        return StreamBuilder<Duration>(
          stream: positionStream,
          builder: (context, positionSnapshot) {
            final currentPosition = positionSnapshot.data ?? Duration.zero;
            return StreamBuilder<List<InternalChapter>>(
              stream: chaptersStream,
              builder: (context, chaptersSnapshot) {
                final chapters = chaptersSnapshot.data ?? const <InternalChapter>[];
                final currentChapter = _getCurrentChapter(chapters, currentPosition);
                final currentItemId = audioHandler.currentMediaItem?.itemId;

                final bookmarkSeconds = currentItemId == null
                    ? const <int>[]
                    : <int>{
                        for (final bookmark in bookmarks)
                          if (bookmark.libraryItemId == currentItemId && bookmark.time > 0) bookmark.time,
                      }.toList(growable: false);

                final fullTimelineMarkers = <SeekTimelineMarker>[
                  if (markerMode.showChapterMarkers)
                    for (final chapter in chapters)
                      SeekTimelineMarker(position: chapter.start.toDuration, type: SeekTimelineMarkerType.chapter),
                  if (markerMode.showBookmarks && currentItemId != null)
                    for (final seconds in bookmarkSeconds)
                      SeekTimelineMarker(
                        position: Duration(seconds: seconds),
                        type: SeekTimelineMarkerType.bookmark,
                      ),
                ];

                final shouldShowChapter =
                    (configuredMode == PlayerSeekBarMode.chapter || configuredMode == PlayerSeekBarMode.both) &&
                    currentChapter != null;
                final shouldShowFull =
                    configuredMode == PlayerSeekBarMode.full ||
                    configuredMode == PlayerSeekBarMode.both ||
                    !shouldShowChapter;

                final seekRows = <Widget>[];

                if (shouldShowChapter) {
                  final chapter = currentChapter;
                  final chapterStart = chapter.start.toDuration;
                  final chapterEnd = chapter.end.toDuration;
                  final chapterDuration = chapterEnd - chapterStart;
                  var chapterElapsed = currentPosition - chapterStart;
                  if (chapterElapsed < Duration.zero) {
                    chapterElapsed = Duration.zero;
                  }
                  if (chapterElapsed > chapterDuration) {
                    chapterElapsed = chapterDuration;
                  }

                  seekRows.add(
                    SeekBarRow(
                      trackHeight: trackHeight,
                      timeLabelsBelow: timeLabelsBelow,
                      showTimeLabels: showTimeLabels,
                      timeLabelFontSize: timeLabelFontSize,
                      previewLabelFontSize: previewLabelFontSize,
                      rangeStart: chapterStart,
                      rangeEnd: chapterEnd,
                      currentPosition: currentPosition,
                      leftTime: chapterElapsed,
                      rightTime: chapterDuration,
                      onSeek: (seekPosition) => audioHandler.seek(seekPosition),
                      markers: const <SeekTimelineMarker>[],
                      markerMode: SeekBarMarkerMode.none,
                      buildPreviewLabel: (position) => _buildSeekPreviewTooltip(position, chapters),
                      formatDuration: _formatDuration,
                    ),
                  );
                }

                if (shouldShowChapter && shouldShowFull) {
                  seekRows.add(const SizedBox(height: 4));
                }

                if (shouldShowFull) {
                  seekRows.add(
                    SeekBarRow(
                      trackHeight: trackHeight,
                      timeLabelsBelow: timeLabelsBelow,
                      showTimeLabels: showTimeLabels,
                      timeLabelFontSize: timeLabelFontSize,
                      previewLabelFontSize: previewLabelFontSize,
                      rangeStart: Duration.zero,
                      rangeEnd: totalDuration,
                      currentPosition: currentPosition,
                      leftTime: currentPosition,
                      rightTime: totalDuration,
                      onSeek: (seekPosition) => audioHandler.seek(seekPosition),
                      markers: fullTimelineMarkers,
                      markerMode: markerMode,
                      buildPreviewLabel: (position) => _buildSeekPreviewTooltip(position, chapters),
                      formatDuration: _formatDuration,
                    ),
                  );
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: seekRows,
                );
              },
            );
          },
        );
      },
    );
  }
}
