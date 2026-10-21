import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library_items/audio_file.dart';
import 'package:yaabsa/api/library_items/chapter.dart';
import 'package:yaabsa/api/library_items/ebook_file.dart';
import 'package:yaabsa/api/library_items/library_file.dart';
import 'package:yaabsa/components/app/item/item_media_file_section.dart';
import 'package:yaabsa/components/common/expressive_expandable_card.dart';
import 'package:yaabsa/util/item_formatters.dart';

class ItemChapterRow extends StatelessWidget {
  const ItemChapterRow({
    super.key,
    required this.title,
    required this.start,
    required this.duration,
    required this.onTap,
  });

  final String title;
  final Duration start;
  final Duration duration;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Expanded(child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis)),
            SizedBox(width: 74, child: Text(formatDurationShort(start), textAlign: TextAlign.right)),
            const SizedBox(width: 10),
            SizedBox(width: 74, child: Text(formatDurationShort(duration), textAlign: TextAlign.right)),
          ],
        ),
      ),
    );
  }
}

class _ChapterTableHeader extends StatelessWidget {
  const _ChapterTableHeader();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall
        ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, letterSpacing: 0.4);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 2),
      child: Row(
        children: [
          Expanded(child: Text('Chapter', style: style)),
          SizedBox(
            width: 74,
            child: Text('Start', style: style, textAlign: TextAlign.right),
          ),
          SizedBox(
            width: 74,
            child: Text('Length', style: style, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}

class LibraryItemMediaSections extends StatelessWidget {
  const LibraryItemMediaSections({
    super.key,
    required this.itemId,
    required this.chapters,
    required this.audioFiles,
    required this.ebookFile,
    required this.libraryFiles,
    required this.onChapterTap,
  });

  final String itemId;
  final List<Chapter> chapters;
  final List<AudioFile> audioFiles;
  final EbookFile? ebookFile;
  final List<LibraryFile> libraryFiles;
  final void Function(Chapter chapter) onChapterTap;

  @override
  Widget build(BuildContext context) {
    final ebookFiles = <String, LibraryFile>{
      for (final file in libraryFiles)
        if (file.fileType?.toLowerCase() == 'ebook') file.ino: file,
    };
    final primaryEbook = ebookFile;
    if (primaryEbook != null) {
      ebookFiles.putIfAbsent(primaryEbook.ino, () {
        return LibraryFile(
          ino: primaryEbook.ino,
          metadata: primaryEbook.metadata,
          addedAt: primaryEbook.addedAt,
          updatedAt: primaryEbook.updatedAt,
          fileType: 'ebook',
          isSupplementary: false,
        );
      });
    }

    final libraryFilesByIno = {for (final file in libraryFiles) file.ino: file};
    final audioLibraryFiles = [
      for (final file in audioFiles)
        libraryFilesByIno[file.ino] ??
            LibraryFile(
              ino: file.ino,
              metadata: file.metadata,
              addedAt: file.addedAt,
              updatedAt: file.updatedAt,
              fileType: 'audio',
            ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (chapters.isNotEmpty) ...[
          const SizedBox(height: 8),
          ExpressiveExpandableCard(
            initiallyExpanded: false,
            title: 'Chapters (${chapters.length})',
            children: [
              const _ChapterTableHeader(),
              ...chapters.map(
                (chapter) => ItemChapterRow(
                  title: chapter.title,
                  start: Duration(seconds: chapter.start.round()),
                  duration: chapterDuration(chapter.start, chapter.end),
                  onTap: () => onChapterTap(chapter),
                ),
              ),
            ],
          ),
        ],
        if (audioFiles.isNotEmpty) ...[
          const SizedBox(height: 8),
          ItemMediaFileSection(
            itemId: itemId,
            title: 'Audio files (${audioFiles.length})',
            files: audioLibraryFiles,
            audioFiles: audioFiles,
          ),
        ],
        if (ebookFiles.isNotEmpty) ...[
          const SizedBox(height: 8),
          ItemMediaFileSection(
            itemId: itemId,
            title: 'Ebook files (${ebookFiles.length})',
            files: ebookFiles.values.toList(growable: false),
            primaryFileIno: ebookFile?.ino,
          ),
        ],
        if (libraryFiles.isNotEmpty) ...[
          const SizedBox(height: 8),
          ItemMediaFileSection(
            itemId: itemId,
            title: 'Library files (${libraryFiles.length})',
            files: libraryFiles,
            audioFiles: audioFiles,
            primaryFileIno: ebookFile?.ino,
          ),
        ],
      ],
    );
  }
}
