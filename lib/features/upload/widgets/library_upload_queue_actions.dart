import 'package:material_ui/material_ui.dart';

class LibraryUploadQueueActions extends StatelessWidget {
  const LibraryUploadQueueActions({
    super.key,
    required this.isUploading,
    required this.hasQueuedItems,
    required this.onClear,
    required this.onStart,
    this.onCancel,
  });

  final bool isUploading;
  final bool hasQueuedItems;
  final VoidCallback onClear;
  final VoidCallback onStart;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final clearButton = OutlinedButton.icon(
      onPressed: isUploading ? null : onClear,
      icon: const Icon(Icons.delete_sweep_outlined),
      label: const Text('Clear queue'),
    );
    final cancelButton = FilledButton.tonalIcon(
      onPressed: onCancel,
      icon: const Icon(Icons.stop_circle_outlined),
      label: const Text('Cancel uploads'),
    );
    final startButton = FilledButton.icon(
      onPressed: !isUploading && hasQueuedItems ? onStart : null,
      icon: const Icon(Icons.cloud_upload_rounded),
      label: const Text('Start upload'),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final leadingActions = Wrap(
          key: const ValueKey<String>('uploadQueueLeadingActionsWrap'),
          spacing: 8,
          runSpacing: 8,
          children: [clearButton, if (isUploading) cancelButton],
        );
        final actions = Wrap(
          key: const ValueKey<String>('uploadQueueActionsWrap'),
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.spaceBetween,
          children: [leadingActions, startButton],
        );

        if (!constraints.maxWidth.isFinite) {
          return actions;
        }

        return SizedBox(width: constraints.maxWidth, child: actions);
      },
    );
  }
}
