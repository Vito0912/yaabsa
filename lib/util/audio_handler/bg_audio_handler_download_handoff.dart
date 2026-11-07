part of 'bg_audio_handler.dart';

extension _DownloadedAudioHandoff on BGAudioHandler {
  Future<void> _useDownloadedAudio(String itemId, String userId) async {
    final media = _currentMediaItem;
    if (_downloadHandoffInProgress ||
        _isDisposing ||
        media == null ||
        media.local ||
        media.itemId != itemId ||
        media.episodeId != null ||
        isCastControlActive ||
        isReaderNarration ||
        _ref.read(currentUserProvider).value?.id != userId) {
      return;
    }

    bool isCurrentRequest() {
      return !_isDisposing &&
          identical(_currentMediaItem, media) &&
          !isCastControlActive &&
          _ref.read(currentUserProvider).value?.id == userId;
    }

    _downloadHandoffInProgress = true;
    InternalMedia? localMedia;
    var resumePosition = position;
    try {
      final download = await _ref.read(appDatabaseProvider).getStoredDownload(itemId, userId);
      if (!isCurrentRequest() || download == null || !download.isComplete || download.tracks.isEmpty) {
        return;
      }

      resumePosition = position;
      localMedia = media.copyWith(tracks: download.tracks, local: true, saf: download.saf);
      localMedia.populateFields();
      _currentMediaItem = localMedia;
      await _setSource(initialPosition: resumePosition, ignoreSavedProgress: true);
    } catch (error, stackTrace) {
      logger(
        'Could not switch to downloaded audio: $error\n$stackTrace',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
      if (localMedia != null &&
          identical(_currentMediaItem, localMedia) &&
          !_isDisposing &&
          !isCastControlActive &&
          _ref.read(currentUserProvider).value?.id == userId) {
        _currentMediaItem = media;
        try {
          await _setSource(initialPosition: resumePosition, ignoreSavedProgress: true);
        } catch (fallbackError) {
          logger('Could not restore streaming audio: $fallbackError', tag: 'AudioHandler', level: InfoLevel.warning);
        }
      }
    } finally {
      _downloadHandoffInProgress = false;
    }
  }
}
