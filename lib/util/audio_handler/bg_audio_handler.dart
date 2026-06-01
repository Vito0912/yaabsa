// ignore_for_file: unused_element_parameter

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_chrome_cast/flutter_chrome_cast.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_data.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/library/personalized_library.dart';
import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/api/library/request/library_items_request.dart';
import 'package:yaabsa/api/library/search_library.dart';
import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/series.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/list/collection.dart';
import 'package:yaabsa/api/list/playlist.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/models/internal_download.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/library/personalized_shelf_refresh.dart';
import 'package:yaabsa/provider/core/server_reachability_provider.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/player/session_provider.dart';
import 'package:yaabsa/util/globals.dart' show packageInfo;
import 'package:yaabsa/util/audio_handler/playback_sync_service.dart';
import 'package:yaabsa/util/audio_handler/player_history_handler.dart';
import 'package:yaabsa/util/handler/tray_handler.dart' show TrayManager;
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/network/request_headers.dart';
import 'package:yaabsa/util/player_utils.dart' show PlayerUtils;
import 'package:yaabsa/util/setting_key.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:rxdart/rxdart.dart';

part 'bg_audio_handler_models.dart';
part 'bg_audio_handler_runtime.dart';
part 'bg_audio_handler_resume.dart';
part 'bg_audio_handler_queue.dart';
part 'bg_audio_handler_preferences.dart';
part 'bg_audio_handler_state.dart';
part 'bg_audio_handler_playback_internal.dart';
part 'bg_audio_handler_source.dart';
part 'bg_audio_handler_custom_actions.dart';
part 'bg_audio_handler_auto_queue.dart';
part 'auto/bg_audio_handler_android_auto.dart';
part 'auto/bg_audio_handler_android_auto_ids.dart';
part 'auto/bg_audio_handler_android_auto_data.dart';
part 'auto/bg_audio_handler_android_auto_media.dart';
part 'auto/bg_audio_handler_android_auto_browse.dart';

const String _androidAutoCustomActionRewind = 'aa.custom.rewind';
const String _androidAutoCustomActionFastForward = 'aa.custom.fast_forward';
const String _androidAutoCustomActionSpeed = 'aa.custom.speed';
const String _androidAutoCustomActionMoreMenu = 'aa.custom.more.menu';
const String _androidAutoCustomActionMoreClose = 'aa.custom.more.close';
const String _androidAutoCustomActionStop = 'aa.custom.stop';
const String _widgetCustomActionPlayLast = 'widget.play_last';

const String _androidAutoIconReplay = 'drawable/replay';
const String _androidAutoIconForwardMedia = 'drawable/forward_media';
const String _androidAutoIconSpeed = 'drawable/speed';
const String _androidAutoIconStop = 'drawable/stop';
const String _androidAutoIconClose = 'drawable/close';
const String _androidAutoIconMoreVert = 'drawable/more_vert';
const int _streamRecoveryMaxAttempts = 6;
const Duration _streamRecoveryResetWindow = Duration(seconds: 45);
const int _streamRecoveryMinDelayMs = 400;
const int _streamRecoveryMaxDelayMs = 5000;

class BGAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  late final AudioPlayer _player;
  final ProviderContainer _ref;
  late final PlaybackSyncService _syncService;
  StreamSubscription<PlayerException>? _errorSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  StreamSubscription<int?>? _playerCurrentIndexSubscription;
  StreamSubscription<GoogleCastSession?>? _castSessionSubscription;
  StreamSubscription<GoggleCastMediaStatus?>? _castMediaStatusSubscription;
  late final StreamSubscription<String?> _activeUserIdSubscription;
  late final StreamSubscription<String?> _showLastPlayedMiniPlayerSettingSubscription;
  bool _isDisposing = false;
  List<PlayerQueueEntry> queueList = [];
  QueueItem? _lastQueueItem;
  Future<void> _skipOperationQueue = Future.value();
  int _queueEntryCounter = 0;
  int _autoQueueGeneration = 0;
  _AutoQueueState? _autoQueueState;
  DateTime? _pausedAt;
  String? _pausedItemId;
  String? _pausedEpisodeId;
  Duration? _pausedManualSeekPosition;
  String? _pausedManualSeekItemId;
  String? _pausedManualSeekEpisodeId;
  Timer? _streamRecoveryRetryTimer;
  DateTime? _lastStreamRecoveryAttemptAt;
  int _streamRecoveryAttempts = 0;
  bool _streamRecoveryInFlight = false;
  int _internalSeekGuardDepth = 0;
  bool _historyWasPlayingReady = false;
  bool _historyWasBufferingOrLoading = false;
  bool _historyWasCompleted = false;
  final BehaviorSubject<int> _queueLengthSubject = BehaviorSubject<int>.seeded(0);
  final BehaviorSubject<PlayerQueueSnapshot> _queueSnapshotSubject = BehaviorSubject<PlayerQueueSnapshot>.seeded(
    const PlayerQueueSnapshot(),
  );
  final BehaviorSubject<bool> _queueTransitionLoadingSubject = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _showPlayerSubject = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<LastPlayedMiniPlayerSnapshot?> _lastPlayedMiniPlayerSnapshotSubject =
      BehaviorSubject<LastPlayedMiniPlayerSnapshot?>.seeded(null);
  final Map<String, Future<LibraryItem?>> _queueItemDetailsCache = <String, Future<LibraryItem?>>{};
  bool _queueTransitionLoading = false;
  String? _queueTransitionItemId;
  String? _queueTransitionEpisodeId;
  bool _forceQueueSwitchOnNextPlay = false;
  bool _androidAutoMoreMenuVisible = false;
  Timer? _androidAutoMoreMenuTimer;
  late final BehaviorSubject<PlayerState> _playerControlStateSubject;
  final BehaviorSubject<bool> _castControlActiveSubject = BehaviorSubject<bool>.seeded(false);
  String? _castControlledContentId;
  int _castControlledTrackIndex = 0;
  BehaviorSubject<InternalMedia?> mediaItemStream = BehaviorSubject<InternalMedia?>();
  InternalMedia? get currentMediaItem => _currentMediaItem;

  Stream<PlayerQueueSnapshot> get queueSnapshotStream => _queueSnapshotSubject.stream;
  PlayerQueueSnapshot get queueSnapshot => _buildQueueSnapshot();
  Stream<bool> get queueTransitionLoadingStream => _queueTransitionLoadingSubject.stream;
  bool get queueTransitionLoading => _queueTransitionLoading;
  Stream<LastPlayedMiniPlayerSnapshot?> get lastPlayedMiniPlayerSnapshotStream =>
      _lastPlayedMiniPlayerSnapshotSubject.stream;
  LastPlayedMiniPlayerSnapshot? get lastPlayedMiniPlayerSnapshot => _lastPlayedMiniPlayerSnapshotSubject.value;
  bool isQueueTransitionForItem(String itemId, {String? episodeId}) {
    final transitionItemId = _queueTransitionItemId;
    if (!_queueTransitionLoading || transitionItemId == null || transitionItemId.isEmpty) {
      return false;
    }

    return _queueItemsMatch(
      leftItemId: transitionItemId,
      leftEpisodeId: _queueTransitionEpisodeId,
      rightItemId: itemId,
      rightEpisodeId: episodeId,
    );
  }

  Stream<PlayerState> get playerControlStateStream => _playerControlStateSubject.stream.distinct(
    (previous, next) => previous.playing == next.playing && previous.processingState == next.processingState,
  );
  PlayerState get playerControlState => _playerControlStateSubject.value;
  Stream<bool> get castControlActiveStream => _castControlActiveSubject.stream.distinct();
  bool get isCastControlActive => _castControlActiveSubject.value;

  bool get _supportsCastPlatform => Platform.isAndroid || Platform.isIOS;

  static double get maxVolume {
    if (Platform.isAndroid) {
      return 2.0;
    }
    return 1.0;
  }

  Future<void> applySleepTimerAutoRewindNow() async {
    return _applySleepTimerAutoRewindNowInternal();
  }

  Future<bool> playLastPlayed({bool requireStartupSettingEnabled = false, bool resumeCurrentIfPaused = true}) async {
    return _playLastPlayedInternal(
      requireStartupSettingEnabled: requireStartupSettingEnabled,
      resumeCurrentIfPaused: resumeCurrentIfPaused,
    );
  }

  Future<bool> playLastPlayedIfEnabledOnStartup() {
    return _playLastPlayedIfEnabledOnStartupInternal();
  }

  Future<void> restoreLastPlayedMiniPlayerIfEnabled() {
    return _restoreLastPlayedMiniPlayerIfEnabledInternal();
  }

  Future<void> clearAndroidAutoAuthenticationError() {
    return _androidAutoClearAuthenticationRequiredState(this, refreshBrowseRoots: true);
  }

  bool isInQueue(String itemId, {String? episodeId}) {
    if (episodeId == null) {
      return queueList.any((entry) => entry.item.itemId == itemId);
    }

    return queueList.any(
      (entry) => _queueItemsMatch(
        leftItemId: entry.item.itemId,
        leftEpisodeId: entry.item.episodeId,
        rightItemId: itemId,
        rightEpisodeId: episodeId,
      ),
    );
  }

  bool isQueueItemInQueue(QueueItem item) {
    return isInQueue(item.itemId, episodeId: item.episodeId);
  }

  void setQueue(QueueItem item, {QueueDisplayInfo displayInfo = QueueDisplayInfo.empty}) {
    _clearAutoQueueState();
    queueList = [];
    _enqueueItem(item, displayInfo: displayInfo);
    _forceQueueSwitchOnNextPlay = true;
    _emitQueueState();
  }

  void setQueueFromLibraryItem(LibraryItem item) {
    setQueue(QueueItem(itemId: item.id), displayInfo: _displayInfoFromLibraryItem(item));
  }

  void setQueueFromPodcastEpisode(LibraryItem item, Episode episode) {
    setQueue(
      QueueItem(itemId: item.id, episodeId: episode.id),
      displayInfo: _displayInfoFromPodcastEpisode(item, episode),
    );
  }

  void addToQueue(QueueItem item, {QueueDisplayInfo displayInfo = QueueDisplayInfo.empty}) {
    _enqueueItem(item, displayInfo: displayInfo);
    _emitQueueState();
  }

  void addLibraryItemToQueue(LibraryItem item) {
    addToQueue(QueueItem(itemId: item.id), displayInfo: _displayInfoFromLibraryItem(item));
  }

  void addPodcastEpisodeToQueue(LibraryItem item, Episode episode) {
    addToQueue(
      QueueItem(itemId: item.id, episodeId: episode.id),
      displayInfo: _displayInfoFromPodcastEpisode(item, episode),
    );
  }

  void removeFromQueueByItemId(String itemId, {String? episodeId}) {
    return _removeFromQueueByItemIdInternal(itemId, episodeId: episodeId);
  }

  void removeFromQueueItem(QueueItem item) {
    removeFromQueueByItemId(item.itemId, episodeId: item.episodeId);
  }

  void removeQueueEntry(String queueEntryId) {
    final nextQueue = queueList.where((entry) => entry.id != queueEntryId).toList();
    if (nextQueue.length == queueList.length) {
      return;
    }

    queueList = nextQueue;
    _emitQueueState();
  }

  void reorderQueue(int oldIndex, int newIndex) {
    return _reorderQueueInternal(oldIndex, newIndex);
  }

  Future<void> loadMoreAutoQueue() {
    return _loadMoreAutoQueue();
  }

  @override
  Future<List<MediaItem>> getChildren(String parentMediaId, [Map<String, dynamic>? options]) {
    return _androidAutoGetChildren(parentMediaId, options: options);
  }

  @override
  Future<MediaItem?> getMediaItem(String mediaId) {
    return _androidAutoGetMediaItem(mediaId);
  }

  @override
  Future<List<MediaItem>> search(String query, [Map<String, dynamic>? extras]) {
    return _androidAutoSearch(query, extras: extras);
  }

  @override
  Future<void> playFromMediaId(String mediaId, [Map<String, dynamic>? extras]) {
    return _androidAutoPlayFromMediaId(mediaId, extras: extras);
  }

  @override
  Future<void> playFromSearch(String query, [Map<String, dynamic>? extras]) {
    return _androidAutoPlayFromSearch(query, extras: extras);
  }

  @override
  Future<dynamic> customAction(String name, [Map<String, dynamic>? extras]) async {
    final handled = await _handleCustomAction(name, extras: extras);
    return handled ?? super.customAction(name, extras);
  }

  Future<LibraryItem?> resolveQueueLibraryItem(String itemId) {
    return _resolveQueueLibraryItemInternal(itemId);
  }

  AudioPlayer get player => _player;

  int _currentTrackIndex = 0;
  InternalMedia? __currentMediaItem;

  InternalMedia? get _currentMediaItem => __currentMediaItem;
  set _currentMediaItem(InternalMedia? mediaItem) {
    __currentMediaItem = mediaItem;
    _currentTrackIndex = 0;
    _clearPausedManualSeekMarker();
    _resetStreamRecoveryState(clearWindow: true);
    if (mediaItem != null) {
      unawaited(_persistLastPlayedQueueItem(itemId: mediaItem.itemId, episodeId: mediaItem.episodeId));
      unawaited(_persistLastPlayedMiniPlayerSnapshot(mediaItem));
      _setLastPlayedMiniPlayerSnapshot(LastPlayedMiniPlayerSnapshot.fromMedia(mediaItem));
    }
    mediaItemStream.add(mediaItem);
    _refreshPlayerControlState();
    _emitShouldShowPlayer();
    _handleAutoQueueOnCurrentItemChange(
      mediaItem == null ? null : _queueItemReferenceKey(itemId: mediaItem.itemId, episodeId: mediaItem.episodeId),
    );
  }

  Stream<double> get volumeStream => _player.volumeStream;

  static const double _minPlaybackSpeed = 0.25;
  static const double _maxPlaybackSpeed = 3.0;
  static const double _playbackPreferenceEpsilon = 0.0001;

  Future<void> setVolume(double volume) async {
    return _setVolumeInternal(volume);
  }

  @override
  Future<void> setSpeed(double speed) async {
    return _setSpeedInternal(speed);
  }

  void activateCastControl({required String contentId, required int trackIndex}) {
    _castControlledContentId = contentId;
    _castControlledTrackIndex = trackIndex < 0 ? 0 : trackIndex;
    _refreshPlayerControlState();
    unawaited(_updatePlaybackState());
  }

  void deactivateCastControl() {
    _castControlledContentId = null;
    _castControlledTrackIndex = 0;
    _refreshPlayerControlState();
    unawaited(_updatePlaybackState());
  }

  Stream<Duration> get durationStream {
    return _durationStreamInternal();
  }

  Duration get duration {
    return _durationInternal();
  }

  Stream<Duration> get positionStream {
    return _positionStreamInternal();
  }

  Stream<Duration> get bufferedPositionStream {
    return _bufferedPositionStreamInternal();
  }

  Stream<InternalChapter?> get chapterStream {
    return _chapterStreamInternal();
  }

  Stream<List<InternalChapter>> get chaptersStream {
    return _chaptersStreamInternal();
  }

  Stream<int> get queueLengthStream => _queueLengthStreamInternal();

  bool get canSkipForwardNow {
    return _canSkipForwardNowInternal();
  }

  Stream<bool> get canSkipForwardStream {
    return _canSkipForwardStreamInternal();
  }

  Duration get position {
    return _positionInternal();
  }

  Stream<bool> get shouldShowPlayer {
    return _shouldShowPlayerInternal();
  }

  bool get shouldShowPlayerNow {
    return _shouldShowPlayerNowInternal();
  }

  Future<void> playLibraryItem(LibraryItem item, {AutoQueueStart? autoQueueStart}) {
    return _playLibraryItemWithContext(item, autoQueueStart: autoQueueStart ?? const AutoQueueStart.none());
  }

  Future<void> playPodcastEpisode(
    LibraryItem item,
    Episode episode, {
    int? episodeIndex,
    List<Episode>? orderedEpisodes,
  }) async {
    return _playPodcastEpisodeInternal(item, episode, episodeIndex: episodeIndex, orderedEpisodes: orderedEpisodes);
  }

  @override
  Future<void> play() async {
    if (isCastControlActive) {
      PlayerUtils.enableWakelock(_ref);
      await GoogleCastRemoteMediaClient.instance.play();
      _refreshPlayerControlState();
      await _updatePlaybackState();
      return;
    }

    if (_queueTransitionLoading) {
      final queuedCandidate = queueList.isNotEmpty ? queueList.first.item : _lastQueueItem;
      if (queuedCandidate != null &&
          isQueueTransitionForItem(queuedCandidate.itemId, episodeId: queuedCandidate.episodeId)) {
        logger(
          'Ignoring duplicate play request while the same item is already loading.',
          tag: 'AudioHandler',
          level: InfoLevel.debug,
        );
        return Future.value();
      }

      logger(
        'Deferring play request until current queue transition completes.',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
      await queueTransitionLoadingStream.firstWhere((isLoading) => !isLoading);
    }

    _resetStreamRecoveryState(clearWindow: true);
    PlayerUtils.enableWakelock(_ref);

    final shouldSwitchToQueuedItem =
        _currentMediaItem != null &&
        queueList.isNotEmpty &&
        !_queueItemsMatch(
          leftItemId: queueList.first.item.itemId,
          leftEpisodeId: queueList.first.item.episodeId,
          rightItemId: _currentMediaItem!.itemId,
          rightEpisodeId: _currentMediaItem!.episodeId,
        ) &&
        (_forceQueueSwitchOnNextPlay ||
            _player.playerState.processingState == ProcessingState.completed ||
            _player.playerState.processingState == ProcessingState.idle);

    if (shouldSwitchToQueuedItem) {
      _forceQueueSwitchOnNextPlay = false;
      _clearSmartRewindPauseMarker();
      await _prepareForQueuedItemTransition();
    }

    if (_currentMediaItem != null) {
      _forceQueueSwitchOnNextPlay = false;

      if (queueList.isNotEmpty &&
          _queueItemsMatch(
            leftItemId: queueList.first.item.itemId,
            leftEpisodeId: queueList.first.item.episodeId,
            rightItemId: _currentMediaItem!.itemId,
            rightEpisodeId: _currentMediaItem!.episodeId,
          )) {
        queueList.removeAt(0);
        _emitQueueState();
        _maybePrefetchAutoQueue();
      }

      final skipResumeProgressReconcile = _consumePausedManualSeekMarkerForCurrentItem();
      await _applySmartRewindOnResumeIfNeeded();
      _setQueueTransitionLoading(false);
      await _syncedPlay(restoreProgress: true, skipResumeProgressReconcile: skipResumeProgressReconcile);
      return Future.value();
    }

    PlayerQueueEntry? nextEntry = queueList.isNotEmpty ? queueList.removeAt(0) : null;
    if (nextEntry != null) {
      _forceQueueSwitchOnNextPlay = false;
      _emitQueueState();
      _maybePrefetchAutoQueue();
    }

    QueueItem? nextItem = nextEntry?.item;

    if (nextItem == null && _lastQueueItem != null) {
      // e.g. Android still shows the notification and allows pressing play. This will re-use the last item.
      nextItem = _lastQueueItem;
    }
    if (nextItem == null) {
      _setQueueTransitionLoading(false);
      return Future.value();
    }

    _setQueueTransitionTargetItem(nextItem);
    _setQueueTransitionLoading(true);
    _clearSmartRewindPauseMarker();
    _lastQueueItem = nextItem;
    _currentMediaItem = await _ref
        .read(sessionRepositoryProvider)
        .openSession(nextItem.itemId, episodeId: nextItem.episodeId);
    if (_currentMediaItem == null) {
      logger(
        'No media item found for ID: ${nextItem.itemId} (${nextItem.episodeId ?? 'item'})',
        tag: 'AudioHandler',
        level: InfoLevel.error,
      );
      PlayerUtils.disableWakelock(_ref);
      TrayManager.update();
      _setQueueTransitionLoading(false, emitMediaWhenEmpty: true);
      return Future.value();
    }
    logger(
      'Playing item: ${_currentMediaItem!.itemId} (${_currentMediaItem!.episodeId ?? 'item'})',
      tag: 'AudioHandler',
      level: InfoLevel.debug,
    );
    try {
      await _setSource();
      logger(
        'Setting source for item: ${_currentMediaItem!.itemId} (${_currentMediaItem!.episodeId ?? 'item'})',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
      _setQueueTransitionLoading(false);
      await _syncedPlay(restoreProgress: true);
    } catch (e) {
      logger('Failed to start playback source: $e', tag: 'AudioHandler', level: InfoLevel.error);
      PlayerUtils.disableWakelock(_ref);
      _setQueueTransitionLoading(false, emitMediaWhenEmpty: true);
    }
    TrayManager.update();
  }

  Future<void> playItemFromPosition({required String itemId, String? episodeId, required Duration position}) async {
    return _playItemFromPositionInternal(itemId: itemId, episodeId: episodeId, position: position);
  }

  @override
  Future<void> stop({bool clearQueue = true}) async {
    if (_currentMediaItem != null) {
      unawaited(
        refreshPersonalizedShelfForCompletedItem(
          container: _ref,
          itemId: _currentMediaItem!.itemId,
          preferredLibraryId: _currentMediaItem!.libraryId,
          sourceTag: 'AudioHandler',
          reason: 'playback stop',
        ),
      );
    }
    final stopPosition = position;
    final shouldStopCastPlayback = isCastControlActive;

    _setQueueTransitionLoading(false);
    _clearSmartRewindPauseMarker();
    _clearPausedManualSeekMarker();
    _resetStreamRecoveryState(clearWindow: true);
    _currentMediaItem = null;
    mediaItem.add(null);
    _currentTrackIndex = 0;
    PlayerUtils.disableWakelock(_ref);
    if (shouldStopCastPlayback) {
      try {
        await GoogleCastRemoteMediaClient.instance.stop();
      } catch (e) {
        logger('Error stopping cast playback: $e', tag: 'AudioHandler', level: InfoLevel.warning);
      }
      deactivateCastControl();
    }
    if (clearQueue) {
      _clearAutoQueueState();
      queueList.clear();
      _forceQueueSwitchOnNextPlay = false;
      _emitQueueState();
    }
    try {
      unawaited(
        _syncService
            .flush(positionOverride: stopPosition)
            .then((_) => _ref.read(sessionRepositoryProvider).closeSession()),
      );
    } catch (e) {
      logger('Error closing session: $e', tag: 'AudioHandler', level: InfoLevel.error);
    }
    return _safePlayerStop();
  }

  Future<void> _safePlayerStop() async {
    if (Platform.isLinux) {
      await _player.pause();
      await _player.seek(Duration.zero);
      return;
    }
    await _player.stop();
    TrayManager.update();
  }

  @override
  Future<void> pause() async {
    PlayerUtils.disableWakelock(_ref);
    _resetStreamRecoveryState(clearWindow: true);
    if (isCastControlActive) {
      _clearSmartRewindPauseMarker();
      await GoogleCastRemoteMediaClient.instance.pause();
      _refreshPlayerControlState();
      await _updatePlaybackState();
      TrayManager.update();
      return Future.value();
    }

    await _player.pause();
    _recordPausedPlaybackMarker();
    TrayManager.update();
    return Future.value();
  }

  static const bool headphoneSkip =
      true; // Later should determine if the skip button just fasts forward or skips chapters

  Duration _skipDurationForKey(String key) {
    final configuredSeconds = _ref.read(settingsManagerProvider.notifier).getGlobalSetting<int>(key);
    final safeSeconds = configuredSeconds < 1 ? 1 : configuredSeconds;
    return Duration(seconds: safeSeconds);
  }

  @override
  Future<void> fastForward() async {
    if (_currentMediaItem == null) return Future.value();
    final skipTime = _skipDurationForKey(SettingKeys.fastForwardInterval);
    final newPosition = position + skipTime;
    seek(newPosition);
    return Future.value();
  }

  @override
  Future<void> rewind() async {
    if (_currentMediaItem == null) return Future.value();
    final skipTime = _skipDurationForKey(SettingKeys.rewindInterval);
    final newPosition = position - skipTime;
    if (newPosition < Duration.zero) {
      logger('Rewind position is negative, resetting to zero', tag: 'AudioHandler', level: InfoLevel.debug);
      return seek(Duration.zero);
    }
    seek(newPosition);
    return Future.value();
  }

  @override
  Future<void> skipToNext() async {
    return _queueSkipOperation(() async {
      if (_currentMediaItem == null) return;
      InternalChapter? nextChapter = _currentMediaItem!.getNextChapterForDuration(position);
      if (nextChapter != null) {
        final newPosition = Duration(microseconds: (nextChapter.start * Duration.microsecondsPerSecond).round());
        logger(
          'Skipping to next chapter: $nextChapter, new position: $newPosition',
          tag: 'AudioHandler',
          level: InfoLevel.debug,
        );
        await seek(newPosition);
        return;
      }

      logger('No next chapter found, skipping to next item', tag: 'AudioHandler', level: InfoLevel.debug);
      if (queueList.isNotEmpty) {
        _forceQueueSwitchOnNextPlay = true;
        await play();
      } else {
        logger(
          'No next chapter and queue is empty, ignoring skip-to-next',
          tag: 'AudioHandler',
          level: InfoLevel.debug,
        );
      }
    });
  }

  @override
  Future<void> skipToPrevious() async {
    return _queueSkipOperation(() async {
      if (_currentMediaItem == null) return;
      InternalChapter? previousChapter = _currentMediaItem!.getPreviousChapterForDuration(position);
      if (previousChapter != null) {
        final newPosition = Duration(microseconds: (previousChapter.start * Duration.microsecondsPerSecond).round());
        logger(
          'Skipping to previous chapter: $previousChapter, new position: $newPosition',
          tag: 'AudioHandler',
          level: InfoLevel.debug,
        );
        await seek(newPosition);
      }
    });
  }

  Future<void> _queueSkipOperation(Future<void> Function() operation) {
    _skipOperationQueue = _skipOperationQueue.then((_) => operation()).catchError((Object e, StackTrace s) {
      logger('Skip operation failed: $e\n$s', tag: 'AudioHandler', level: InfoLevel.error);
    });
    return _skipOperationQueue;
  }

  @override
  Future<void> seek(Duration position) async {
    if (_currentMediaItem == null) return Future.value();

    final maxPosition = _currentMediaItem!.totalDuration;
    final boundedPosition = position < Duration.zero
        ? Duration.zero
        : (position > maxPosition ? maxPosition : position);

    final shouldRecordPausedManualSeek =
        _internalSeekGuardDepth == 0 &&
        !playerControlState.playing &&
        playerControlState.processingState == ProcessingState.ready;
    if (shouldRecordPausedManualSeek) {
      _markPausedManualSeek(boundedPosition);
    }

    if (isCastControlActive) {
      final relativePosition = _absoluteToCastRelativePosition(boundedPosition);
      await GoogleCastRemoteMediaClient.instance.seek(GoogleCastMediaSeekOption(position: relativePosition));
      _refreshPlayerControlState();
      await _updatePlaybackState();
      return Future.value();
    }

    final newTrackIndex = _currentMediaItem!.getIndexForDuration(boundedPosition);
    if (newTrackIndex < 0) {
      logger(
        'Ignoring seek with invalid track index for position: $boundedPosition',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
      return Future.value();
    }
    logger(
      'Seeking to position: $boundedPosition, track index: $newTrackIndex',
      tag: 'AudioHandler',
      level: InfoLevel.debug,
    );
    final relativeTrackPosition = boundedPosition - _currentMediaItem!.startDurationForTrack(newTrackIndex);

    if (newTrackIndex != _currentTrackIndex) {
      _currentTrackIndex = newTrackIndex;
      await _player.seek(relativeTrackPosition, index: _currentTrackIndex);
      if (Platform.isWindows || Platform.isLinux) {
        // Bugfix for Windows as it doesn't seek correctly if the index changed
        _player.playerStateStream.firstWhere((state) => state.processingState == ProcessingState.ready).then((_) async {
          await _player.seek(relativeTrackPosition, index: _currentTrackIndex);
        });
      }
    } else {
      await _player.seek(relativeTrackPosition, index: _currentTrackIndex);
    }
    return Future.value();
  }

  BGAudioHandler(this._ref) {
    _activeUserIdSubscription = _ref
        .read(appDatabaseProvider)
        .watchGlobalSetting('activeUserId')
        .map((setting) => setting?.value.trim())
        .distinct()
        .listen((activeUserId) {
          if (_isDisposing || activeUserId == null || activeUserId.isEmpty) {
            return;
          }

          // Clear Android Auto auth error as soon as login becomes active.
          unawaited(_androidAutoClearAuthenticationRequiredState(this, refreshBrowseRoots: true));
          unawaited(_restoreLastPlayedMiniPlayerIfEnabledInternal());
        });

    _showLastPlayedMiniPlayerSettingSubscription = _ref
        .read(appDatabaseProvider)
        .watchGlobalSetting(SettingKeys.showLastPlayedMiniPlayerAlways)
        .map((setting) => setting?.value.trim())
        .distinct()
        .listen((_) {
          if (_isDisposing) {
            return;
          }

          _emitShouldShowPlayer();
          unawaited(_updatePlaybackState());
        });

    final settingManager = _ref.read(settingsManagerProvider.notifier);
    final bufferSize = settingManager.getGlobalSetting<int>(SettingKeys.bufferSize);

    logger('Buffer size: $bufferSize', tag: 'AudioHandler', level: InfoLevel.debug);

    final AndroidLoadControl androidLoadControl = AndroidLoadControl(
      maxBufferDuration: Duration(seconds: 300),
      bufferForPlaybackDuration: Duration(milliseconds: 500),
      bufferForPlaybackAfterRebufferDuration: Duration(seconds: 5),
      backBufferDuration: Duration(seconds: 120),
      targetBufferBytes: bufferSize,
    );

    JustAudioMediaKit.bufferSize = bufferSize;

    final DarwinLoadControl iOSLoadControl = DarwinLoadControl(
      // iOS does what iOS wants anyways
      preferredForwardBufferDuration: Duration(seconds: 300),
      canUseNetworkResourcesForLiveStreamingWhilePaused: false,
    );

    AudioLoadConfiguration loadCfg = AudioLoadConfiguration(
      androidLoadControl: androidLoadControl,
      darwinLoadControl: iOSLoadControl,
    );

    final disableHeaderProxy = Platform.isAndroid || Platform.isLinux;
    _player = AudioPlayer(audioLoadConfiguration: loadCfg, useProxyForRequestHeaders: !disableHeaderProxy);
    _playerControlStateSubject = BehaviorSubject<PlayerState>.seeded(_player.playerState);

    _errorSubscription = _player.errorStream.listen((error) {
      logger('AudioPlayer error: $error', tag: 'AudioHandler', level: InfoLevel.error);
      if (error.toString().toLowerCase().contains('ffurl_read')) {
        _scheduleStreamRecoveryRetry(error);
      }
    });

    _syncService = PlaybackSyncService(this, _ref);
    _playerStateSubscription = _player.playerStateStream.listen((PlayerState state) async {
      if (_isDisposing) return;
      logger(state.toString(), tag: 'AudioHandler', level: InfoLevel.debug);
      _recordPlayerHistoryForState(state);

      if (state.playing && state.processingState == ProcessingState.ready) {
        _resetStreamRecoveryState(clearWindow: true);
      }

      if (state.processingState == ProcessingState.completed || state.processingState == ProcessingState.idle) {
        _resetStreamRecoveryState(clearWindow: true);
      }

      if (state.processingState == ProcessingState.completed) {
        final finishedMedia = _currentMediaItem;
        if (finishedMedia == null) return;
        logger(
          'Current track index: $_currentTrackIndex, total tracks: ${finishedMedia.tracks.length}',
          tag: 'AudioHandler',
          level: InfoLevel.debug,
        );
        await _syncService.flush();
        await _ref.read(sessionRepositoryProvider).closeSession();
        unawaited(
          refreshPersonalizedShelfForCompletedItem(
            container: _ref,
            itemId: finishedMedia.itemId,
            preferredLibraryId: finishedMedia.libraryId,
            sourceTag: 'AudioHandler',
            reason: 'playback completed',
          ),
        );

        if (queueList.isNotEmpty) {
          await play();
        } else {
          await _safePlayerStop();
        }
      }
      _refreshPlayerControlState();
      _updatePlaybackState();
    });

    _playerCurrentIndexSubscription = _player.currentIndexStream.listen((index) {
      if (_isDisposing || index == null || index < 0) {
        return;
      }

      if (_currentTrackIndex == index) {
        return;
      }

      _currentTrackIndex = index;
      _refreshPlayerControlState();
      unawaited(_updatePlaybackState());
    });

    _setupCastStateListeners();
    _refreshPlayerControlState();

    _emitQueueState();
    _emitShouldShowPlayer();
    unawaited(_restorePlaybackPreferencesOnStartup());
  }

  Map<String, String> get currentRequestHeaders => _currentRequestHeadersInternal;

  Future<void> _updatePlaybackState() async {
    final lockMediaNotification = _ref
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<bool>(SettingKeys.lockMediaNotification);
    final showNotificationMoreButton = _ref
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<bool>(SettingKeys.showNotificationMoreButton);

    if (!showNotificationMoreButton && _androidAutoMoreMenuVisible) {
      _androidAutoMoreMenuVisible = false;
      _androidAutoMoreMenuTimer?.cancel();
      _androidAutoMoreMenuTimer = null;
    }

    final isTransitionLoading =
        _queueTransitionLoading || (_player.processingState == ProcessingState.completed && queueList.isNotEmpty);
    final hasPlaybackContext = _currentMediaItem != null || queueList.isNotEmpty || _queueTransitionLoading;
    final isMoreMenuVisible = showNotificationMoreButton && _androidAutoMoreMenuVisible;
    final castActive = isCastControlActive;
    final controlState = castActive ? playerControlState : _player.playerState;
    final playPauseControl = controlState.playing ? MediaControl.pause : MediaControl.play;
    final updatePosition = position;
    final effectiveSpeed = castActive
        ? (GoogleCastRemoteMediaClient.instance.mediaStatus?.playbackRate.toDouble() ?? _player.speed)
        : _player.speed;
    final bufferedPosition = castActive
        ? updatePosition
        : (_currentMediaItem?.offsetForTrack(_currentTrackIndex) ?? Duration.zero) + _player.bufferedPosition;
    final controls = !hasPlaybackContext
        ? const <MediaControl>[]
        : isMoreMenuVisible
        ? <MediaControl>[
            MediaControl.custom(
              androidIcon: _androidAutoIconClose,
              label: 'Close',
              name: _androidAutoCustomActionMoreClose,
            ),
            MediaControl.custom(androidIcon: _androidAutoIconStop, label: 'Stop', name: _androidAutoCustomActionStop),
            playPauseControl,
          ]
        : <MediaControl>[
            MediaControl.custom(
              androidIcon: _androidAutoIconReplay,
              label: 'Rewind',
              name: _androidAutoCustomActionRewind,
            ),
            MediaControl.custom(
              androidIcon: _androidAutoIconForwardMedia,
              label: 'Fast forward',
              name: _androidAutoCustomActionFastForward,
            ),
            MediaControl.custom(
              androidIcon: _androidAutoIconSpeed,
              label: 'Speed',
              name: _androidAutoCustomActionSpeed,
            ),
            showNotificationMoreButton
                ? MediaControl.custom(
                    androidIcon: _androidAutoIconMoreVert,
                    label: 'More',
                    name: _androidAutoCustomActionMoreMenu,
                  )
                : MediaControl.custom(
                    androidIcon: _androidAutoIconStop,
                    label: 'Stop',
                    name: _androidAutoCustomActionStop,
                  ),
            playPauseControl,
          ];
    final compactActionIndices = !hasPlaybackContext
        ? const <int>[]
        : (isMoreMenuVisible ? const <int>[0, 1, 2] : <int>[0, 2, controls.length - 1]);

    playbackState.add(
      PlaybackState(
        // Which buttons should appear in the notification now
        controls: controls,
        // Which other actions should be enabled in the notification
        systemActions: (!hasPlaybackContext || lockMediaNotification)
            ? const <MediaAction>{}
            : const {MediaAction.seek},
        // Which controls to show in Android's compact view.
        androidCompactActionIndices: compactActionIndices,
        // Whether audio is ready, buffering, ...
        processingState: !hasPlaybackContext
            ? AudioProcessingState.idle
            : isTransitionLoading
            ? AudioProcessingState.loading
            : _toAudioProcessingState(controlState.processingState),
        playing: hasPlaybackContext && (isTransitionLoading ? true : controlState.playing),
        // The current position as of this update. You should not broadcast
        // position changes continuously because listeners will be able to
        // project the current position after any elapsed time based on the
        // current speed and whether audio is playing and ready. Instead, only
        // broadcast position updates when they are different from expected (e.g.
        // buffering, or seeking).
        updatePosition: hasPlaybackContext ? updatePosition : Duration.zero,
        bufferedPosition: hasPlaybackContext ? bufferedPosition : Duration.zero,
        speed: hasPlaybackContext ? effectiveSpeed : 1.0,
      ),
    );
  }

  Future<void> dispose() async {
    _isDisposing = true;
    await _activeUserIdSubscription.cancel();
    await _showLastPlayedMiniPlayerSettingSubscription.cancel();
    _resetStreamRecoveryState(clearWindow: true);
    _androidAutoMoreMenuTimer?.cancel();
    _androidAutoMoreMenuTimer = null;
    _clearAutoQueueState();
    await _errorSubscription?.cancel();
    _errorSubscription = null;
    await _playerStateSubscription?.cancel();
    _playerStateSubscription = null;
    await _playerCurrentIndexSubscription?.cancel();
    _playerCurrentIndexSubscription = null;
    await _castSessionSubscription?.cancel();
    _castSessionSubscription = null;
    await _castMediaStatusSubscription?.cancel();
    _castMediaStatusSubscription = null;
    await _syncService.dispose();
    await _player.dispose();
    await mediaItemStream.close();
    await _playerControlStateSubject.close();
    await _castControlActiveSubject.close();
    await _queueLengthSubject.close();
    await _queueSnapshotSubject.close();
    await _queueTransitionLoadingSubject.close();
    await _showPlayerSubject.close();
    await _lastPlayedMiniPlayerSnapshotSubject.close();
  }
}
