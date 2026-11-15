import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

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
    final isIconOnly = iconOnly;
    final buttonStyle = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll<Size>(Size(48, 48)),
      maximumSize: isIconOnly ? const WidgetStatePropertyAll<Size>(Size(48, 48)) : null,
      padding: isIconOnly ? const WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.zero) : null,
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.38);
        }

        return colorScheme.primary;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        final color = states.contains(WidgetState.disabled)
            ? colorScheme.onSurface.withValues(alpha: 0.12)
            : colorScheme.primary;
        return BorderSide(color: color);
      }),
    );

    if (iconOnly) {
      return Tooltip(
        message: tooltip,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: isLoading
              ? const SizedBox(width: 16, height: 16, child: YaabsaCircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.sort_rounded),
        ),
      );
    }

    final buttonLabel = _truncateLabel(label);

    return Tooltip(
      message: tooltip,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        icon: isLoading
            ? const SizedBox(width: 16, height: 16, child: YaabsaCircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.sort_rounded),
        label: Text(buttonLabel, overflow: TextOverflow.ellipsis),
      ),
    );
  }

  String _truncateLabel(String value) {
    if (value.length <= maxLabelCharacters) {
      return value;
    }

    return '${value.substring(0, maxLabelCharacters - 3)}...';
  }
}
