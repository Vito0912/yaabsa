import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/common/local_cover_image.dart';
import 'package:yaabsa/models/internal_download.dart';

class DownloadCoverThumbnail extends StatelessWidget {
  const DownloadCoverThumbnail({super.key, required this.download, this.size = 44});

  final InternalDownload download;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final coverPath = download.coverPath?.trim();
    final placeholder = Container(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        download.isPodcast ? Icons.podcasts_rounded : Icons.library_books_outlined,
        color: colorScheme.onSurfaceVariant,
      ),
    );
    final itemId = download.item?.id ?? download.episode?.libraryItemId ?? 'unknown';
    final episodeId = download.episode?.id ?? 'item';

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: size,
        height: size,
        child: coverPath == null || coverPath.isEmpty
            ? placeholder
            : LocalCoverImage(coverPath: coverPath, cacheKey: 'download:$itemId:$episodeId', placeholder: placeholder),
      ),
    );
  }
}
