import 'package:flutter/widget_previews.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/common/cover_placeholder.dart';
import 'package:yaabsa/ui/components/media/yaabsa_cover_image.dart';

import 'preview_theme.dart';

@Preview(name: 'Cover images / light', size: Size(520, 300), wrapper: yaabsaPreviewLight)
@Preview(name: 'Cover images / dark', size: Size(520, 300), wrapper: yaabsaPreviewDark)
@Preview(name: 'Cover images / AMOLED', size: Size(520, 300), wrapper: yaabsaPreviewAmoled)
Widget coverImagesPreview() => const CoverImagesPreview();

class CoverImagesPreview extends StatelessWidget {
  const CoverImagesPreview({super.key, this.artwork = const AssetImage('assets/logo_blue_fill.png')});

  final ImageProvider<Object> artwork;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cover presentation', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _CoverStatePreview(
                  label: 'Artwork',
                  child: YaabsaCoverImage(
                    image: artwork,
                    width: 112,
                    height: 150,
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    semanticLabel: 'YAABSA logo cover fixture',
                    placeholder: CoverPlaceholder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _CoverStatePreview(
                  label: 'Unavailable artwork',
                  child: const YaabsaCoverImage(
                    image: null,
                    width: 112,
                    height: 150,
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    placeholder: CoverPlaceholder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CoverStatePreview extends StatelessWidget {
  const _CoverStatePreview({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
