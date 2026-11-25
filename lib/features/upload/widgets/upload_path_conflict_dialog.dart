import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/ui/components/dialogs/dialog_actions.dart';

class UploadPathConflictDialog extends StatelessWidget {
  const UploadPathConflictDialog({super.key, required this.conflicts});

  final List<String> conflicts;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.uploadPathIssuesTitle),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.uploadPathIssuesPrompt),
            const SizedBox(height: 8),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: conflicts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('- ${conflicts[index]}', style: Theme.of(context).textTheme.bodySmall),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        YaabsaDialogActions(
          cancelLabel: 'Cancel upload',
          actionLabel: 'Continue anyway',
          actionIcon: Icons.cloud_upload_rounded,
          onCancel: () => Navigator.of(context).pop(false),
          onAction: () => Navigator.of(context).pop(true),
        ),
      ],
    );
  }
}
