import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:audio_service/audio_service.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart' show AudioSource;
import 'package:path_provider/path_provider.dart';
import 'package:yaabsa/api/library_items/audio_track.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/request/play_library_item_request.dart';
import 'package:yaabsa/main_wear.dart' show wearAudioHandler, WearAudioHandler;
import 'package:yaabsa/provider/wear/wear_providers.dart';
import 'package:yaabsa/util/player_utils.dart';
import 'package:yaabsa/util/globals.dart' show appName;

// ═══════════════════════════════════════════════════════════════
// Player screen
// ═══════════════════════════════════════════════════════════════

class WearPlayerScreen extends ConsumerStatefulWidget {
  const WearPlayerScreen({super.key});
  @override ConsumerState<WearPlayerScreen> createState() => _WearPlayerScreenState();
}

class _WearPlayerScreenState extends ConsumerState<WearPlayerScreen> {
  String? _title, _author, _coverUrl, _error, _itemId, _episodeId;
  bool _isPlaying = false, _isLoading = true, _isDownloaded = false, _isDownloading = false;
  double _volume = 0.7, _downloadProgress = 0.0;
  DateTime _now = DateTime.now();
  StreamSubscription<PlaybackState>? _ps;
  Timer? _clock;
  Timer? _downloadPollTimer;

  WearAudioHandler get _h => wearAudioHandler;

  @override void initState() {
    super.initState();
    _ps = _h.playbackState.listen((s) { if (mounted) setState(() => _isPlaying = s.playing); });
    _clock = Timer.periodic(const Duration(seconds: 30), (_) { if (mounted) setState(() => _now = DateTime.now()); });
    _load();
  }
  @override void dispose() { _ps?.cancel(); _clock?.cancel(); _downloadPollTimer?.cancel(); super.dispose(); }

  Future<void> _load() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final api = await ref.read(wearApiProvider.future);
      if (api == null) return setState(() { _error = 'Not connected to server'; _isLoading = false; });

      final user = (await api.getMeApi().getUser()).data;
      if (user == null) return setState(() { _error = 'Failed to load user data'; _isLoading = false; });
      final mp = user.mediaProgress;
      if (mp == null || mp.isEmpty) return setState(() { _error = 'No listening history'; _isLoading = false; });

      mp.sort((a, b) => (b.lastUpdate ?? 0).compareTo(a.lastUpdate ?? 0));
      final lp = mp.firstWhere((p) => !(p.isFinished ?? false), orElse: () => mp.first);
      LibraryItem? li;
      try { li = (await api.getLibraryItemApi().getLibraryItem(itemId: lp.libraryItemId)).data; } catch (_) {}

      final pr = PlayLibraryItemRequest(deviceInfo: await PlayerUtils.getDeviceInfo(), forceDirectPlay: false, forceTranscode: false, supportedMimeTypes: await PlayerUtils.getSupportedMimeTypes(), mediaPlayer: '$appName just_audio');
      final session = (await api.getLibraryItemApi().playLibraryItem(lp.libraryItemId, episodeId: lp.episodeId, playRequest: pr)).data;
      final tracks = session?.audioTracks ?? <AudioTrack>[];
      if (tracks.isEmpty) return setState(() { _error = 'No audio tracks'; _isLoading = false; });

      final title = session?.displayTitle ?? li?.title ?? 'Unknown';
      final author = session?.displayAuthor ?? li?.authorString ?? '';
      String? cover = (li?.hasCover ?? false) ? api.getLibraryItemApi().getCoverUri(lp.libraryItemId).toString() : null;

