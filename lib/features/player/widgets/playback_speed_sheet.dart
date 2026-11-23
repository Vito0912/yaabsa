import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';

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
          Text('Playback speed', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text('${_formatSheetSpeed(_value)}x', style: Theme.of(context).textTheme.titleMedium),
          Slider(
            value: _value,
            min: PlaybackSpeedSheet.minSpeed,
            max: PlaybackSpeedSheet.maxSpeed,
            divisions: 25,
            label: '${_value.toStringAsFixed(1)}x',
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
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
            onSubmitted: (_) => _applyCustomValue(),
            label: 'Custom value',
            hintText: '0.5 - 3.0',
            suffixText: 'x',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
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
                  child: const Text('Apply'),
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

    final parsed = double.tryParse(raw);

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

  String _formatSheetSpeed(double value) {
    final roundedToTenth = (value * 10).round() / 10;

    if ((value - roundedToTenth).abs() < 0.000000001) {
      return roundedToTenth.toStringAsFixed(1);
    }

    return value.toString();
  }
}

class _PresetButton extends StatelessWidget {
  const _PresetButton({required this.value, required this.onTap});

  final double value;
  final ValueChanged<double> onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(label: Text('${value.toStringAsFixed(1)}x'), onPressed: () => onTap(value));
  }
}
