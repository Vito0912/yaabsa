import 'package:buchshelfly/database/app_database.dart';
import 'package:buchshelfly/util/setting_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlobalPlayerSettings extends ConsumerStatefulWidget {
  const GlobalPlayerSettings({super.key});

  @override
  ConsumerState<GlobalPlayerSettings> createState() => _GlobalPlayerSettingsState();
}

class _GlobalPlayerSettingsState extends ConsumerState<GlobalPlayerSettings> {
  int? _bufferSize;

  @override
  void initState() {
    super.initState();
    _loadBufferSize();
  }

  Future<void> _loadBufferSize() async {
    final database = ref.read(appDatabaseProvider);
    final setting = (await database.getGlobalSetting(SettingKeys.bufferSize))?.value;
    setState(() {
      _bufferSize = int.tryParse(setting ?? '1048576');
    });
  }

  @override
  Widget build(BuildContext context) {
    final database = ref.watch(appDatabaseProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Player Settings'),
      ),
      body: Column(
        children: [
          if (_bufferSize != null)
            CustomLabeledSlider<int>(
              label: 'Max buffer size',
              tooltip: 'Maximum size of the buffer in bytes. This is just a hint for the player and may not be respected by the OS. No more than 5 minutes should be cac.',
              icon: Icons.info_outline,
              values: const [512 * 1024, 1024 * 1024, 2 * 1024 * 1024, 5 * 1024 * 1024, 10 * 1024 * 1024],
              valueLabels: const ['512 KB', '1 MB', '2 MB', '5 MB', '10 MB'],
              value: _bufferSize!,
              onChanged: (v) {
                setState(() {
                  _bufferSize = v;
                });
                database.setGlobalSetting(SettingKeys.bufferSize, v.toString());
              },
            ),
        ],
      ),
    );
  }
}


class CustomLabeledSlider<T> extends StatelessWidget {
  final String label;
  final String? description;
  final String? tooltip;
  final IconData? icon;
  final List<T> values;
  final List<String> valueLabels;
  final T value;
  final ValueChanged<T> onChanged;

  const CustomLabeledSlider({
    super.key,
    required this.label,
    this.description,
    this.tooltip,
    this.icon,
    required this.values,
    required this.valueLabels,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final int currentIndex = values.indexOf(value);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: Theme.of(context).textTheme.labelMedium),
              if (icon != null && tooltip != null)
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Tooltip(
                    message: tooltip!,
                    child: Icon(icon, size: 18),
                  ),
                ),
            ],
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
              child: Text(description!, style: Theme.of(context).textTheme.bodySmall),
            ),
          Slider(
            min: 0,
            max: (values.length - 1).toDouble(),
            divisions: values.length - 1,
            value: currentIndex.toDouble(),
            label: valueLabels[currentIndex],
            onChanged: (double newIndex) {
              onChanged(values[newIndex.round()]);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: valueLabels
                .map((lbl) => Text(lbl, style: Theme.of(context).textTheme.bodySmall))
                .toList(),
          ),
        ],
      ),
    );
  }
}