      final items = <MediaItem>[], sources = <AudioSource>[];
      for (var i = 0; i < tracks.length; i++) {
        final t = tracks[i], it = t.toInternalTrack(api.basePathOverride, session!.id);
        items.add(MediaItem(id: '${lp.libraryItemId}:${lp.episodeId ?? 'item'}:$i', title: tracks.length > 1 ? '$title (${i + 1}/${tracks.length})' : title, artist: author.isNotEmpty ? author : null, duration: Duration(milliseconds: ((t.duration ?? 0) * 1000).round()), artUri: cover != null ? Uri.parse(cover) : null));
        sources.add(AudioSource.uri(Uri.parse(it.url!)));
      }
      await _h.loadMedia(mediaItems: items, audioSources: sources, initialPosition: Duration(microseconds: ((lp.currentTime ?? 0) * Duration.microsecondsPerSecond).round()));
      _checkExistingDownloads();
      setState(() { _title = title; _author = author; _coverUrl = cover; _itemId = lp.libraryItemId; _episodeId = lp.episodeId; _isPlaying = false; _isLoading = false; });
    } catch (e) { setState(() { _error = 'Failed: $e'; _isLoading = false; }); }
  }

  void _toggle() { if (_isPlaying) { _h.pause(); } else { _h.play(); } }
  void _ff() => _h.player.seek(_h.player.position + const Duration(seconds: 30));
  void _rew() { final p = _h.player.position - const Duration(seconds: 15); _h.player.seek(p < Duration.zero ? Duration.zero : p); }
  void _vol() => Navigator.of(context).push(MaterialPageRoute(fullscreenDialog: true, builder: (_) => _WearVolumeControl(volume: _volume, onChanged: (v) { _h.player.setVolume(v); setState(() => _volume = v); })));
  Future<void> _checkExistingDownloads() async {
    try { final d = Directory('${(await getApplicationDocumentsDirectory()).path}/yaabsa_wear'); if (await d.exists() && mounted) setState(() => _isDownloaded = true); } catch (_) {}
  }

  void _pollDownloadCompletion() {
    _downloadPollTimer?.cancel();
    _downloadPollTimer = Timer.periodic(const Duration(seconds: 2), (t) async {
      try {
        final records = await FileDownloader().database.allRecords();
        final mine = records.where((r) => r.taskId.startsWith('wear_${_itemId}_'));
        final pending = mine.where((r) => r.status.isNotFinalState);
        if (pending.isEmpty) {
          t.cancel();
          if (mounted) setState(() { _isDownloaded = true; _isDownloading = false; _downloadProgress = 0.0; });
        } else if (mounted) {
          final total = pending.fold<double>(0.0, (s, r) => s + r.progress);
          setState(() => _downloadProgress = pending.isEmpty ? 0.0 : total / pending.length);
        }
      } catch (_) { t.cancel(); if (mounted) setState(() => _isDownloading = false); }
    });
  }
  Future<void> _toggleDownload() async {
    if (_itemId == null) return;
    if (_isDownloaded) {
      setState(() { _isDownloading = true; _isDownloaded = false; });
      try { await Directory('${(await getApplicationDocumentsDirectory()).path}/yaabsa_wear').delete(recursive: true); } catch (_) {}
      setState(() => _isDownloading = false);
    } else {
      setState(() => _isDownloading = true);
      try {
        final api = await ref.read(wearApiProvider.future);
        if (api == null) return setState(() => _isDownloading = false);
        final li = (await api.getLibraryItemApi().getLibraryItem(itemId: _itemId!)).data;
        final files = li?.media?.bookMedia?.audioFiles ?? [];
        final dl = FileDownloader();
        for (final f in files) {
          await dl.enqueue(DownloadTask(taskId: 'wear_${_itemId}_${f.ino}', group: _itemId!, url: '${api.basePathOverride}/api/items/$_itemId/file/${f.ino}/download', filename: f.metadata.filename, baseDirectory: BaseDirectory.applicationDocuments, directory: 'yaabsa_wear', headers: {'Authorization': 'Bearer ${api.token}'}, updates: Updates.statusAndProgress));
        }
        // Download runs async via WorkManager — poll for completion
        _pollDownloadCompletion();
      } catch (_) { setState(() => _isDownloading = false); }
    }
  }

  @override Widget build(BuildContext c) => Scaffold(backgroundColor: Colors.black, body: _isLoading ? const Center(child: CircularProgressIndicator(strokeWidth: 2)) : _error != null ? _err() : _player());

  Widget _err() => Center(child: Padding(padding: const EdgeInsets.all(16), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.error_outline, size: 32, color: Colors.redAccent), const SizedBox(height: 8), Text(_error!, style: const TextStyle(fontSize: 11, color: Colors.white70), textAlign: TextAlign.center), const SizedBox(height: 10), ElevatedButton(onPressed: _load, child: const Text('Retry', style: TextStyle(fontSize: 12)))])));

  Widget _player() {
    final t = '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}';
    return Stack(fit: StackFit.expand, children: [
      if (_coverUrl != null)
        Positioned.fill(
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.black87, BlendMode.darken),
            child: Image.network(_coverUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholder()),
          ),
        )
      else
        Positioned.fill(child: _placeholder()),
      Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(t, style: const TextStyle(fontSize: 11, color: Colors.white38)),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            if (_author != null && _author!.isNotEmpty)
              Text(_author!, style: const TextStyle(fontSize: 11, color: Colors.white60), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(_title ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _btn(Icons.replay_30, _rew), const SizedBox(width: 8),
              Container(decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent), child: _btn(_isPlaying ? Icons.pause : Icons.play_arrow, _toggle, s: 30)),
              const SizedBox(width: 8), _btn(Icons.forward_30, _ff),
            ]),
          ]),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            IconButton(icon: const Icon(Icons.volume_up, color: Colors.white54, size: 22), onPressed: _vol, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 36, minHeight: 36)),
            if (_isDownloading)
              SizedBox(
                width: 22, height: 22,
                child: Stack(alignment: Alignment.center, children: [
                  CircularProgressIndicator(value: _downloadProgress, strokeWidth: 2, color: Colors.white54),
                  Text('${(_downloadProgress * 100).round()}', style: const TextStyle(fontSize: 7, color: Colors.white54)),
                ]),
              )
            else
              IconButton(
                icon: Icon(_isDownloaded ? Icons.file_download_done : Icons.download, color: Colors.white54, size: 22),
                onPressed: _toggleDownload, padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
          ]),
        ),
        const Icon(Icons.expand_less, color: Colors.white24, size: 18),
      ]),
    ]);
  }
  Widget _btn(IconData i, VoidCallback f, {double s = 28}) => IconButton(icon: Icon(i, color: Colors.white70, size: s), onPressed: f, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 44, minHeight: 44));
  Widget _placeholder() => Container(color: Colors.grey[900]);
}

