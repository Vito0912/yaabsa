import 'package:flutter/widget_previews.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/common/cover_loading_placeholder.dart';
import 'package:yaabsa/components/common/cover_placeholder.dart';
import 'package:yaabsa/features/library/widgets/library_item_card.dart';
import 'package:yaabsa/ui/components/media/yaabsa_cover_image.dart';

import 'preview_fixtures.dart';
import 'preview_theme.dart';

@Preview(name: 'Cover loading / light', size: Size(160, 160), wrapper: yaabsaPreviewLight)
@Preview(name: 'Cover loading / dark', size: Size(160, 160), wrapper: yaabsaPreviewDark)
@Preview(name: 'Cover loading / AMOLED', size: Size(160, 160), wrapper: yaabsaPreviewAmoled)
Widget coverLoadingPreview() {
  return const Padding(padding: EdgeInsets.all(8), child: CoverLoadingPlaceholder());
}

@Preview(name: 'Loading cover cards / phone', size: Size(390, 720), wrapper: yaabsaPreviewLight)
@Preview(name: 'Loading cover cards / desktop', size: Size(1100, 720), wrapper: yaabsaPreviewDark)
Widget loadingCoverCardsPreview() => const LoadingCoverCardsPreview();

@Preview(name: 'Loading cover cards / enlarged text', size: Size(390, 720), wrapper: yaabsaPreviewLight)
Widget loadingCoverCardsEnlargedPreview() {
  return const LoadingCoverCardsPreview(textScaleFactor: 1.6);
}

class LoadingCoverCardsPreview extends StatelessWidget {
  const LoadingCoverCardsPreview({super.key, this.textScaleFactor});

  static final _items = previewSearchLibraryItems().take(25).toList(growable: false);

  final double? textScaleFactor;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final overrideScale = textScaleFactor;
    final textScaler = overrideScale == null ? mediaQuery.textScaler : TextScaler.linear(overrideScale);

    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: textScaler),
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200, mainAxisExtent: 320),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return LibraryItemCard(
            title: _items[index].title,
            cover: const AspectRatio(aspectRatio: 1, child: CoverLoadingPlaceholder()),
          );
        },
      ),
    );
  }
}

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
