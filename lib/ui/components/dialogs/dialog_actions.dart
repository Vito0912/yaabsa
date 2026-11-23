import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/buttons/yaabsa_button.dart';

class YaabsaDialogActions extends StatelessWidget {
  const YaabsaDialogActions({
    super.key,
    required this.actionLabel,
    required this.actionIcon,
    required this.onAction,
    required this.onCancel,
    this.cancelLabel = 'Cancel',
    this.isLoading = false,
    this.destructive = false,
  });

  final String actionLabel;
  final IconData actionIcon;
  final VoidCallback? onAction;
  final VoidCallback? onCancel;
  final String cancelLabel;
  final bool isLoading;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final actionStyle = destructive
        ? FilledButton.styleFrom(backgroundColor: colors.error, foregroundColor: colors.onError)
        : null;

    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 8,
      runSpacing: 8,
      children: [
        YaabsaButton(variant: YaabsaButtonVariant.text, onPressed: onCancel, label: Text(cancelLabel)),
        YaabsaButton(
          onPressed: onAction,
          style: actionStyle,
          isLoading: isLoading,
          icon: Icon(actionIcon),
          label: Text(actionLabel),
        ),
      ],
    );
  }
}
