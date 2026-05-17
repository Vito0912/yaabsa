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
import 'package:yaabsa/util/handler/playback_sync_service.dart';
import 'package:yaabsa/util/handler/player_history_handler.dart';
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
part 'bg_audio_handler_auto_queue.dart';
part 'bg_audio_handler_android_auto.dart';
part 'bg_audio_handler_android_auto_ids.dart';
part 'bg_audio_handler_android_auto_data.dart';
part 'bg_audio_handler_android_auto_media.dart';
part 'bg_audio_handler_android_auto_browse.dart';

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
  final BehaviorSubject<int> _queueLengthSubject = BehaviorSubject<int>.seeded(0);
  final BehaviorSubject<PlayerQueueSnapshot> _queueSnapshotSubject = BehaviorSubject<PlayerQueueSnapshot>.seeded(
    const PlayerQueueSnapshot(),
  );
  final BehaviorSubject<bool> _queueTransitionLoadingSubject = BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _showPlayerSubject = BehaviorSubject<bool>.seeded(false);
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

  bool _isSameControlState(PlayerState left, PlayerState right) {
    return left.playing == right.playing && left.processingState == right.processingState;
  }

  void _clearCastControlTracking() {
    _castControlledContentId = null;
    _castControlledTrackIndex = 0;
  }

  void _emitShouldShowPlayer() {
    if (!_showPlayerSubject.isClosed) {
      _showPlayerSubject.add(_currentMediaItem != null || _queueTransitionLoading);
    }
  }

  void _setAndroidAutoMoreMenuVisible(bool visible, {Duration? autoCloseAfter}) {
    if (_androidAutoMoreMenuVisible == visible && autoCloseAfter == null) {
      return;
    }

    _androidAutoMoreMenuVisible = visible;

    _androidAutoMoreMenuTimer?.cancel();
    _androidAutoMoreMenuTimer = null;

    if (visible && autoCloseAfter != null) {
      _androidAutoMoreMenuTimer = Timer(autoCloseAfter, () {
        if (!_androidAutoMoreMenuVisible) {
          return;
        }

        _androidAutoMoreMenuVisible = false;
        unawaited(_updatePlaybackState());
      });
    }

    unawaited(_updatePlaybackState());
  }

  void _setQueueTransitionLoading(bool value, {bool emitMediaWhenEmpty = false}) {
    if (!value) {
      _queueTransitionItemId = null;
      _queueTransitionEpisodeId = null;
    }

    if (_queueTransitionLoading == value) {
      return;
    }

    _queueTransitionLoading = value;
    if (!_queueTransitionLoadingSubject.isClosed) {
      _queueTransitionLoadingSubject.add(value);
    }
    _emitShouldShowPlayer();

    if (emitMediaWhenEmpty && !value && _currentMediaItem == null && !mediaItemStream.isClosed) {
      mediaItemStream.add(null);
    }

    unawaited(_updatePlaybackState());
  }

  void _setQueueTransitionTargetItem(QueueItem? item) {
    _queueTransitionItemId = item?.itemId;
    _queueTransitionEpisodeId = item?.episodeId;
  }

  static double get maxVolume {
    if (Platform.isAndroid) {
      return 2.0;
    }
    return 1.0;
  }

  bool _queueItemsMatch({
    required String leftItemId,
    required String? leftEpisodeId,
    required String rightItemId,
    required String? rightEpisodeId,
  }) {
    return leftItemId == rightItemId && leftEpisodeId == rightEpisodeId;
  }

  String _queueItemReferenceKey({required String itemId, String? episodeId}) {
    return '$itemId::${episodeId ?? ''}';
  }

  void _resetStreamRecoveryState({bool clearWindow = false}) {
    _streamRecoveryRetryTimer?.cancel();
    _streamRecoveryRetryTimer = null;
    _streamRecoveryInFlight = false;

    if (clearWindow) {
      _streamRecoveryAttempts = 0;
      _lastStreamRecoveryAttemptAt = null;
    }
  }

  void _scheduleStreamRecoveryRetry(Object error) {
    if (_isDisposing || _currentMediaItem == null || isCastControlActive) {
      return;
    }

    if (_streamRecoveryRetryTimer != null || _streamRecoveryInFlight) {
      return;
    }

    final currentState = _player.playerState;
    if (currentState.playing && currentState.processingState == ProcessingState.ready) {
      _resetStreamRecoveryState(clearWindow: true);
      return;
    }

    final now = DateTime.now();
    final lastAttemptAt = _lastStreamRecoveryAttemptAt;
    if (lastAttemptAt == null || now.difference(lastAttemptAt) > _streamRecoveryResetWindow) {
      _streamRecoveryAttempts = 0;
    }

    if (_streamRecoveryAttempts >= _streamRecoveryMaxAttempts) {
      logger(
        'Suppressing automatic stream recovery after $_streamRecoveryAttempts attempts within '
        '${_streamRecoveryResetWindow.inSeconds}s. Waiting for manual retry.',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
      return;
    }

    final delayMs = (_streamRecoveryMinDelayMs * (1 << _streamRecoveryAttempts))
        .clamp(_streamRecoveryMinDelayMs, _streamRecoveryMaxDelayMs)
        .toInt();
    final delay = Duration(milliseconds: delayMs);

    logger(
      'Scheduling stream recovery attempt ${_streamRecoveryAttempts + 1} in '
      '${delay.inMilliseconds}ms after error: $error',
      tag: 'AudioHandler',
      level: InfoLevel.warning,
    );

    _streamRecoveryRetryTimer = Timer(delay, () async {
      _streamRecoveryRetryTimer = null;

      if (_isDisposing || _currentMediaItem == null || isCastControlActive || _streamRecoveryInFlight) {
        return;
      }

      _streamRecoveryInFlight = true;
      _streamRecoveryAttempts += 1;
      _lastStreamRecoveryAttemptAt = DateTime.now();

      try {
        await _syncedPlay();
      } catch (e, s) {
        logger(
          'Stream recovery attempt $_streamRecoveryAttempts failed: $e\n$s',
          tag: 'AudioHandler',
          level: InfoLevel.warning,
        );
      } finally {
        _streamRecoveryInFlight = false;
      }
    });
  }

  Duration _rewindPosition(Duration position, Duration rewindBy) {
    if (rewindBy <= Duration.zero) {
      return position;
    }

    final rewoundPosition = position - rewindBy;
    return rewoundPosition.isNegative ? Duration.zero : rewoundPosition;
  }

  Future<void> applySleepTimerAutoRewindNow() async {
    if (_currentMediaItem == null) {
      return;
    }

    final rewindMinutes = _ref
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<int>(SettingKeys.sleepTimerAutoRewindMinutes);

    if (rewindMinutes <= 0) {
      return;
    }

    final rewindBy = Duration(minutes: rewindMinutes);
    final currentPosition = position;
    final targetPosition = _rewindPosition(currentPosition, rewindBy);
    if (targetPosition >= currentPosition) {
      return;
    }

    await seek(targetPosition);

    final currentPositionSeconds = targetPosition.inMicroseconds / Duration.microsecondsPerSecond;
    final canReachServer = _ref.read(serverReachabilityProvider);

    try {
      await _ref
          .read(sessionRepositoryProvider)
          .syncOpenSession(currentPositionSeconds, 0.3, canReachServer: canReachServer);
    } catch (e) {
      logger('Failed to sync sleep timer rewind before stop: $e', tag: 'AudioHandler', level: InfoLevel.warning);
    }

    logger(
      'Applied sleep timer auto-rewind (${rewindBy.inMinutes} min) before stop at ${targetPosition.inSeconds}s.',
      tag: 'AudioHandler',
      level: InfoLevel.debug,
    );
  }

  void _clearSmartRewindPauseMarker() {
    _pausedAt = null;
    _pausedItemId = null;
    _pausedEpisodeId = null;
  }

  void _clearPausedManualSeekMarker() {
    _pausedManualSeekPosition = null;
    _pausedManualSeekItemId = null;
    _pausedManualSeekEpisodeId = null;
  }

  void _markPausedManualSeek(Duration targetPosition) {
    if (_currentMediaItem == null) {
      _clearPausedManualSeekMarker();
      return;
    }

    _pausedManualSeekPosition = targetPosition;
    _pausedManualSeekItemId = _currentMediaItem!.itemId;
    _pausedManualSeekEpisodeId = _currentMediaItem!.episodeId;
  }

  bool _hasPausedManualSeekMarkerForItem({required String itemId, required String? episodeId}) {
    final markedPosition = _pausedManualSeekPosition;
    if (markedPosition == null) {
      return false;
    }

    return _queueItemsMatch(
      leftItemId: _pausedManualSeekItemId ?? '',
      leftEpisodeId: _pausedManualSeekEpisodeId,
      rightItemId: itemId,
      rightEpisodeId: episodeId,
    );
  }

  bool _consumePausedManualSeekMarkerForCurrentItem() {
    final currentMedia = _currentMediaItem;
    if (currentMedia == null) {
      _clearPausedManualSeekMarker();
      return false;
    }

    final markedPosition = _pausedManualSeekPosition;
    final hasMarker = _hasPausedManualSeekMarkerForItem(itemId: currentMedia.itemId, episodeId: currentMedia.episodeId);

    if (hasMarker) {
      logger(
        'Skipping resume progress reconcile after paused manual seek to $markedPosition.',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
    }

    _clearPausedManualSeekMarker();
    return hasMarker;
  }

  Future<void> _seekWithoutPausedManualMarker(Future<void> Function() action) async {
    _internalSeekGuardDepth += 1;
    try {
      await action();
    } finally {
      _internalSeekGuardDepth -= 1;
    }
  }

  void _recordPausedPlaybackMarker() {
    if (_currentMediaItem == null) {
      _clearSmartRewindPauseMarker();
      return;
    }

    _pausedAt = DateTime.now();
    _pausedItemId = _currentMediaItem!.itemId;
    _pausedEpisodeId = _currentMediaItem!.episodeId;
  }

  bool _hasPauseMarkerForCurrentItem() {
    if (_currentMediaItem == null || _pausedAt == null) {
      return false;
    }

    return _queueItemsMatch(
      leftItemId: _currentMediaItem!.itemId,
      leftEpisodeId: _currentMediaItem!.episodeId,
      rightItemId: _pausedItemId ?? '',
      rightEpisodeId: _pausedEpisodeId,
    );
  }

  Duration _smartRewindDurationForPause(Duration pausedFor) {
    final settingManager = _ref.read(settingsManagerProvider.notifier);

    final shortPauseThresholdSeconds = settingManager.getGlobalSetting<int>(
      SettingKeys.smartRewindShortPauseThresholdSeconds,
    );
    final longPauseThresholdSeconds = settingManager.getGlobalSetting<int>(
      SettingKeys.smartRewindLongPauseThresholdSeconds,
    );

    final shortThreshold = shortPauseThresholdSeconds < 1 ? 1 : shortPauseThresholdSeconds;
    final longThresholdSeed = longPauseThresholdSeconds < 1 ? shortThreshold : longPauseThresholdSeconds;
    final longThreshold = longThresholdSeed < shortThreshold ? shortThreshold : longThresholdSeed;

    final shortRewindSeconds = settingManager.getGlobalSetting<int>(SettingKeys.smartRewindShortRewindSeconds);
    final mediumRewindSeconds = settingManager.getGlobalSetting<int>(SettingKeys.smartRewindMediumRewindSeconds);
    final longRewindSeconds = settingManager.getGlobalSetting<int>(SettingKeys.smartRewindLongRewindSeconds);

    final shortRewind = shortRewindSeconds < 1 ? 1 : shortRewindSeconds;
    final mediumRewind = mediumRewindSeconds < 1 ? shortRewind : mediumRewindSeconds;
    final longRewind = longRewindSeconds < 1 ? mediumRewind : longRewindSeconds;

    final pausedSeconds = pausedFor.inSeconds;
    if (pausedSeconds <= shortThreshold) {
      return Duration(seconds: shortRewind);
    }
    if (pausedSeconds <= longThreshold) {
      return Duration(seconds: mediumRewind);
    }
    return Duration(seconds: longRewind);
  }

  Future<void> _applySmartRewindOnResumeIfNeeded() async {
    if (_currentMediaItem == null || playerControlState.playing) {
      return;
    }

    if (!_hasPauseMarkerForCurrentItem()) {
      _clearSmartRewindPauseMarker();
      return;
    }

    final settingManager = _ref.read(settingsManagerProvider.notifier);
    final smartRewindEnabled = settingManager.getGlobalSetting<bool>(SettingKeys.smartRewindEnabled);
    if (!smartRewindEnabled) {
      _clearSmartRewindPauseMarker();
      return;
    }

    final pausedAt = _pausedAt;
    if (pausedAt == null) {
      _clearSmartRewindPauseMarker();
      return;
    }

    final pausedFor = DateTime.now().difference(pausedAt);
    final rewindBy = _smartRewindDurationForPause(pausedFor);
    final currentPosition = position;

    if (rewindBy <= Duration.zero || currentPosition <= Duration.zero) {
      _clearSmartRewindPauseMarker();
      return;
    }

    final targetPosition = _rewindPosition(currentPosition, rewindBy);

    if (targetPosition < currentPosition) {
      await _seekWithoutPausedManualMarker(() => seek(targetPosition));
      logger(
        'Applied smart rewind (${rewindBy.inSeconds}s) after pause (${pausedFor.inSeconds}s).',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
    }

    _clearSmartRewindPauseMarker();
  }

  Future<void> _persistLastPlayedQueueItem({required String itemId, String? episodeId}) async {
    final userId = _ref.read(currentUserProvider).value?.id;
    if (userId == null || userId.isEmpty) {
      return;
    }

    final db = _ref.read(appDatabaseProvider);
    final payload = jsonEncode(<String, dynamic>{'itemId': itemId, 'episodeId': episodeId});

    try {
      await db.setUserSetting(userId, SettingKeys.lastPlayedQueueItem, payload);
    } catch (e, s) {
      logger(
        'Failed to persist last played item for user $userId: $e\\n$s',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
    }
  }

  QueueItem? _decodeLastPlayedQueueItem(String? rawValue) {
    if (rawValue == null || rawValue.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(rawValue);
      if (decoded is! Map) {
        return null;
      }

      final itemIdValue = decoded['itemId'];
      if (itemIdValue is! String || itemIdValue.trim().isEmpty) {
        return null;
      }

      final episodeIdValue = decoded['episodeId'];
      final episodeId = episodeIdValue is String && episodeIdValue.trim().isNotEmpty ? episodeIdValue.trim() : null;

      return QueueItem(itemId: itemIdValue.trim(), episodeId: episodeId);
    } catch (e) {
      logger('Failed to decode last played item payload: $e', tag: 'AudioHandler', level: InfoLevel.warning);
      return null;
    }
  }

  Future<bool> playLastPlayed({bool requireStartupSettingEnabled = false, bool resumeCurrentIfPaused = true}) async {
    if (requireStartupSettingEnabled) {
      final autoPlayEnabled = _ref
          .read(settingsManagerProvider.notifier)
          .getGlobalSetting<bool>(SettingKeys.autoPlayLastPlayedOnLaunch);
      if (!autoPlayEnabled) {
        return false;
      }
    }

    if (_currentMediaItem != null) {
      if (resumeCurrentIfPaused && !playerControlState.playing) {
        await play();
        return true;
      }
      return false;
    }

    if (playerControlState.playing || _queueTransitionLoading || queueList.isNotEmpty) {
      return false;
    }

    final userId = _ref.read(currentUserProvider).value?.id;
    if (userId == null || userId.isEmpty) {
      return false;
    }

    final db = _ref.read(appDatabaseProvider);
    final rawLastPlayed = (await db.getUserSetting(userId, SettingKeys.lastPlayedQueueItem))?.value;
    final lastPlayedItem = _decodeLastPlayedQueueItem(rawLastPlayed);
    if (lastPlayedItem == null) {
      return false;
    }

    final progress = await _ref
        .read(mediaProgressProvider.notifier)
        .fetchOrRefreshIndividualProgress(lastPlayedItem.itemId, episodeId: lastPlayedItem.episodeId);

    if (progress?.isFinished ?? false) {
      logger(
        'Last played item ${lastPlayedItem.itemId} is finished. Skipping resume.',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
      return false;
    }

    final resumePosition = Duration(
      microseconds: ((progress?.currentTime ?? 0) * Duration.microsecondsPerSecond).round(),
    );

    await playItemFromPosition(
      itemId: lastPlayedItem.itemId,
      episodeId: lastPlayedItem.episodeId,
      position: resumePosition,
    );

    return true;
  }

  Future<bool> playLastPlayedIfEnabledOnStartup() {
    return playLastPlayed(requireStartupSettingEnabled: true, resumeCurrentIfPaused: false);
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
    final nextQueue = queueList
        .where(
          (entry) => episodeId == null
              ? entry.item.itemId != itemId
              : !_queueItemsMatch(
                  leftItemId: entry.item.itemId,
                  leftEpisodeId: entry.item.episodeId,
                  rightItemId: itemId,
                  rightEpisodeId: episodeId,
                ),
        )
        .toList();
    if (nextQueue.length == queueList.length) {
      return;
    }

    queueList = nextQueue;
    _emitQueueState();
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
    if (queueList.isEmpty || oldIndex < 0 || oldIndex >= queueList.length) {
      return;
    }

    var targetIndex = newIndex;
    if (targetIndex > oldIndex) {
      targetIndex -= 1;
    }

    if (targetIndex < 0 || targetIndex >= queueList.length) {
      return;
    }

    final nextQueue = List<PlayerQueueEntry>.from(queueList);
    final moved = nextQueue.removeAt(oldIndex);
    nextQueue.insert(targetIndex, moved);
    queueList = nextQueue;
    _emitQueueState();
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
    if (name == _widgetCustomActionPlayLast) {
      final started = await playLastPlayed();
      logger('Widget custom action: play last (started=$started)', tag: 'AudioHandler', level: InfoLevel.info);
      return <String, dynamic>{'handled': true, 'started': started};
    }

    if (name == _androidAutoCustomActionRewind) {
      _setAndroidAutoMoreMenuVisible(false);

      await rewind();
      logger('Android Auto custom action: rewind', tag: 'AudioHandler', level: InfoLevel.info);
      return <String, dynamic>{'handled': true};
    }

    if (name == _androidAutoCustomActionFastForward) {
      _setAndroidAutoMoreMenuVisible(false);

      await fastForward();
      logger('Android Auto custom action: fast forward', tag: 'AudioHandler', level: InfoLevel.info);
      return <String, dynamic>{'handled': true};
    }

    if (name == _androidAutoCustomActionSpeed) {
      _setAndroidAutoMoreMenuVisible(false);

      const steps = <double>[0.75, 1.0, 1.25, 1.5, 1.75, 2.0];
      final currentSpeed = _player.speed;

      final currentIndex = steps.indexWhere((value) => (value - currentSpeed).abs() < 0.001);
      final nextIndex = currentIndex < 0 ? 1 : (currentIndex + 1) % steps.length;
      final nextSpeed = steps[nextIndex];

      await setSpeed(nextSpeed);
      logger('Android Auto custom action: speed changed to $nextSpeed', tag: 'AudioHandler', level: InfoLevel.info);
      return <String, dynamic>{'handled': true, 'speed': nextSpeed};
    }

    if (name == _androidAutoCustomActionMoreMenu) {
      _setAndroidAutoMoreMenuVisible(true, autoCloseAfter: const Duration(seconds: 4));

      logger('Android Auto more menu opened', tag: 'AudioHandler', level: InfoLevel.info);
      return <String, dynamic>{
        'handled': true,
        'actions': <String>['close', 'stop'],
      };
    }

    if (name == _androidAutoCustomActionMoreClose) {
      _setAndroidAutoMoreMenuVisible(false);

      logger('Android Auto custom action: more menu closed', tag: 'AudioHandler', level: InfoLevel.info);
      return <String, dynamic>{'handled': true, 'action': 'close'};
    }

    if (name == _androidAutoCustomActionStop) {
      _setAndroidAutoMoreMenuVisible(false);

      await stop();
      logger('Android Auto custom action: stop invoked', tag: 'AudioHandler', level: InfoLevel.info);
      return <String, dynamic>{'handled': true, 'action': 'stop'};
    }

    return super.customAction(name, extras);
  }

  Future<LibraryItem?> resolveQueueLibraryItem(String itemId) {
    return _queueItemDetailsCache.putIfAbsent(itemId, () async {
      try {
        return await _ref.read(libraryItemProvider(itemId).future);
      } catch (e) {
        logger('Failed to resolve queue item $itemId: $e', tag: 'AudioHandler', level: InfoLevel.warning);
        return null;
      }
    });
  }

  void _emitQueueLength() {
    if (!_queueLengthSubject.isClosed) {
      _queueLengthSubject.add(queueList.length);
    }
  }

  void _emitQueueState() {
    _emitQueueLength();
    if (!_queueSnapshotSubject.isClosed) {
      _queueSnapshotSubject.add(_buildQueueSnapshot());
    }
  }

  bool _enqueueItem(
    QueueItem item, {
    QueueDisplayInfo displayInfo = QueueDisplayInfo.empty,
    bool autoQueued = false,
    int? autoQueuePage,
  }) {
    if (_currentMediaItem != null &&
        _queueItemsMatch(
          leftItemId: _currentMediaItem!.itemId,
          leftEpisodeId: _currentMediaItem!.episodeId,
          rightItemId: item.itemId,
          rightEpisodeId: item.episodeId,
        )) {
      return false;
    }

    if (isInQueue(item.itemId, episodeId: item.episodeId)) {
      return false;
    }

    queueList = [
      ...queueList,
      PlayerQueueEntry(
        id: 'q_${_queueEntryCounter++}',
        item: item,
        displayInfo: displayInfo,
        autoQueued: autoQueued,
        autoQueuePage: autoQueuePage,
      ),
    ];

    return true;
  }

  QueueDisplayInfo _displayInfoFromLibraryItem(LibraryItem item) {
    return QueueDisplayInfo(title: item.title, subtitle: item.subtitle, author: item.authorString);
  }

  QueueDisplayInfo _displayInfoFromPodcastEpisode(LibraryItem item, Episode episode) {
    final title = (episode.title != null && episode.title!.trim().isNotEmpty) ? episode.title!.trim() : item.title;
    final subtitle = (episode.subtitle != null && episode.subtitle!.trim().isNotEmpty)
        ? episode.subtitle!.trim()
        : item.title;
    return QueueDisplayInfo(title: title, subtitle: subtitle, author: item.authorString);
  }

  bool get _isAutoQueueEnabled {
    return _ref.read(settingsManagerProvider.notifier).getGlobalSetting<bool>(SettingKeys.autoQueue);
  }

  bool get _isSeriesFallbackAutoQueueEnabled {
    return _ref
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<bool>(SettingKeys.autoQueueIncludeSeriesOutsideContext);
  }

  PlayerQueueSnapshot _buildQueueSnapshot() {
    final autoState = _autoQueueState;
    final autoQueueRemaining = autoState == null ? 0 : _remainingAutoQueueItems(autoState);

    return PlayerQueueSnapshot(
      entries: List<PlayerQueueEntry>.unmodifiable(queueList),
      autoQueueEnabled: _isAutoQueueEnabled,
      autoQueueActive: autoState != null,
      autoQueueLoading: autoState?.isLoading ?? false,
      autoQueueRemaining: autoQueueRemaining,
      canLoadMoreAutoQueue: autoState != null && !autoState.isLoading && autoQueueRemaining > 0,
    );
  }

  int _remainingAutoQueueItems(_AutoQueueState state) {
    if (state.totalItems <= 0 || state.pageSize <= 0) {
      return 0;
    }

    final highestLoadedAbsoluteIndex = ((state.highestLoadedPage + 1) * state.pageSize - 1)
        .clamp(0, state.totalItems - 1)
        .toInt();
    final loadedAfterCurrent = (highestLoadedAbsoluteIndex - state.currentItemAbsoluteIndex)
        .clamp(0, state.totalItems)
        .toInt();
    final totalAfterCurrent = (state.totalItems - state.currentItemAbsoluteIndex - 1)
        .clamp(0, state.totalItems)
        .toInt();

    return (totalAfterCurrent - loadedAfterCurrent).clamp(0, state.totalItems).toInt();
  }

  void _maybePrefetchAutoQueue({int minBufferedEntries = 1}) {
    final autoState = _autoQueueState;
    if (autoState == null || autoState.isLoading) {
      return;
    }

    if (_remainingAutoQueueItems(autoState) <= 0 || queueList.length > minBufferedEntries) {
      return;
    }

    logger(
      'Prefetching auto-queue page (buffered=${queueList.length}, remaining=${_remainingAutoQueueItems(autoState)}).',
      tag: 'AudioHandler',
      level: InfoLevel.debug,
    );
    unawaited(_loadMoreAutoQueue());
  }

  void _clearAutoQueueState() {
    _autoQueueGeneration += 1;
    _autoQueueState = null;
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
    }
    mediaItemStream.add(mediaItem);
    _refreshPlayerControlState();
    _emitShouldShowPlayer();
    _handleAutoQueueOnCurrentItemChange(
      mediaItem == null ? null : _queueItemReferenceKey(itemId: mediaItem.itemId, episodeId: mediaItem.episodeId),
    );
  }

  Stream<double> get volumeStream => _player.volumeStream;

  Future<void> setVolume(double volume) async {
    if (volume < 0 || volume > maxVolume) {
      logger('Volume out of bounds: $volume', tag: 'AudioHandler', level: InfoLevel.error);
      return Future.value();
    }
    await _player.setVolume(volume);
    return Future.value();
  }

  @override
  Future<void> setSpeed(double speed) async {
    if (speed < 0.25 || speed > 3) {
      logger('Speed out of bounds: $speed', tag: 'AudioHandler', level: InfoLevel.error);
      return Future.value();
    }
    await _player.setSpeed(speed);
    return Future.value();
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

  bool _computeCastControlActive() {
    if (!_supportsCastPlatform) {
      return false;
    }
    if (_castControlledContentId == null || _currentMediaItem == null) {
      return false;
    }
    if (!GoogleCastSessionManager.instance.hasConnectedSession) {
      return false;
    }
    if (_currentMediaItem!.id != _castControlledContentId) {
      return false;
    }

    final status = GoogleCastRemoteMediaClient.instance.mediaStatus;
    if (status == null) {
      return false;
    }

    if (status.playerState == CastMediaPlayerState.idle) {
      return false;
    }

    final remoteContentId = status.mediaInformation?.contentId;
    return remoteContentId != null && remoteContentId == _castControlledContentId;
  }

  PlayerState _castPlayerStateFromStatus(GoggleCastMediaStatus? status) {
    if (status == null) {
      return PlayerState(false, ProcessingState.loading);
    }

    switch (status.playerState) {
      case CastMediaPlayerState.playing:
        return PlayerState(true, ProcessingState.ready);
      case CastMediaPlayerState.paused:
        return PlayerState(false, ProcessingState.ready);
      case CastMediaPlayerState.buffering:
        return PlayerState(true, ProcessingState.buffering);
      case CastMediaPlayerState.loading:
        return PlayerState(false, ProcessingState.loading);
      case CastMediaPlayerState.idle:
        if (status.idleReason == GoogleCastMediaIdleReason.finished) {
          return PlayerState(false, ProcessingState.completed);
        }
        return PlayerState(false, ProcessingState.idle);
      case CastMediaPlayerState.unknown:
        return PlayerState(false, ProcessingState.loading);
    }
  }

  AudioProcessingState _toAudioProcessingState(ProcessingState state) {
    return {
      ProcessingState.idle: AudioProcessingState.idle,
      ProcessingState.loading: AudioProcessingState.loading,
      ProcessingState.buffering: AudioProcessingState.buffering,
      ProcessingState.ready: AudioProcessingState.ready,
      ProcessingState.completed: AudioProcessingState.completed,
    }[state]!;
  }

  int _resolvedCastTrackIndex(InternalMedia media) {
    if (media.tracks.isEmpty) {
      return 0;
    }
    final maxIndex = media.tracks.length - 1;
    return _castControlledTrackIndex.clamp(0, maxIndex).toInt();
  }

  Duration _trackEndDurationForIndex(InternalMedia media, int trackIndex) {
    final track = media.tracks[trackIndex];
    final endSeconds = track.end ?? ((track.start ?? 0) + track.duration);
    return Duration(microseconds: (endSeconds * Duration.microsecondsPerSecond).round());
  }

  Duration _castAbsolutePosition(Duration castRelativePosition) {
    final media = _currentMediaItem;
    if (media == null || media.tracks.isEmpty) {
      return castRelativePosition;
    }

    final trackIndex = _resolvedCastTrackIndex(media);
    final trackStart = media.startDurationForTrack(trackIndex);
    final trackEnd = _trackEndDurationForIndex(media, trackIndex);
    final boundedTrackEnd = trackEnd < trackStart ? media.totalDuration : trackEnd;
    final absolute = trackStart + castRelativePosition;
    if (absolute < trackStart) {
      return trackStart;
    }
    if (absolute > boundedTrackEnd) {
      return boundedTrackEnd;
    }
    if (absolute > media.totalDuration) {
      return media.totalDuration;
    }
    return absolute;
  }

  Duration _absoluteToCastRelativePosition(Duration absolutePosition) {
    final media = _currentMediaItem;
    if (media == null || media.tracks.isEmpty) {
      return absolutePosition;
    }

    final trackIndex = _resolvedCastTrackIndex(media);
    final trackStart = media.startDurationForTrack(trackIndex);
    final trackEnd = _trackEndDurationForIndex(media, trackIndex);
    final boundedTrackEnd = trackEnd < trackStart ? media.totalDuration : trackEnd;

    final bounded = absolutePosition < trackStart
        ? trackStart
        : (absolutePosition > boundedTrackEnd ? boundedTrackEnd : absolutePosition);
    return bounded - trackStart;
  }

  Duration _localAbsolutePosition() {
    return (_currentMediaItem?.offsetForTrack(_currentTrackIndex) ?? Duration.zero) + _player.position;
  }

  void _refreshPlayerControlState() {
    if (_supportsCastPlatform && !GoogleCastSessionManager.instance.hasConnectedSession) {
      _clearCastControlTracking();
    }

    final castActive = _computeCastControlActive();
    if (!_castControlActiveSubject.isClosed && _castControlActiveSubject.value != castActive) {
      _castControlActiveSubject.add(castActive);
    }

    final state = castActive
        ? _castPlayerStateFromStatus(GoogleCastRemoteMediaClient.instance.mediaStatus)
        : _player.playerState;

    if (!_playerControlStateSubject.isClosed && !_isSameControlState(_playerControlStateSubject.value, state)) {
      _playerControlStateSubject.add(state);
    }
  }

  void _setupCastStateListeners() {
    if (!_supportsCastPlatform) {
      return;
    }

    _castSessionSubscription = GoogleCastSessionManager.instance.currentSessionStream.listen((session) {
      final wasCastControlActive = isCastControlActive;
      if (session?.connectionState != GoogleCastConnectState.connected) {
        _clearCastControlTracking();
      }
      _refreshPlayerControlState();
      if (wasCastControlActive != isCastControlActive || isCastControlActive) {
        unawaited(_updatePlaybackState());
      }
    });

    _castMediaStatusSubscription = GoogleCastRemoteMediaClient.instance.mediaStatusStream.listen((_) {
      final wasCastControlActive = isCastControlActive;

      final status = GoogleCastRemoteMediaClient.instance.mediaStatus;
      if (status == null || status.playerState == CastMediaPlayerState.idle) {
        _clearCastControlTracking();
      }

      _refreshPlayerControlState();
      if (wasCastControlActive != isCastControlActive || isCastControlActive) {
        unawaited(_updatePlaybackState());
      }
    });
  }

  Stream<Duration> get durationStream {
    return _player.durationStream.map((duration) {
      return _currentMediaItem?.totalDuration ?? duration ?? Duration.zero;
    }).distinct();
  }

  Duration get duration {
    return _currentMediaItem?.totalDuration ?? Duration.zero;
  }

  Stream<Duration> get positionStream {
    final localPositionStream = _player.positionStream
        .throttleTime(const Duration(milliseconds: 200))
        .map((position) => (_currentMediaItem?.offsetForTrack(_currentTrackIndex) ?? Duration.zero) + position)
        .distinct();

    if (!_supportsCastPlatform) {
      return localPositionStream;
    }

    final castPositionStream = GoogleCastRemoteMediaClient.instance.playerPositionStream
        .throttleTime(const Duration(milliseconds: 200))
        .map(_castAbsolutePosition)
        .distinct();

    return castControlActiveStream.startWith(isCastControlActive).switchMap((castActive) {
      if (castActive) {
        return castPositionStream.startWith(position);
      }
      return localPositionStream.startWith(position);
    }).distinct();
  }

  Stream<Duration> get bufferedPositionStream {
    return _player.bufferedPositionStream
        .throttleTime(const Duration(seconds: 1))
        .map((position) => (_currentMediaItem?.offsetForTrack(_currentTrackIndex) ?? Duration.zero) + position)
        .distinct();
  }

  Stream<InternalChapter?> get chapterStream {
    return positionStream
        .throttleTime(const Duration(milliseconds: 1000))
        .map((position) => _currentMediaItem?.getChapterForDuration(position))
        .distinct();
  }

  Stream<List<InternalChapter>> get chaptersStream {
    return mediaItemStream.map((position) => _currentMediaItem?.chapters ?? []).distinct();
  }

  Stream<int> get queueLengthStream => _queueLengthSubject.stream;

  bool get canSkipForwardNow {
    if (_currentMediaItem == null) return false;
    if (queueList.isNotEmpty) return true;
    return _currentMediaItem!.getNextChapterForDuration(position) != null;
  }

  Stream<bool> get canSkipForwardStream {
    return Rx.combineLatest3<Duration, List<InternalChapter>, int, bool>(
      positionStream,
      chaptersStream,
      queueLengthStream,
      (position, chapters, queueLength) {
        if (_currentMediaItem == null) return false;
        if (queueLength > 0) return true;
        return _currentMediaItem!.getNextChapterForDuration(position) != null;
      },
    ).startWith(canSkipForwardNow).distinct();
  }

  Duration get position {
    if (isCastControlActive) {
      return _castAbsolutePosition(GoogleCastRemoteMediaClient.instance.playerPosition);
    }
    return _localAbsolutePosition();
  }

  Stream<bool> get shouldShowPlayer {
    return _showPlayerSubject.stream.distinct();
  }

  bool get shouldShowPlayerNow {
    return _currentMediaItem != null || _queueTransitionLoading;
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
    final libraryId = item.libraryId;
    final autoQueueContext = libraryId != null && episodeIndex != null
        ? _AutoQueueRequestContext.podcast(
            libraryId: libraryId,
            podcastItemId: item.id,
            podcastItem: item,
            initialPage: episodeIndex ~/ _autoQueuePageSize,
            seededPodcastEpisodes: orderedEpisodes,
          )
        : null;

    setQueueFromPodcastEpisode(item, episode);
    await play();

    if (!_isAutoQueueEnabled) {
      return;
    }

    if (!_queueItemsMatch(
      leftItemId: _currentMediaItem?.itemId ?? '',
      leftEpisodeId: _currentMediaItem?.episodeId,
      rightItemId: item.id,
      rightEpisodeId: episode.id,
    )) {
      return;
    }

    if (autoQueueContext != null) {
      unawaited(_startAutoQueue(autoQueueContext, QueueItem(itemId: item.id, episodeId: episode.id)));
    }
  }

  Future<void> _playLibraryItemWithContext(
    LibraryItem item, {
    AutoQueueStart autoQueueStart = const AutoQueueStart.none(),
  }) async {
    logger(
      'Starting library item playback with auto-queue start type=${autoQueueStart.type.name}, '
      'sourceId=${autoQueueStart.sourceId}, globalIndex=${autoQueueStart.globalIndex}.',
      tag: 'AudioHandler',
      level: InfoLevel.debug,
    );

    setQueueFromLibraryItem(item);
    await play();

    if (!_isAutoQueueEnabled) {
      logger('Auto queue disabled. Skipping auto-queue setup.', tag: 'AudioHandler', level: InfoLevel.debug);
      return;
    }

    if (!_queueItemsMatch(
      leftItemId: _currentMediaItem?.itemId ?? '',
      leftEpisodeId: _currentMediaItem?.episodeId,
      rightItemId: item.id,
      rightEpisodeId: null,
    )) {
      logger(
        'Auto queue setup skipped because active media does not match requested item ${item.id}.',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
      return;
    }

    if (autoQueueStart.type != AutoQueueStartType.none) {
      final scopedContext = await _buildAutoQueueContextFromStart(item, autoQueueStart);
      if (scopedContext == null) {
        logger(
          'Auto queue scope could not be resolved for ${autoQueueStart.type.name} (sourceId=${autoQueueStart.sourceId}).',
          tag: 'AudioHandler',
          level: InfoLevel.warning,
        );
        return;
      }

      logger(
        'Starting scoped auto queue: type=${autoQueueStart.type.name}, sourceId=${autoQueueStart.sourceId}, '
        'globalIndex=${autoQueueStart.globalIndex}.',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
      unawaited(_startAutoQueue(scopedContext, QueueItem(itemId: item.id)));
      return;
    }

    if (!_isSeriesFallbackAutoQueueEnabled) {
      logger(
        'Auto queue start type is none and outside-source fallback is disabled. Skipping auto queue.',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
      return;
    }

    logger('Attempting fallback series auto queue for item ${item.id}.', tag: 'AudioHandler', level: InfoLevel.debug);
    final fallbackContext = await _buildSeriesFallbackAutoQueueContext(item);
    if (fallbackContext != null) {
      unawaited(_startAutoQueue(fallbackContext, QueueItem(itemId: item.id)));
    } else {
      logger(
        'Fallback series auto queue context could not be resolved for item ${item.id}.',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
    }
  }

  Future<void> _prepareForQueuedItemTransition() async {
    final transitionPosition = position;
    _setQueueTransitionTargetItem(null);
    _setQueueTransitionLoading(true);
    _currentMediaItem = null;
    _currentTrackIndex = 0;

    try {
      await _syncService.flush(positionOverride: transitionPosition);
      await _ref.read(sessionRepositoryProvider).closeSession();
    } catch (e) {
      logger('Error preparing queued transition: $e', tag: 'AudioHandler', level: InfoLevel.error);
    }

    await _safePlayerStop();
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
    PlayerUtils.enableWakelock(_ref);
    _resetStreamRecoveryState(clearWindow: true);

    final isCurrentItem =
        _currentMediaItem != null &&
        _queueItemsMatch(
          leftItemId: _currentMediaItem!.itemId,
          leftEpisodeId: _currentMediaItem!.episodeId,
          rightItemId: itemId,
          rightEpisodeId: episodeId,
        );
    if (!isCurrentItem) {
      await stop(clearQueue: true);
      _lastQueueItem = QueueItem(itemId: itemId, episodeId: episodeId);
      _currentMediaItem = await _ref.read(sessionRepositoryProvider).openSession(itemId, episodeId: episodeId);
      if (_currentMediaItem == null) {
        logger('No media item found for ID: $itemId', tag: 'AudioHandler', level: InfoLevel.error);
        return Future.value();
      }
      await _setSource(ignoreSavedProgress: true);
    }

    _clearSmartRewindPauseMarker();
    await seek(position);
    if (isCastControlActive) {
      await play();
    } else {
      await _syncedPlay();
    }
    TrayManager.update();
  }

  Future<void> _syncedPlay({bool restoreProgress = false, bool skipResumeProgressReconcile = false}) async {
    mediaItem.add(_currentMediaItem?.toMediaItem());

    if (_currentMediaItem == null) return Future.value();
    final resumeItem = _currentMediaItem!;
    final startPosition = position;
    logger(
      'Starting playback for item: ${resumeItem.itemId} (${resumeItem.episodeId ?? 'item'}) from position: $startPosition (restoreProgress=$restoreProgress, castControl=$isCastControlActive)',
      tag: 'AudioHandler',
      level: InfoLevel.info,
    );

    if (restoreProgress && !skipResumeProgressReconcile && !isCastControlActive) {
      unawaited(_reconcileResumeProgressInBackground(resumeItem));
    } else if (restoreProgress && skipResumeProgressReconcile) {
      logger(
        'Resume progress reconcile skipped because playback position was manually changed while paused.',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
    }

    unawaited(
      _player.play().catchError((error, stackTrace) {
        logger('Failed to start player playback: $error\n$stackTrace', tag: 'AudioHandler', level: InfoLevel.error);
      }),
    );
  }

  Future<void> _reconcileResumeProgressInBackground(InternalMedia resumeItem) async {
    const driftThreshold = Duration(seconds: 10);

    try {
      final progress = await _ref
          .read(mediaProgressProvider.notifier)
          .fetchOrRefreshIndividualProgress(resumeItem.itemId, episodeId: resumeItem.episodeId);

      final currentMedia = _currentMediaItem;
      if (currentMedia == null ||
          !_queueItemsMatch(
            leftItemId: currentMedia.itemId,
            leftEpisodeId: currentMedia.episodeId,
            rightItemId: resumeItem.itemId,
            rightEpisodeId: resumeItem.episodeId,
          )) {
        logger(
          'Background resume reconcile aborted: current media item changed or is null (current=${currentMedia?.itemId}(${currentMedia?.episodeId ?? 'item'}), resume=${resumeItem.itemId}(${resumeItem.episodeId ?? 'item'}))',
          tag: 'AudioHandler',
          level: InfoLevel.debug,
        );
        return;
      }

      if (progress == null) {
        logger(
          'Background resume reconcile: no progress found for item ${resumeItem.itemId} (${resumeItem.episodeId ?? 'item'}), skipping reconcile',
          tag: 'AudioHandler',
          level: InfoLevel.debug,
        );
        return;
      }

      final remotePosition = progress.isFinished
          ? Duration.zero
          : Duration(microseconds: (progress.currentTime * Duration.microsecondsPerSecond).round());
      final currentAbsolutePosition = position;
      final positionDrift = (remotePosition - currentAbsolutePosition).abs();

      logger(
        'Background resume reconcile for item: ${resumeItem.itemId} (${resumeItem.episodeId ?? 'item'}), '
        'current position: $currentAbsolutePosition, remote position: $remotePosition, drift: $positionDrift',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );

      if (positionDrift < driftThreshold) {
        return;
      }

      logger(
        'Background resume reconcile detected position drift of $positionDrift. '
        'Seeking from $currentAbsolutePosition to $remotePosition',
        tag: 'AudioHandler',
        level: InfoLevel.info,
      );

      await _seekWithoutPausedManualMarker(() => seek(remotePosition));
    } catch (e) {
      logger('Background resume reconcile failed: $e', tag: 'AudioHandler', level: InfoLevel.warning);
    }
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
      await _syncService.flush(positionOverride: stopPosition);
      await _ref.read(sessionRepositoryProvider).closeSession();
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

      if (state.processingState == ProcessingState.completed) {
        PlayerHistoryHandler.addPlayerHistory(PlayerHistoryType.stop);
      }
      if (state.processingState == ProcessingState.loading || state.processingState == ProcessingState.buffering) {
        PlayerHistoryHandler.addPlayerHistory(PlayerHistoryType.pause);
      }
      if (state.playing && state.processingState == ProcessingState.ready) {
        _resetStreamRecoveryState(clearWindow: true);
        PlayerHistoryHandler.addPlayerHistory(PlayerHistoryType.play);
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
  }

  Future<dynamic> _setSource({Duration initialPosition = Duration.zero, bool ignoreSavedProgress = false}) async {
    if (_currentMediaItem == null) return Future.value();
    final requestHeaders = currentRequestHeaders;
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

  Map<String, String> get currentRequestHeaders {
    final user = _ref.read(currentUserProvider).value;
    return buildRequestHeaders(serverHeaders: user?.server?.headers, bearerToken: user?.preferredAuthToken);
  }

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
    final controls = isMoreMenuVisible
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
    final compactActionIndices = isMoreMenuVisible ? const <int>[0, 1, 2] : <int>[0, 2, controls.length - 1];

    playbackState.add(
      PlaybackState(
        // Which buttons should appear in the notification now
        controls: controls,
        // Which other actions should be enabled in the notification
        systemActions: lockMediaNotification ? const <MediaAction>{} : const {MediaAction.seek},
        // Which controls to show in Android's compact view.
        androidCompactActionIndices: compactActionIndices,
        // Whether audio is ready, buffering, ...
        processingState: isTransitionLoading
            ? AudioProcessingState.loading
            : _toAudioProcessingState(controlState.processingState),
        playing: isTransitionLoading ? true : controlState.playing,
        // The current position as of this update. You should not broadcast
        // position changes continuously because listeners will be able to
        // project the current position after any elapsed time based on the
        // current speed and whether audio is playing and ready. Instead, only
        // broadcast position updates when they are different from expected (e.g.
        // buffering, or seeking).
        updatePosition: updatePosition,
        bufferedPosition: bufferedPosition,
        speed: effectiveSpeed,
      ),
    );
  }

  Future<void> dispose() async {
    _isDisposing = true;
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
  }
}
