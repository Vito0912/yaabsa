part of 'bg_audio_handler.dart';

extension _BGAudioHandlerSource on BGAudioHandler {
  Future<dynamic> _setSource({Duration initialPosition = Duration.zero, bool ignoreSavedProgress = false}) async {
    if (_currentMediaItem == null) return Future.value();

    await _applyPreferredPlaybackSpeed(seedPerBookSpeedWhenMissing: true);

    final requestHeaders = _currentRequestHeadersInternal;
    final source = _currentMediaItem!.toAudioSources(headers: requestHeaders);
    if (!ignoreSavedProgress) {
      final sessionStartTimeSeconds = _ref.read(sessionRepositoryProvider).currentSession?.startTime;
      if (sessionStartTimeSeconds != null && sessionStartTimeSeconds > 0) {
        initialPosition = Duration(microseconds: (sessionStartTimeSeconds * Duration.microsecondsPerSecond).round());
      } else {
        final currentProgress = _ref.read(
          mediaProgressProvider.select((asyncValue) {
            return asyncValue.value?[mediaProgressKey(_currentMediaItem!.itemId, _currentMediaItem!.episodeId)];
          }),
        );

        if (currentProgress != null) {
          if (currentProgress.isFinished == true) {
            initialPosition = Duration.zero;
            logger('Progress indicates finished. Starting from beginning', tag: 'AudioHandler', level: InfoLevel.debug);
          } else {
            initialPosition = Duration(
              microseconds: ((currentProgress.currentTime) * Duration.microsecondsPerSecond).round(),
            );
          }
        }
      }
    }

    logger('Setting source with initial position: $initialPosition', tag: 'AudioHandler', level: InfoLevel.debug);

    final trackIndex = _currentMediaItem!.getIndexForDuration(initialPosition);
    final trackCount = _currentMediaItem!.tracks.length;
    final trackStartDuration = _currentMediaItem!.startDurationForTrack(trackIndex);
    final relativeTrackInitialPosition = initialPosition > trackStartDuration
        ? initialPosition - trackStartDuration
        : Duration.zero;
    _currentTrackIndex = trackIndex;

    final setSourceStopwatch = Stopwatch()..start();
    await player.setAudioSources(
      source,
      initialIndex: trackIndex,
      initialPosition: relativeTrackInitialPosition,
      preload: true,
    );
    setSourceStopwatch.stop();

    logger(
      'setAudioSources completed in ${setSourceStopwatch.elapsedMilliseconds}ms '
      '(trackIndex=$trackIndex, trackCount=$trackCount, initialPosition=$relativeTrackInitialPosition, preload=true)',
      tag: 'AudioHandler',
      level: InfoLevel.debug,
    );
  }

  Map<String, String> get _currentRequestHeadersInternal {
    final user = _ref.read(currentUserProvider).value;
    return buildRequestHeaders(serverHeaders: user?.server?.headers, bearerToken: user?.preferredAuthToken);
  }
}
