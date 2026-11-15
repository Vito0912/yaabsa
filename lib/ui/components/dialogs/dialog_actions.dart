import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

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
        TextButton(onPressed: onCancel, child: Text(cancelLabel)),
        FilledButton.icon(
          onPressed: isLoading ? null : onAction,
          style: actionStyle,
          icon: isLoading
              ? const SizedBox.square(dimension: 16, child: YaabsaCircularProgressIndicator(strokeWidth: 2))
              : Icon(actionIcon),
          label: Text(actionLabel),
        ),
      ],
    );
  }
}
