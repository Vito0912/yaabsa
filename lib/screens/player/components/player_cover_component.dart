import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/common/cover_placeholder.dart';
import 'package:yaabsa/components/common/cover_zoom_view.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/screens/player/layout/player_layout_config.dart';

class PlayerCoverComponent extends StatelessWidget {
  const PlayerCoverComponent({
    super.key,
    required this.api,
    required this.media,
    this.fitMode = PlayerCoverFitMode.height,
  });

  final ABSApi? api;
  final InternalMedia media;
  final PlayerCoverFitMode fitMode;

  @override
  Widget build(BuildContext context) {
    final requestHeaders = api == null
        ? const <String, String>{}
        : normalizeImageRequestHeaders(api!.dio.options.headers);
    final imageProvider = coverImageProviderFromUri(media.cover, requestHeaders: requestHeaders);

    const fallback = CoverPlaceholder(borderRadius: 10);

    if (imageProvider == null) {
      return const SizedBox.expand(child: fallback);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

        int? targetPixels(double logicalExtent) {
          if (!logicalExtent.isFinite || logicalExtent <= 0) {
            return null;
          }
          return (logicalExtent * devicePixelRatio).ceil().clamp(1, playerCoverRequestDimension).toInt();
        }

        final cacheWidth = fitMode == PlayerCoverFitMode.height ? null : targetPixels(constraints.maxWidth);
        final cacheHeight = fitMode == PlayerCoverFitMode.width ? null : targetPixels(constraints.maxHeight);
        final displayProvider = ResizeImage.resizeIfNeeded(cacheWidth, cacheHeight, imageProvider);

        return RepaintBoundary(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: media.cover == null
                    ? null
                    : () {
                        openCoverZoomView(
                          context,
                          coverUri: media.cover!,
                          requestHeaders: requestHeaders,
                          semanticsLabel: media.title,
                        );
                      },
                child: Image(
                  image: displayProvider,
                  fit: fitMode.boxFit,
                  filterQuality: FilterQuality.medium,
                  errorBuilder: (context, error, stackTrace) => fallback,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
