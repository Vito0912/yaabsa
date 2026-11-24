import 'package:yaabsa/screens/wear/components/wear_item_header.dart';
import 'package:yaabsa/screens/wear/components/wear_player_background.dart';
import 'package:yaabsa/provider/common/item_download_status_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/wear/wear_browse_provider.dart';
import 'package:yaabsa/provider/wear/wear_sign_in_provider.dart';
import 'package:yaabsa/screens/wear/components/wear_browse_scaffold.dart';
import 'package:yaabsa/screens/wear/wear_player_screen.dart';
import 'package:yaabsa/screens/wear/components/wear_playback_progress.dart';
import 'package:yaabsa/util/audio_handler/wear_audio_handler.dart';
import 'package:yaabsa/util/browse/compact_browse_models.dart';
import 'package:yaabsa/util/globals.dart' show downloadHandler;

class WearItemScreen extends ConsumerStatefulWidget {
  const WearItemScreen({required this.entry, required this.handler, this.onShowPlayer, super.key});

  final CompactBrowseEntry entry;
  final WearAudioHandler handler;
  final VoidCallback? onShowPlayer;

  @override
  ConsumerState<WearItemScreen> createState() => _WearItemScreenState();
}

enum _WearItemAction { play, download }

class _WearItemScreenState extends ConsumerState<WearItemScreen> {
  _WearItemAction? _pendingAction;
  String? _error;

  bool get _busy => _pendingAction != null;

  Future<void> _perform(_WearItemAction pendingAction, Future<void> Function() action) async {
    if (_busy) {
      return;
    }

    setState(() {
      _pendingAction = pendingAction;
      _error = null;
    });
    try {
      await action();
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = wearRequestError(error);
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _pendingAction = null;
        });
      }
    }
  }

  Future<void> _play() async {
    final entry = widget.entry;
    await widget.handler.openItem(itemId: entry.itemId!, episodeId: entry.episodeId);
    if (!mounted ||
        widget.handler.media?.itemId != entry.itemId ||
        widget.handler.media?.episodeId != entry.episodeId) {
      return;
    }
    await widget.handler.play();
    if (mounted) {
      final showPlayer = widget.onShowPlayer;
      if (showPlayer != null) {
        showPlayer();
        return;
      }
      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WearPlayerScreen()));
    }
  }

  Future<void> _download(bool completed) async {
    final entry = widget.entry;
    final user = ref.read(currentUserProvider).value;
    if (user == null) {
      return;
    }
    if (completed) {
      final download = await ref
          .read(appDatabaseProvider)
          .getStoredDownload(entry.itemId!, user.id, episodeId: entry.episodeId);
      if (download != null) {
        await downloadHandler.deleteDownloadedItem(download, userId: user.id);
      }
    } else {
      await downloadHandler.downloadFile(entry.itemId!, episodeId: entry.episodeId);
    }
    if (mounted) {
      ref.invalidate(wearBrowseProvider);
    }
  }

  Future<void> _cancelDownload() async {
    final entry = widget.entry;
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId != null) {
      await downloadHandler.cancelDownloadForItem(entry.itemId!, episodeId: entry.episodeId, userId: userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final completed = ref.watch(completedDownloadForItemProvider(entry.itemId!, episodeId: entry.episodeId));
    final downloading = ref.watch(
      itemDownloadStatusesProvider.select((value) => value.value?[(entry.itemId!, entry.episodeId)]),
    );
    String downloadLabel;
    if (downloading != null) {
      downloadLabel = 'Cancel download ${downloading.percent}%';
    } else if (completed) {
      downloadLabel = 'Remove download';
    } else {
      downloadLabel = 'Download';
    }

    IconData downloadIcon;
    if (downloading != null) {
      downloadIcon = Icons.close;
    } else if (completed) {
      downloadIcon = Icons.download_done;
    } else {
      downloadIcon = Icons.download_outlined;
    }

    final children = <Widget>[
      if (widget.onShowPlayer != null) const Padding(padding: EdgeInsets.only(bottom: 12), child: WearPlaybackTime()),
      WearItemHeader(entry: entry, showCover: widget.onShowPlayer == null),
      WearBrowseButton(
        title: _pendingAction == _WearItemAction.play ? 'Opening…' : 'Play',
        icon: Icons.play_arrow_rounded,
        primary: true,
        loading: _pendingAction == _WearItemAction.play,
        onPressed: _busy ? null : () => _perform(_WearItemAction.play, _play),
      ),
      WearBrowseButton(
        title: downloadLabel,
        icon: downloadIcon,
        destructive: completed && downloading == null,
        loading: _pendingAction == _WearItemAction.download,
        progress: downloading == null ? null : downloading.percent / 100,
        onPressed: _busy
            ? null
            : () => _perform(
                _WearItemAction.download,
                downloading != null ? _cancelDownload : () => _download(completed),
              ),
      ),
      if (_error != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Semantics(
            liveRegion: true,
            child: Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),
    ];
    return WearBrowseScaffold(
      dismissible: widget.onShowPlayer == null,
      transformItems: false,
      background: widget.onShowPlayer == null ? WearPlayerBackground(coverUri: entry.coverUri) : null,
      backgroundColor: widget.onShowPlayer == null ? Colors.black : Colors.transparent,
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}
