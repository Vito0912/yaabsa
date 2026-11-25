import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/util/l10n.dart';

class PlaybackSpeedSheet extends StatefulWidget {
  const PlaybackSpeedSheet({super.key, required this.initialSpeed, required this.onApplySpeed});

  static const double minSpeed = 0.5;
  static const double maxSpeed = 3.0;
  static const double defaultSpeed = 1.0;
  static const double step = 0.1;

  final double initialSpeed;
  final ValueChanged<double> onApplySpeed;

  @override
  State<PlaybackSpeedSheet> createState() => _PlaybackSpeedSheetState();
}

class _PlaybackSpeedSheetState extends State<PlaybackSpeedSheet> {
  final TextEditingController _customController = TextEditingController();
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = _clampSpeed(widget.initialSpeed);
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.playbackSpeed, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(_formatSpeedMultiplier(context, _value), style: Theme.of(context).textTheme.titleMedium),
          Slider(
            value: _value,
            min: PlaybackSpeedSheet.minSpeed,
            max: PlaybackSpeedSheet.maxSpeed,
            divisions: 25,
            label: _formatSpeedMultiplier(context, _value),
            onChanged: (newValue) {
              setState(() {
                _value = _roundToStep(newValue);
              });
            },
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _PresetButton(value: 0.8, onTap: _setValue),
              _PresetButton(value: 1.0, onTap: _setValue),
              _PresetButton(value: 1.2, onTap: _setValue),
              _PresetButton(value: 1.5, onTap: _setValue),
              _PresetButton(value: 2.0, onTap: _setValue),
            ],
          ),
          const SizedBox(height: 12),
          StyledTextField(
            controller: _customController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onSubmitted: (_) => _applyCustomValue(),
            label: context.l10n.speedCustomValue,
            hintText: context.l10n.speedRangeHint(PlaybackSpeedSheet.minSpeed, PlaybackSpeedSheet.maxSpeed),
            suffixText: 'x',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(context.l10n.actionCancel),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    final didApplyCustom = _applyCustomValue();

                    if (!didApplyCustom) {
                      widget.onApplySpeed(_value);
                    }

                    Navigator.of(context).pop();
                  },
                  child: Text(context.l10n.actionApply),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _setValue(double value) {
    setState(() {
      _value = _roundToStep(value);
      _customController.clear();
    });
  }

  bool _applyCustomValue() {
    final raw = _customController.text.trim();

    if (raw.isEmpty) {
      return false;
    }

    final locale = Localizations.localeOf(context).toLanguageTag();
    final parsed = NumberFormat.decimalPattern(locale).tryParse(raw)?.toDouble();

    if (parsed == null) {
      return false;
    }

    final clamped = _clampSpeed(parsed);

    setState(() {
      _value = clamped;
    });
    widget.onApplySpeed(clamped);

    return true;
  }

  double _clampSpeed(double value) {
    return value.clamp(PlaybackSpeedSheet.minSpeed, PlaybackSpeedSheet.maxSpeed).toDouble();
  }

  double _roundToStep(double value) {
    final normalized = (value / PlaybackSpeedSheet.step).round() * PlaybackSpeedSheet.step;

    return _clampSpeed(normalized);
  }
}

class _PresetButton extends StatelessWidget {
  const _PresetButton({required this.value, required this.onTap});

  final double value;
  final ValueChanged<double> onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(label: Text(_formatSpeedMultiplier(context, value)), onPressed: () => onTap(value));
  }
}

String _formatSpeedMultiplier(BuildContext context, double value) {
  return context.l10n.playbackSpeedMultiplier(value);
}
