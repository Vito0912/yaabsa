import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/screens/player/layout/player_layout_config.dart';

class PlayerMediaInfoPresentation extends StatelessWidget {
  const PlayerMediaInfoPresentation({
    super.key,
    required this.title,
    required this.textAlignMode,
    required this.fontScale,
    this.author,
    this.narrator,
    this.series,
    this.seriesPosition,
    this.showAuthor = true,
    this.showNarrator = true,
    this.showSeries = true,
    this.titleMaxLines = 3,
    this.detailMaxLines = 2,
    this.onPressed,
  });

  final String title;
  final String? author;
  final String? narrator;
  final String? series;
  final String? seriesPosition;
  final bool showAuthor;
  final bool showNarrator;
  final bool showSeries;
  final PlayerMetadataTextAlign textAlignMode;
  final double fontScale;
  final int titleMaxLines;
  final int detailMaxLines;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scale = fontScale.clamp(0.75, 1.6);
    final textAlign = textAlignMode.textAlign;
    final crossAxis = textAlignMode.crossAxisAlignment;
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontSize: (theme.textTheme.titleLarge?.fontSize ?? 16) * scale,
    );
    final detailStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontSize: (theme.textTheme.bodyLarge?.fontSize ?? 14) * (scale * 0.9),
    );
    final trimmedSeries = series?.trim();
    final trimmedPosition = seriesPosition?.trim();
    final seriesText = trimmedSeries == null || trimmedSeries.isEmpty
        ? null
        : trimmedPosition == null || trimmedPosition.isEmpty
        ? trimmedSeries
        : '$trimmedSeries #$trimmedPosition';
    final trimmedAuthor = author?.trim();
    final trimmedNarrator = narrator?.trim();

    final textScaler = MediaQuery.textScalerOf(context);
    final titleLineHeight = textScaler.scale(titleStyle?.fontSize ?? 16) * 1.5;
    final detailLineHeight = textScaler.scale(detailStyle?.fontSize ?? 14) * 1.5;

    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: LayoutBuilder(
          builder: (context, constraints) {
            var remainingHeight = constraints.maxHeight.isFinite
                ? (constraints.maxHeight - 8).clamp(0.0, double.infinity)
                : double.infinity;
            final visibleTitleLines = remainingHeight.isFinite
                ? (remainingHeight / titleLineHeight).floor().clamp(1, titleMaxLines)
                : titleMaxLines;
            if (remainingHeight.isFinite) {
              remainingHeight -= visibleTitleLines * titleLineHeight;
            }

            bool canShowDetail(bool requested, String? value, double spacing) {
              if (!requested || value == null || value.isEmpty) {
                return false;
              }

              return !remainingHeight.isFinite || remainingHeight >= detailLineHeight + spacing;
            }

            final showAuthorDetail = canShowDetail(showAuthor, trimmedAuthor, 4);
            if (showAuthorDetail && remainingHeight.isFinite) {
              remainingHeight -= detailLineHeight + 4;
            }
            final showNarratorDetail = canShowDetail(showNarrator, trimmedNarrator, 3);
            if (showNarratorDetail && remainingHeight.isFinite) {
              remainingHeight -= detailLineHeight + 3;
            }
            final showSeriesDetail = canShowDetail(showSeries, seriesText, 3);
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: crossAxis,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: textAlign,
                  maxLines: visibleTitleLines,
                  overflow: TextOverflow.ellipsis,
                  style: titleStyle,
                ),
                if (showAuthorDetail) ...[
                  const SizedBox(height: 4),
                  Text(
                    trimmedAuthor!,
                    textAlign: textAlign,
                    maxLines: detailMaxLines,
                    overflow: TextOverflow.ellipsis,
                    style: detailStyle,
                  ),
                ],
                if (showNarratorDetail) ...[
                  const SizedBox(height: 3),
                  Text(
                    trimmedNarrator!,
                    textAlign: textAlign,
                    maxLines: detailMaxLines,
                    overflow: TextOverflow.ellipsis,
                    style: detailStyle,
                  ),
                ],
                if (showSeriesDetail) ...[
                  const SizedBox(height: 3),
                  Text(
                    seriesText!,
                    textAlign: textAlign,
                    maxLines: detailMaxLines,
                    overflow: TextOverflow.ellipsis,
                    style: detailStyle,
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
