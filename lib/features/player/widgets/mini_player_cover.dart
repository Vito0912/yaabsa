import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/common/cover_placeholder.dart';
import 'package:yaabsa/components/common/cover_zoom_view.dart';
import 'package:yaabsa/ui/components/media/yaabsa_cover_image.dart';

class MiniPlayerCover extends StatelessWidget {
  const MiniPlayerCover({super.key, required this.coverUri, required this.requestHeaders, required this.borderRadius});

  final Uri? coverUri;
  final Map<String, String> requestHeaders;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final imageProvider = coverImageProviderFromUri(coverUri, requestHeaders: requestHeaders);

    return YaabsaCoverImage(
      image: imageProvider,
      borderRadius: BorderRadius.circular(borderRadius),
      fit: BoxFit.cover,
      filterQuality: FilterQuality.low,
      placeholder: CoverPlaceholder(borderRadius: borderRadius),
    );
  }
}
