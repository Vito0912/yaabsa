import 'package:flutter/material.dart';
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
  });

  final InternalMedia media;
  final bool showAuthor;
  final bool showNarrator;
  final bool showSeries;
  final PlayerMetadataTextAlign textAlignMode;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final scale = (constraints.maxHeight / 120).clamp(0.75, 1.5);
        final textAlign = textAlignMode.textAlign;
        final crossAxis = textAlignMode.crossAxisAlignment;

        final titleStyle = Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontSize: (Theme.of(context).textTheme.titleMedium?.fontSize ?? 16) * scale);

        final detailStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14) * (scale * 0.9),
        );

        final seriesText = media.series == null || media.series!.trim().isEmpty
            ? null
            : media.seriesPosition == null || media.seriesPosition!.trim().isEmpty
            ? media.series!.trim()
            : '${media.series!.trim()} #${media.seriesPosition!.trim()}';

        final narratorText = media.subtitle?.trim();

        return Column(
          crossAxisAlignment: crossAxis,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(media.title, textAlign: textAlign, maxLines: 3, overflow: TextOverflow.ellipsis, style: titleStyle),
            if (showAuthor && media.author?.trim().isNotEmpty == true) ...<Widget>[
              const SizedBox(height: 4),
              Text(
                media.author!.trim(),
                textAlign: textAlign,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: detailStyle,
              ),
            ],
            if (showNarrator && narratorText?.isNotEmpty == true) ...<Widget>[
              const SizedBox(height: 3),
              Text(
                'Narrator: ${narratorText!}',
                textAlign: textAlign,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: detailStyle,
              ),
            ],
            if (showSeries && seriesText != null) ...<Widget>[
              const SizedBox(height: 3),
              Text(seriesText, textAlign: textAlign, maxLines: 2, overflow: TextOverflow.ellipsis, style: detailStyle),
            ],
          ],
        );
      },
    );
  }
}
