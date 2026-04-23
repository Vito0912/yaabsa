// ignore_for_file: unused_element_parameter

import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/api/library/request/library_items_request.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/player/session_provider.dart';
import 'package:yaabsa/util/handler/playback_sync_service.dart';
import 'package:yaabsa/util/handler/player_history_handler.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/player_utils.dart' show PlayerUtils;
import 'package:yaabsa/util/setting_key.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:rxdart/rxdart.dart';

part 'bg_audio_handler_auto_queue.dart';

const int _autoQueuePageSize = 20;

class QueueDisplayInfo {
  const QueueDisplayInfo({this.title, this.subtitle, this.author});

  final String? title;
  final String? subtitle;
  final String? author;

  static const empty = QueueDisplayInfo();
}

class PlayerQueueEntry {
  const PlayerQueueEntry({
    required this.id,
    required this.item,
    this.displayInfo = QueueDisplayInfo.empty,
    this.autoQueued = false,
    this.autoQueuePage,
  });

  final String id;
  final QueueItem item;
  final QueueDisplayInfo displayInfo;
  final bool autoQueued;
  final int? autoQueuePage;
}

class PlayerQueueSnapshot {
  const PlayerQueueSnapshot({
    this.entries = const <PlayerQueueEntry>[],
    this.autoQueueEnabled = false,
    this.autoQueueActive = false,
    this.autoQueueLoading = false,
    this.autoQueueRemaining = 0,
    this.canLoadMoreAutoQueue = false,
  });

  final List<PlayerQueueEntry> entries;
  final bool autoQueueEnabled;
  final bool autoQueueActive;
  final bool autoQueueLoading;
  final int autoQueueRemaining;
  final bool canLoadMoreAutoQueue;
}

enum _AutoQueueSourceType { series, playlist, collection }

class _AutoQueueRequestContext {
  _AutoQueueRequestContext._({
    required this.sourceType,
    required this.libraryId,
    required this.initialPage,
    this.sort,
    this.desc,
    this.filter,
    this.collapseseries,
    this.include,
    this.seriesId,
    this.playlistId,
    this.collectionId,
  });

  factory _AutoQueueRequestContext.series({
    required String libraryId,
    required String seriesId,
    required int initialPage,
  }) {
    return _AutoQueueRequestContext._(
      sourceType: _AutoQueueSourceType.series,
      libraryId: libraryId,
      initialPage: initialPage,
      filter: LibraryFilter.grouped(LibraryFilterGroup.series, seriesId).queryValue,
      collapseseries: 0,
      seriesId: seriesId,
    );
  }

  factory _AutoQueueRequestContext.playlist({
    required String libraryId,
    required String playlistId,
    required int initialPage,
  }) {
    return _AutoQueueRequestContext._(
      sourceType: _AutoQueueSourceType.playlist,
      libraryId: libraryId,
      initialPage: initialPage,
      playlistId: playlistId,
    );
  }

  factory _AutoQueueRequestContext.collection({
    required String libraryId,
    required String collectionId,
    required int initialPage,
  }) {
    return _AutoQueueRequestContext._(
      sourceType: _AutoQueueSourceType.collection,
      libraryId: libraryId,
      initialPage: initialPage,
      collectionId: collectionId,
    );
  }

  final _AutoQueueSourceType sourceType;
  final String libraryId;
  final int initialPage;
  final int pageSize = _autoQueuePageSize;
  final String? sort;
  final int? desc;
  final String? filter;
  final int? collapseseries;
  final String? include;
  final String? seriesId;
  final String? playlistId;
  final String? collectionId;

  List<LibraryItem>? cachedItems;
}

class _AutoQueuePageResult {
  const _AutoQueuePageResult({required this.items, required this.total, required this.page, required this.pageSize});

  final List<LibraryItem> items;
  final int total;
  final int page;
  final int pageSize;
}

class _AutoQueueState {
  _AutoQueueState({
    required this.context,
    required this.currentItemId,
    required this.currentItemAbsoluteIndex,
    required this.totalItems,
    required this.pageSize,
    required this.highestLoadedPage,
  });

