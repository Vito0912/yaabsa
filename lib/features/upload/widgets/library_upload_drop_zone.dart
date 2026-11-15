import 'package:material_ui/material_ui.dart';

class LibraryUploadDropZone extends StatelessWidget {
  const LibraryUploadDropZone({
    super.key,
    required this.supportsDragDrop,
    required this.isDropHovering,
    required this.enabled,
    required this.onChooseFiles,
    this.onChooseFolder,
  });

  final bool supportsDragDrop;
  final bool isDropHovering;
  final bool enabled;
  final VoidCallback onChooseFiles;
  final VoidCallback? onChooseFolder;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final allowsFolders = onChooseFolder != null;
    final String description;
    if (supportsDragDrop) {
      description = allowsFolders
          ? 'Drop files or folders here, or choose them below.'
          : 'Drop files here, or choose them below.';
    } else {
      description = allowsFolders ? 'Choose files or a folder below.' : 'Choose files below.';
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDropHovering ? colorScheme.primary : colorScheme.outlineVariant.withValues(alpha: 0.6),
          width: isDropHovering ? 1.6 : 1,
        ),
        color: isDropHovering
            ? colorScheme.primaryContainer.withValues(alpha: 0.28)
            : colorScheme.surfaceContainerLowest,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(isDropHovering ? Icons.move_to_inbox_rounded : Icons.upload_file_rounded, size: 26),
          const SizedBox(height: 8),
          Text(description, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: enabled ? onChooseFiles : null,
                icon: const Icon(Icons.file_open_rounded),
                label: const Text('Choose files'),
              ),
              if (allowsFolders)
                OutlinedButton.icon(
                  onPressed: enabled ? onChooseFolder : null,
                  icon: const Icon(Icons.folder_open_rounded),
                  label: const Text('Choose folder'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
