import 'package:yaabsa/util/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SpeedSlider extends StatelessWidget {
  static const double minSpeed = 0.5;
  static const double maxSpeed = 3.0;
  static const double defaultSpeed = 1.0;
  static const double step = 0.1;

  const SpeedSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: audioHandler.player.speedStream,
      initialData: defaultSpeed,
      builder: (context, snapshot) {
        final speed = (snapshot.data ?? defaultSpeed).clamp(minSpeed, maxSpeed);
        return OutlinedButton.icon(
          onPressed: () => _openSpeedSheet(context, speed),
          icon: const Icon(Icons.speed_rounded),
          label: Text('Speed ${speed.toStringAsFixed(1)}x'),
        );
      },
    );
  }

  Future<void> _openSpeedSheet(BuildContext context, double currentSpeed) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return _SpeedSheet(initialSpeed: currentSpeed);
      },
    );
  }
}

class _SpeedSheet extends StatefulWidget {
  const _SpeedSheet({required this.initialSpeed});

  final double initialSpeed;

  @override
  State<_SpeedSheet> createState() => _SpeedSheetState();
}

class _SpeedSheetState extends State<_SpeedSheet> {
  final TextEditingController _customController = TextEditingController();
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = _roundToStep(widget.initialSpeed);
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Playback speed', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text('${_value.toStringAsFixed(1)}x', style: Theme.of(context).textTheme.titleMedium),
          Slider(
            value: _value,
            min: SpeedSlider.minSpeed,
            max: SpeedSlider.maxSpeed,
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
          TextField(
            controller: _customController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$'))],
            decoration: const InputDecoration(
              labelText: 'Custom value',
              hintText: '0.5 - 3.0',
              suffixText: 'x',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _applyCustomValue(),
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
                      audioHandler.setSpeed(_value);
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
    final clamped = parsed.clamp(SpeedSlider.minSpeed, SpeedSlider.maxSpeed);
    final rounded = _roundToStep(clamped);
    setState(() {
      _value = rounded;
    });
    audioHandler.setSpeed(rounded);
    return true;
  }

  double _roundToStep(double value) {
    final normalized = (value / SpeedSlider.step).round() * SpeedSlider.step;
    return normalized.clamp(SpeedSlider.minSpeed, SpeedSlider.maxSpeed);
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
