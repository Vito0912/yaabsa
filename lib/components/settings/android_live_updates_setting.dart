import 'package:background_downloader/background_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/android_live_updates.dart';
import 'package:yaabsa/util/setting_key.dart';

class AndroidLiveUpdatesSetting extends ConsumerStatefulWidget {
  const AndroidLiveUpdatesSetting({super.key});

  @override
  ConsumerState<AndroidLiveUpdatesSetting> createState() => _AndroidLiveUpdatesSettingState();
}

class _AndroidLiveUpdatesSettingState extends ConsumerState<AndroidLiveUpdatesSetting> {
  late final Future<bool> _supported = AndroidLiveUpdates.supported;
  bool _unavailable = false;
  bool _saving = false;

  Future<void> _setMode(String value) async {
    if (!mounted || _saving) return;
    setState(() => _saving = true);
    try {
      if (value != AndroidLiveUpdateMode.off.name) {
        if (!await AndroidLiveUpdates.supported) {
          if (mounted) setState(() => _unavailable = true);
          await AndroidLiveUpdates.clear();
          return;
        }
        if (!mounted) return;
        await FileDownloader().permissions.request(PermissionType.notifications);
        if (!mounted) return;
        if (!await AndroidLiveUpdates.supported) {
          if (mounted) setState(() => _unavailable = true);
          await AndroidLiveUpdates.clear();
          return;
        }
      }
      if (!mounted) return;
      await ref.read(settingsManagerProvider.notifier).setGlobalSetting<String>(SettingKeys.androidLiveUpdates, value);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_unavailable) return const SizedBox.shrink();
    final setting = ref.watch(globalSettingByKeyProvider(SettingKeys.androidLiveUpdates));
    return FutureBuilder<bool>(
      future: _supported,
      builder: (context, snapshot) {
        if (snapshot.data != true) return const SizedBox.shrink();
        return SettingDropdown<String>.remote(
          label: 'Live Updates',
          description: 'Show playback progress in Android status bar',
          values: AndroidLiveUpdateMode.values.map((mode) => mode.name).toList(),
          valueLabels: AndroidLiveUpdateMode.values.map((mode) => mode.label).toList(),
          value: AndroidLiveUpdateMode.fromSettingValue(setting.value).name,
          onValueChanged: _setMode,
          isLoading: setting.isLoading || _saving,
        );
      },
    );
  }
}
