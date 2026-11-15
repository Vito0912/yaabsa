import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

class TextboxButton extends StatelessWidget {
  const TextboxButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final buttonChild = isLoading
        ? SizedBox(
            width: 16,
            height: 16,
            child: YaabsaCircularProgressIndicator(strokeWidth: 2, color: colorScheme.onPrimary),
          )
        : Icon(icon);

    return SizedBox(
      height: 52,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        child: Row(mainAxisSize: MainAxisSize.min, spacing: 8, children: [buttonChild, Text(label)]),
      ),
    );
  }
}
