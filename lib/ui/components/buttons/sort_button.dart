import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/buttons/yaabsa_button.dart';

class YaabsaSortButton extends StatelessWidget {
  const YaabsaSortButton({
    super.key,
    required this.label,
    required this.tooltip,
    required this.onPressed,
    required this.iconOnly,
    this.isLoading = false,
    this.maxLabelCharacters = 30,
  });

  final String label;
  final String tooltip;
  final VoidCallback onPressed;
  final bool iconOnly;
  final bool isLoading;
  final int maxLabelCharacters;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final buttonStyle = ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.38);
        }

        return colorScheme.primary;
      }),
    );

    if (iconOnly) {
      return YaabsaButton.iconSmall(
        tooltip: tooltip,
        onPressed: onPressed,
        variant: YaabsaButtonVariant.outlined,
        style: buttonStyle,
        isLoading: isLoading,
        icon: const Icon(Icons.sort_rounded),
      );
    }

    final buttonLabel = _truncateLabel(label);

    return YaabsaButton.small(
      tooltip: tooltip,
      onPressed: onPressed,
      variant: YaabsaButtonVariant.outlined,
      style: buttonStyle,
      isLoading: isLoading,
      icon: const Icon(Icons.sort_rounded),
      label: Text(buttonLabel, overflow: TextOverflow.ellipsis),
    );
  }

  String _truncateLabel(String value) {
    if (value.length <= maxLabelCharacters) {
      return value;
    }

    return '${value.substring(0, maxLabelCharacters - 3)}...';
  }
}
