import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/database/settings_manager.dart';

class SettingPositiveInteger extends ConsumerStatefulWidget {
  const SettingPositiveInteger({
    super.key,
    required this.settingKey,
    required this.label,
    required this.fallback,
    this.enabled = true,
  });

  final String settingKey;
  final String label;
  final int fallback;
  final bool enabled;

  @override
  ConsumerState<SettingPositiveInteger> createState() => _SettingPositiveIntegerState();
}

class _SettingPositiveIntegerState extends ConsumerState<SettingPositiveInteger> {
  final _controller = TextEditingController();
  String? _error;
  int? _displayedValue;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final value = int.tryParse(_controller.text);
    if (value == null || value < 1) {
      setState(() => _error = 'Enter a positive whole number');
      return;
    }
    setState(() => _error = null);
    await ref.read(settingsManagerProvider.notifier).setGlobalSetting<int>(widget.settingKey, value);
  }

  @override
  Widget build(BuildContext context) {
    final raw = ref.watch(globalSettingByKeyProvider(widget.settingKey)).asData?.value;
    final parsed = int.tryParse(raw ?? '');
    final value = parsed != null && parsed > 0 ? parsed : widget.fallback;
    if (_displayedValue != value) {
      _displayedValue = value;
      _controller.text = '$value';
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextField(
        controller: _controller,
        enabled: widget.enabled,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onSubmitted: (_) => _save(),
        decoration: InputDecoration(
          labelText: widget.label,
          errorText: _error,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            tooltip: 'Save',
            onPressed: widget.enabled ? _save : null,
            icon: const Icon(Icons.check),
          ),
        ),
      ),
    );
  }
}
