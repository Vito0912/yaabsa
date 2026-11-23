import 'package:flutter/widget_previews.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/dialogs/dialog_actions.dart';

import 'preview_theme.dart';

@Preview(name: 'Dialog actions / light', size: Size(640, 480), wrapper: yaabsaPreviewLight)
@Preview(name: 'Dialog actions / dark', size: Size(640, 480), wrapper: yaabsaPreviewDark)
@Preview(name: 'Dialog actions / AMOLED', size: Size(640, 480), wrapper: yaabsaPreviewAmoled)
Widget dialogActionsPreview() => const DialogActionsPreview();

@Preview(name: 'Destructive dialog actions / light', size: Size(640, 480), wrapper: yaabsaPreviewLight)
@Preview(name: 'Destructive dialog actions / dark', size: Size(640, 480), wrapper: yaabsaPreviewDark)
@Preview(name: 'Destructive dialog actions / AMOLED', size: Size(640, 480), wrapper: yaabsaPreviewAmoled)
Widget destructiveDialogActionsPreview() => const DialogActionsPreview(destructive: true);

class DialogActionsPreview extends StatelessWidget {
  const DialogActionsPreview({super.key, this.destructive = false});

  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final title = destructive ? 'Delete this item?' : 'Save your changes?';
    final content = destructive ? 'This action cannot be undone.' : 'Your metadata changes are ready to save.';

    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        YaabsaDialogActions(
          actionLabel: destructive ? 'Delete item' : 'Save changes',
          actionIcon: destructive ? Icons.delete_outline_rounded : Icons.save_outlined,
          onAction: _ignoreDialogAction,
          onCancel: _ignoreDialogAction,
          destructive: destructive,
        ),
      ],
    );
  }
}

void _ignoreDialogAction() {}
