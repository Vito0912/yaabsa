// ignore_for_file: unused_element_parameter

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
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
  late final StreamSubscription<String?> _mediaNotificationTypeSubscription;
  late final StreamSubscription<String?> _mediaNotificationPagesSubscription;
  late final StreamSubscription<String?> _showSkipInsteadOfFastForwardSubscription;
  int _currentNotificationPageIndex = 0;
  List<List<String>> _notificationPages = const [
    ['rewind', 'fastForward', 'speed', 'stop'],
  ];
  StreamSubscription<InternalChapter?>? _chapterSubscription;
  StreamSubscription<String?>? _skipSilenceSubscription;
  StreamSubscription<String?>? _volumeBoostEnabledSubscription;
  StreamSubscription<String?>? _equalizerEnabledSubscription;
  StreamSubscription<String?>? _equalizerBandGainsSubscription;
  StreamSubscription<int?>? _equalizerSessionSubscription;
  StreamSubscription<String?>? _autoResumeOnBluetoothSubscription;
  AndroidLoudnessEnhancer? _loudnessEnhancer;
  AndroidEqualizer? _equalizer;
  AndroidEqualizer? get equalizer => _equalizer;
  Stream<int?> get androidAudioSessionIdStream => _player.androidAudioSessionIdStream;
  int? get androidAudioSessionId => _player.androidAudioSessionId;
  late final BehaviorSubject<double> _volumeSubject;
  bool _isDisposing = false;
  List<PlayerQueueEntry> queueList = [];
  List<PlayerQueueEntry> _originalQueueList = [];
  QueueItem? _lastQueueItem;
  Future<void> _skipOperationQueue = Future.value();
  int _queueEntryCounter = 0;
  String? _activeMusicLibraryId;
  String? _activeMusicLibraryFilter;
  bool _ignoreProgressOnNextPlay = false;
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
  bool _chapterNotificationEnabled = false;
  Duration _chapterNotificationOffset = Duration.zero;
  Duration _chapterNotificationDuration = Duration.zero;
  bool _isInternalSeek = false;
  bool _historyWasPlayingReady = false;
  bool _historyWasBufferingOrLoading = false;
  bool _historyWasCompleted = false;
  bool _hasFiredCompleted = false;
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
  MediaItem? _restoredMediaItem;
  Duration _restoredPosition = Duration.zero;
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

  bool get _supportsCastPlatform => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  static double get maxVolume => 1.0;

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

  Future<void> restoreLastPlayedMiniPlayerIfEnabled({String? explicitUserId}) {
    return _restoreLastPlayedMiniPlayerIfEnabledInternal(explicitUserId: explicitUserId);
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
    _originalQueueList.clear();
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

  void addToQueue(QueueItem item, {QueueDisplayInfo displayInfo = QueueDisplayInfo.empty, bool allowCurrent = false}) {
    _enqueueItem(item, displayInfo: displayInfo, allowCurrent: allowCurrent);
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
    _originalQueueList.removeWhere((entry) => entry.id == queueEntryId);
    _emitQueueState();
  }

  void reorderQueue(int oldIndex, int newIndex) {
    return _reorderQueueInternal(oldIndex, newIndex);
  }

  Future<void> loadMoreAutoQueue() {
    return _loadMoreAutoQueue();
  }

  void toggleMix() {
    final manager = _ref.read(settingsManagerProvider.notifier);
    final currentMix = manager.getGlobalSetting<bool>(SettingKeys.mixQueue, defaultValue: false);
    final nextMix = !currentMix;
    manager.setGlobalSetting<bool>(SettingKeys.mixQueue, nextMix);

    if (nextMix) {
      _originalQueueList = List<PlayerQueueEntry>.from(queueList);
      final shuffled = List<PlayerQueueEntry>.from(queueList)..shuffle();
      queueList = shuffled;
    } else {
      final restored = _originalQueueList.where((orig) => queueList.any((q) => q.id == orig.id)).toList();
      final newItems = queueList.where((q) => !_originalQueueList.any((orig) => orig.id == q.id)).toList();
      queueList = [...restored, ...newItems];
      _originalQueueList.clear();
    }
    _emitQueueState();
  }

  void cycleLoopMode() {
    final manager = _ref.read(settingsManagerProvider.notifier);
    final currentLoop = manager.getGlobalSetting<String>(SettingKeys.loopMode, defaultValue: 'off');
    String nextLoop = currentLoop == 'off' ? 'on' : 'off';
    manager.setGlobalSetting<String>(SettingKeys.loopMode, nextLoop);
  }

  Future<void> _refillMusicQueue(String libraryId, {String? filter}) async {
    final api = _ref.read(absApiProvider);
    if (api == null) return;

    final currentQueueIds = queueList.map((e) => e.item.itemId).toSet();
    if (_currentMediaItem != null) {
      currentQueueIds.add(_currentMediaItem!.itemId);
    }

    int attempts = 0;
    const maxAttempts = 10;
    while (attempts < maxAttempts) {
      attempts++;
      try {
        final request = LibraryItemsRequest(limit: 1, page: 0, sort: 'random', filter: filter);
        final response = await api.getLibraryApi().getLibraryItems(libraryId, request, extra: const {'noCache': true});
        final data = response.data;
        if (data != null && data.results.isNotEmpty) {
          final candidate = data.results.first;
          if (!currentQueueIds.contains(candidate.id)) {
            addToQueue(QueueItem(itemId: candidate.id), displayInfo: _displayInfoFromLibraryItem(candidate));
            logger('Successfully refilled music queue with random item ${candidate.id}', tag: 'AudioHandler');
            break;
          } else {
            logger('Fetched duplicate random item ${candidate.id}, retrying request...', tag: 'AudioHandler');
          }
        } else {
          break;
        }
      } catch (e) {
        logger('Failed to refill music queue: $e', tag: 'AudioHandler', level: InfoLevel.warning);
        break;
      }
    }
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
      _restoredMediaItem = null;
      _restoredPosition = Duration.zero;
    } else {
      _restoredMediaItem = null;
      _restoredPosition = Duration.zero;
    }
    mediaItemStream.add(mediaItem);
    _refreshPlayerControlState();
    _emitShouldShowPlayer();
    _handleAutoQueueOnCurrentItemChange(
      mediaItem == null ? null : _queueItemReferenceKey(itemId: mediaItem.itemId, episodeId: mediaItem.episodeId),
    );
  }

  Stream<double> get volumeStream => _volumeSubject.stream;

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

  Duration _lastKnownCastPosition = Duration.zero;

  Future<void> deactivateCastControl({Duration? fallbackPosition}) async {
    final castPosition = fallbackPosition ?? _lastKnownCastPosition;
    await _syncService.flush(positionOverride: castPosition);

    _castControlledContentId = null;
    _castControlledTrackIndex = 0;
    _lastKnownCastPosition = Duration.zero;

    if (_currentMediaItem != null) {
      await _seekInternal(castPosition);
    }

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

  Future<void> playLibraryItem(
    LibraryItem item, {
    AutoQueueStart? autoQueueStart,
    String? sort,
    int? desc,
    String? filter,
  }) {
    return _playLibraryItemWithContext(
      item,
      autoQueueStart: autoQueueStart ?? const AutoQueueStart.none(),
      sort: sort,
      desc: desc,
      filter: filter,
    );
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
    final ignoreProgress = _ignoreProgressOnNextPlay || _activeMusicLibraryId != null;
    final forceRestart = _ignoreProgressOnNextPlay;
    _ignoreProgressOnNextPlay = false;

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
        final removed = queueList.removeAt(0);
        _originalQueueList.removeWhere((e) => e.id == removed.id);
        _emitQueueState();
        _maybePrefetchAutoQueue();
      }

      if (_player.playerState.processingState == ProcessingState.completed || forceRestart) {
        await seek(Duration.zero);
      }

      final skipResumeProgressReconcile = _consumePausedManualSeekMarkerForCurrentItem();
      await _applySmartRewindOnResumeIfNeeded();
      _setQueueTransitionLoading(false);
      await _syncedPlay(restoreProgress: !ignoreProgress, skipResumeProgressReconcile: skipResumeProgressReconcile);
      return Future.value();
    }

    PlayerQueueEntry? nextEntry = queueList.isNotEmpty ? queueList.removeAt(0) : null;
    if (nextEntry != null) {
      _originalQueueList.removeWhere((e) => e.id == nextEntry.id);
      _forceQueueSwitchOnNextPlay = false;
      _emitQueueState();
      _maybePrefetchAutoQueue();
      final loopMode = _ref
          .read(settingsManagerProvider.notifier)
          .getGlobalSetting<String>(SettingKeys.loopMode, defaultValue: 'off');
      final isLoopOn = loopMode == 'on';
      if (_activeMusicLibraryId != null && !isLoopOn) {
        unawaited(_refillMusicQueue(_activeMusicLibraryId!, filter: _activeMusicLibraryFilter));
      }
    }

    QueueItem? nextItem = nextEntry?.item;

    if (nextItem == null && _lastQueueItem != null) {
      // e.g. Android still shows the notification and allows pressing play. This will re-use the last item.
      nextItem = _lastQueueItem;
    }
    if (nextItem == null) {
      final resumed = await _playLastPlayedInternal(requireStartupSettingEnabled: false, resumeCurrentIfPaused: false);
      if (!resumed) {
        _setQueueTransitionLoading(false);
      }
      return Future.value();
    }

    _setQueueTransitionTargetItem(nextItem);
    _setQueueTransitionLoading(true);
    _clearSmartRewindPauseMarker();
    _lastQueueItem = nextItem;

    try {
      _currentMediaItem = await _ref
          .read(sessionRepositoryProvider)
          .openSession(nextItem.itemId, episodeId: nextItem.episodeId);
    } catch (e, s) {
      logger(
        'Exception opening session for ID: ${nextItem.itemId} (${nextItem.episodeId ?? 'item'}): $e\n$s',
        tag: 'AudioHandler',
        level: InfoLevel.error,
      );
      _currentMediaItem = null;
    }

    if (_currentMediaItem == null) {
      logger(
        'No media item found for ID: ${nextItem.itemId} (${nextItem.episodeId ?? 'item'})',
        tag: 'AudioHandler',
        level: InfoLevel.error,
      );
      _lastQueueItem = null;
      _setLastPlayedMiniPlayerSnapshot(null);
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
      await _setSource(ignoreSavedProgress: ignoreProgress);
      logger(
        'Setting source for item: ${_currentMediaItem!.itemId} (${_currentMediaItem!.episodeId ?? 'item'})',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
      _setQueueTransitionLoading(false);
      await _syncedPlay(restoreProgress: !ignoreProgress);
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
    _restoredMediaItem = null;
    _restoredPosition = Duration.zero;
    mediaItem.add(null);
    _currentTrackIndex = 0;
    PlayerUtils.disableWakelock(_ref);
    if (shouldStopCastPlayback) {
      try {
        await GoogleCastRemoteMediaClient.instance.stop();
      } catch (e) {
        logger('Error stopping cast playback: $e', tag: 'AudioHandler', level: InfoLevel.warning);
      }
      await deactivateCastControl();
    }
    if (clearQueue) {
      _clearAutoQueueState();
      _activeMusicLibraryId = null;
      queueList.clear();
      _originalQueueList.clear();
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
    if (!kIsWeb && Platform.isLinux) {
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
    if (!kIsWeb && Platform.isIOS) {
      final showSkipInsteadOfFastForward = _ref
          .read(settingsManagerProvider.notifier)
          .getGlobalSetting<bool>(SettingKeys.showSkipInsteadOfFastForward, defaultValue: false);
      final chaptersExist = _currentMediaItem?.chapters?.isNotEmpty ?? false;
      final queueExists = queueList.isNotEmpty;
      if (showSkipInsteadOfFastForward && (chaptersExist || queueExists)) {
        return skipToNext();
      }
    }
    final skipTime = _skipDurationForKey(SettingKeys.fastForwardInterval);
    final newPosition = position + skipTime;
    _seekInternal(newPosition);
    return Future.value();
  }

  @override
  Future<void> rewind() async {
    if (_currentMediaItem == null) return Future.value();
    if (!kIsWeb && Platform.isIOS) {
      final showSkipInsteadOfFastForward = _ref
          .read(settingsManagerProvider.notifier)
          .getGlobalSetting<bool>(SettingKeys.showSkipInsteadOfFastForward, defaultValue: false);
      final chaptersExist = _currentMediaItem?.chapters?.isNotEmpty ?? false;
      final queueExists = queueList.isNotEmpty;
      if (showSkipInsteadOfFastForward && (chaptersExist || queueExists)) {
        return skipToPrevious();
      }
    }
    final skipTime = _skipDurationForKey(SettingKeys.rewindInterval);
    final newPosition = position - skipTime;
    if (newPosition < Duration.zero) {
      logger('Rewind position is negative, resetting to zero', tag: 'AudioHandler', level: InfoLevel.debug);
      return _seekInternal(Duration.zero);
    }
    _seekInternal(newPosition);
    return Future.value();
  }

  @override
  Future<void> skipToNext() async {
    if (_currentMediaItem == null) return;
    if (!kIsWeb && Platform.isIOS) {
      final showSkipInsteadOfFastForward = _ref
          .read(settingsManagerProvider.notifier)
          .getGlobalSetting<bool>(SettingKeys.showSkipInsteadOfFastForward, defaultValue: false);
      final chaptersExist = _currentMediaItem?.chapters?.isNotEmpty ?? false;
      final queueExists = queueList.isNotEmpty;
      if (!showSkipInsteadOfFastForward || !(chaptersExist || queueExists)) {
        return fastForward();
      }
    }
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
        await _seekInternal(newPosition);
        return;
      }

      logger('No next chapter found, skipping to next item', tag: 'AudioHandler', level: InfoLevel.debug);
      final loopMode = _ref
          .read(settingsManagerProvider.notifier)
          .getGlobalSetting<String>(SettingKeys.loopMode, defaultValue: 'off');
      final isLoopOn = loopMode == 'on';

      if (isLoopOn && _currentMediaItem != null) {
        final finishedMedia = _currentMediaItem!;
        final finishedQueueItem = QueueItem(itemId: finishedMedia.itemId, episodeId: finishedMedia.episodeId);
        final displayInfo = QueueDisplayInfo(
          title: finishedMedia.title,
          subtitle: finishedMedia.subtitle,
          author: finishedMedia.author,
        );
        addToQueue(finishedQueueItem, displayInfo: displayInfo, allowCurrent: true);
      }

      if (queueList.isNotEmpty) {
        _forceQueueSwitchOnNextPlay = true;
        _ignoreProgressOnNextPlay = isLoopOn;
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
    if (_currentMediaItem == null) return;
    if (!kIsWeb && Platform.isIOS) {
      final showSkipInsteadOfFastForward = _ref
          .read(settingsManagerProvider.notifier)
          .getGlobalSetting<bool>(SettingKeys.showSkipInsteadOfFastForward, defaultValue: false);
      final chaptersExist = _currentMediaItem?.chapters?.isNotEmpty ?? false;
      final queueExists = queueList.isNotEmpty;
      if (!showSkipInsteadOfFastForward || !(chaptersExist || queueExists)) {
        return rewind();
      }
    }
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
        await _seekInternal(newPosition);
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

    Duration resolvedPosition = position;
    if (_chapterNotificationEnabled && !_isInternalSeek) {
      resolvedPosition = _chapterNotificationOffset + position;
    }

    final maxPosition = _currentMediaItem!.totalDuration;
    final boundedPosition = resolvedPosition < Duration.zero
        ? Duration.zero
        : (resolvedPosition > maxPosition ? maxPosition : resolvedPosition);

    final shouldRecordPausedManualSeek =
        _internalSeekGuardDepth == 0 &&
        !playerControlState.playing &&
        (playerControlState.processingState == ProcessingState.ready ||
            playerControlState.processingState == ProcessingState.completed);
    if (shouldRecordPausedManualSeek) {
      _markPausedManualSeek(boundedPosition);
    }

    if (isCastControlActive) {
      final relativePosition = _absoluteToCastRelativePosition(boundedPosition);
      await GoogleCastRemoteMediaClient.instance.seek(GoogleCastMediaSeekOption(position: relativePosition));
      _refreshPlayerControlState();
      _refreshChapterNotificationState(customPosition: boundedPosition);
      _updateMediaItemForChapterNotification(customPosition: boundedPosition);
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
      if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
        // Bugfix for Windows as it doesn't seek correctly if the index changed
        _player.playerStateStream.firstWhere((state) => state.processingState == ProcessingState.ready).then((_) async {
          await _player.seek(relativeTrackPosition, index: _currentTrackIndex);
        });
      }
    } else {
      await _player.seek(relativeTrackPosition, index: _currentTrackIndex);
    }

    _refreshChapterNotificationState(customPosition: boundedPosition);
    _updateMediaItemForChapterNotification(customPosition: boundedPosition);
    unawaited(_updatePlaybackState());
    return Future.value();
  }

  void _refreshChapterNotificationState({Duration? customPosition}) {
    final settingValue = _ref
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<String>(SettingKeys.mediaNotificationType);
    final mode = MediaNotificationType.fromSettingValue(settingValue);

    if (mode != MediaNotificationType.chapter) {
      _chapterNotificationEnabled = false;
      _chapterNotificationOffset = Duration.zero;
      _chapterNotificationDuration = Duration.zero;
      return;
    }

    final searchPos = customPosition ?? position;
    final chapter = _currentMediaItem?.getChapterForDuration(searchPos);
    if (chapter == null) {
      _chapterNotificationEnabled = false;
      _chapterNotificationOffset = Duration.zero;
      _chapterNotificationDuration = Duration.zero;
      return;
    }

    _chapterNotificationEnabled = true;
    _chapterNotificationOffset = Duration(microseconds: (chapter.start * Duration.microsecondsPerSecond).round());
    _chapterNotificationDuration = Duration(
      microseconds: ((chapter.end - chapter.start) * Duration.microsecondsPerSecond).round(),
    );
  }

  void _updateMediaItemForChapterNotification({Duration? customPosition}) {
    final currentItem = _currentMediaItem;
    if (currentItem == null) return;

    if (_chapterNotificationEnabled) {
      final searchPos = customPosition ?? position;
      final chapter = currentItem.getChapterForDuration(searchPos);
      mediaItem.add(
        MediaItem(
          id: currentItem.id,
          album: currentItem.toMediaItem().album,
          title: chapter?.title ?? currentItem.title,
          displayTitle: chapter?.title ?? currentItem.title,
          artist: currentItem.author,
          displaySubtitle: currentItem.subtitle,
          duration: _chapterNotificationDuration,
          isLive: false,
          artUri: currentItem.cover,
        ),
      );
    } else {
      mediaItem.add(currentItem.toMediaItem());
    }
  }

  Future<void> _seekInternal(Duration position) async {
    _isInternalSeek = true;
    try {
      await seek(position);
    } finally {
      _isInternalSeek = false;
    }
  }

  Future<void> seekAbsolute(Duration position) => _seekInternal(position);

  Duration _clampDuration(Duration value, Duration min, Duration max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
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

          if (_currentMediaItem != null || queueList.isNotEmpty || _queueTransitionLoading) {
            unawaited(stop(clearQueue: true));
          }

          _lastQueueItem = null;
          _setLastPlayedMiniPlayerSnapshot(null);

          // Clear Android Auto auth error as soon as login becomes active.
          unawaited(_androidAutoClearAuthenticationRequiredState(this, refreshBrowseRoots: true));
          unawaited(_restoreLastPlayedMiniPlayerIfEnabledInternal(explicitUserId: activeUserId));
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

    _mediaNotificationTypeSubscription = _ref
        .read(appDatabaseProvider)
        .watchGlobalSetting(SettingKeys.mediaNotificationType)
        .map((setting) => setting?.value.trim())
        .distinct()
        .listen((_) {
          if (_isDisposing) return;
          _refreshChapterNotificationState();
          _updateMediaItemForChapterNotification();
          unawaited(_updatePlaybackState());
        });

    _loadNotificationPages();
    _mediaNotificationPagesSubscription = _ref
        .read(appDatabaseProvider)
        .watchGlobalSetting(SettingKeys.mediaNotificationPages)
        .map((setting) => setting?.value.trim())
        .distinct()
        .listen((_) {
          if (_isDisposing) return;
          _loadNotificationPages();
          unawaited(_updatePlaybackState());
        });

    _showSkipInsteadOfFastForwardSubscription = _ref
        .read(appDatabaseProvider)
        .watchGlobalSetting(SettingKeys.showSkipInsteadOfFastForward)
        .map((setting) => setting?.value.trim())
        .distinct()
        .listen((_) {
          if (_isDisposing) return;
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

    final disableHeaderProxy = kIsWeb || Platform.isAndroid || Platform.isLinux;
    if (!kIsWeb && Platform.isAndroid) {
      _loudnessEnhancer = AndroidLoudnessEnhancer();
      final equalizerEnabled = settingManager.getGlobalSetting<bool>(SettingKeys.equalizerEnabled, defaultValue: false);
      if (equalizerEnabled) {
        _equalizer = AndroidEqualizer();
        final pipeline = AudioPipeline(androidAudioEffects: [_loudnessEnhancer!, _equalizer!]);
        _player = AudioPlayer(
          audioPipeline: pipeline,
          audioLoadConfiguration: loadCfg,
          useProxyForRequestHeaders: !disableHeaderProxy,
        );
      } else {
        final pipeline = AudioPipeline(androidAudioEffects: [_loudnessEnhancer!]);
        _player = AudioPlayer(
          audioPipeline: pipeline,
          audioLoadConfiguration: loadCfg,
          useProxyForRequestHeaders: !disableHeaderProxy,
        );
      }
    } else {
      _player = AudioPlayer(audioLoadConfiguration: loadCfg, useProxyForRequestHeaders: !disableHeaderProxy);
    }
    _playerControlStateSubject = BehaviorSubject<PlayerState>.seeded(_player.playerState);
    _volumeSubject = BehaviorSubject<double>.seeded(_readLastVolumeSetting());

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

      if (state.processingState != ProcessingState.completed) {
        _hasFiredCompleted = false;
      }

      if (state.processingState == ProcessingState.completed || state.processingState == ProcessingState.idle) {
        _resetStreamRecoveryState(clearWindow: true);
      }

      if (state.processingState == ProcessingState.completed) {
        if (_hasFiredCompleted) return;
        _hasFiredCompleted = true;
        final finishedMedia = _currentMediaItem;
        if (finishedMedia == null) return;
        logger(
          'Current track index: $_currentTrackIndex, total tracks: ${finishedMedia.tracks.length}',
          tag: 'AudioHandler',
          level: InfoLevel.debug,
        );
        await _syncService.flush();
        unawaited(
          refreshPersonalizedShelfForCompletedItem(
            container: _ref,
            itemId: finishedMedia.itemId,
            preferredLibraryId: finishedMedia.libraryId,
            sourceTag: 'AudioHandler',
            reason: 'playback completed',
          ),
        );

        final loopMode = _ref
            .read(settingsManagerProvider.notifier)
            .getGlobalSetting<String>(SettingKeys.loopMode, defaultValue: 'off');
        final isLoopOn = loopMode == 'on';

        if (isLoopOn) {
          final finishedQueueItem = QueueItem(itemId: finishedMedia.itemId, episodeId: finishedMedia.episodeId);
          final displayInfo = QueueDisplayInfo(
            title: finishedMedia.title,
            subtitle: finishedMedia.subtitle,
            author: finishedMedia.author,
          );
          addToQueue(finishedQueueItem, displayInfo: displayInfo, allowCurrent: true);
        }

        if (queueList.isNotEmpty) {
          _forceQueueSwitchOnNextPlay = true;
          _ignoreProgressOnNextPlay = isLoopOn;
          await play();
        } else {
          await pause();
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

    if (!kIsWeb && Platform.isAndroid) {
      _skipSilenceSubscription = _ref
          .read(appDatabaseProvider)
          .watchGlobalSetting(SettingKeys.skipSilence)
          .map((setting) => setting?.value.trim())
          .distinct()
          .listen((value) {
            if (_isDisposing) return;
            final enabled = value == 'true';
            unawaited(_player.setSkipSilenceEnabled(enabled));
          });

      _volumeBoostEnabledSubscription = _ref
          .read(appDatabaseProvider)
          .watchGlobalSetting(SettingKeys.volumeBoostEnabled)
          .map((setting) => setting?.value.trim())
          .distinct()
          .listen((value) {
            if (_isDisposing) return;
            final enabled = value == 'true';
            final loudnessEnhancer = _loudnessEnhancer;
            if (loudnessEnhancer != null) {
              if (enabled) {
                unawaited(loudnessEnhancer.setEnabled(true));
                unawaited(loudnessEnhancer.setTargetGain(10.0));
              } else {
                unawaited(loudnessEnhancer.setEnabled(false));
              }
            }
          });

      _equalizerEnabledSubscription = _ref
          .read(appDatabaseProvider)
          .watchGlobalSetting(SettingKeys.equalizerEnabled)
          .map((setting) => setting?.value.trim())
          .distinct()
          .listen((value) {
            if (_isDisposing || _player.androidAudioSessionId == null) return;
            final enabled = value == 'true';
            final equalizer = _equalizer;
            if (equalizer != null) {
              unawaited(equalizer.setEnabled(enabled));
            }
          });

      _equalizerBandGainsSubscription = _ref
          .read(appDatabaseProvider)
          .watchGlobalSetting(SettingKeys.equalizerBandGains)
          .map((setting) => setting?.value.trim())
          .distinct()
          .listen((value) async {
            if (_isDisposing || _player.androidAudioSessionId == null) return;
            final equalizer = _equalizer;
            if (equalizer == null) return;
            try {
              final params = await equalizer.parameters;
              final savedGains = _parseEqualizerBandGains(value);
              for (final band in params.bands) {
                final targetGain = savedGains[band.index] ?? 0.0;
                if (band.gain != targetGain) {
                  unawaited(band.setGain(targetGain));
                }
              }
            } catch (e) {
              logger('Failed to apply equalizer gains: $e', tag: 'AudioHandler', level: InfoLevel.error);
            }
          });

      _equalizerSessionSubscription = _player.androidAudioSessionIdStream.distinct().listen((sessionId) async {
        if (_isDisposing || sessionId == null) return;
        final equalizer = _equalizer;
        if (equalizer == null) return;
        try {
          final enabledSetting = _ref
              .read(settingsManagerProvider.notifier)
              .getGlobalSetting<bool>(SettingKeys.equalizerEnabled);
          unawaited(equalizer.setEnabled(enabledSetting));

          final params = await equalizer.parameters;
          final savedGainsStr = _ref
              .read(settingsManagerProvider.notifier)
              .getGlobalSetting<String>(SettingKeys.equalizerBandGains);
          final savedGains = _parseEqualizerBandGains(savedGainsStr);
          for (final band in params.bands) {
            final targetGain = savedGains[band.index] ?? 0.0;
            if (band.gain != targetGain) {
              unawaited(band.setGain(targetGain));
            }
          }
        } catch (e) {
          logger('Failed to apply equalizer on session activation: $e', tag: 'AudioHandler', level: InfoLevel.error);
        }
      });

      const autoResumeChannel = MethodChannel('de.vito0912.yaabsa/autoresume');
      Future<void> sendAutoResumeSettingsToNative() async {
        if (_isDisposing) return;
        try {
          final bluetooth = _ref
              .read(settingsManagerProvider.notifier)
              .getGlobalSetting<bool>(SettingKeys.autoResumeOnBluetoothConnection, defaultValue: false);
          await autoResumeChannel.invokeMethod('updateAutoResumeSettings', {'bluetooth': bluetooth});
        } catch (e) {
          logger('Failed to send auto resume settings to native: $e', tag: 'AudioHandler', level: InfoLevel.warning);
        }
      }

      _autoResumeOnBluetoothSubscription = _ref
          .read(appDatabaseProvider)
          .watchGlobalSetting(SettingKeys.autoResumeOnBluetoothConnection)
          .map((setting) => setting?.value.trim())
          .distinct()
          .listen((_) {
            sendAutoResumeSettingsToNative();
          });
    }

    unawaited(_restorePlaybackPreferencesOnStartup());

    _chapterSubscription = chapterStream.listen((chapter) {
      if (_isDisposing) return;
      final wasEnabled = _chapterNotificationEnabled;
      _refreshChapterNotificationState();
      if (_chapterNotificationEnabled || wasEnabled) {
        _updateMediaItemForChapterNotification();
        unawaited(_updatePlaybackState());
      }
    });
  }

  Map<String, String> get currentRequestHeaders => _currentRequestHeadersInternal;

  Future<void> _updatePlaybackState() async {
    final lockMediaNotification = _ref
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<bool>(SettingKeys.lockMediaNotification);

    logger(
      'Updating playback state. Current media item: ${_currentMediaItem?.itemId}, queue length: ${queueList.length}, isTransitionLoading: $_queueTransitionLoading',
      tag: 'AudioHandler',
      level: InfoLevel.debug,
    );

    final isTransitionLoading =
        _queueTransitionLoading || (_player.processingState == ProcessingState.completed && queueList.isNotEmpty);
    final hasPlaybackContext =
        _currentMediaItem != null || queueList.isNotEmpty || _queueTransitionLoading || _restoredMediaItem != null;
    final castActive = isCastControlActive;
    final controlState = castActive ? playerControlState : _player.playerState;
    final playPauseControl = controlState.playing ? MediaControl.pause : MediaControl.play;
    final rawPosition = position;
    final updatePosition = _chapterNotificationEnabled
        ? _clampDuration(rawPosition - _chapterNotificationOffset, Duration.zero, _chapterNotificationDuration)
        : rawPosition;
    final effectiveSpeed = castActive
        ? (GoogleCastRemoteMediaClient.instance.mediaStatus?.playbackRate.toDouble() ?? _player.speed)
        : _player.speed;
    final bufferedPosition = castActive
        ? updatePosition
        : _chapterNotificationEnabled
        ? updatePosition
        : (_currentMediaItem == null && _restoredMediaItem != null)
        ? _restoredPosition
        : (_currentMediaItem?.offsetForTrack(_currentTrackIndex) ?? Duration.zero) + _player.bufferedPosition;

    final List<MediaControl> controls = [];
    final List<int> compactActionIndices = [];

    if (hasPlaybackContext) {
      final currentPageActions = _currentNotificationPageIndex < _notificationPages.length
          ? _notificationPages[_currentNotificationPageIndex]
          : const <String>[];

      final chaptersExist =
          _currentMediaItem != null && _currentMediaItem!.chapters != null && _currentMediaItem!.chapters!.isNotEmpty;
      final queueExists = queueList.isNotEmpty;
      final hasChaptersOrQueue = chaptersExist || queueExists;

      final showSkipInsteadOfFastForward = _ref
          .read(settingsManagerProvider.notifier)
          .getGlobalSetting<bool>(SettingKeys.showSkipInsteadOfFastForward, defaultValue: false);

      for (final action in currentPageActions) {
        if (controls.length >= 4) break;

        var resolvedAction = action;
        if (showSkipInsteadOfFastForward && !hasChaptersOrQueue) {
          if (action == 'skipToPrevious') {
            resolvedAction = 'rewind';
          } else if (action == 'skipToNext') {
            resolvedAction = 'fastForward';
          }
        }

        switch (resolvedAction) {
          case 'rewind':
            controls.add(
              MediaControl.custom(
                androidIcon: _androidAutoIconReplay,
                label: 'Rewind',
                name: _androidAutoCustomActionRewind,
              ),
            );
            break;
          case 'fastForward':
            controls.add(
              MediaControl.custom(
                androidIcon: _androidAutoIconForwardMedia,
                label: 'Fast forward',
                name: _androidAutoCustomActionFastForward,
              ),
            );
            break;
          case 'speed':
            controls.add(
              MediaControl.custom(
                androidIcon: _androidAutoIconSpeed,
                label: 'Speed',
                name: _androidAutoCustomActionSpeed,
              ),
            );
            break;
          case 'stop':
            controls.add(
              MediaControl.custom(androidIcon: _androidAutoIconStop, label: 'Stop', name: _androidAutoCustomActionStop),
            );
            break;
          case 'skipToNext':
            controls.add(
              MediaControl.custom(
                androidIcon: 'drawable/widget_skip_next',
                label: 'Next chapter',
                name: 'custom.skip_next',
              ),
            );
            break;
          case 'skipToPrevious':
            controls.add(
              MediaControl.custom(
                androidIcon: 'drawable/widget_skip_previous',
                label: 'Previous chapter',
                name: 'custom.skip_previous',
              ),
            );
            break;
          case 'switchPage':
            if (_notificationPages.length > 1) {
              controls.add(
                MediaControl.custom(
                  androidIcon: _androidAutoIconMoreVert,
                  label: 'Next page',
                  name: 'custom.switch_page',
                ),
              );
            }
            break;
        }
      }

      final hasSwitchPageAction = currentPageActions.contains('switchPage');
      if (_notificationPages.length > 1 && !hasSwitchPageAction) {
        final switchPageControl = MediaControl.custom(
          androidIcon: _androidAutoIconMoreVert,
          label: 'Next page',
          name: 'custom.switch_page',
        );
        if (controls.length < 4) {
          controls.add(switchPageControl);
        } else {
          controls[3] = switchPageControl;
        }
      }

      controls.add(playPauseControl);

      if (controls.isNotEmpty) {
        final playPauseIndex = controls.length - 1;
        compactActionIndices.add(playPauseIndex);
        for (int i = 0; i < controls.length - 1; i++) {
          if (compactActionIndices.length >= 3) break;
          compactActionIndices.add(i);
        }
        compactActionIndices.sort();
      }
    }

    final Set<MediaAction> finalSystemActions;
    if (!hasPlaybackContext || lockMediaNotification) {
      finalSystemActions = const <MediaAction>{};
    } else if (!kIsWeb && (Platform.isIOS || Platform.isMacOS)) {
      final chaptersExist =
          _currentMediaItem != null && _currentMediaItem!.chapters != null && _currentMediaItem!.chapters!.isNotEmpty;
      final queueExists = queueList.isNotEmpty;
      final hasChaptersOrQueue = chaptersExist || queueExists;

      final showSkipInsteadOfFastForward = _ref
          .read(settingsManagerProvider.notifier)
          .getGlobalSetting<bool>(SettingKeys.showSkipInsteadOfFastForward, defaultValue: false);

      final useSkip = showSkipInsteadOfFastForward && hasChaptersOrQueue;
      if (useSkip) {
        finalSystemActions = const {
          MediaAction.seek,
          MediaAction.play,
          MediaAction.pause,
          MediaAction.skipToNext,
          MediaAction.skipToPrevious,
        };
      } else {
        finalSystemActions = const {
          MediaAction.seek,
          MediaAction.play,
          MediaAction.pause,
          MediaAction.fastForward,
          MediaAction.rewind,
        };
      }
    } else {
      finalSystemActions = const {MediaAction.seek};
    }

    playbackState.add(
      PlaybackState(
        // Which buttons should appear in the notification now
        controls: controls,
        // Which other actions should be enabled in the notification
        systemActions: finalSystemActions,
        // Which controls to show in Android's compact view.
        androidCompactActionIndices: compactActionIndices,
        processingState: !hasPlaybackContext
            ? AudioProcessingState.idle
            : isTransitionLoading
            ? AudioProcessingState.loading
            : (_currentMediaItem == null && _restoredMediaItem != null)
            ? AudioProcessingState.ready
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

  void _loadNotificationPages() {
    final settingVal = _ref
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<String>(SettingKeys.mediaNotificationPages);
    try {
      final List<dynamic> outer = json.decode(settingVal);
      final List<List<String>> parsed = [];
      for (final page in outer) {
        if (page is List) {
          final List<String> parsedPage = page.map((e) => e.toString()).toList();
          while (parsedPage.length < 4) {
            parsedPage.add('');
          }
          parsed.add(parsedPage.take(4).toList());
        }
      }
      if (parsed.isNotEmpty) {
        _notificationPages = parsed.take(4).toList();
      } else {
        _notificationPages = const [
          ['rewind', 'fastForward', 'speed', 'stop'],
        ];
      }
    } catch (e) {
      logger('Failed to parse mediaNotificationPages setting: $e', tag: 'AudioHandler', level: InfoLevel.error);
      _notificationPages = const [
        ['rewind', 'fastForward', 'speed', 'stop'],
      ];
    }

    if (_currentNotificationPageIndex >= _notificationPages.length) {
      _currentNotificationPageIndex = 0;
    }
  }

  void _cycleNotificationPage() {
    if (_notificationPages.length <= 1) return;
    _currentNotificationPageIndex = (_currentNotificationPageIndex + 1) % _notificationPages.length;
    unawaited(_updatePlaybackState());
  }

  Future<void> dispose() async {
    _isDisposing = true;
    await _activeUserIdSubscription.cancel();
    await _showLastPlayedMiniPlayerSettingSubscription.cancel();
    await _mediaNotificationTypeSubscription.cancel();
    await _mediaNotificationPagesSubscription.cancel();
    await _showSkipInsteadOfFastForwardSubscription.cancel();
    await _chapterSubscription?.cancel();
    await _skipSilenceSubscription?.cancel();
    _skipSilenceSubscription = null;
    await _volumeBoostEnabledSubscription?.cancel();
    _volumeBoostEnabledSubscription = null;
    await _equalizerEnabledSubscription?.cancel();
    _equalizerEnabledSubscription = null;
    await _equalizerBandGainsSubscription?.cancel();
    _equalizerBandGainsSubscription = null;
    await _equalizerSessionSubscription?.cancel();
    _equalizerSessionSubscription = null;
    await _autoResumeOnBluetoothSubscription?.cancel();
    _autoResumeOnBluetoothSubscription = null;
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
    await _volumeSubject.close();
    await _castControlActiveSubject.close();
    await _queueLengthSubject.close();
    await _queueSnapshotSubject.close();
    await _queueTransitionLoadingSubject.close();
    await _showPlayerSubject.close();
    await _lastPlayedMiniPlayerSnapshotSubject.close();
  }

  Map<int, double> _parseEqualizerBandGains(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return const {};
    try {
      final Map<String, dynamic> decoded = json.decode(jsonString);
      return decoded.map((key, value) => MapEntry(int.parse(key), (value as num).toDouble()));
    } catch (e) {
      return const {};
    }
  }
}
