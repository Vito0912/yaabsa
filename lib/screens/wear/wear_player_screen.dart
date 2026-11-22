import 'package:audio_service/audio_service.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/main_wear.dart' show wearAudioHandler;
import 'package:yaabsa/screens/wear/components/wear_browse_scaffold.dart';
import 'package:yaabsa/screens/wear/components/wear_player_background.dart';
import 'package:yaabsa/ui/components/wear/wear_page_header.dart';
import 'package:yaabsa/screens/wear/components/wear_player_controls.dart';
import 'package:yaabsa/screens/wear/components/wear_player_pager.dart';
import 'package:yaabsa/screens/wear/wear_item_screen.dart';
import 'package:yaabsa/util/browse/compact_browse_models.dart';
import 'package:yaabsa/screens/wear/components/wear_playback_progress.dart';

class WearPlayerScreen extends StatelessWidget {
  const WearPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final handler = wearAudioHandler;
    return StreamBuilder<MediaItem?>(
      stream: handler.mediaItem,
      initialData: handler.mediaItem.value,
      builder: (context, snapshot) {
        final media = handler.media;
        if (media == null) {
          return WearBrowseScaffold(
            title: 'Now playing',
            itemCount: 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const Text('Choose something from your libraries or downloads.', textAlign: TextAlign.center);
              }
              return WearBrowseButton(
                title: 'Back',
                icon: Icons.arrow_back,
                onPressed: () => Navigator.of(context).maybePop(),
              );
            },
          );
        }

        final coverUri = snapshot.data?.artUri ?? media.cover;
        const actions = WearPlayerActions();
        return WearPlayerPager(
          key: ValueKey((media.itemId, media.episodeId)),
          background: WearPlayerBackground(coverUri: coverUri),
          actionsBuilder: (showPlayer) => WearItemScreen(
            handler: handler,
            onShowPlayer: showPlayer,
            entry: CompactBrowseEntry(
              title: media.title,
              subtitle: media.author,
              itemId: media.itemId,
              episodeId: media.episodeId,
              coverUri: coverUri,
            ),
          ),
          player: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;
              final hasAuthor = media.author?.trim().isNotEmpty == true;
              final titleHeight = _lineHeight(context, 14) + (hasAuthor ? _lineHeight(context, 12) : 0);
              final clockHeight = _lineHeight(context, 12);
              final topInset = height * 0.04;
              final bottomInset = height * 0.04;
              final primarySize = wearPrimaryControlSize(context);
              final requiredHeight = topInset + bottomInset + clockHeight + titleHeight + primarySize + 48 + 8;
              if (requiredHeight > height || width < 185) {
                final children = <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: WearPlayerHeader(media: media, lines: 2),
                  ),
                  const WearPlaybackControls(),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: WearPlaybackTime()),
                  actions,
                ];
                return WearBrowseScaffold(
                  dismissible: false,
                  transformItems: false,
                  backgroundColor: Colors.transparent,
                  itemCount: children.length,
                  itemBuilder: (context, index) => children[index],
                );
              }

              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  fit: StackFit.expand,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: topInset, bottom: bottomInset),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const WearTimeText(),
                          SizedBox(
                            width: width * 0.70,
                            height: titleHeight,
                            child: Center(child: WearPlayerHeader(media: media)),
                          ),
                          SizedBox(width: width * 0.92, height: primarySize, child: const WearPlaybackControls()),
                          SizedBox(width: width * 0.64, height: 48, child: actions),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

double _lineHeight(BuildContext context, double size) {
  final painter = TextPainter(
    text: TextSpan(
      text: 'Ag',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: size, height: 1.1),
    ),
    textDirection: Directionality.of(context),
    textScaler: MediaQuery.textScalerOf(context),
  );
  painter.layout();
  final height = painter.height;
  painter.dispose();
  return height;
}
