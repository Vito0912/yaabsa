import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

@immutable
class LibraryFolderEditorEntry {
  const LibraryFolderEditorEntry({required this.path, this.id});

  final String path;
  final String? id;

  bool get isExisting => id != null && id!.trim().isNotEmpty;
}

class LibraryFolderListEditor extends StatelessWidget {
  const LibraryFolderListEditor({
    super.key,
    required this.folders,
    required this.newFolderPathController,
    required this.onAddFolderPressed,
    required this.onRemoveFolderPressed,
    this.onBrowseFolderPressed,
    this.isBrowsing = false,
    this.errorText,
    this.enabled = true,
  });

  final List<LibraryFolderEditorEntry> folders;
  final TextEditingController newFolderPathController;
  final VoidCallback onAddFolderPressed;
  final ValueChanged<LibraryFolderEditorEntry> onRemoveFolderPressed;
  final Future<void> Function()? onBrowseFolderPressed;
  final bool isBrowsing;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.l10n.headingFolders, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        if (folders.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.34)),
            ),
            child: Text(
              context.l10n.statusNoFoldersAdded,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          )
        else
          Column(
            children: [
              for (final folder in folders)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: colorScheme.surfaceContainerLow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      leading: const Icon(Icons.folder_outlined),
                      title: Text(folder.path, overflow: TextOverflow.ellipsis),
                      subtitle: folder.isExisting
                          ? Text(
                              context.l10n.statusExistingFolder,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: colorScheme.onSurfaceVariant),
                            )
                          : null,
                      trailing: IconButton(
                        tooltip: context.l10n.actionRemove,
                        onPressed: enabled ? () => onRemoveFolderPressed(folder) : null,
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        StyledTextField(
          label: context.l10n.fieldAddFolderPath,
          controller: newFolderPathController,
          hintText: '/media/audiobooks',
          enabled: enabled,
          onSubmitted: (_) {
            if (!enabled) {
              return;
            }
            onAddFolderPressed();
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: enabled && onBrowseFolderPressed != null && !isBrowsing
                  ? () => onBrowseFolderPressed!.call()
                  : null,
              icon: isBrowsing
                  ? const SizedBox(width: 14, height: 14, child: YaabsaCircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.folder_open_rounded),
              label: Text(context.l10n.browseServerFolders),
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: enabled ? onAddFolderPressed : null,
              icon: const Icon(Icons.add_rounded),
              label: Text(context.l10n.actionAddFolder),
            ),
          ],
        ),
        if (errorText != null && errorText!.trim().isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(errorText!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.error)),
        ],
      ],
    );
  }
}
