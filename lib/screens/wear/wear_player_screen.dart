import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/common/cover_zoom_view.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/main_wear.dart' show wearAudioHandler;
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/core/server_reachability_provider.dart';
import 'package:yaabsa/provider/core/socket_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/player/session_provider.dart';
import 'package:yaabsa/screens/wear/components/wear_fixed_view.dart';
import 'package:yaabsa/screens/wear/components/wear_ambient_view.dart';
import 'package:yaabsa/screens/wear/components/wear_swipe_to_dismiss.dart';
import 'package:yaabsa/screens/wear/components/wear_volume_control.dart';
import 'package:yaabsa/util/audio_handler/wear_audio_handler.dart';
import 'package:yaabsa/util/extensions.dart';
import 'package:yaabsa/util/globals.dart' show BreakpointContextX, downloadHandler;
import 'package:yaabsa/util/server_version.dart';

class WearPlayerScreen extends ConsumerStatefulWidget {
  const WearPlayerScreen({this.isAmbient = false, super.key});

  final bool isAmbient;

  @override
  ConsumerState<WearPlayerScreen> createState() => _WearPlayerScreenState();
}

class _WearPlayerScreenState extends ConsumerState<WearPlayerScreen> {
  String? _title, _author, _error, _itemId, _episodeId;
  bool _isPlaying = false, _isLoading = true, _isDownloaded = false, _isDownloading = false;
  double _volume = 0.7, _downloadProgress = 0.0;
  Duration _position = Duration.zero;
  DateTime _now = DateTime.now();
  StreamSubscription<PlaybackState>? _ps;
  StreamSubscription<Duration>? _pos;
  StreamSubscription<TaskProgressUpdate>? _dlProgress;
  StreamSubscription<List<TaskRecord>>? _dlQueue;
  final Map<String, double> _taskProgress = {};
  Timer? _clock;
  Timer? _downloadFinishFallback;
  AppLifecycleListener? _lifecycle;

  WearAudioHandler get _h => wearAudioHandler;

