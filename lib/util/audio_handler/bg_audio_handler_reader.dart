part of 'bg_audio_handler.dart';

extension _BGAudioHandlerReader on BGAudioHandler {
  Future<void> _prepareReaderNarration({
    required LibraryItem item,
    required List<EpubNarrationClip> clips,
    required Map<int, String> chapterTitles,
    Uri? cover,
  }) async {
    if (clips.isEmpty) {
      throw const FormatException('This book has no playable narration');
    }

    final requestGeneration = ++_readerNarrationRequestGeneration;
    final playbackGeneration = _sleepTimerPlaybackGeneration;
    final navigationGeneration = _sleepTimerNavigationGeneration;

    final directory = await Directory.systemTemp.createTemp('yaabsa-narration-');

    final copiedFiles = <String, String>{};
    final sources = <AudioSource>[];
    final tracks = <InternalTrack>[];
    final chapters = <InternalChapter>[];
    final cues = <({double start, double end, String target})>[];
    var position = 0.0;
    var initialPosition = 0.0;
    var foundStart = false;

    try {
      for (var index = 0; index < clips.length;) {
        final first = clips[index];
        var filePath = copiedFiles[first.path];

        if (filePath == null) {
          final extension = RegExp(r'\.[a-zA-Z0-9]+$').firstMatch(first.path)?.group(0) ?? '.audio';

          filePath = '${directory.path}/${copiedFiles.length}$extension';
          await File(first.path).copy(filePath);

          copiedFiles[first.path] = filePath;
        }

        final start = position;
        var last = first;
        final sectionIndex = first.sectionIndex;

        do {
          final clip = clips[index];

          if (clip.isStart && !foundStart) {
            initialPosition = position;
            foundStart = true;
          }

          cues.add((start: position, end: position + clip.duration, target: clip.target));
          position += clip.duration;
          last = clip;
          index++;
        } while (index < clips.length &&
            clips[index].path == first.path &&
            clips[index].sectionIndex == sectionIndex &&
            (clips[index].begin - last.end).abs() < 0.000001);

        sources.add(
          ClippingAudioSource(
            child: AudioSource.file(filePath),
            start: Duration(microseconds: (first.begin * 1e6).round()),
            end: Duration(microseconds: (last.end * 1e6).round()),
          ),
        );
        tracks.add(
          InternalTrack(
            index: tracks.length,
            duration: position - start,
            url: filePath,
            mimeType: first.mimeType,
            start: start,
            end: position,
          ),
        );

        final title = chapterTitles[sectionIndex] ?? 'Chapter ${sectionIndex + 1}';

        if (chapters.isNotEmpty && chapters.last.title == title && chapters.last.end == start) {
          chapters[chapters.length - 1] = chapters.last.copyWith(end: position);
        } else {
          chapters.add(InternalChapter(start: start, end: position, title: title));
        }
      }

      if (_isDisposing ||
          requestGeneration != _readerNarrationRequestGeneration ||
          playbackGeneration != _sleepTimerPlaybackGeneration ||
          navigationGeneration != _sleepTimerNavigationGeneration) {
        throw PlayerInterruptedException('Narration preparation interrupted');
      }

      await stop();

      if (_isDisposing || requestGeneration + 1 != _readerNarrationRequestGeneration) {
        throw PlayerInterruptedException('Narration preparation interrupted');
      }

      _readerNarrationDirectory = directory;
      _readerNarrationSources = sources;
      _readerNarrationCues = cues;
      _currentMediaItem = InternalMedia(
        libraryId: item.libraryId ?? '',
        itemId: item.id,
        episodeId: null,
        sessionId: 'epub:${DateTime.now().microsecondsSinceEpoch}',
        title: item.title,
        subtitle: 'Book narration',
        author: item.authorString,
        cover: cover,
        tracks: tracks,
        chapters: chapters,
        duration: position,
        local: true,
        saf: false,
      );
      mediaItem.add(_currentMediaItem!.toMediaItem());

      final initial = Duration(microseconds: (initialPosition * 1e6).round());
      final trackIndex = _currentMediaItem!.getIndexForDuration(initial);

      _currentTrackIndex = trackIndex;

      final media = _currentMediaItem;

      await _player.setAudioSources(
        sources,
        initialIndex: trackIndex,
        initialPosition: initial - media!.startDurationForTrack(trackIndex),
      );

      if (!identical(_currentMediaItem, media) || _isDisposing) {
        return;
      }

      await _applyPreferredPlaybackSpeed();

      if (identical(_currentMediaItem, media) && !_isDisposing) {
        await play();
      }
    } catch (_) {
      if (identical(_readerNarrationDirectory, directory)) {
        await stop();
      }

      if (await directory.exists()) {
        await directory.delete(recursive: true);
      }

      rethrow;
    }
  }
}