// ═══════════════════════════════════════════════════════════════
// Volume control
// ═══════════════════════════════════════════════════════════════

class _WearVolumeControl extends StatefulWidget {
  const _WearVolumeControl({required this.volume, required this.onChanged});
  final double volume;
  final ValueChanged<double> onChanged;
  @override State<_WearVolumeControl> createState() => _WearVolumeControlState();
}

class _WearVolumeControlState extends State<_WearVolumeControl> {
  late double _v = widget.volume;
  @override void didUpdateWidget(_WearVolumeControl old) { super.didUpdateWidget(old); if (old.volume != widget.volume) _v = widget.volume; }

  @override Widget build(BuildContext c) => Listener(
    onPointerSignal: (e) {
      try { final d = (e as dynamic).scrollDelta?.y as double?; if (d != null) { setState(() => _v = (_v + d * 0.05).clamp(0.0, 1.0)); widget.onChanged(_v); } } catch (_) {}
    },
    child: Scaffold(backgroundColor: Colors.black, body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.volume_up, color: Colors.white38, size: 18), const SizedBox(height: 4),
      SizedBox(width: 110, height: 110, child: CustomPaint(painter: _CircularVolumePainter(volume: _v, color: Colors.white, bg: Colors.white24), child: Center(child: Text('${(_v * 100).round()}%', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: Colors.white))))),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _vBtn(Icons.remove_circle_outline, () { setState(() => _v = (_v - 0.1).clamp(0.0, 1.0)); widget.onChanged(_v); }),
        const SizedBox(width: 20),
        GestureDetector(onTap: () => Navigator.of(c).pop(), child: Container(width: 36, height: 36, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent), child: const Icon(Icons.check, color: Colors.white, size: 22))),
        const SizedBox(width: 20),
        _vBtn(Icons.add_circle_outline, () { setState(() => _v = (_v + 0.1).clamp(0.0, 1.0)); widget.onChanged(_v); }),
      ]),
    ]))),
  );
  Widget _vBtn(IconData i, VoidCallback f) => IconButton(icon: Icon(i, color: Colors.white70, size: 26), onPressed: f, padding: EdgeInsets.zero, constraints: const BoxConstraints(minWidth: 40, minHeight: 40));
}

class _CircularVolumePainter extends CustomPainter {
  _CircularVolumePainter({required this.volume, required this.color, required this.bg});
  final double volume; final Color color, bg;
  @override void paint(Canvas c, Size s) {
    final o = Offset(s.width / 2, s.height / 2), r = s.width / 2 - 8;
    c.drawCircle(o, r, Paint()..color = bg..style = PaintingStyle.stroke..strokeWidth = 8..strokeCap = StrokeCap.round);
    c.drawArc(Rect.fromCircle(center: o, radius: r), -math.pi / 2, volume * 2 * math.pi, false, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 8..strokeCap = StrokeCap.round);
  }
  @override bool shouldRepaint(covariant _CircularVolumePainter o) => o.volume != volume;
}
