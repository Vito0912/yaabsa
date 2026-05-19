import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yaabsa/util/item_formatters.dart';

import 'package:yaabsa/generated/l10n.dart';

class SessionDurationPickerField extends StatelessWidget {
  const SessionDurationPickerField({
    required this.label,
    required this.seconds,
    required this.enabled,
    required this.onChanged,
    super.key,
  });

  final String label;
  final double? seconds;
  final bool enabled;
  final ValueChanged<double> onChanged;

  Future<void> _openPicker(BuildContext context) async {
    if (!enabled) {
      return;
    }

    final pickedSeconds = await showDialog<int>(
      context: context,
      builder: (context) {
        return _SessionDurationPickerDialog(title: label, initialSeconds: (seconds ?? 0).round());
      },
    );

    if (pickedSeconds == null) {
      return;
    }

    onChanged(pickedSeconds.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    final valueLabel = _formatDuration(seconds);

    return InkWell(
      onTap: enabled ? () => _openPicker(context) : null,
      borderRadius: BorderRadius.circular(10),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
          suffixIcon: const Icon(Icons.timer_outlined),
          enabled: enabled,
        ),
        child: Text(valueLabel, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }

  String _formatDuration(double? value) {
    final totalSeconds = (value ?? 0).round();
    final duration = Duration(seconds: totalSeconds);
    return formatDurationShort(duration);
  }
}

class _SessionDurationPickerDialog extends StatefulWidget {
  const _SessionDurationPickerDialog({required this.title, required this.initialSeconds});

  final String title;
  final int initialSeconds;

  @override
  State<_SessionDurationPickerDialog> createState() => _SessionDurationPickerDialogState();
}

class _SessionDurationPickerDialogState extends State<_SessionDurationPickerDialog> {
  late int _hours;
  late int _minutes;
  late int _seconds;

  @override
  void initState() {
    super.initState();
    final duration = Duration(seconds: widget.initialSeconds < 0 ? 0 : widget.initialSeconds);
    _hours = duration.inHours;
    _minutes = duration.inMinutes.remainder(60);
    _seconds = duration.inSeconds.remainder(60);
  }

  @override
  Widget build(BuildContext context) {
    final availableWidth = MediaQuery.of(context).size.width;
    final dialogWidth = availableWidth > 460 ? 420.0 : (availableWidth - 36).clamp(280.0, 420.0).toDouble();

    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: dialogWidth,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 360;
            final targetWidth = isCompact ? ((constraints.maxWidth - 10) / 2) : ((constraints.maxWidth - 20) / 3);
            final stepperWidth = targetWidth.clamp(110.0, 136.0).toDouble();

            return Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                _DurationStepper(
                  label: S.current.componentsSessionsSessionDurationPickerFieldHours,
                  width: stepperWidth,
                  value: _hours,
                  onDecrement: _hours > 0
                      ? () {
                          setState(() {
                            _hours -= 1;
                          });
                        }
                      : null,
                  onIncrement: () {
                    setState(() {
                      _hours += 1;
                    });
                  },
                ),
                _DurationStepper(
                  label: S.current.componentsSessionsSessionDurationPickerFieldMinutes,
                  width: stepperWidth,
                  value: _minutes,
                  padLeft: true,
                  onDecrement: () {
                    setState(() {
                      _minutes = _minutes == 0 ? 59 : _minutes - 1;
                    });
                  },
                  onIncrement: () {
                    setState(() {
                      _minutes = _minutes == 59 ? 0 : _minutes + 1;
                    });
                  },
                ),
                _DurationStepper(
                  label: S.current.componentsSessionsSessionDurationPickerFieldSeconds,
                  width: stepperWidth,
                  value: _seconds,
                  padLeft: true,
                  onDecrement: () {
                    setState(() {
                      _seconds = _seconds == 0 ? 59 : _seconds - 1;
                    });
                  },
                  onIncrement: () {
                    setState(() {
                      _seconds = _seconds == 59 ? 0 : _seconds + 1;
                    });
                  },
                ),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(S.current.componentsSessionsSessionDurationPickerFieldCancel),
        ),
        FilledButton(
          onPressed: () {
            final totalSeconds = (_hours * 3600) + (_minutes * 60) + _seconds;
            Navigator.of(context).pop(totalSeconds);
          },
          child: Text(S.current.componentsSessionsSessionDurationPickerFieldSet),
        ),
      ],
    );
  }
}

class _DurationStepper extends StatelessWidget {
  const _DurationStepper({
    required this.label,
    required this.width,
    required this.value,
    required this.onIncrement,
    this.onDecrement,
    this.padLeft = false,
  });

  final String label;
  final double width;
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback? onDecrement;
  final bool padLeft;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final displayValue = padLeft
        ? NumberFormat('00', locale).format(value)
        : NumberFormat.decimalPattern(locale).format(value);

    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 34, height: 34),
                onPressed: onDecrement,
                icon: const Icon(Icons.remove_circle_outline_rounded),
              ),
              SizedBox(
                width: 34,
                child: Text(displayValue, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 34, height: 34),
                onPressed: onIncrement,
                icon: const Icon(Icons.add_circle_outline_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
