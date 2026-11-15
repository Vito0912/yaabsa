import 'package:material_ui/material_ui.dart';

class YaabsaCoverImage extends StatelessWidget {
  const YaabsaCoverImage({
    super.key,
    required this.image,
    required this.placeholder,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
    this.fit = BoxFit.cover,
    this.filterQuality = FilterQuality.low,
    this.semanticLabel,
  });

  final ImageProvider<Object>? image;
  final Widget placeholder;
  final double? width;
  final double? height;
  final BorderRadiusGeometry borderRadius;
  final BoxFit fit;
  final FilterQuality filterQuality;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final imageProvider = image;
    final child = imageProvider == null
        ? placeholder
        : Image(
            image: imageProvider,
            width: width,
            height: height,
            fit: fit,
            filterQuality: filterQuality,
            semanticLabel: semanticLabel,
            errorBuilder: (context, error, stackTrace) => placeholder,
          );

    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(width: width, height: height, child: child),
    );
  }
}