  final _AutoQueueRequestContext context;
  final String currentItemId;
  final int currentItemAbsoluteIndex;
  final int totalItems;
  final int pageSize;

  int highestLoadedPage;
  bool isLoading = false;
  final Map<int, String> firstItemIdByPage = <int, String>{};
  final Set<int> triggeredPages = <int>{};
}

class BGAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  late final AudioPlayer _player;
  final ProviderContainer _ref;
  late final PlaybackSyncService _syncService;
  StreamSubscription<PlayerException>? _errorSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  bool _isDisposing = false;
  List<PlayerQueueEntry> queueList = [];
  QueueItem? _lastQueueItem;
  Future<void> _skipOperationQueue = Future.value();
  int _queueEntryCounter = 0;
  int _autoQueueGeneration = 0;
  _AutoQueueState? _autoQueueState;
  final BehaviorSubject<int> _queueLengthSubject = BehaviorSubject<int>.seeded(0);
  final BehaviorSubject<PlayerQueueSnapshot> _queueSnapshotSubject = BehaviorSubject<PlayerQueueSnapshot>.seeded(
    const PlayerQueueSnapshot(),
  );
  final Map<String, Future<LibraryItem?>> _queueItemDetailsCache = <String, Future<LibraryItem?>>{};
  BehaviorSubject<InternalMedia?> mediaItemStream = BehaviorSubject<InternalMedia?>();
  InternalMedia? get currentMediaItem => _currentMediaItem;

  Stream<PlayerQueueSnapshot> get queueSnapshotStream => _queueSnapshotSubject.stream;
  PlayerQueueSnapshot get queueSnapshot => _buildQueueSnapshot();

  static double get maxVolume {
    if (Platform.isAndroid) {
      return 2.0;
    }
    return 1.0;
  }

  bool isInQueue(String itemId) {
    return queueList.any((entry) => entry.item.itemId == itemId);
  }

  void setQueue(QueueItem item, {QueueDisplayInfo displayInfo = QueueDisplayInfo.empty}) {
    _clearAutoQueueState();
    queueList = [];
    _enqueueItem(item, displayInfo: displayInfo);
    _emitQueueState();
  }

  void setQueueFromLibraryItem(LibraryItem item) {
    setQueue(QueueItem(itemId: item.id), displayInfo: _displayInfoFromLibraryItem(item));
  }

  void addToQueue(QueueItem item, {QueueDisplayInfo displayInfo = QueueDisplayInfo.empty}) {
    _enqueueItem(item, displayInfo: displayInfo);
    _emitQueueState();
  }

  void addLibraryItemToQueue(LibraryItem item) {
    addToQueue(QueueItem(itemId: item.id), displayInfo: _displayInfoFromLibraryItem(item));
  }

  void removeFromQueueByItemId(String itemId) {
    final nextQueue = queueList.where((entry) => entry.item.itemId != itemId).toList();
    if (nextQueue.length == queueList.length) {
      return;
    }

    queueList = nextQueue;
    _emitQueueState();
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
    if (_currentMediaItem?.itemId == item.itemId) {
      return false;
    }

    if (isInQueue(item.itemId)) {
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
    mediaItemStream.add(mediaItem);
    _handleAutoQueueOnCurrentItemChange(mediaItem?.itemId);
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

  Stream<Duration> get durationStream {
    return _player.durationStream.map((duration) {
      return _currentMediaItem?.totalDuration ?? duration ?? Duration.zero;
    }).distinct();
  }

  Duration get duration {
    return _currentMediaItem?.totalDuration ?? Duration.zero;
  }

  Stream<Duration> get positionStream {
    return _player.positionStream
        .throttleTime(const Duration(milliseconds: 200))
        .map((position) => (_currentMediaItem?.offsetForTrack(_currentTrackIndex) ?? Duration.zero) + position)
        .distinct();
  }

  Stream<Duration> get bufferedPositionStream {
    return _player.bufferedPositionStream
        .throttleTime(const Duration(seconds: 1))
        .map((position) => (_currentMediaItem?.offsetForTrack(_currentTrackIndex) ?? Duration.zero) + position)
        .distinct();
  }

  Stream<InternalChapter?> get chapterStream {
    return _player.positionStream
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
    final pos = _player.position;
    return (_currentMediaItem?.offsetForTrack(_currentTrackIndex) ?? Duration.zero) + pos;
  }

  Stream<bool> get shouldShowPlayer {
    return _player.playerStateStream.map((state) => _currentMediaItem != null).distinct();
  }

  Future<void> playLibraryItem(LibraryItem item) {
    return _playLibraryItemWithContext(item);
  }

  Future<void> playLibraryItemFromSeriesView(
    LibraryItem item, {
    required String libraryId,
    required String seriesId,
    required int itemIndex,
  }) {
    final context = _AutoQueueRequestContext.series(
      libraryId: libraryId,
      seriesId: seriesId,
      initialPage: itemIndex ~/ _autoQueuePageSize,
    );

    return _playLibraryItemWithContext(item, autoQueueContext: context);
  }

  Future<void> playLibraryItemFromPlaylistView(
    LibraryItem item, {
    required String libraryId,
    required String playlistId,
    required int itemIndex,
  }) {
    final context = _AutoQueueRequestContext.playlist(
      libraryId: libraryId,
      playlistId: playlistId,
      initialPage: itemIndex ~/ _autoQueuePageSize,
    );

    return _playLibraryItemWithContext(item, autoQueueContext: context);
  }

  Future<void> playLibraryItemFromCollectionView(
    LibraryItem item, {
    required String libraryId,
    required String collectionId,
    required int itemIndex,
  }) {
    final context = _AutoQueueRequestContext.collection(
      libraryId: libraryId,
      collectionId: collectionId,
      initialPage: itemIndex ~/ _autoQueuePageSize,
    );

    return _playLibraryItemWithContext(item, autoQueueContext: context);
  }

  Future<void> _playLibraryItemWithContext(LibraryItem item, {_AutoQueueRequestContext? autoQueueContext}) async {
    setQueueFromLibraryItem(item);
    await play();

    if (!_isAutoQueueEnabled) {
      return;
    }

    if (_currentMediaItem?.itemId != item.id) {
      return;
    }

    if (autoQueueContext != null) {
      unawaited(_startAutoQueue(autoQueueContext, item.id));
      return;
    }

    if (!_isSeriesFallbackAutoQueueEnabled) {
      return;
    }

    final fallbackContext = await _buildSeriesFallbackAutoQueueContext(item);
    if (fallbackContext != null) {
      unawaited(_startAutoQueue(fallbackContext, item.id));
    }
  }

  @override
  Future<void> play() async {
    PlayerUtils.enableWakelock(_ref);

    final shouldSwitchToQueuedItem =
        _currentMediaItem != null && queueList.isNotEmpty && queueList.first.item.itemId != _currentMediaItem!.itemId;

    if (shouldSwitchToQueuedItem) {
      await stop(clearQueue: false);
    }

    if (_currentMediaItem != null) {
      await _syncedPlay();
      return Future.value();
    }

    PlayerQueueEntry? nextEntry = queueList.isNotEmpty ? queueList.removeAt(0) : null;
    if (nextEntry != null) {
      _emitQueueState();
    }

    QueueItem? nextItem = nextEntry?.item;

    if (nextItem == null && _lastQueueItem != null) {
      // e.g. Android still shows the notification and allows pressing play. This will re-use the last item.
      nextItem = _lastQueueItem;
    }
    if (nextItem == null) return Future.value();
    _lastQueueItem = nextItem;
    _currentMediaItem = await _ref.read(sessionRepositoryProvider).openSession(nextItem.itemId);
    if (_currentMediaItem == null) {
      logger('No media item found for ID: ${nextItem.itemId}', tag: 'AudioHandler', level: InfoLevel.error);
      return Future.value();
    }
    logger('Playing item: ${_currentMediaItem!.itemId}', tag: 'AudioHandler', level: InfoLevel.debug);
    await _setSource();
    logger('Setting source for item: ${_currentMediaItem!.itemId}', tag: 'AudioHandler', level: InfoLevel.debug);
    await _syncedPlay(restoreProgress: true);
  }

  Future<void> playItemFromPosition({required String itemId, required Duration position}) async {
    PlayerUtils.enableWakelock(_ref);

    final isCurrentItem = _currentMediaItem?.itemId == itemId;
    if (!isCurrentItem) {
      await stop(clearQueue: true);
      _lastQueueItem = QueueItem(itemId: itemId);
      _currentMediaItem = await _ref.read(sessionRepositoryProvider).openSession(itemId);
      if (_currentMediaItem == null) {
        logger('No media item found for ID: $itemId', tag: 'AudioHandler', level: InfoLevel.error);
        return Future.value();
      }
      await _setSource(ignoreSavedProgress: true);
    }

    await seek(position);
    await _player.play();
  }

  Future<void> _syncedPlay({bool restoreProgress = false}) async {
    mediaItem.add(_currentMediaItem?.toMediaItem());

    if (_currentMediaItem == null) return Future.value();

    if (!restoreProgress) {
      await _player.play();
      return Future.value();
    }

    Duration currentPosition = Duration.zero;

    final progress = await _ref
        .read(mediaProgressProvider.notifier)
        .fetchOrRefreshIndividualProgress(_currentMediaItem!.itemId);

    currentPosition = Duration(microseconds: ((progress?.currentTime ?? 0) * Duration.microsecondsPerSecond).round());

    logger(
      'Current position: $currentPosition, player position: ${_player.position}, progress: ${progress?.currentTime}',
      tag: 'AudioHandler',
      level: InfoLevel.debug,
    );

    if (currentPosition > Duration.zero) {
      await seek(currentPosition);
    }

    logger('Wakelock enabled', tag: 'AudioHandler', level: InfoLevel.debug);
    await _player.play();
  }

  @override
  Future<void> stop({bool clearQueue = true}) async {
    _currentMediaItem = null;
    _currentTrackIndex = 0;
    PlayerUtils.disableWakelock(_ref);
    if (clearQueue) {
      _clearAutoQueueState();
      queueList.clear();
      _emitQueueState();
    }
    try {
      await _syncService.flush();
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
  }

  @override
  Future<void> pause() async {
    PlayerUtils.disableWakelock(_ref);
    await _player.pause();
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
        await stop(clearQueue: false);
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
    if (newTrackIndex != _currentTrackIndex) {
      _currentTrackIndex = newTrackIndex;
      await _player.seek(
        boundedPosition - _currentMediaItem!.startDurationForTrack(_currentTrackIndex),
        index: _currentTrackIndex,
      );
      if (Platform.isWindows) {
        // Bugfix for Windows as it doesn't seek correctly if the index changed
        _player.playerStateStream.firstWhere((state) => state.processingState == ProcessingState.ready).then((_) async {
          await _player.seek(boundedPosition - _currentMediaItem!.startDurationForTrack(_currentTrackIndex));
        });
      }
    } else {
      await _player.seek(boundedPosition - _currentMediaItem!.startDurationForTrack(_currentTrackIndex));
    }
    return Future.value();
  }

  BGAudioHandler(this._ref) {
    final settingManager = _ref.read(settingsManagerProvider.notifier);
    final bufferSize = settingManager.getGlobalSetting<int>(SettingKeys.bufferSize);

    logger('Buffer size: $bufferSize', tag: 'AudioHandler', level: InfoLevel.debug);

    final AndroidLoadControl androidLoadControl = AndroidLoadControl(
      minBufferDuration: Duration(seconds: 50),
      maxBufferDuration: Duration(seconds: 300),
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

    _player = AudioPlayer(audioLoadConfiguration: loadCfg);

    _errorSubscription = _player.errorStream.listen((error) {
      logger('AudioPlayer error: $error', tag: 'AudioHandler', level: InfoLevel.error);
      if (error.toString().contains('ffurl_read')) {
        logger('Trying to reconnect to stream', tag: 'AudioHandler', level: InfoLevel.warning);
        _syncedPlay();
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
        PlayerHistoryHandler.addPlayerHistory(PlayerHistoryType.play);
      }

      if (state.processingState == ProcessingState.completed) {
        if (_currentMediaItem == null) return;
        logger(
          'Current track index: $_currentTrackIndex, total tracks: ${_currentMediaItem!.tracks.length}',
          tag: 'AudioHandler',
          level: InfoLevel.debug,
        );
        await _syncService.flush();
        await _ref.read(sessionRepositoryProvider).closeSession();

        if (queueList.isNotEmpty) {
          await play();
        } else {
          await _safePlayerStop();
        }
      }
      _updatePlaybackState();
    });

    _emitQueueState();
  }

  Future<dynamic> _setSource({Duration initialPosition = Duration.zero, bool ignoreSavedProgress = false}) async {
    if (_currentMediaItem == null) return Future.value();
    final source = _currentMediaItem!.toAudioSources();
    if (!ignoreSavedProgress) {
      final currentProgress = _ref.read(
        mediaProgressProvider.select((asyncValue) {
          return asyncValue.value?[_currentMediaItem!.itemId];
        }),
      );

      if (currentProgress != null) {
        initialPosition = Duration(
          microseconds: ((currentProgress.currentTime) * Duration.microsecondsPerSecond).round(),
        );
      }
    }

    logger('Setting source with initial position: $initialPosition', tag: 'AudioHandler', level: InfoLevel.debug);

    final trackIndex = _currentMediaItem!.getIndexForDuration(initialPosition);

    await player.setAudioSources(source, initialIndex: trackIndex, initialPosition: Duration.zero, preload: true);
  }

  Future<void> _updatePlaybackState() async {
    final lockMediaNotification = _ref
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<bool>(SettingKeys.lockMediaNotification);
    playbackState.add(
      PlaybackState(
        // Which buttons should appear in the notification now
        controls: [MediaControl.rewind, MediaControl.pause, MediaControl.stop, MediaControl.fastForward],
        // Which other actions should be enabled in the notification
        systemActions: lockMediaNotification
            ? const {MediaAction.seekForward, MediaAction.seekBackward}
            : const {MediaAction.seek, MediaAction.seekForward, MediaAction.seekBackward},
        // Which controls to show in Android's compact view.
        androidCompactActionIndices: const [0, 1, 3],
        // Whether audio is ready, buffering, ...
        processingState: (_player.processingState == ProcessingState.completed && queueList.isNotEmpty)
            ? AudioProcessingState.loading
            : {
                ProcessingState.idle: AudioProcessingState.idle,
                ProcessingState.loading: AudioProcessingState.loading,
                ProcessingState.buffering: AudioProcessingState.buffering,
                ProcessingState.ready: AudioProcessingState.ready,
                ProcessingState.completed: AudioProcessingState.completed,
              }[_player.processingState]!,
        playing: (_player.processingState == ProcessingState.completed && queueList.isNotEmpty)
            ? true
            : _player.playerState.playing,
        // The current position as of this update. You should not broadcast
        // position changes continuously because listeners will be able to
        // project the current position after any elapsed time based on the
        // current speed and whether audio is playing and ready. Instead, only
        // broadcast position updates when they are different from expected (e.g.
        // buffering, or seeking).
        updatePosition: _player.position,
        speed: _player.speed,
      ),
    );
  }

  Future<void> dispose() async {
    _isDisposing = true;
    _clearAutoQueueState();
    await _errorSubscription?.cancel();
    _errorSubscription = null;
    await _playerStateSubscription?.cancel();
    _playerStateSubscription = null;
    await _syncService.dispose();
    await _player.dispose();
    await mediaItemStream.close();
    await _queueLengthSubject.close();
    await _queueSnapshotSubject.close();
  }
}
