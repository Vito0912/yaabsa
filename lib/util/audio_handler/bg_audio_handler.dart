// ignore_for_file: unused_element_parameter

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:audio_service/audio_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/services.dart' show PlatformException;
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
import 'package:yaabsa/api/routes/abs_api.dart';
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
import 'package:yaabsa/provider/player/queue_source_provider.dart';
import 'package:yaabsa/provider/library/smart_download_provider.dart';
import 'package:yaabsa/models/queue_source.dart';
import 'package:yaabsa/util/globals.dart' show packageInfo;
import 'package:yaabsa/util/audio_handler/playback_error_classifier.dart';
import 'package:yaabsa/util/audio_handler/playback_sync_service.dart';
import 'package:yaabsa/util/audio_handler/player_mutation_barrier.dart';
import 'package:yaabsa/util/audio_handler/playback_start_attempt.dart';
import 'package:yaabsa/util/audio_handler/sleep_timer_completion_gate.dart';
import 'package:yaabsa/util/bluetooth_auto_resume.dart';
import 'package:yaabsa/util/audio_handler/player_history_handler.dart';
import 'package:yaabsa/util/audio_handler/auto/android_auto_browse_models.dart';
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
  Stream<Duration>? _subtitlePositionStream;
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
  late final StreamSubscription<String?> _desktopSkipControlsSeekSubscription;
  late final ProviderSubscription<ABSApi?> _androidAutoApiSubscription;
  late final ProviderSubscription<bool> _androidAutoServerReachabilitySubscription;
  late final ProviderSubscription<AsyncValue<Map<String, MediaProgress>>> _androidAutoMediaProgressSubscription;
  int _currentNotificationPageIndex = 0;
  List<List<String>> _notificationPages = const [
    ['rewind', 'fastForward', 'speed', 'stop'],
  ];
  StreamSubscription<InternalChapter?>? _chapterSubscription;
  StreamSubscription<String?>? _skipSilenceSubscription;
  StreamSubscription<AudioEffectStatus>? _volumeBoostAvailabilitySubscription;
  StreamSubscription<String?>? _equalizerEnabledSubscription;
  StreamSubscription<String?>? _equalizerBandGainsSubscription;
  StreamSubscription<int?>? _equalizerSessionSubscription;
  StreamSubscription<String?>? _autoResumeOnBluetoothSubscription;
  StreamSubscription<String?>? _autoResumeBluetoothRestrictionSubscription;
  StreamSubscription<String?>? _autoResumeBluetoothDeviceAddressesSubscription;
  AndroidLoudnessEnhancer? _loudnessEnhancer;
  AndroidEqualizer? _equalizer;
  AndroidEqualizer? get equalizer => _equalizer;
  static bool get supportsVolumeBoostPlatform => !kIsWeb && (Platform.isAndroid || Platform.isLinux);
  Stream<int?> get androidAudioSessionIdStream => _player.androidAudioSessionIdStream;
  int? get androidAudioSessionId => _player.androidAudioSessionId;
  final BehaviorSubject<bool> _volumeBoostAvailableSubject = BehaviorSubject<bool>.seeded(supportsVolumeBoostPlatform);
  Stream<bool> get volumeBoostAvailableStream => _volumeBoostAvailableSubject.stream;
  bool get volumeBoostAvailable => _volumeBoostAvailableSubject.value;
  double get maxVolume => supportsVolumeBoostPlatform && volumeBoostAvailable ? 2.0 : 1.0;
  double get volume => _volumeSubject.value;
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
  final Set<String> _autoQueueSuppressedReferences = <String>{};
  bool _autoQueueDisabledForCurrentSession = false;
  bool _manualQueueSessionPending = false;
  MediaSourceDescriptor? _restoredQueueSource;
  PlayableRef? _restoredQueueAnchor;
  bool _skipQueueIntentPersistence = false;
  Timer? _queueIntentPersistenceTimer;
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
  bool _transcodeFallbackInFlight = false;
  String? _transcodeAttemptedFor;
  Future<bool>? _transcodeFallbackFuture;
  PlayerMutationLease? _transcodeFallbackLease;
  Completer<PlayerException>? _sourceLoadErrorCompleter;
  int _internalSeekGuardDepth = 0;
  final StreamController<UserSeekNavigationEvent> _userSeekNavigationController =
      StreamController<UserSeekNavigationEvent>.broadcast(sync: true);
  int _userSeekNavigationSequence = 0;
  final UserSeekNavigationLedger _userSeekNavigationLedger = UserSeekNavigationLedger();
  final PlayerMutationBarrier _playerMutationBarrier = PlayerMutationBarrier();
  final PlaybackStartAttemptLedger _playbackStartAttemptLedger = PlaybackStartAttemptLedger();
  int _audioSourceGeneration = 0;
  final SleepTimerCompletionGateLedger _sleepTimerCompletionGate = SleepTimerCompletionGateLedger();
  PlayerMutationLease? _queueTransitionLoadingOwner;
  int _seekGeneration = 0;
  int _playbackContextGeneration = 0;
  bool _chapterNotificationEnabled = false;
  Duration _chapterNotificationOffset = Duration.zero;
  Duration _chapterNotificationDuration = Duration.zero;
  bool _historyWasPlayingReady = false;
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
  Future<void>? _androidAutoBrowseRefreshFuture;
  Future<void>? _androidAutoBrowsePreparationFuture;
  bool _androidAutoPreparedForNextLaunch = false;
  int _androidAutoBrowseSession = 0;
  String? _androidAutoBrowseUserId;
  ABSApi? _androidAutoBrowseApi;
  final AndroidAutoBrowseSnapshotCache _androidAutoBrowseCache = AndroidAutoBrowseSnapshotCache();
  Timer? _androidAutoContinueRefreshDebounce;
  final Map<String, List<MediaItem>> _androidAutoPrimedChildren = <String, List<MediaItem>>{};
  late final BehaviorSubject<PlayerState> _playerControlStateSubject;
  final BehaviorSubject<bool> _castControlActiveSubject = BehaviorSubject<bool>.seeded(false);
  String? _castControlledContentId;
  int _castControlledTrackIndex = 0;
  bool _hasObservedActiveUserId = false;
  String? _observedActiveUserId;
  Future<void>? _lastPlayedMiniPlayerRestoreFuture;
  String? _lastPlayedMiniPlayerRestoreUserId;
  int _lastPlayedMiniPlayerRestoreGeneration = 0;
  int? _lastPlayedMiniPlayerRestoreActiveGeneration;
  Future<bool>? _lastPlayedPlaybackFuture;
  PlayerMutationLease? _lastPlayedPlaybackLease;
  int? _lastPlayedPlaybackGeneration;
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
  Stream<UserSeekNavigationEvent> get userSeekNavigationStream => _userSeekNavigationController.stream;
  Set<int> get activeUserSeekNavigationOperations => _userSeekNavigationLedger.activeSnapshot;
  bool get hasActiveUserSeekNavigation => _userSeekNavigationLedger.hasActive;
  int get playbackContextGeneration => _playbackContextGeneration;

  bool get _supportsCastPlatform => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  void _setOwnedQueueTransitionLoading(PlayerMutationLease lease) {
    _queueTransitionLoadingOwner = lease;
    _setQueueTransitionLoading(true);
  }

  bool _clearQueueTransitionLoadingIfOwned(PlayerMutationLease lease, {bool emitMediaWhenEmpty = false}) {
    if (!identical(_queueTransitionLoadingOwner, lease)) {
      return false;
    }
    _queueTransitionLoadingOwner = null;
    if (_queueTransitionLoading) {
      _setQueueTransitionLoading(false, emitMediaWhenEmpty: emitMediaWhenEmpty);
    }
    return true;
  }

  bool _abandonQueueTransitionLoadingIfOwned(PlayerMutationLease lease, {bool emitMediaWhenEmpty = false}) {
    final cleared = _clearQueueTransitionLoadingIfOwned(lease, emitMediaWhenEmpty: emitMediaWhenEmpty);
    if (cleared && !playerControlState.playing && !isCastControlActive) {
      PlayerUtils.disableWakelock(_ref);
    }
    return cleared;
  }

  Future<void> applySleepTimerAutoRewindNow() async {
    await _applySleepTimerAutoRewindNowInternal();
  }

  Future<bool> applySleepTimerAutoRewindNowWithLease(PlayerMutationLease lease) {
    return _applySleepTimerAutoRewindNowInternal(mutationLease: lease);
  }

  PlayerMutationLease acquirePlayerMutationLease() {
    _playbackContextGeneration += 1;
    return _playerMutationBarrier.acquire();
  }

  bool isPlayerMutationLeaseCurrent(PlayerMutationLease lease) => _playerMutationBarrier.isCurrent(lease);

  void invalidatePlayerMutationLease(PlayerMutationLease lease) {
    _playerMutationBarrier.invalidate(lease);
  }

  SleepTimerCompletionGateToken armSleepTimerCompletionGate({required String itemId, String? episodeId}) {
    return _sleepTimerCompletionGate.arm(itemId: itemId, episodeId: episodeId);
  }

  bool clearSleepTimerCompletionGate(SleepTimerCompletionGateToken token) {
    return _sleepTimerCompletionGate.clear(token);
  }

  SleepTimerCompletionGateClaim? _claimSleepTimerCompletionGate(InternalMedia media) {
    return _sleepTimerCompletionGate.claimWhere(
      (itemId, episodeId) => _queueItemsMatch(
        leftItemId: itemId,
        leftEpisodeId: episodeId,
        rightItemId: media.itemId,
        rightEpisodeId: media.episodeId,
      ),
    );
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

  Future<void> androidAutoAuthenticationChanged({required bool authenticated}) {
    return _androidAutoAuthenticationChanged(this, authenticated: authenticated);
  }

  Future<void> prepareAndroidAutoBrowse() {
    return _androidAutoPrepareBrowse(this);
  }

  void invalidateAndroidAutoBrowseState({bool notify = true}) {
    _androidAutoInvalidateBrowseState(this, notify: notify);
  }

  AndroidAutoBrowseResult<AndroidAutoBrowseSnapshot> get androidAutoBrowseState => _androidAutoBrowseCache.state;

  void completeAndroidAutoBrowseLaunch() {
    _androidAutoPreparedForNextLaunch = false;
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
    _autoQueueSuppressedReferences.clear();
    _autoQueueDisabledForCurrentSession = false;
    _manualQueueSessionPending = false;
    _restoredQueueSource = null;
    _restoredQueueAnchor = null;
    queueList = [];
    _originalQueueList.clear();
    _enqueueItem(item, displayInfo: displayInfo);
    _forceQueueSwitchOnNextPlay = true;
    _emitQueueState();
    _persistQueueIntentSoon();
  }

  void clearQueue() {
    _clearAutoQueueState();
    _activeMusicLibraryId = null;
    _activeMusicLibraryFilter = null;
    _autoQueueSuppressedReferences.clear();
    _manualQueueSessionPending = false;
    _restoredQueueSource = null;
    _restoredQueueAnchor = null;
    queueList.clear();
    _originalQueueList.clear();
    _forceQueueSwitchOnNextPlay = false;
    _emitQueueState();
    _persistQueueIntentSoon();
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

  void addToQueue(
    QueueItem item, {
    QueueDisplayInfo displayInfo = QueueDisplayInfo.empty,
    bool allowCurrent = false,
    bool markAsManual = true,
  }) {
    if (markAsManual) {
      final generatedMatch = queueList
          .where(
            (entry) =>
                entry.autoQueued &&
                _queueItemsMatch(
                  leftItemId: entry.item.itemId,
                  leftEpisodeId: entry.item.episodeId,
                  rightItemId: item.itemId,
                  rightEpisodeId: item.episodeId,
                ),
          )
          .firstOrNull;
      if (generatedMatch != null) {
        queueList = queueList.where((entry) => entry.id != generatedMatch.id).toList(growable: false);
        _originalQueueList.removeWhere((entry) => entry.id == generatedMatch.id);
      }
    }

    final didAdd = _enqueueItem(item, displayInfo: displayInfo, allowCurrent: allowCurrent);
    final hasMatchingManualEntry = queueList.any(
      (entry) =>
          !entry.autoQueued &&
          _queueItemsMatch(
            leftItemId: entry.item.itemId,
            leftEpisodeId: entry.item.episodeId,
            rightItemId: item.itemId,
            rightEpisodeId: item.episodeId,
          ),
    );
    if (markAsManual && (didAdd || hasMatchingManualEntry)) {
      _manualQueueSessionPending = true;
      _destroyAutoQueueAfterLastManualEntry();
    }
    _emitQueueState();
    _persistQueueIntentSoon();
  }

  void _destroyAutoQueueAfterLastManualEntry() {
    _clearAutoQueueState();
    _restoredQueueSource = null;
    _restoredQueueAnchor = null;
    _autoQueueSuppressedReferences.clear();

    final lastManualIndex = queueList.lastIndexWhere((entry) => !entry.autoQueued);
    if (lastManualIndex >= 0 && lastManualIndex < queueList.length - 1) {
      queueList = queueList.take(lastManualIndex + 1).toList(growable: false);
    }

    final retainedIds = queueList.map((entry) => entry.id).toSet();
    _originalQueueList.removeWhere((entry) => !retainedIds.contains(entry.id));
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
    for (final entry in queueList) {
      final matches = episodeId == null
          ? entry.item.itemId == itemId
          : _queueItemsMatch(
              leftItemId: entry.item.itemId,
              leftEpisodeId: entry.item.episodeId,
              rightItemId: itemId,
              rightEpisodeId: episodeId,
            );
      if (matches && entry.autoQueued) {
        _autoQueueSuppressedReferences.add(
          _queueItemReferenceKey(itemId: entry.item.itemId, episodeId: entry.item.episodeId),
        );
      }
    }
    _removeFromQueueByItemIdInternal(itemId, episodeId: episodeId);
    _clearManualQueueSessionPendingIfNeeded();
    _persistQueueIntentSoon();
  }

  void removeFromQueueItem(QueueItem item) {
    removeFromQueueByItemId(item.itemId, episodeId: item.episodeId);
  }

  void removeQueueEntry(String queueEntryId) {
    final removedEntry = queueList.where((entry) => entry.id == queueEntryId).firstOrNull;
    final nextQueue = queueList.where((entry) => entry.id != queueEntryId).toList();
    if (nextQueue.length == queueList.length) {
      return;
    }

    queueList = nextQueue;
    _originalQueueList.removeWhere((entry) => entry.id == queueEntryId);
    if (removedEntry?.autoQueued ?? false) {
      _autoQueueSuppressedReferences.add(
        _queueItemReferenceKey(itemId: removedEntry!.item.itemId, episodeId: removedEntry.item.episodeId),
      );
    }
    _clearManualQueueSessionPendingIfNeeded();
    _emitQueueState();
    _persistQueueIntentSoon();
  }

  void reorderQueue(int oldIndex, int newIndex) {
    final movedEntry = oldIndex >= 0 && oldIndex < queueList.length ? queueList[oldIndex] : null;
    final didReorder = _reorderQueueInternal(oldIndex, newIndex);
    if (didReorder && (movedEntry?.autoQueued ?? false)) {
      _manualQueueSessionPending = true;
    }
    _persistQueueIntentSoon();
  }

  void disableAutoQueueForCurrentSession() {
    if (_autoQueueDisabledForCurrentSession) {
      return;
    }

    _autoQueueDisabledForCurrentSession = true;
    _clearAutoQueueState();
    _emitQueueState();
  }

  bool get autoQueueDisabledForCurrentSession => _autoQueueDisabledForCurrentSession;

  void _clearManualQueueSessionPendingIfNeeded() {
    if (!queueList.any((entry) => !entry.autoQueued)) {
      _manualQueueSessionPending = false;
    }
  }

  void _markManualQueueItemPlayed(PlayerQueueEntry entry) {
    if (entry.autoQueued) {
      return;
    }

    _markPendingManualQueueSessionPlayed();
  }

  void _markPendingManualQueueSessionPlayed() {
    if (!_manualQueueSessionPending) {
      return;
    }

    _manualQueueSessionPending = false;
    disableAutoQueueForCurrentSession();
  }

  Future<void> loadMoreAutoQueue() {
    return _loadMoreAutoQueue();
  }

  void _persistQueueIntentSoon() {
    _queueIntentPersistenceTimer?.cancel();
    _queueIntentPersistenceTimer = Timer(const Duration(milliseconds: 150), () {
      unawaited(_persistQueueIntent());
    });
  }

  Future<void> _persistQueueIntent() async {
    final userId = _ref.read(currentUserProvider).value?.id;
    if (userId == null || userId.isEmpty || _isDisposing || _skipQueueIntentPersistence) {
      return;
    }

    final sourceState = _autoQueueState;
    final source = sourceState == null ? null : _sourceDescriptorFromContext(sourceState.context);
    final manualEntries = queueList
        .where((entry) => !entry.autoQueued)
        .map(
          (entry) => QueueIntentEntry(
            ref: PlayableRef(itemId: entry.item.itemId, episodeId: entry.item.episodeId),
            title: entry.displayInfo.title,
            subtitle: entry.displayInfo.subtitle,
            author: entry.displayInfo.author,
          ),
        )
        .toList(growable: false);
    final anchor = _currentMediaItem == null
        ? sourceState == null
              ? null
              : _playableRefFromKey(sourceState.currentItemReferenceKey)
        : PlayableRef(itemId: _currentMediaItem!.itemId, episodeId: _currentMediaItem!.episodeId);

    final snapshot = QueueIntentSnapshot(
      manualEntries: manualEntries,
      source: source,
      anchor: anchor,
      suppressed: _autoQueueSuppressedReferences
          .map(_playableRefFromKey)
          .whereType<PlayableRef>()
          .toList(growable: false),
      sourceRevision: null,
    );
    try {
      await _ref
          .read(appDatabaseProvider)
          .setUserSetting(userId, SettingKeys.queueIntent, jsonEncode(snapshot.toJson()));
    } catch (e, s) {
      logger('Failed to persist queue intent: $e\n$s', tag: 'AudioHandler', level: InfoLevel.warning);
    }
  }

  Future<void> _restoreQueueIntent(String userId) async {
    if (_isDisposing || queueList.isNotEmpty || _currentMediaItem != null) {
      return;
    }

    final raw = (await _ref.read(appDatabaseProvider).getUserSetting(userId, SettingKeys.queueIntent))?.value;
    if (raw == null || raw.trim().isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return;
      }
      final snapshot = QueueIntentSnapshot.fromJson(Map<String, dynamic>.from(decoded));
      _autoQueueSuppressedReferences
        ..clear()
        ..addAll(
          snapshot.suppressed.map((ref) => _queueItemReferenceKey(itemId: ref.itemId, episodeId: ref.episodeId)),
        );
      _restoredQueueSource = snapshot.source;
      _restoredQueueAnchor = snapshot.anchor;
      for (final entry in snapshot.manualEntries) {
        _enqueueItem(
          QueueItem(itemId: entry.ref.itemId, episodeId: entry.ref.episodeId),
          displayInfo: QueueDisplayInfo(title: entry.title, subtitle: entry.subtitle, author: entry.author),
        );
      }
      _manualQueueSessionPending = snapshot.manualEntries.isNotEmpty;
      if (queueList.isNotEmpty) {
        _emitQueueState();
      }
    } catch (e, s) {
      logger('Failed to restore queue intent for user $userId: $e\n$s', tag: 'AudioHandler', level: InfoLevel.warning);
    }
  }

  MediaSourceDescriptor? _sourceDescriptorFromContext(_AutoQueueRequestContext context) {
    return switch (context.sourceType) {
      _AutoQueueSourceType.series => MediaSourceDescriptor(
        type: MediaSourceType.series,
        sourceId: context.seriesId ?? '',
        libraryId: context.libraryId,
      ),
      _AutoQueueSourceType.playlist => MediaSourceDescriptor(
        type: MediaSourceType.playlist,
        sourceId: context.playlistId ?? '',
        libraryId: context.libraryId,
      ),
      _AutoQueueSourceType.collection => MediaSourceDescriptor(
        type: MediaSourceType.collection,
        sourceId: context.collectionId ?? '',
        libraryId: context.libraryId,
      ),
      _AutoQueueSourceType.podcast => MediaSourceDescriptor(
        type: MediaSourceType.podcast,
        sourceId: context.podcastItemId ?? '',
        libraryId: context.libraryId,
        descending: false,
      ),
    };
  }

  PlayableRef? _playableRefFromKey(String key) {
    final separator = key.indexOf('::');
    if (separator < 0) {
      return key.isEmpty ? null : PlayableRef(itemId: key);
    }
    final itemId = key.substring(0, separator);
    final episodeId = key.substring(separator + 2);
    return itemId.isEmpty ? null : PlayableRef(itemId: itemId, episodeId: episodeId.isEmpty ? null : episodeId);
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
    _persistQueueIntentSoon();
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
            addToQueue(
              QueueItem(itemId: candidate.id),
              displayInfo: _displayInfoFromLibraryItem(candidate),
              markAsManual: false,
            );
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
    final oldKey = __currentMediaItem == null ? null : _mediaKey(__currentMediaItem!);
    final newKey = mediaItem == null ? null : _mediaKey(mediaItem);
    if (oldKey != newKey) {
      _transcodeAttemptedFor = null;
      _playbackContextGeneration += 1;
      _seekGeneration += 1;
    }

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
    _persistQueueIntentSoon();
    _handleAutoQueueOnCurrentItemChange(
      mediaItem == null ? null : _queueItemReferenceKey(itemId: mediaItem.itemId, episodeId: mediaItem.episodeId),
    );
  }

  String _mediaKey(InternalMedia media) => '${media.itemId}:${media.episodeId ?? ''}';

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
    _playbackContextGeneration += 1;
    _seekGeneration += 1;
    _playerMutationBarrier.acquire();
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

  Stream<Duration> get subtitlePositionStream {
    return _subtitlePositionStreamInternal();
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
  Future<void> play() => _playInternal();

  Future<void> _playWithPlayerMutationLease(PlayerMutationLease lease) {
    if (!_playerMutationBarrier.isCurrent(lease) || _isDisposing) {
      return Future.value();
    }
    return _playInternal(mutationLease: lease);
  }

  Future<void> _playInternal({PlayerMutationLease? mutationLease}) async {
    if (mutationLease != null && (!_playerMutationBarrier.isCurrent(mutationLease) || _isDisposing)) {
      return;
    }
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

      final observedLoadingLease = _playerMutationBarrier.currentLease;
      logger(
        'Deferring play request until current queue transition completes.',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
      await queueTransitionLoadingStream.firstWhere((isLoading) => !isLoading);
      if (observedLoadingLease == null || !_playerMutationBarrier.isCurrent(observedLoadingLease) || _isDisposing) {
        return;
      }
    }

    if (mutationLease != null && (!_playerMutationBarrier.isCurrent(mutationLease) || _isDisposing)) {
      return;
    }

    var playContextGeneration = mutationLease == null ? ++_playbackContextGeneration : _playbackContextGeneration;
    final playLease = mutationLease ?? _playerMutationBarrier.acquire();
    bool playIntentIsCurrent() => playContextGeneration == _playbackContextGeneration && !_isDisposing;
    bool ownsPlay() => playIntentIsCurrent() && _playerMutationBarrier.isCurrent(playLease);
    void abandonPlayLoading() {
      _abandonQueueTransitionLoadingIfOwned(playLease, emitMediaWhenEmpty: _currentMediaItem == null);
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
      try {
        await _prepareForQueuedItemTransition(playLease);
      } on PlayerInterruptedException {
        abandonPlayLoading();
        return;
      }
      if (!_playerMutationBarrier.isCurrent(playLease) || _isDisposing) {
        abandonPlayLoading();
        return;
      }
      playContextGeneration = _playbackContextGeneration;
    }

    if (!ownsPlay()) {
      abandonPlayLoading();
      return;
    }

    if (_currentMediaItem != null) {
      _forceQueueSwitchOnNextPlay = false;
      PlayerQueueEntry? matchingCurrentQueueEntry;
      if (queueList.isNotEmpty &&
          _queueItemsMatch(
            leftItemId: queueList.first.item.itemId,
            leftEpisodeId: queueList.first.item.episodeId,
            rightItemId: _currentMediaItem!.itemId,
            rightEpisodeId: _currentMediaItem!.episodeId,
          )) {
        matchingCurrentQueueEntry = queueList.first;
      }

      if (_player.playerState.processingState == ProcessingState.completed || forceRestart) {
        await _seekInternal(Duration.zero, mutationLease: playLease);
        if (!ownsPlay()) {
          return;
        }
      }

      final skipResumeProgressReconcile = _consumePausedManualSeekMarkerForCurrentItem();
      await _applySmartRewindOnResumeIfNeeded(mutationLease: playLease);
      if (!ownsPlay()) {
        return;
      }
      final startAttempt = _beginPlaybackStartAttempt(playLease, reservedQueueEntryId: matchingCurrentQueueEntry?.id);
      final startResult = await _syncedPlay(
        restoreProgress: !ignoreProgress,
        skipResumeProgressReconcile: skipResumeProgressReconcile,
        mutationLease: playLease,
      );
      final attemptCurrent = ownsPlay() && _isPlaybackStartAttemptCurrent(startAttempt);
      if (!attemptCurrent || !startResult.started) {
        _settlePlaybackStartAttempt(
          startAttempt,
          attemptCurrent ? _statusForPlaybackStartResult(startResult) : PlaybackStartAttemptStatus.superseded,
        );
        abandonPlayLoading();
        PlayerUtils.disableWakelock(_ref);
        return Future.value();
      }
      try {
        if (matchingCurrentQueueEntry != null) {
          final matchingIndex = queueList.indexWhere((entry) => entry.id == matchingCurrentQueueEntry!.id);
          if (matchingIndex >= 0) {
            final removed = queueList.removeAt(matchingIndex);
            _originalQueueList.removeWhere((entry) => entry.id == removed.id);
            _emitQueueState();
            _maybePrefetchAutoQueue();
          }
          _markManualQueueItemPlayed(matchingCurrentQueueEntry);
        }
        _queueTransitionLoadingOwner = null;
        _setQueueTransitionLoading(false);
      } finally {
        _settlePlaybackStartAttempt(startAttempt, PlaybackStartAttemptStatus.started);
      }
      return Future.value();
    }

    final PlayerQueueEntry? nextEntry = queueList.isNotEmpty ? queueList.first : null;
    final isPendingManualEntry = nextEntry != null && !nextEntry.autoQueued && _manualQueueSessionPending;
    if (nextEntry != null) {
      _forceQueueSwitchOnNextPlay = false;
    }

    QueueItem? nextItem = nextEntry?.item;

    if (mutationLease != null && nextEntry == null) {
      abandonPlayLoading();
      return;
    }

    if (nextEntry == null && _restoredMediaItem != null) {
      final resumed = await _playLastPlayedInternal(requireStartupSettingEnabled: false, resumeCurrentIfPaused: false);
      if (!resumed && playIntentIsCurrent()) {
        _queueTransitionLoadingOwner = null;
        _setQueueTransitionLoading(false);
      }
      return Future.value();
    }

    if (nextItem == null && _lastQueueItem != null) {
      nextItem = _lastQueueItem;
    }
    if (nextItem == null) {
      final resumed = await _playLastPlayedInternal(requireStartupSettingEnabled: false, resumeCurrentIfPaused: false);
      if (!resumed && playIntentIsCurrent()) {
        _queueTransitionLoadingOwner = null;
        _setQueueTransitionLoading(false);
      }
      return Future.value();
    }

    if (!ownsPlay()) {
      abandonPlayLoading();
      return;
    }
    _setQueueTransitionTargetItem(nextItem);
    _setOwnedQueueTransitionLoading(playLease);
    _clearSmartRewindPauseMarker();
    _lastQueueItem = nextItem;

    InternalMedia? openedMedia;
    try {
      openedMedia = await _ref
          .read(sessionRepositoryProvider)
          .openSession(nextItem.itemId, episodeId: nextItem.episodeId, isStillCurrent: ownsPlay);
    } catch (e, s) {
      if (!ownsPlay()) {
        abandonPlayLoading();
        return;
      }
      logger(
        'Exception opening session for ID: ${nextItem.itemId} (${nextItem.episodeId ?? 'item'}): $e\n$s',
        tag: 'AudioHandler',
        level: InfoLevel.error,
      );
    }

    if (!ownsPlay()) {
      abandonPlayLoading();
      return;
    }
    _currentMediaItem = openedMedia;
    playContextGeneration = _playbackContextGeneration;
    if (!ownsPlay()) {
      abandonPlayLoading();
      return;
    }

    if (_currentMediaItem == null) {
      logger(
        'No media item found for ID: ${nextItem.itemId} (${nextItem.episodeId ?? 'item'})',
        tag: 'AudioHandler',
        level: InfoLevel.error,
      );
      _lastQueueItem = null;
      _setLastPlayedMiniPlayerSnapshot(null);
      if (nextEntry != null && !nextEntry.autoQueued) {
        _clearManualQueueSessionPendingIfNeeded();
      }
      PlayerUtils.disableWakelock(_ref);
      TrayManager.update();
      _clearQueueTransitionLoadingIfOwned(playLease, emitMediaWhenEmpty: true);
      return Future.value();
    }
    logger(
      'Playing item: ${_currentMediaItem!.itemId} (${_currentMediaItem!.episodeId ?? 'item'})',
      tag: 'AudioHandler',
      level: InfoLevel.debug,
    );
    try {
      await _setSource(ignoreSavedProgress: ignoreProgress, mutationLease: playLease);
      if (!ownsPlay()) {
        abandonPlayLoading();
        return;
      }
      logger(
        'Setting source for item: ${_currentMediaItem!.itemId} (${_currentMediaItem!.episodeId ?? 'item'})',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
      final startAttempt = _beginPlaybackStartAttempt(playLease, reservedQueueEntryId: nextEntry?.id);
      final startResult = await _syncedPlay(restoreProgress: !ignoreProgress, mutationLease: playLease);
      final attemptCurrent = ownsPlay() && _isPlaybackStartAttemptCurrent(startAttempt);
      if (!attemptCurrent || !startResult.started) {
        _settlePlaybackStartAttempt(
          startAttempt,
          attemptCurrent ? _statusForPlaybackStartResult(startResult) : PlaybackStartAttemptStatus.superseded,
        );
        abandonPlayLoading();
        PlayerUtils.disableWakelock(_ref);
        return;
      }
      try {
        if (nextEntry != null) {
          final reservedIndex = queueList.indexWhere((entry) => entry.id == nextEntry.id);
          if (reservedIndex >= 0) {
            final removed = queueList.removeAt(reservedIndex);
            _originalQueueList.removeWhere((entry) => entry.id == removed.id);
            _emitQueueState();
            if (!isPendingManualEntry) {
              _maybePrefetchAutoQueue();
            }
            final loopMode = _ref
                .read(settingsManagerProvider.notifier)
                .getGlobalSetting<String>(SettingKeys.loopMode, defaultValue: 'off');
            final isLoopOn = loopMode == 'on';
            if (_activeMusicLibraryId != null && !isLoopOn) {
              unawaited(_refillMusicQueue(_activeMusicLibraryId!, filter: _activeMusicLibraryFilter));
            }
          }
          _markManualQueueItemPlayed(nextEntry);
        } else {
          unawaited(_setupAutoQueueOnResume(itemId: nextItem.itemId, episodeId: nextItem.episodeId));
        }
        _clearQueueTransitionLoadingIfOwned(playLease);
      } finally {
        _settlePlaybackStartAttempt(startAttempt, PlaybackStartAttemptStatus.started);
      }
    } catch (e) {
      if (!ownsPlay()) {
        abandonPlayLoading();
        return;
      }
      logger('Failed to start playback source: $e', tag: 'AudioHandler', level: InfoLevel.error);
      if (nextEntry != null && !nextEntry.autoQueued) {
        _clearManualQueueSessionPendingIfNeeded();
      }
      PlayerUtils.disableWakelock(_ref);
      _clearQueueTransitionLoadingIfOwned(playLease, emitMediaWhenEmpty: true);
      final failedSessionBinding = _ref.read(sessionRepositoryProvider).currentSessionBinding;
      _currentMediaItem = null;
      if (failedSessionBinding != null) {
        unawaited(_ref.read(sessionRepositoryProvider).closeSessionBinding(failedSessionBinding));
      }
      TrayManager.update();
    }
    if (ownsPlay()) {
      TrayManager.update();
    }
  }

  Future<bool> playItemFromPosition({
    required String itemId,
    String? episodeId,
    required Duration position,
    bool preserveQueue = false,
    bool userNavigation = true,
  }) async {
    late final PlayerMutationLease lease;
    int? operationId;
    if (userNavigation) {
      lease = _playerMutationBarrier.acquire();
      operationId = _beginUserSeekNavigation(mutationLease: lease);
    } else {
      _playbackContextGeneration += 1;
      lease = _playerMutationBarrier.acquire();
    }

    var succeeded = false;
    try {
      succeeded = await _playItemFromPositionInternal(
        itemId: itemId,
        episodeId: episodeId,
        position: position,
        preserveQueue: preserveQueue,
        mutationLease: lease,
      );
      return succeeded;
    } finally {
      if (operationId != null) {
        _settleUserSeekNavigation(operationId, shouldRetarget: succeeded);
      }
    }
  }

  @override
  Future<void> stop({bool clearQueue = true}) async {
    final lease = _playerMutationBarrier.acquire();
    _playbackContextGeneration += 1;
    await _stopWithPlayerMutationLease(lease, clearQueue: clearQueue);
  }

  Future<bool> stopWithPlayerMutationLease(PlayerMutationLease lease, {bool clearQueue = true}) {
    return _stopWithPlayerMutationLease(lease, clearQueue: clearQueue);
  }

  Future<bool> _stopWithPlayerMutationLease(PlayerMutationLease lease, {required bool clearQueue}) async {
    if (!_playerMutationBarrier.isCurrent(lease)) {
      return false;
    }

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
    final stoppedMedia = _currentMediaItem;
    final sessionRepository = _ref.read(sessionRepositoryProvider);
    final stoppedSessionBinding = sessionRepository.currentSessionBinding;
    final shouldStopCastPlayback = isCastControlActive;

    if (stoppedMedia != null) {
      unawaited(
        PlayerHistoryHandler.addPlayerHistory(PlayerHistoryType.stop, media: stoppedMedia, position: stopPosition),
      );
    }

    if (!_playerMutationBarrier.isCurrent(lease)) {
      return false;
    }

    _queueTransitionLoadingOwner = null;
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
      if (!_playerMutationBarrier.isCurrent(lease)) {
        return false;
      }
      await deactivateCastControl();
    }
    if (clearQueue) {
      _clearAutoQueueState();
      _activeMusicLibraryId = null;
      _autoQueueSuppressedReferences.clear();
      _autoQueueDisabledForCurrentSession = false;
      _manualQueueSessionPending = false;
      _restoredQueueSource = null;
      _restoredQueueAnchor = null;
      queueList.clear();
      _originalQueueList.clear();
      _forceQueueSwitchOnNextPlay = false;
      _emitQueueState();
      _persistQueueIntentSoon();
    }
    if (stoppedSessionBinding != null) {
      unawaited(() async {
        try {
          await _syncService.flush(
            positionOverride: stopPosition,
            sessionClosing: true,
            expectedSessionId: stoppedSessionBinding.sessionId,
          );
          await sessionRepository.closeSessionBinding(stoppedSessionBinding);
        } catch (e) {
          logger('Error closing stopped session: $e', tag: 'AudioHandler', level: InfoLevel.error);
        }
      }());
    }
    return _safePlayerStop(lease);
  }

  Future<bool> _safePlayerStop(PlayerMutationLease lease) async {
    final result = await _playerMutationBarrier.run<bool>(lease, () async {
      if (!kIsWeb && Platform.isLinux) {
        await _player.pause();
        await _player.seek(Duration.zero);
        return true;
      }
      await _player.stop();
      TrayManager.update();
      return true;
    });
    return result ?? false;
  }

  @override
  Future<void> pause() async {
    final lease = _playerMutationBarrier.acquire();
    _playbackContextGeneration += 1;
    await _pauseWithPlayerMutationLease(lease);
  }

  Future<bool> pauseWithPlayerMutationLease(PlayerMutationLease lease) {
    return _pauseWithPlayerMutationLease(lease);
  }

  Future<bool> _pauseWithPlayerMutationLease(PlayerMutationLease lease) async {
    if (!_playerMutationBarrier.isCurrent(lease)) {
      return false;
    }
    if (_queueTransitionLoading) {
      _queueTransitionLoadingOwner = null;
      _setQueueTransitionLoading(false, emitMediaWhenEmpty: _currentMediaItem == null);
    }
    PlayerUtils.disableWakelock(_ref);
    _resetStreamRecoveryState(clearWindow: true);
    if (isCastControlActive) {
      if (!_playerMutationBarrier.isCurrent(lease)) {
        return false;
      }
      _clearSmartRewindPauseMarker();
      await GoogleCastRemoteMediaClient.instance.pause();
      if (!_playerMutationBarrier.isCurrent(lease)) {
        return false;
      }
      _refreshPlayerControlState();
      await _updatePlaybackState();
      TrayManager.update();
      return true;
    }

    final result = await _playerMutationBarrier.run<bool>(lease, () async {
      await _player.pause();
      return true;
    });
    if (result != true || !_playerMutationBarrier.isCurrent(lease)) {
      return false;
    }
    _recordPausedPlaybackMarker();
    TrayManager.update();
    return true;
  }

  static const bool headphoneSkip =
      true; // Later should determine if the skip button just fasts forward or skips chapters

  Duration _skipDurationForKey(String key) {
    final configuredSeconds = _ref.read(settingsManagerProvider.notifier).getGlobalSetting<int>(key);
    final safeSeconds = configuredSeconds < 1 ? 1 : configuredSeconds;
    return Duration(seconds: safeSeconds);
  }

  bool get _seekWithDesktopSkipControls {
    if (kIsWeb || (!Platform.isLinux && !Platform.isMacOS && !Platform.isWindows)) {
      return false;
    }
    return _ref
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<bool>(SettingKeys.desktopSkipControlsSeek, defaultValue: false);
  }

  @override
  Future<void> fastForward() async {
    if (_currentMediaItem == null) return Future.value();
    final skipTime = _skipDurationForKey(SettingKeys.fastForwardInterval);
    final fromPosition = position;
    final newPosition = fromPosition + skipTime;
    await _seekInternal(newPosition, userNavigation: true);
    unawaited(
      PlayerHistoryHandler.addPlayerHistory(
        PlayerHistoryType.skipForward,
        details: <String, Object?>{'fromPosition': fromPosition.inSeconds, 'toPosition': position.inSeconds},
      ),
    );
  }

  @override
  Future<void> rewind() async {
    if (_currentMediaItem == null) return Future.value();
    final skipTime = _skipDurationForKey(SettingKeys.rewindInterval);
    final fromPosition = position;
    final newPosition = fromPosition - skipTime;
    if (newPosition < Duration.zero) {
      logger('Rewind position is negative, resetting to zero', tag: 'AudioHandler', level: InfoLevel.debug);
      await _seekInternal(Duration.zero, userNavigation: true);
    } else {
      await _seekInternal(newPosition, userNavigation: true);
    }
    unawaited(
      PlayerHistoryHandler.addPlayerHistory(
        PlayerHistoryType.skipBackward,
        details: <String, Object?>{'fromPosition': fromPosition.inSeconds, 'toPosition': position.inSeconds},
      ),
    );
  }

  @override
  Future<void> skipToNext() async {
    if (_currentMediaItem == null) return;
    if (_seekWithDesktopSkipControls) {
      return fastForward();
    }
    return skipToNextInApp();
  }

  Future<void> skipToNextInApp() async {
    if (_currentMediaItem == null) return;
    final skipLease = _playerMutationBarrier.acquire();
    final operationId = _beginUserSeekNavigation(mutationLease: skipLease);
    bool ownsSkip() => _playerMutationBarrier.isCurrent(skipLease) && !_isDisposing;
    var navigationSucceeded = false;
    try {
      await _queueSkipOperation(() async {
        if (!ownsSkip() || _currentMediaItem == null) return;
        InternalChapter? nextChapter = _currentMediaItem!.getNextChapterForDuration(position);
        if (nextChapter != null) {
          final fromPosition = position;
          final newPosition = Duration(microseconds: (nextChapter.start * Duration.microsecondsPerSecond).round());
          logger(
            'Skipping to next chapter: $nextChapter, new position: $newPosition',
            tag: 'AudioHandler',
            level: InfoLevel.debug,
          );
          await _seekInternal(newPosition, mutationLease: skipLease, authoritativeProgressCorrection: true);
          if (!ownsSkip()) {
            return;
          }
          navigationSucceeded = position != fromPosition;
          unawaited(
            PlayerHistoryHandler.addPlayerHistory(
              PlayerHistoryType.skipForward,
              details: <String, Object?>{
                'fromPosition': fromPosition.inSeconds,
                'toPosition': newPosition.inSeconds,
                'chapterTitle': nextChapter.title,
              },
            ),
          );
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
          addToQueue(finishedQueueItem, displayInfo: displayInfo, allowCurrent: true, markAsManual: false);
        }

        if (!ownsSkip()) {
          return;
        }

        if (queueList.isNotEmpty) {
          final beforeMedia = _currentMediaItem;
          final beforePosition = position;
          _forceQueueSwitchOnNextPlay = true;
          _ignoreProgressOnNextPlay = isLoopOn;
          await _playWithPlayerMutationLease(skipLease);
          if (!ownsSkip()) {
            return;
          }
          final afterMedia = _currentMediaItem;
          navigationSucceeded =
              afterMedia != null &&
              (beforeMedia == null ||
                  !_queueItemsMatch(
                    leftItemId: beforeMedia.itemId,
                    leftEpisodeId: beforeMedia.episodeId,
                    rightItemId: afterMedia.itemId,
                    rightEpisodeId: afterMedia.episodeId,
                  ) ||
                  position != beforePosition);
        } else {
          logger(
            'No next chapter and queue is empty, ignoring skip-to-next',
            tag: 'AudioHandler',
            level: InfoLevel.debug,
          );
        }
      });
    } finally {
      _settleUserSeekNavigation(operationId, shouldRetarget: navigationSucceeded);
    }
  }

  @override
  Future<void> skipToPrevious() async {
    if (_currentMediaItem == null) return;
    if (_seekWithDesktopSkipControls) {
      return rewind();
    }
    return skipToPreviousInApp();
  }

  Future<void> skipToPreviousInApp() async {
    if (_currentMediaItem == null) return;
    final skipLease = _playerMutationBarrier.acquire();
    final operationId = _beginUserSeekNavigation(mutationLease: skipLease);
    bool ownsSkip() => _playerMutationBarrier.isCurrent(skipLease) && !_isDisposing;
    var navigationSucceeded = false;
    try {
      await _queueSkipOperation(() async {
        if (!ownsSkip() || _currentMediaItem == null) return;
        InternalChapter? previousChapter = _currentMediaItem!.getPreviousChapterForDuration(position);
        if (previousChapter != null) {
          final fromPosition = position;
          final newPosition = Duration(microseconds: (previousChapter.start * Duration.microsecondsPerSecond).round());
          logger(
            'Skipping to previous chapter: $previousChapter, new position: $newPosition',
            tag: 'AudioHandler',
            level: InfoLevel.debug,
          );
          await _seekInternal(newPosition, mutationLease: skipLease, authoritativeProgressCorrection: true);
          if (!ownsSkip()) {
            return;
          }
          navigationSucceeded = position != fromPosition;
          unawaited(
            PlayerHistoryHandler.addPlayerHistory(
              PlayerHistoryType.skipBackward,
              details: <String, Object?>{
                'fromPosition': fromPosition.inSeconds,
                'toPosition': newPosition.inSeconds,
                'chapterTitle': previousChapter.title,
              },
            ),
          );
        }
      });
    } finally {
      _settleUserSeekNavigation(operationId, shouldRetarget: navigationSucceeded);
    }
  }

  Future<void> _queueSkipOperation(Future<void> Function() operation) {
    _skipOperationQueue = _skipOperationQueue.then((_) => operation()).catchError((Object e, StackTrace s) {
      logger('Skip operation failed: $e\n$s', tag: 'AudioHandler', level: InfoLevel.error);
    });
    return _skipOperationQueue;
  }

  @override
  Future<void> seek(Duration position) {
    return _seekResolved(
      position,
      positionIsAbsolute: false,
      userNavigation: true,
      recordManualSeek: true,
      authoritativeProgressCorrection: true,
    );
  }

  Future<void> _seekResolved(
    Duration requestedPosition, {
    required bool positionIsAbsolute,
    required bool userNavigation,
    required bool recordManualSeek,
    bool authoritativeProgressCorrection = false,
    PlayerMutationLease? mutationLease,
  }) async {
    final media = _currentMediaItem;
    if (media == null) {
      return;
    }

    final fromPosition = position;
    var resolvedPosition = requestedPosition;
    if (_chapterNotificationEnabled && !positionIsAbsolute) {
      resolvedPosition = _chapterNotificationOffset + requestedPosition;
    }

    final maxPosition = media.totalDuration;
    final boundedPosition = resolvedPosition < Duration.zero
        ? Duration.zero
        : (resolvedPosition > maxPosition ? maxPosition : resolvedPosition);
    final shouldRetarget = boundedPosition != fromPosition;
    final operationId = userNavigation ? _beginUserSeekNavigation(mutationLease: mutationLease) : null;
    final lease =
        mutationLease ??
        (userNavigation
            ? _playerMutationBarrier.currentLease ?? _playerMutationBarrier.acquire()
            : _playerMutationBarrier.acquire());
    final seekGeneration = ++_seekGeneration;
    final audioSourceGeneration = _audioSourceGeneration;
    final mediaKey = _mediaKey(media);
    var navigationSucceeded = false;

    try {
      if (recordManualSeek && (boundedPosition - fromPosition).abs() >= const Duration(seconds: 1)) {
        _syncService.markProgressDirty();
      }

      final shouldRecordPausedManualSeek =
          _internalSeekGuardDepth == 0 &&
          !playerControlState.playing &&
          (playerControlState.processingState == ProcessingState.ready ||
              playerControlState.processingState == ProcessingState.completed);
      if (shouldRecordPausedManualSeek) {
        _markPausedManualSeek(boundedPosition);
      }

      if (isCastControlActive) {
        if (!_playerMutationBarrier.isCurrent(lease)) {
          return;
        }
        final relativePosition = _absoluteToCastRelativePosition(boundedPosition);
        await GoogleCastRemoteMediaClient.instance.seek(GoogleCastMediaSeekOption(position: relativePosition));
        navigationSucceeded = true;
        if (!_playerMutationBarrier.isCurrent(lease) || seekGeneration != _seekGeneration) {
          return;
        }
        _refreshPlayerControlState();
        _refreshChapterNotificationState(customPosition: boundedPosition);
        _updateMediaItemForChapterNotification(customPosition: boundedPosition);
        await _updatePlaybackState();
        if (recordManualSeek) {
          _recordManualSeekIfNeeded(fromPosition, boundedPosition);
        }
        return;
      }

      final newTrackIndex = media.getIndexForDuration(boundedPosition);
      if (newTrackIndex < 0) {
        logger(
          'Ignoring seek with invalid track index for position: $boundedPosition',
          tag: 'AudioHandler',
          level: InfoLevel.warning,
        );
        return;
      }
      logger(
        'Seeking to position: $boundedPosition, track index: $newTrackIndex',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
      final relativeTrackPosition = boundedPosition - media.startDurationForTrack(newTrackIndex);
      final trackChanged = newTrackIndex != _currentTrackIndex;

      final seekResult = await _playerMutationBarrier.run<SeekConfirmationResult>(
        lease,
        () => _player.seekConfirmed(relativeTrackPosition, index: newTrackIndex),
      );
      if (seekResult == null) {
        return;
      }

      Duration? confirmedSettledPosition;
      int? confirmedActualIndex;
      if (seekResult.status == SeekConfirmationStatus.reached) {
        final actualPosition = seekResult.actualPosition;
        final actualIndex = seekResult.actualIndex;
        if (actualPosition == null || actualIndex == null || actualIndex < 0 || actualIndex >= media.tracks.length) {
          logger(
            'Confirmed seek returned reached without a valid actual position/index.',
            tag: 'AudioHandler',
            level: InfoLevel.warning,
          );
          return;
        }

        final actualAbsolutePosition = media.startDurationForTrack(actualIndex) + actualPosition;
        confirmedSettledPosition = _clampDuration(actualAbsolutePosition, Duration.zero, media.totalDuration);
        confirmedActualIndex = actualIndex;

        if (seekGeneration == _seekGeneration &&
            audioSourceGeneration == _audioSourceGeneration &&
            identical(_currentMediaItem, media) &&
            !_isDisposing) {
          _currentTrackIndex = actualIndex;
        }
      }

      if (!_isSeekOwnershipCurrent(lease, seekGeneration, mediaKey)) {
        return;
      }

      Duration settledPosition;
      if (seekResult.status == SeekConfirmationStatus.reached) {
        settledPosition = confirmedSettledPosition!;
        _currentTrackIndex = confirmedActualIndex!;
        navigationSucceeded = settledPosition != fromPosition;

        if (authoritativeProgressCorrection && _isSeekOwnershipCurrent(lease, seekGeneration, mediaKey)) {
          unawaited(_syncService.correctAuthoritativePosition(settledPosition));
        }
      } else if (seekResult.status == SeekConfirmationStatus.unsupported) {
        // The compatibility implementation already performed the legacy seek.
        // Preserve existing UX, but do not treat the optimistic Dart position
        // as authoritative for progress synchronization.
        _currentTrackIndex = newTrackIndex;
        navigationSucceeded = true;
        settledPosition = boundedPosition;

        if (trackChanged && !kIsWeb && (Platform.isWindows || Platform.isLinux)) {
          final correctionReady = await _waitForDesktopCorrectiveSeek(
            lease: lease,
            seekGeneration: seekGeneration,
            mediaKey: mediaKey,
            trackIndex: newTrackIndex,
          );
          if (!correctionReady) {
            return;
          }
          await _playerMutationBarrier.run<void>(
            lease,
            () => _player.seek(relativeTrackPosition, index: newTrackIndex),
          );
          if (!_isSeekOwnershipCurrent(lease, seekGeneration, mediaKey)) {
            return;
          }
        }
      } else {
        final level = seekResult.status == SeekConfirmationStatus.superseded ? InfoLevel.debug : InfoLevel.warning;
        logger(
          'Seek was not authoritatively reached: ${seekResult.status}${seekResult.errorMessage == null ? '' : ' (${seekResult.errorMessage})'}',
          tag: 'AudioHandler',
          level: level,
        );
        return;
      }

      if (!_isSeekOwnershipCurrent(lease, seekGeneration, mediaKey)) {
        return;
      }
      _refreshChapterNotificationState(customPosition: settledPosition);
      _updateMediaItemForChapterNotification(customPosition: settledPosition);
      unawaited(_updatePlaybackState());
      if (recordManualSeek) {
        _recordManualSeekIfNeeded(fromPosition, settledPosition);
      }
    } finally {
      if (operationId != null) {
        _settleUserSeekNavigation(operationId, shouldRetarget: navigationSucceeded && shouldRetarget);
      }
    }
  }

  bool _isSeekOwnershipCurrent(PlayerMutationLease lease, int seekGeneration, String mediaKey) {
    final media = _currentMediaItem;
    return _playerMutationBarrier.isCurrent(lease) &&
        seekGeneration == _seekGeneration &&
        media != null &&
        _mediaKey(media) == mediaKey &&
        !_isDisposing;
  }

  Future<bool> _waitForDesktopCorrectiveSeek({
    required PlayerMutationLease lease,
    required int seekGeneration,
    required String mediaKey,
    required int trackIndex,
  }) async {
    if (!_isSeekOwnershipCurrent(lease, seekGeneration, mediaKey)) {
      return false;
    }

    final currentState = _player.playerState;
    if (currentState.processingState == ProcessingState.ready) {
      return _currentTrackIndex == trackIndex;
    }
    if (currentState.processingState == ProcessingState.completed ||
        currentState.processingState == ProcessingState.idle) {
      return false;
    }

    final outcome = await Rx.merge<bool>([
      _player.playerStateStream
          .where(
            (state) =>
                state.processingState == ProcessingState.ready ||
                state.processingState == ProcessingState.completed ||
                state.processingState == ProcessingState.idle,
          )
          .map((state) => state.processingState == ProcessingState.ready)
          .take(1),
      _player.errorStream.map((_) => false).take(1),
      mediaItemStream.where((media) => media == null || _mediaKey(media) != mediaKey).map((_) => false).take(1),
      lease.invalidated.asStream().map((_) => false).take(1),
    ]).first;

    return outcome && _isSeekOwnershipCurrent(lease, seekGeneration, mediaKey) && _currentTrackIndex == trackIndex;
  }

  void _recordManualSeekIfNeeded(Duration fromPosition, Duration toPosition) {
    if ((toPosition - fromPosition).abs() < const Duration(seconds: 1)) {
      return;
    }

    unawaited(
      PlayerHistoryHandler.addPlayerHistory(
        PlayerHistoryType.seek,
        position: toPosition,
        details: <String, Object?>{'fromPosition': fromPosition.inSeconds, 'toPosition': toPosition.inSeconds},
      ),
    );
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

    late final MediaItem nextMediaItem;
    if (_chapterNotificationEnabled) {
      final searchPos = customPosition ?? position;
      final chapter = currentItem.getChapterForDuration(searchPos);
      nextMediaItem = MediaItem(
        id: currentItem.id,
        album: currentItem.toMediaItem().album,
        title: chapter?.title ?? currentItem.title,
        displayTitle: chapter?.title ?? currentItem.title,
        artist: currentItem.author,
        displaySubtitle: currentItem.subtitle,
        duration: _chapterNotificationDuration,
        isLive: false,
        artUri: notificationArtworkUri(currentItem.cover),
      );
    } else {
      nextMediaItem = currentItem.toMediaItem();
    }

    final publishedMediaItem = mediaItem.valueOrNull;
    if (_hasSameNotificationMetadata(publishedMediaItem, nextMediaItem)) {
      return;
    }
    mediaItem.add(nextMediaItem);
  }

  bool _hasSameNotificationMetadata(MediaItem? current, MediaItem next) {
    return current != null &&
        current.id == next.id &&
        current.album == next.album &&
        current.title == next.title &&
        current.displayTitle == next.displayTitle &&
        current.artist == next.artist &&
        current.displaySubtitle == next.displaySubtitle &&
        current.duration == next.duration &&
        current.isLive == next.isLive &&
        current.artUri == next.artUri;
  }

  int _beginUserSeekNavigation({PlayerMutationLease? mutationLease}) {
    _playbackContextGeneration += 1;
    _seekGeneration += 1;
    if (mutationLease == null) {
      _playerMutationBarrier.acquire();
    } else if (!_playerMutationBarrier.isCurrent(mutationLease)) {
      throw StateError('Cannot begin user navigation with a stale player mutation lease');
    }
    final operationId = ++_userSeekNavigationSequence;
    if (!_userSeekNavigationLedger.begin(operationId)) {
      throw StateError('Duplicate user navigation operation id: $operationId');
    }
    if (!_userSeekNavigationController.isClosed) {
      _userSeekNavigationController.add(
        UserSeekNavigationEvent(operationId: operationId, phase: UserSeekNavigationPhase.began),
      );
    }
    return operationId;
  }

  void _settleUserSeekNavigation(int operationId, {required bool shouldRetarget}) {
    if (!_userSeekNavigationLedger.settle(operationId)) {
      return;
    }
    if (!_userSeekNavigationController.isClosed) {
      _userSeekNavigationController.add(
        UserSeekNavigationEvent(
          operationId: operationId,
          phase: UserSeekNavigationPhase.settled,
          shouldRetarget: shouldRetarget,
        ),
      );
    }
  }

  Future<void> _seekInternal(
    Duration position, {
    bool userNavigation = false,
    bool authoritativeProgressCorrection = false,
    PlayerMutationLease? mutationLease,
  }) {
    return _seekResolved(
      position,
      positionIsAbsolute: true,
      userNavigation: userNavigation,
      recordManualSeek: false,
      authoritativeProgressCorrection: authoritativeProgressCorrection || userNavigation,
      mutationLease: mutationLease,
    );
  }

  Future<void> seekAbsolute(Duration position) => _seekInternal(position, userNavigation: true);

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
          if (_isDisposing) {
            return;
          }

          if (activeUserId == null || activeUserId.isEmpty) {
            _observedActiveUserId = null;
            unawaited(_androidAutoHandleSignedOutIfAutomotive());
            return;
          }

          final isInitialUser = !_hasObservedActiveUserId;
          _hasObservedActiveUserId = true;
          _observedActiveUserId = activeUserId;

          unawaited(_handleActiveUserIdEmission(activeUserId, stopPlayback: !isInitialUser));
        });

    _androidAutoApiSubscription = _ref.listen<ABSApi?>(absApiProvider, (previous, next) {
      if (_isDisposing || identical(previous, next)) {
        return;
      }

      _androidAutoInvalidateBrowseState(this);
    });

    _androidAutoServerReachabilitySubscription = _ref.listen<bool>(serverReachabilityProvider, (previous, next) {
      if (_isDisposing || previous == next || !next) {
        return;
      }

      unawaited(_androidAutoHandleServerReachabilityChanged(this));
    });

    _androidAutoMediaProgressSubscription = _ref.listen<AsyncValue<Map<String, MediaProgress>>>(mediaProgressProvider, (
      previous,
      next,
    ) {
      if (_isDisposing || !_androidAutoProgressMeaningfullyChanged(previous, next)) {
        return;
      }

      _androidAutoScheduleContinueRefresh(this);
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

    _desktopSkipControlsSeekSubscription = _ref
        .read(appDatabaseProvider)
        .watchGlobalSetting(SettingKeys.desktopSkipControlsSeek)
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
      _equalizer = AndroidEqualizer();
      final pipeline = AudioPipeline(androidAudioEffects: [_loudnessEnhancer!, _equalizer!]);
      _player = AudioPlayer(
        audioPipeline: pipeline,
        audioLoadConfiguration: loadCfg,
        useProxyForRequestHeaders: !disableHeaderProxy,
      );
    } else {
      _player = AudioPlayer(audioLoadConfiguration: loadCfg, useProxyForRequestHeaders: !disableHeaderProxy);
    }
    _playerControlStateSubject = BehaviorSubject<PlayerState>.seeded(_player.playerState);
    _volumeSubject = BehaviorSubject<double>.seeded(_readLastVolumeSetting());

    if (!kIsWeb && Platform.isAndroid) {
      _volumeBoostAvailabilitySubscription = _loudnessEnhancer!.statusStream.listen((status) {
        if (_isDisposing) return;
        final available = status.availability != AudioEffectAvailability.unavailable;
        _volumeBoostAvailableSubject.add(available);
        if (!available && _volumeSubject.value > 1.0) {
          unawaited(_setVolumeInternal(1.0));
        }
      });
    }

    _errorSubscription = _player.errorStream.listen((error) {
      logger('AudioPlayer error: $error', tag: 'AudioHandler', level: InfoLevel.error);
      final sourceLoadError = _sourceLoadErrorCompleter;
      if (sourceLoadError != null && !sourceLoadError.isCompleted) {
        sourceLoadError.complete(error);
      } else {
        unawaited(_handlePlaybackFailure(error));
      }
    });

    _syncService = PlaybackSyncService(_ref, playerStateStream: playerControlStateStream, position: () => position);
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
        final completionContextGeneration = _playbackContextGeneration;
        final navigationWasActive = hasActiveUserSeekNavigation;
        final completionGateClaim = _claimSleepTimerCompletionGate(finishedMedia);
        final suppressAutoAdvanceForSleepTimer = completionGateClaim != null;
        final terminalPosition = finishedMedia.totalDuration;
        logger(
          'Current track index: $_currentTrackIndex, total tracks: ${finishedMedia.tracks.length}',
          tag: 'AudioHandler',
          level: InfoLevel.debug,
        );
        await _syncService.flush(positionOverride: terminalPosition);
        unawaited(
          _ref
              .read(smartDownloadManagerProvider.notifier)
              .deleteFinishedContinueDownload(itemId: finishedMedia.itemId, episodeId: finishedMedia.episodeId),
        );
        _ref.read(smartDownloadManagerProvider.notifier).requestReconcile(reason: 'playback completed');
        unawaited(
          refreshPersonalizedShelfForCompletedItem(
            container: _ref,
            itemId: finishedMedia.itemId,
            preferredLibraryId: finishedMedia.libraryId,
            sourceTag: 'AudioHandler',
            reason: 'playback completed',
          ),
        );

        final currentMedia = _currentMediaItem;
        final completionStillOwnsPlayback =
            !navigationWasActive &&
            !hasActiveUserSeekNavigation &&
            completionContextGeneration == _playbackContextGeneration &&
            currentMedia != null &&
            _queueItemsMatch(
              leftItemId: finishedMedia.itemId,
              leftEpisodeId: finishedMedia.episodeId,
              rightItemId: currentMedia.itemId,
              rightEpisodeId: currentMedia.episodeId,
            );

        if (!completionStillOwnsPlayback) {
          if (suppressAutoAdvanceForSleepTimer) {
            logger(
              'Sleep timer completion suppression remains claimed, but playback action ownership became stale.',
              tag: 'AudioHandler',
              level: InfoLevel.debug,
            );
          }
        } else if (suppressAutoAdvanceForSleepTimer) {
          logger(
            'Suppressing queue auto-advance because the sleep timer targets media completion',
            tag: 'AudioHandler',
            level: InfoLevel.info,
          );
        } else {
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
            addToQueue(finishedQueueItem, displayInfo: displayInfo, allowCurrent: true, markAsManual: false);
          }

          if (queueList.isNotEmpty) {
            _forceQueueSwitchOnNextPlay = true;
            _ignoreProgressOnNextPlay = isLoopOn;
            await play();
          } else {
            await pause();
          }
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

      _equalizerEnabledSubscription = _ref
          .read(appDatabaseProvider)
          .watchGlobalSetting(SettingKeys.equalizerEnabled)
          .map((setting) => setting?.value.trim())
          .distinct()
          .listen((value) {
            if (_isDisposing) return;
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
        try {
          final loudnessEnhancer = _loudnessEnhancer;
          if (loudnessEnhancer != null) {
            await loudnessEnhancer.refreshStatus();
          }
          final equalizer = _equalizer;
          if (equalizer == null) return;
          final effectStatus = await equalizer.refreshStatus();
          if (!effectStatus.isAvailable) return;
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

      Future<void> sendAutoResumeSettingsToNative() async {
        if (_isDisposing) return;
        try {
          final settings = _ref.read(settingsManagerProvider.notifier);
          final bluetooth = settings.getGlobalSetting<bool>(
            SettingKeys.autoResumeOnBluetoothConnection,
            defaultValue: false,
          );
          final restrictToSelectedDevices = settings.getGlobalSetting<bool>(
            SettingKeys.restrictAutoResumeToSelectedBluetoothDevices,
            defaultValue: false,
          );
          final selectedDeviceAddresses = decodeBluetoothDeviceAddresses(
            settings.getGlobalSetting<String>(SettingKeys.autoResumeBluetoothDeviceAddresses, defaultValue: '[]'),
          ).toList()..sort();

          await autoResumeMethodChannel.invokeMethod<void>('updateAutoResumeSettings', {
            'bluetooth': bluetooth,
            'restrictToSelectedDevices': restrictToSelectedDevices,
            'selectedDeviceAddresses': selectedDeviceAddresses,
          });
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
      _autoResumeBluetoothRestrictionSubscription = _ref
          .read(appDatabaseProvider)
          .watchGlobalSetting(SettingKeys.restrictAutoResumeToSelectedBluetoothDevices)
          .map((setting) => setting?.value.trim())
          .distinct()
          .listen((_) {
            sendAutoResumeSettingsToNative();
          });
      _autoResumeBluetoothDeviceAddressesSubscription = _ref
          .read(appDatabaseProvider)
          .watchGlobalSetting(SettingKeys.autoResumeBluetoothDeviceAddresses)
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

    final currentMedia = _currentMediaItem;
    final sleepTimerSuppressesCompletedAutoAdvance =
        currentMedia != null &&
        _player.processingState == ProcessingState.completed &&
        _claimSleepTimerCompletionGate(currentMedia) != null;
    final isTransitionLoading =
        _queueTransitionLoading ||
        (!sleepTimerSuppressesCompletedAutoAdvance &&
            _player.processingState == ProcessingState.completed &&
            queueList.isNotEmpty);
    final hasPlaybackContext =
        _currentMediaItem != null || queueList.isNotEmpty || _queueTransitionLoading || _restoredMediaItem != null;
    final castActive = isCastControlActive;
    final controlState = castActive ? playerControlState : _player.playerState;
    final effectivePlaying = playbackStatePlayingForSleepTimerCompletion(
      playerPlaying: controlState.playing,
      suppressCompletedAutoAdvance: sleepTimerSuppressesCompletedAutoAdvance,
    );
    final playPauseControl = effectivePlaying ? MediaControl.pause : MediaControl.play;
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

      final useSkip = _seekWithDesktopSkipControls || (showSkipInsteadOfFastForward && hasChaptersOrQueue);
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
        controls: controls,
        systemActions: finalSystemActions,
        androidCompactActionIndices: compactActionIndices,
        processingState: !hasPlaybackContext
            ? AudioProcessingState.idle
            : isTransitionLoading
            ? AudioProcessingState.loading
            : (_currentMediaItem == null && _restoredMediaItem != null)
            ? AudioProcessingState.ready
            : _toAudioProcessingState(controlState.processingState),
        playing: hasPlaybackContext && (isTransitionLoading ? true : effectivePlaying),
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
    _playbackContextGeneration += 1;
    _seekGeneration += 1;
    _playerMutationBarrier.acquire();
    _androidAutoApiSubscription.close();
    _androidAutoServerReachabilitySubscription.close();
    _androidAutoMediaProgressSubscription.close();
    await _activeUserIdSubscription.cancel();
    await _showLastPlayedMiniPlayerSettingSubscription.cancel();
    await _mediaNotificationTypeSubscription.cancel();
    await _mediaNotificationPagesSubscription.cancel();
    await _showSkipInsteadOfFastForwardSubscription.cancel();
    await _desktopSkipControlsSeekSubscription.cancel();
    await _chapterSubscription?.cancel();
    await _skipSilenceSubscription?.cancel();
    _skipSilenceSubscription = null;
    await _volumeBoostAvailabilitySubscription?.cancel();
    _volumeBoostAvailabilitySubscription = null;
    await _equalizerEnabledSubscription?.cancel();
    _equalizerEnabledSubscription = null;
    await _equalizerBandGainsSubscription?.cancel();
    _equalizerBandGainsSubscription = null;
    await _equalizerSessionSubscription?.cancel();
    _equalizerSessionSubscription = null;
    await _autoResumeOnBluetoothSubscription?.cancel();
    _autoResumeOnBluetoothSubscription = null;
    await _autoResumeBluetoothRestrictionSubscription?.cancel();
    _autoResumeBluetoothRestrictionSubscription = null;
    await _autoResumeBluetoothDeviceAddressesSubscription?.cancel();
    _autoResumeBluetoothDeviceAddressesSubscription = null;
    _resetStreamRecoveryState(clearWindow: true);
    _androidAutoMoreMenuTimer?.cancel();
    _androidAutoMoreMenuTimer = null;
    _androidAutoContinueRefreshDebounce?.cancel();
    _androidAutoContinueRefreshDebounce = null;
    _queueIntentPersistenceTimer?.cancel();
    _queueIntentPersistenceTimer = null;
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
    await _volumeBoostAvailableSubject.close();
    await _castControlActiveSubject.close();
    await _queueLengthSubject.close();
    await _queueSnapshotSubject.close();
    await _queueTransitionLoadingSubject.close();
    await _showPlayerSubject.close();
    await _lastPlayedMiniPlayerSnapshotSubject.close();
    await _userSeekNavigationController.close();
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
