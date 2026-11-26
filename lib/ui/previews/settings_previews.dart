import 'package:flutter/widget_previews.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/settings_button.dart';
import 'package:yaabsa/features/settings/model/setting_definition.dart';
import 'package:yaabsa/features/settings/model/settings_spec.dart';
import 'package:yaabsa/features/settings/widgets/settings_action_presentation.dart';
import 'package:yaabsa/features/settings/widgets/settings_choice_presentation.dart';
import 'package:yaabsa/features/settings/widgets/settings_control_status_presentation.dart';
import 'package:yaabsa/features/settings/widgets/settings_multi_choice_presentation.dart';
import 'package:yaabsa/features/settings/widgets/settings_number_presentation.dart';
import 'package:yaabsa/features/settings/widgets/settings_scope_badge.dart';
import 'package:yaabsa/features/settings/widgets/settings_segmented_presentation.dart';
import 'package:yaabsa/features/settings/widgets/settings_slider_presentation.dart';
import 'package:yaabsa/features/settings/widgets/settings_time_of_day_presentation.dart';
import 'package:yaabsa/ui/components/settings/settings_switch_presentation.dart';

import 'preview_theme.dart';

@Preview(name: 'Settings controls / light', size: Size(640, 680), wrapper: yaabsaPreviewLight)
@Preview(name: 'Settings controls / dark', size: Size(640, 680), wrapper: yaabsaPreviewDark)
@Preview(name: 'Settings controls / AMOLED', size: Size(640, 680), wrapper: yaabsaPreviewAmoled)
Widget settingsControlsPreview() => const SettingsControlsPreview();

class SettingsControlsPreview extends StatefulWidget {
  const SettingsControlsPreview({super.key});

  @override
  State<SettingsControlsPreview> createState() => _SettingsControlsPreviewState();
}

class _SettingsControlsPreviewState extends State<SettingsControlsPreview> {
  bool _wifiOnly = true;
  bool _includeArtwork = false;
  bool _notifications = true;
  int _quality = 2;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        SettingButton(
          label: 'Export preferences',
          description: 'Save a local copy of your preferences',
          buttonText: 'Export',
          buttonIcon: Icons.save_alt,
          onPressed: () {},
        ),
        const SettingButton(label: 'Unavailable action', buttonText: 'Export'),
        const SettingButton(label: 'Saving preferences', buttonText: 'Save', isLoading: true),
        SettingsSwitchPresentation(
          label: 'Wi-Fi only',
          description: 'Use Wi-Fi for automatic downloads',
          value: _wifiOnly,
          icon: Icons.wifi_rounded,
          tooltip: 'Download network preference',
          onChanged: (value) => setState(() => _wifiOnly = value),
        ),
        const SettingsSwitchPresentation(
          label: 'Unavailable setting',
          description: 'This option is not available for this account',
          value: false,
          enabled: false,
          onChanged: null,
        ),
        const SettingsSwitchPresentation(
          label: 'Saving setting',
          description: 'Applying your preference',
          value: true,
          isLoading: true,
          onChanged: null,
        ),
        const SettingsControlStatusPresentation(
          label: 'Loading remote setting',
          state: SettingsControlLoadState.loading,
        ),
        const SettingsControlStatusPresentation(
          label: 'Unavailable remote setting',
          state: SettingsControlLoadState.error,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SettingsSliderPresentation<int>(
            label: 'Download quality',
            description: 'Choose a balance between size and fidelity',
            values: const [0, 1, 2, 3, 4],
            valueLabels: const ['Small', 'Low', 'Balanced', 'High', 'Maximum'],
            value: _quality,
            icon: Icons.high_quality_outlined,
            tooltip: 'Download quality',
            onChanged: (value) => setState(() => _quality = value),
          ),
        ),
        SettingsSwitchPresentation(
          label: 'Include cover artwork',
          value: _includeArtwork,
          onChanged: (value) => setState(() => _includeArtwork = value),
        ),
        SettingsSwitchPresentation(
          label: 'Notify when complete',
          value: _notifications,
          onChanged: (value) => setState(() => _notifications = value),
        ),
      ],
    );
  }
}

@Preview(name: 'Settings extended controls / light', size: Size(640, 1080), wrapper: yaabsaPreviewLight)
@Preview(name: 'Settings extended controls / dark', size: Size(640, 1080), wrapper: yaabsaPreviewDark)
@Preview(name: 'Settings extended controls / AMOLED', size: Size(640, 1080), wrapper: yaabsaPreviewAmoled)
Widget settingsExtendedControlsPreview() => const SettingsExtendedControlsPreview();

class SettingsExtendedControlsPreview extends StatefulWidget {
  const SettingsExtendedControlsPreview({super.key});

  @override
  State<SettingsExtendedControlsPreview> createState() => _SettingsExtendedControlsPreviewState();
}

class _SettingsExtendedControlsPreviewState extends State<SettingsExtendedControlsPreview> {
  String _timerMode = 'minutes';
  String _layoutMode = 'adaptive';
  String _language = 'en';
  Set<String> _selectedDevices = const <String>{'bt-headphones'};
  int _autoRestartStartMinutes = 21 * 60;
  int _autoMinutes = 30;

