import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/features/player/widgets/player_media_info_presentation.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/screens/player/layout/player_layout_config.dart';

class PlayerMediaInfoComponent extends StatelessWidget {
  const PlayerMediaInfoComponent({
    super.key,
    required this.media,
    required this.showAuthor,
    required this.showNarrator,
    required this.showSeries,
    required this.textAlignMode,
    required this.fontScale,
    this.titleMaxLines = 3,
    this.detailMaxLines = 2,
  });

  final InternalMedia media;
  final bool showAuthor;
  final bool showNarrator;
  final bool showSeries;
  final PlayerMetadataTextAlign textAlignMode;
  final double fontScale;
  final int titleMaxLines;
  final int detailMaxLines;

  @override
  Widget build(BuildContext context) {
    return PlayerMediaInfoPresentation(
      title: media.title,
      author: media.author,
      narrator: media.narrator,
      series: media.series,
      seriesPosition: media.seriesPosition,
      showAuthor: showAuthor,
      showNarrator: showNarrator,
      showSeries: showSeries,
      textAlignMode: textAlignMode,
      fontScale: fontScale,
      titleMaxLines: titleMaxLines,
      detailMaxLines: detailMaxLines,
      onPressed: () {
        final navigator = Navigator.of(context);
        final router = GoRouter.of(context);
        final matchedLocation = GoRouterState.of(context).matchedLocation;
        if (matchedLocation == '/player') {
          if (navigator.canPop()) {
            navigator.pop();
          } else {
            router.go('/');
          }
        }
        router.push(
          Uri(
            path: '/item/${media.itemId}',
            queryParameters: media.episodeId == null ? null : <String, String>{'episodeId': media.episodeId!},
          ).toString(),
        );
      },
    );
  }
}
