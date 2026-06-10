import 'dart:async';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/main_wear.dart' show wearAudioHandler;
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/core/server_reachability_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/player/session_provider.dart';
import 'package:yaabsa/screens/wear/components/wear_volume_control.dart';
import 'package:yaabsa/util/audio_handler/wear_audio_handler.dart';
import 'package:yaabsa/util/globals.dart' show downloadHandler;

class WearPlayerScreen extends ConsumerStatefulWidget {
  const WearPlayerScreen({super.key});
  @override
  ConsumerState<WearPlayerScreen> createState() => _WearPlayerScreenState();
}

class _WearPlayerScreenState extends ConsumerState<WearPlayerScreen> {
  String? _title, _author, _coverUrl, _error, _itemId, _episodeId;
  bool _isPlaying = false, _isLoading = true, _isDownloaded = false, _isDownloading = false;
  double _volume = 0.7, _downloadProgress = 0.0;
  DateTime _now = DateTime.now();
  StreamSubscription<PlaybackState>? _ps;
  StreamSubscription<TaskProgressUpdate>? _dlProgress;
  StreamSubscription<List<TaskRecord>>? _dlQueue;
  final Map<String, double> _taskProgress = {};
  Timer? _clock;
  Timer? _downloadFinishFallback;

  WearAudioHandler get _h => wearAudioHandler;

  @override
  void initState() {
    super.initState();
    _ps = _h.playbackState.listen((s) {
      if (mounted) setState(() => _isPlaying = s.playing);
    });
    _clock = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() => _now = DateTime.now());
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
    _load();
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
  void dispose() {
    _ps?.cancel();
    _dlProgress?.cancel();
    _dlQueue?.cancel();
    _clock?.cancel();
    _downloadFinishFallback?.cancel();
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
          mp = (await api.getMeApi().getUser()).data?.mediaProgress;
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

      await _h.loadInternalMedia(
        loadedMedia,
        initialPosition: Duration(microseconds: ((lp.currentTime) * Duration.microsecondsPerSecond).round()),
      );
      _itemId = loadedMedia.itemId;
      _episodeId = loadedMedia.episodeId;
      setState(() {
        _title = loadedMedia.title;
        _author = loadedMedia.author ?? '';
        _coverUrl = loadedMedia.cover?.toString();
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
        final download = await ref
            .read(appDatabaseProvider)
            .getStoredDownload(itemId, user.id, episodeId: _episodeId);
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
          : _error != null
          ? _err()
          : _player(),
    );
  }

  Widget _err() => Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 32, color: Colors.redAccent),
          const SizedBox(height: 8),
          Text(
            _error!,
            style: const TextStyle(fontSize: 11, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _load,
            child: const Text('Retry', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    ),
  );

  Widget _player() {
    final t = '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}';
    return Stack(
      fit: StackFit.expand,
      children: [
        if (_coverUrl != null)
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(Colors.black87, BlendMode.darken),
              child: _coverImage(_coverUrl!),
            ),
          )
        else
          Positioned.fill(child: _placeholder()),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(t, style: const TextStyle(fontSize: 11, color: Colors.white38)),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_author != null && _author!.isNotEmpty)
                    Text(
                      _author!,
                      style: const TextStyle(fontSize: 11, color: Colors.white60),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  Text(
                    _title ?? '',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _btn(Icons.replay_30, _rew),
                      const SizedBox(width: 8),
                      Container(
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
                        child: _btn(_isPlaying ? Icons.pause : Icons.play_arrow, _toggle, s: 30),
                      ),
                      const SizedBox(width: 8),
                      _btn(Icons.forward_30, _ff),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.volume_up, color: Colors.white54, size: 22),
                    onPressed: _vol,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  ),
                  if (_isDownloading)
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(value: _downloadProgress, strokeWidth: 2, color: Colors.white54),
                          Text(
                            '${(_downloadProgress * 100).round()}',
                            style: const TextStyle(fontSize: 7, color: Colors.white54),
                          ),
                        ],
                      ),
                    )
                  else
                    IconButton(
                      icon: Icon(
                        _isDownloaded ? Icons.file_download_done : Icons.download,
                        color: Colors.white54,
                        size: 22,
                      ),
                      onPressed: _toggleDownload,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    ),
                ],
              ),
            ),
            const Icon(Icons.expand_less, color: Colors.white24, size: 18),
          ],
        ),
      ],
    );
  }

  Widget _btn(IconData i, VoidCallback f, {double s = 28}) => IconButton(
    icon: Icon(i, color: Colors.white70, size: s),
    onPressed: f,
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
  );

  Widget _coverImage(String url) {
    final uri = Uri.tryParse(url);
    if (uri != null && uri.scheme == 'file') {
      return Image.file(File(uri.toFilePath()), fit: BoxFit.cover, errorBuilder: (_, _, _) => _placeholder());
    }
    return Image.network(url, fit: BoxFit.cover, errorBuilder: (_, _, _) => _placeholder());
  }

  Widget _placeholder() => Container(color: Colors.grey[900]);
}