  static const _timerModeOptions = <SettingsChoiceOption<String>>[
    SettingsChoiceOption(value: 'minutes', label: 'Minutes', icon: Icons.timer_outlined),
    SettingsChoiceOption(value: 'chapters', label: 'Chapters', icon: Icons.menu_book_outlined),
  ];

  static const _layoutModeOptions = <SettingsChoiceOption<String>>[
    SettingsChoiceOption(
      value: 'adaptive',
      label: 'Adaptive',
      description: 'Switches layout automatically for compact and wide screens',
    ),
    SettingsChoiceOption(value: 'custom', label: 'Custom', description: 'Uses your saved component placement profile'),
  ];

  static const _languageOptions = <SettingsChoiceOption<String>>[
    SettingsChoiceOption(value: 'system', label: 'System default'),
    SettingsChoiceOption(value: 'en', label: 'English'),
    SettingsChoiceOption(value: 'de', label: 'Deutsch'),
    SettingsChoiceOption(value: 'es', label: 'Español'),
    SettingsChoiceOption(value: 'fr', label: 'Français'),
    SettingsChoiceOption(value: 'it', label: 'Italiano'),
    SettingsChoiceOption(value: 'nl', label: 'Nederlands'),
    SettingsChoiceOption(value: 'pl', label: 'Polski'),
    SettingsChoiceOption(value: 'pt', label: 'Português'),
    SettingsChoiceOption(value: 'sv', label: 'Svenska'),
  ];

  static const _bluetoothDeviceOptions = <SettingsChoiceOption<String>>[
    SettingsChoiceOption(
      value: 'bt-headphones',
      label: 'Commute Headphones',
      description: '00:11:22:33:44:55',
      icon: Icons.headphones_rounded,
    ),
    SettingsChoiceOption(
      value: 'bt-car',
      label: 'Car Audio',
      description: '00:11:22:33:44:66',
      icon: Icons.directions_car_rounded,
    ),
    SettingsChoiceOption(
      value: 'bt-speaker',
      label: 'Living Room Speaker',
      description: '00:11:22:33:44:77',
      icon: Icons.speaker_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SettingsScopeBadge(scope: SettingScope.app),
              SettingsScopeBadge(scope: SettingScope.account),
              SettingsScopeBadge(scope: SettingScope.server),
            ],
          ),
        ),
        SettingsSegmentedPresentation<String>(
          label: 'Sleep timer mode',
          description: 'Choose whether the auto-restart timer counts minutes or chapters',
          options: _timerModeOptions,
          value: _timerMode,
          onChanged: (value) {
            setState(() {
              _timerMode = value;
            });
          },
        ),
        SettingsChoicePresentation<String>(
          label: 'Full player layout',
          description: 'Select how controls are arranged on the playback screen',
          presentation: SettingsChoicePresentationMode.inlineRadio,
          options: _layoutModeOptions,
          value: _layoutMode,
          onChanged: (value) {
            setState(() {
              _layoutMode = value;
            });
          },
        ),
        SettingsChoicePresentation<String>(
          label: 'Display language',
          description: 'Choose the language used throughout yaabsa',
          presentation: SettingsChoicePresentationMode.searchableDialog,
          options: _languageOptions,
          value: _language,
          onChanged: (value) {
            setState(() {
              _language = value;
            });
          },
        ),
        SettingsMultiChoicePresentation<String>(
          label: 'Bluetooth audio devices',
          description: 'Auto-resume playback only when these paired devices connect',
          options: _bluetoothDeviceOptions,
          selectedValues: _selectedDevices,
          onChanged: (values) {
            setState(() {
              _selectedDevices = values;
            });
          },
        ),
        SettingsTimeOfDayPresentation(
          label: 'Auto-restart window start',
          description: 'Begin automatic sleep timer restarts after this time',
          minutesOfDay: _autoRestartStartMinutes,
          onChanged: (minutes) {
            setState(() {
              _autoRestartStartMinutes = minutes;
            });
          },
        ),
        SettingsNumberPresentation(
          label: 'Sleep timer duration',
          description: 'Default duration used when auto-restart triggers',
          value: _autoMinutes,
          min: 1,
          max: 1440,
          unitLabel: 'min',
          onChanged: (minutes) {
            setState(() {
              _autoMinutes = minutes;
            });
          },
        ),
        SettingsActionPresentation(
          label: 'Check for updates',
          description: 'Verify if a newer release of yaabsa is available',
          buttonLabel: 'Check',
          buttonIcon: Icons.system_update_rounded,
          onPressed: () {},
        ),
        SettingsActionPresentation(
          label: 'Clear cached responses',
          description: 'Remove locally cached server responses from this device',
          buttonLabel: 'Clear',
          buttonIcon: Icons.delete_outline_rounded,
          isDestructive: true,
          onPressed: () {},
        ),
      ],
    );
  }
}
