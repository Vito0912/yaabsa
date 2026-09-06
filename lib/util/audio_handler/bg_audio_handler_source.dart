part of 'bg_audio_handler.dart';

extension _BGAudioHandlerSource on BGAudioHandler {
  Future<dynamic> _setSource({
    Duration initialPosition = Duration.zero,
    bool ignoreSavedProgress = false,
    int transcodeStartupAttempt = 0,
  }) async {
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
    final loadingMedia = _currentMediaItem;

    final setSourceStopwatch = Stopwatch()..start();
    final sourceLoadError = Completer<PlayerException>();
    _sourceLoadErrorCompleter = sourceLoadError;
    try {
      final sourceLoad = player.setAudioSources(
        source,
        initialIndex: trackIndex,
        initialPosition: relativeTrackInitialPosition,
        preload: true,
      );
      final loadResult = Future.any<dynamic>([
        sourceLoad,
        sourceLoadError.future.then<dynamic>((error) => throw error),
      ]);
      if (_ref.read(sessionRepositoryProvider).currentSession?.playMethod == 2) {
        await loadResult.timeout(
          const Duration(seconds: 15),
          onTimeout: () => throw PlayerException(1, 'Timed out waiting for transcoded stream', trackIndex),
        );
      } else {
        await loadResult;
      }
    } on PlayerException catch (error) {
      final session = _ref.read(sessionRepositoryProvider).currentSession;
      if (identical(_currentMediaItem, loadingMedia) &&
          !_isDisposing &&
          !isCastControlActive &&
          session?.playMethod == 2 &&
          session?.id == loadingMedia?.sessionId &&
          transcodeStartupAttempt < 10 &&
          _isRetryableTranscodeStartupError(error)) {
        final delay = Duration(seconds: transcodeStartupAttempt < 5 ? 4 : 6);
        logger(
          'Transcoded stream is not ready. Retrying source load '
          '${transcodeStartupAttempt + 1}/10 in ${delay.inSeconds}s.',
          tag: 'AudioHandler',
          level: InfoLevel.warning,
        );
        await _safePlayerStop();
        await Future<void>.delayed(delay);
        if (!identical(_currentMediaItem, loadingMedia) || _isDisposing || isCastControlActive) {
          throw PlayerInterruptedException('Transcoded stream loading interrupted');
        }
        return await _setSource(
          initialPosition: initialPosition,
          ignoreSavedProgress: true,
          transcodeStartupAttempt: transcodeStartupAttempt + 1,
        );
      }
      if (identical(_currentMediaItem, loadingMedia) &&
          !_isDisposing &&
          classifyPlaybackError(error) == PlaybackFailureAction.transcode &&
          await _attemptTranscodeFallback(error, initialPosition: initialPosition, resumePlayback: false)) {
        return;
      }

      rethrow;
    } finally {
      if (identical(_sourceLoadErrorCompleter, sourceLoadError)) {
        _sourceLoadErrorCompleter = null;
      }
    }
    setSourceStopwatch.stop();

    logger(
      'setAudioSources completed in ${setSourceStopwatch.elapsedMilliseconds}ms '
      '(trackIndex=$trackIndex, trackCount=$trackCount, initialPosition=$relativeTrackInitialPosition, preload=true)',
      tag: 'AudioHandler',
      level: InfoLevel.debug,
    );
  }

  bool _isRetryableTranscodeStartupError(PlayerException error) {
    final message = '${error.message}'.toLowerCase();
    if (RegExp(r'\b(?:400|401|403)\b').hasMatch(message) ||
        classifyPlaybackError(error) == PlaybackFailureAction.transcode) {
      return false;
    }
    return classifyPlaybackError(error) == PlaybackFailureAction.retryStream ||
        RegExp(r'\b(?:404|408|425|429|500|502|503|504)\b').hasMatch(message) ||
        message.contains('failed to open') ||
        message.contains('avformat_open_input') ||
        message.contains('source error') ||
        message.contains('no video or audio streams') ||
        message.contains('failed to create file cache');
  }

  Map<String, String> get _currentRequestHeadersInternal {
    final user = _ref.read(currentUserProvider).value;
    final isHls = _currentMediaItem?.tracks.any((track) => track.mimeType.toLowerCase().contains('mpegurl')) ?? false;
    return buildRequestHeaders(
      serverHeaders: user?.server?.headers,
      bearerToken: isHls ? user?.preferredAuthToken : null,
    );
  }
}