  @override
  void initState() {
    super.initState();
    _ps = _h.playbackState.listen((s) {
      if (mounted) setState(() => _isPlaying = s.playing);
    });
    _pos = _h.player
        .createPositionStream(minPeriod: const Duration(milliseconds: 500), maxPeriod: const Duration(seconds: 1))
        .listen((_) {
          if (mounted && !_isLoading && !widget.isAmbient) {
            setState(() => _position = _h.position);
          }
        });
    _clock = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted && !widget.isAmbient) {
        setState(() => _now = DateTime.now());
      }
    });
    _dlProgress = downloadHandler.progressUpdateStream.listen((update) {
      final itemId = _itemId;
      if (itemId == null || update.task.group != itemId || !mounted) return;
      _downloadFinishFallback?.cancel();
      _taskProgress[update.task.taskId] = update.progress < 0 ? 0.0 : update.progress.clamp(0.0, 1.0);
      final values = _taskProgress.values;
      setState(() {
        _isDownloading = true;
        _downloadProgress = values.isEmpty ? 0.0 : values.reduce((a, b) => a + b) / values.length;
      });
    });
    _dlQueue = downloadHandler.taskQueueStream.listen((tasks) {
      final itemId = _itemId;
      if (itemId == null || !_isDownloading) return;
      final active = tasks.any((t) => downloadHandler.taskBelongsToItem(t, itemId, episodeId: _episodeId));
      if (active) return;
      _taskProgress.clear();
      // Persisting the finished download (file path + cover) lags the task
      // queue, so keep the ring until the stored download lands (see the
      // completedDownloadItemIds listener) or, for failed/cancelled
      // downloads that never produce one, until the fallback fires.
      _downloadFinishFallback?.cancel();
      _downloadFinishFallback = Timer(const Duration(seconds: 10), _stopDownloadIndicator);
    });
    ref.listenManual(completedDownloadItemIdsProvider, (previous, next) {
      final itemId = _itemId;
      if (itemId == null || !_isDownloading) return;
      if (next.value?.contains(itemId) ?? false) _stopDownloadIndicator();
    });
    ref.listenManual(remoteMediaProgressUpdateProvider, (previous, next) {
      if (next != null) unawaited(_onRemoteProgress(next));
    });
    // The socket is disconnected while the app is backgrounded, so re-check
    // for remote playback when the app comes back to the foreground.
    _lifecycle = AppLifecycleListener(onResume: () => unawaited(_checkRemoteProgress()));
    _load();
  }

  /// Follows playback that happens on other clients while the watch is
  /// paused: switches to a different item, or moves the paused position when
  /// the same item progressed elsewhere.
  Future<void> _onRemoteProgress(MediaProgress progress) async {
    if (_isLoading || _isPlaying || progress.isFinished) return;

    final itemId = _itemId;
    final sameItem = itemId != null && progress.libraryItemId == itemId && progress.episodeId == _episodeId;
    if (!sameItem) {
      return _load();
    }

    final remote = Duration(microseconds: (progress.currentTime * Duration.microsecondsPerSecond).round());
    if ((remote - _h.position).abs() < const Duration(seconds: 5)) return;
    await _h.seek(remote);
    if (mounted) setState(() => _position = remote);
  }

  Future<void> _checkRemoteProgress() async {
    if (_isLoading || _isPlaying) return;
    final api = ref.read(absApiProvider);
    if (api == null) return;
    try {
      final mp = await _fetchAllProgress(api);
      if (mp == null || mp.isEmpty) return;
      final sorted = [...mp]..sort((a, b) => (b.lastUpdate ?? 0).compareTo(a.lastUpdate ?? 0));
      final newest = sorted.firstWhere((p) => !p.isFinished, orElse: () => sorted.first);
      await _onRemoteProgress(newest);
    } catch (_) {
      // Offline or transient failure; the next resume or socket event retries.
    }
  }

  Future<List<MediaProgress>?> _fetchAllProgress(ABSApi api) async {
    if (!serverSupportsMediaProgressAndBookmarkRoutes(ref.read(serverVersionProvider))) {
      return (await api.getMeApi().getUser()).data?.mediaProgress;
    }

    return (await api.getMeApi().getAllMediaProgress()).data?.mediaProgress;
  }

  void _stopDownloadIndicator() {
    _downloadFinishFallback?.cancel();
    if (!mounted) return;
    setState(() {
      _isDownloading = false;
      _downloadProgress = 0.0;
    });
  }

  @override
  void didUpdateWidget(WearPlayerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isAmbient && !widget.isAmbient) {
      _position = _h.position;
      _now = DateTime.now();
    }
  }

  @override
  void dispose() {
    _ps?.cancel();
    _pos?.cancel();
    _dlProgress?.cancel();
    _dlQueue?.cancel();
    _clock?.cancel();
    _downloadFinishFallback?.cancel();
    _lifecycle?.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final user = ref.read(currentUserProvider).value;
      if (user == null) {
        return setState(() {
          _error = 'Not signed in';
          _isLoading = false;
        });
      }

      final api = ref.read(absApiProvider);
      List<MediaProgress>? mp;
      var freshProgress = false;
      if (api != null) {
        try {
          mp = await _fetchAllProgress(api);
          freshProgress = mp != null;
        } catch (_) {
          // Server unreachable; fall back to the progress cached with the
          // stored user below.
        }
      }
      mp ??= user.mediaProgress;
      if (mp == null || mp.isEmpty) {
        return setState(() {
          _error = 'No listening history';
          _isLoading = false;
        });
      }

      final sorted = [...mp]..sort((a, b) => (b.lastUpdate ?? 0).compareTo(a.lastUpdate ?? 0));
      final unfinished = sorted.where((p) => !p.isFinished).toList();
      final candidates = (unfinished.isEmpty ? [sorted.first] : unfinished).take(5).toList();

      final db = ref.read(appDatabaseProvider);
      final sessions = ref.read(sessionRepositoryProvider);
      final canReachServer = freshProgress || ref.read(serverReachabilityProvider);

      // Most recent first; skip what cannot play right now (not downloaded
      // while the server is unreachable) and fall through on open errors.
      InternalMedia? media;
      MediaProgress? lp;
      for (final candidate in candidates) {
        final downloaded =
            await db.getStoredDownload(candidate.libraryItemId, user.id, episodeId: candidate.episodeId) != null;
        if (!downloaded && !canReachServer) continue;
        try {
          await sessions.closeSession();
          final opened = await sessions.openSession(candidate.libraryItemId, episodeId: candidate.episodeId);
          if (opened != null && opened.tracks.isNotEmpty) {
            media = opened;
            lp = candidate;
            break;
          }
        } catch (_) {
          // Try the next candidate.
        }
      }

      if (media == null || lp == null) {
        return setState(() {
          _error = 'Nothing playable found.\nDownload an item or check your connection.';
          _isLoading = false;
        });
      }
      final loadedMedia = media;

      final initialPosition = Duration(microseconds: ((lp.currentTime) * Duration.microsecondsPerSecond).round());
      await _h.loadInternalMedia(loadedMedia, initialPosition: initialPosition);
      _itemId = loadedMedia.itemId;
      _episodeId = loadedMedia.episodeId;
      setState(() {
        _title = loadedMedia.title;
        _author = loadedMedia.author ?? '';
        _position = initialPosition;
        _isPlaying = false;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed: $e';
        _isLoading = false;
      });
    }
  }

  void _toggle() {
    if (_isPlaying) {
      _h.pause();
    } else {
      _h.play();
    }
  }

  void _ff() => _h.seek(_h.position + const Duration(seconds: 30));
  void _rew() => _h.seek(_h.position - const Duration(seconds: 15));

  void _vol() => Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => WearVolumeControl(
        volume: _volume,
        onChanged: (v) {
          _h.player.setVolume(v);
          setState(() => _volume = v);
        },
      ),
    ),
  );
  Future<void> _toggleDownload() async {
    final itemId = _itemId;
    final user = ref.read(currentUserProvider).value;
    if (itemId == null || user == null) return;

    if (_isDownloaded) {
      // The completedDownloadItemIds stream flips the icon back once the
      // stored download row is gone.
      try {
        final download = await ref.read(appDatabaseProvider).getStoredDownload(itemId, user.id, episodeId: _episodeId);
        if (download != null) {
          await downloadHandler.deleteDownloadedItem(download, userId: user.id);
        }
      } catch (_) {}
    } else {
      setState(() {
        _isDownloading = true;
        _downloadProgress = 0.0;
      });
      try {
        await downloadHandler.downloadFile(itemId, episodeId: _episodeId);
      } catch (_) {
        if (mounted) setState(() => _isDownloading = false);
      }
    }
  }

  @override
  Widget build(BuildContext c) {
    final downloadedIds = ref.watch(completedDownloadItemIdsProvider).value;
    _isDownloaded = _itemId != null && (downloadedIds?.contains(_itemId) ?? false);
    return WearSwipeToDismiss(
      child: Scaffold(
        body: widget.isAmbient
            ? WearAmbientView(title: _title, author: _author)
            : _isLoading
            ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
            : _error != null
            ? _err()
            : Stack(fit: StackFit.expand, children: [_coverBackground(), _player()]),
      ),
    );
  }

  // Hierarchy on the watch is conveyed by dimming the theme's onSurface
  // color, mirroring the white opacity steps used before the shared theme.
  Color _onSurface(double alpha) => Theme.of(context).colorScheme.onSurface.withValues(alpha: alpha);

  Widget _coverBackground() {
    final api = ref.watch(absApiProvider);
    final image = coverImageProviderFromUri(
      _h.media?.cover,
      requestHeaders: normalizeImageRequestHeaders(api?.dio.options.headers),
    );

    if (image == null) {
      return const SizedBox.expand();
    }

    return ExcludeSemantics(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image(image: image, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const SizedBox.expand()),
          ColoredBox(color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.80)),
        ],
      ),
    );
  }

  Widget _err() {
    return WearFixedView(
      children: [
        Icon(Icons.error_outline, size: 32, color: Theme.of(context).colorScheme.error),
        const SizedBox(height: 8),
        Text(
          _error!,
          style: TextStyle(fontSize: 12, color: _onSurface(0.70)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _load,
          style: ElevatedButton.styleFrom(minimumSize: const Size(48, 48)),
          child: const Text('Retry', style: TextStyle(fontSize: 12)),
        ),
      ],
    );
  }

  Widget _player() {
    final colorScheme = Theme.of(context).colorScheme;
    final time = '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}';

    return WearFixedView.builder(
      builder: (context, constraints) {
        final scaler = MediaQuery.textScalerOf(context);
        final compact = context.screenWidth < 225 || constraints.maxHeight < 180 || scaler.scale(12) > 15;
        final showTime = constraints.maxHeight >= 102 + scaler.scale(16) * 1.4 + scaler.scale(12) * 1.4;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!compact)
              Text(
                time,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: _onSurface(0.60)),
              ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!compact && _author != null && _author!.isNotEmpty)
                        Text(
                          _author!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: _onSurface(0.70)),
                          textAlign: TextAlign.center,
                        ),
                      Flexible(
                        child: Text(
                          _title ?? '',
                          maxLines: compact ? 1 : 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _progress(showTime: showTime),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _btn(Icons.replay_30, _rew, label: 'Rewind 15 seconds'),
                DecoratedBox(
                  decoration: BoxDecoration(shape: BoxShape.circle, color: colorScheme.primary),
                  child: _btn(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    _toggle,
                    label: _isPlaying ? 'Pause' : 'Play',
                    s: 36,
                    color: colorScheme.onPrimary,
                  ),
                ),
                _btn(Icons.forward_30, _ff, label: 'Forward 30 seconds'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _btn(Icons.volume_up, _vol, label: 'Volume', s: 22),
                if (_isDownloading)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox.square(
                          dimension: 24,
                          child: CircularProgressIndicator(value: _downloadProgress, strokeWidth: 2),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(_downloadProgress * 100).round()}%',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: _onSurface(0.70)),
                        ),
                      ],
                    ),
                  )
                else
                  _btn(
                    _isDownloaded ? Icons.file_download_done : Icons.download,
                    _toggleDownload,
                    label: _isDownloaded ? 'Remove download' : 'Download',
                    s: 22,
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _btn(IconData i, VoidCallback f, {required String label, double s = 28, Color? color}) => IconButton(
    icon: Icon(i, color: color ?? _onSurface(0.70), size: s),
    onPressed: f,
    tooltip: label,
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
  );

  Widget _progress({bool showTime = true}) {
    final total = _h.media?.totalDuration ?? Duration.zero;
    final fraction = total.inMilliseconds > 0 ? (_position.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0) : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 3,
              backgroundColor: _onSurface(0.12),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          if (showTime) ...[
            const SizedBox(height: 3),
            Text(
              '${_position.toCompactClockString()} / ${total.toCompactClockString()}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: _onSurface(0.70)),
            ),
          ],
        ],
      ),
    );
  }
}
