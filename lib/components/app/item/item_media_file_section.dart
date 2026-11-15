import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library_items/library_file.dart';
import 'package:yaabsa/api/library_items/audio_file.dart';
import 'package:yaabsa/components/app/item/library_item_file_menu.dart';
import 'package:yaabsa/components/app/item/library_item_upload_button.dart';
import 'package:yaabsa/components/common/expressive_expandable_card.dart';
import 'package:yaabsa/ui/theme/component_styles.dart';
import 'package:yaabsa/util/item_formatters.dart';

class ItemMediaFileSection extends StatefulWidget {
  const ItemMediaFileSection({
    super.key,
    required this.itemId,
    required this.title,
    required this.files,
    this.primaryFileIno,
    this.allowUpload = false,
    this.audioFiles = const [],
  });

  final String itemId;
  final String title;
  final List<AudioFile> audioFiles;
  final List<LibraryFile> files;
  final String? primaryFileIno;
  final bool allowUpload;

  @override
  State<ItemMediaFileSection> createState() => _ItemMediaFileSectionState();
}

class _ItemMediaFileSectionState extends State<ItemMediaFileSection> {
  var _showAbsolutePaths = false;
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final audioByIno = {for (final file in widget.audioFiles) file.ino: file};
        final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
        final rowHeight = 80.0 * math.max(1, textScale);
        final minimumLabeledWidth = 340.0 * math.max(1, textScale);
        final showPathLabel = !constraints.hasBoundedWidth || constraints.maxWidth >= minimumLabeledWidth;

        return ExpressiveExpandableCard(
          title: widget.title,
          onExpansionChanged: (expanded) {
            setState(() {
              _expanded = expanded;
            });
          },
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
          initiallyExpanded: false,
          actions: [
            MediaFilePathModeButton(
              showAbsolutePaths: _showAbsolutePaths,
              compact: !showPathLabel,
              onPressed: () {
                setState(() {
                  _showAbsolutePaths = !_showAbsolutePaths;
                });
              },
            ),
          ],
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: rowHeight * 5),
              child: ListView.builder(
                primary: false,
                shrinkWrap: widget.files.length <= 5,
                padding: EdgeInsets.zero,
                itemCount: widget.files.length,
                itemBuilder: (context, index) {
                  final file = widget.files[index];
                  final metadata = file.metadata;
                  var path = metadata.relPath.isEmpty ? metadata.filename : metadata.relPath;
                  if (_showAbsolutePaths) {
                    path = metadata.path;
                  }
                  final type = file.fileType?.trim() ?? '';
                  final audio = audioByIno[file.ino];
                  final details = <String>[
                    if (type.isNotEmpty) type,
                    if (metadata.ext.isNotEmpty) metadata.ext.replaceFirst(RegExp(r'^\.'), '').toUpperCase(),
                    formatBytes(metadata.size),
                    if (audio?.duration != null) formatDurationShort(Duration(seconds: audio!.duration!.round())),
                    if (file.ino == widget.primaryFileIno) 'Primary',
                    if (file.ino != widget.primaryFileIno && file.isSupplementary == true) 'Supplementary',
                  ];

                  return ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    title: Tooltip(
                      message: path,
                      child: _FilePathTitle(path: path, filename: metadata.filename),
                    ),
                    subtitle: Text(details.join(' • '), maxLines: 1, overflow: TextOverflow.ellipsis),
                    trailing: LibraryItemFileMenu(
                      itemId: widget.itemId,
                      fileIno: file.ino,
                      metadata: metadata,
                      audioFile: audioByIno[file.ino],
                    ),
                  );
                },
              ),
            ),
            if (_expanded && widget.allowUpload) LibraryItemUploadButton(itemId: widget.itemId),
          ],
        );
      },
    );
  }
}

class MediaFilePathModeButton extends StatelessWidget {
  const MediaFilePathModeButton({
    super.key,
    required this.showAbsolutePaths,
    required this.onPressed,
    this.compact = false,
  });

  final bool showAbsolutePaths;
  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final label = showAbsolutePaths ? 'Absolute paths' : 'Relative paths';
    final button = TextButton.icon(
      style: YaabsaButtonStyles.compactFilePathAction,
      onPressed: onPressed,
      icon: Icon(showAbsolutePaths ? Icons.folder_open_rounded : Icons.insert_drive_file_rounded, size: 16),
      label: compact ? const SizedBox.shrink() : Text(label),
    );

    if (!compact) {
      return button;
    }

    return Semantics(
      label: label,
      button: true,
      child: Tooltip(message: label, child: button),
    );
  }
}

class _FilePathTitle extends StatelessWidget {
  const _FilePathTitle({required this.path, required this.filename});

  final String path;
  final String filename;

  @override
  Widget build(BuildContext context) {
    if (filename.isEmpty || !path.endsWith(filename)) {
      return Text(path, maxLines: 2, overflow: TextOverflow.ellipsis);
    }

    final directory = path.substring(0, path.length - filename.length);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: directory,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
          ),
          TextSpan(text: filename),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
