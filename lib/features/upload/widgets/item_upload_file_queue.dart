import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/upload/library_upload_models.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/ui/components/cards/surface_card.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/byte_format.dart';
import 'package:yaabsa/util/l10n.dart';

class ItemUploadFileQueue extends StatelessWidget {
  const ItemUploadFileQueue({super.key, required this.items, required this.enabled, required this.onRemoveFile});

  final List<UploadItemDraft> items;
  final bool enabled;
  final void Function(int itemId, UploadPickedFile file) onRemoveFile;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return YaabsaSurfaceCard(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final item in items) ...[
            for (final file in item.uploadFiles)
              ListTile(
                key: ValueKey(file.absolutePath),
                leading: Icon(
                  file.kind == UploadFileKind.item ? Icons.audio_file_outlined : Icons.insert_drive_file_outlined,
                ),
                title: Text(file.fileName, maxLines: 2, overflow: TextOverflow.ellipsis),
                subtitle: Text(item.status.label(context.l10n)),
                trailing: YaabsaDeleteIconButton(
                  tooltip: context.l10n.removeNamedItem(file.fileName),
                  onPressed: enabled ? () => onRemoveFile(item.id, file) : null,
                ),
              ),
            if (item.status == UploadItemStatus.uploading)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    YaabsaLinearProgressIndicator(value: item.progress.clamp(0, 1)),
                    const SizedBox(height: 4),
                    Text(
                      '${formatByteProgress(transferredBytes: item.uploadedBytes, totalBytes: item.totalBytes)} | ${formatByteRate(item.uploadSpeedBytesPerSecond)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            if (item.message != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  item.message!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: item.status == UploadItemStatus.failed ? colors.error : colors.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
