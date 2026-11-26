import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/lists/settings_control_label.dart';

class SettingsTimeOfDayPresentation extends StatelessWidget {
  const SettingsTimeOfDayPresentation({
    super.key,
    required this.label,
    required this.minutesOfDay,
    required this.onChanged,
    this.description,
    this.icon,
    this.tooltip,
    this.enabled = true,
  });

  final String label;
  final int minutesOfDay;
  final ValueChanged<int>? onChanged;
  final String? description;
  final IconData? icon;
  final String? tooltip;
  final bool enabled;

  String _formatTime(BuildContext context) {
    final normalized = ((minutesOfDay % (24 * 60)) + (24 * 60)) % (24 * 60);
    final dateTime = DateTime(2000).add(Duration(minutes: normalized));
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.jm(locale).format(dateTime);
  }

  Future<void> _pickTime(BuildContext context) async {
    final normalized = ((minutesOfDay % (24 * 60)) + (24 * 60)) % (24 * 60);
    final initialTime = TimeOfDay(hour: normalized ~/ 60, minute: normalized % 60);

    final picked = await showTimePicker(context: context, initialTime: initialTime);

    if (picked == null) {
      return;
    }

    onChanged?.call(picked.hour * 60 + picked.minute);
  }

  bool _fitsInline(BuildContext context, double maxWidth, String formattedTime) {
    if (!maxWidth.isFinite) {
      return true;
    }

    final theme = Theme.of(context);
    final textScaler = MediaQuery.textScalerOf(context);
    final textScale = textScaler.scale(1);
    final pillStyle = theme.textTheme.labelLarge ?? const TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
    final painter = TextPainter(
      text: TextSpan(text: formattedTime, style: pillStyle),
      maxLines: 1,
      textDirection: Directionality.of(context),
      textScaler: textScaler,
    )..layout();

    final pillWidth = painter.width + 24.0;
    final minLabelWidth = 150.0 * textScale;
    return maxWidth >= minLabelWidth + 16.0 + pillWidth;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEnabled = enabled && onChanged != null;
    final formattedTime = _formatTime(context);

    final labelWidget = SettingsControlLabel(
      label: label,
      description: description,
      enabled: isEnabled,
      icon: icon,
      tooltip: tooltip,
    );

    final timeChip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isEnabled ? colorScheme.secondaryContainer : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        formattedTime,
        style: theme.textTheme.labelLarge?.copyWith(
          color: isEnabled ? colorScheme.onSecondaryContainer : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    return InkWell(
      onTap: isEnabled ? () => _pickTime(context) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (_fitsInline(context, constraints.maxWidth, formattedTime)) {
              return Row(
                children: [
                  Expanded(child: labelWidget),
                  const SizedBox(width: 16),
                  timeChip,
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                labelWidget,
                const SizedBox(height: 10),
                Align(alignment: AlignmentDirectional.centerEnd, child: timeChip),
              ],
            );
          },
        ),
      ),
    );
  }
}
