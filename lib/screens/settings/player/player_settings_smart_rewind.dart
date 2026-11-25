import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/screens/settings/player/player_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/extensions.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/setting_key.dart';

const _shortPauseThresholdValues = [15, 30, 45, 60, 90, 120, 180, 300];
const _longPauseThresholdValues = [300, 600, 900, 1200, 1800, 2700, 3600];
const _shortRewindValues = [3, 5, 10, 15, 20, 30];
const _mediumRewindValues = [10, 15, 20, 30, 45, 60];
const _longRewindValues = [20, 30, 45, 60, 90, 120];

class PlayerSettingsSmartRewind extends ConsumerWidget {
  const PlayerSettingsSmartRewind({super.key});

  static const String routeName = '/settings/player/smart-rewind';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final smartRewindSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.smartRewindEnabled)).asData?.value;
    final smartRewindDefault = defaultSettings[SettingKeys.smartRewindEnabled] as bool? ?? false;
    final smartRewindEnabled = SettingsParser.decodeValue<bool>(smartRewindSetting, smartRewindDefault);

    return SettingsPageScaffold(
      title: context.l10n.settingSmartRewind,
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: PlayerSettings.routeName,
      children: [
        SettingsNavigationSection(
          title: context.l10n.settingSmartRewind,
          topPadding: 0,
          settings: [
            SettingSwitchTile(
              label: context.l10n.settingSmartRewind,
              subtitle: context.l10n.settingSmartRewindDescription,
              settingKey: SettingKeys.smartRewindEnabled,
            ),
            SettingSlider<int>(
              label: context.l10n.settingShortPauseThreshold,
              description: context.l10n.settingShortPauseThresholdDescription,
              disabledReason: context.l10n.permissionEnableSettingToChangeOption(context.l10n.settingSmartRewind),
              values: _shortPauseThresholdValues,
              valueLabels: _shortPauseThresholdValues
                  .map((seconds) => Duration(seconds: seconds).toCompactRemainingString(localizations: context.l10n))
                  .toList(growable: false),
              settingKey: SettingKeys.smartRewindShortPauseThresholdSeconds,
              enabled: smartRewindEnabled,
            ),
            SettingSlider<int>(
              label: context.l10n.settingLongPauseThreshold,
              description: context.l10n.settingLongPauseThresholdDescription,
              disabledReason: context.l10n.permissionEnableSettingToChangeOption(context.l10n.settingSmartRewind),
              values: _longPauseThresholdValues,
              valueLabels: _longPauseThresholdValues
                  .map((seconds) => Duration(seconds: seconds).toCompactRemainingString(localizations: context.l10n))
                  .toList(growable: false),
              settingKey: SettingKeys.smartRewindLongPauseThresholdSeconds,
              enabled: smartRewindEnabled,
            ),
            SettingSlider<int>(
              label: context.l10n.settingShortRewindAmount,
              description: context.l10n.settingShortRewindAmountDescription,
              disabledReason: context.l10n.permissionEnableSettingToChangeOption(context.l10n.settingSmartRewind),
              values: _shortRewindValues,
              valueLabels: _shortRewindValues
                  .map((seconds) => Duration(seconds: seconds).toCompactRemainingString(localizations: context.l10n))
                  .toList(growable: false),
              settingKey: SettingKeys.smartRewindShortRewindSeconds,
              enabled: smartRewindEnabled,
            ),
            SettingSlider<int>(
              label: context.l10n.settingMediumRewindAmount,
              description: context.l10n.settingMediumRewindAmountDescription,
              disabledReason: context.l10n.permissionEnableSettingToChangeOption(context.l10n.settingSmartRewind),
              values: _mediumRewindValues,
              valueLabels: _mediumRewindValues
                  .map((seconds) => Duration(seconds: seconds).toCompactRemainingString(localizations: context.l10n))
                  .toList(growable: false),
              settingKey: SettingKeys.smartRewindMediumRewindSeconds,
              enabled: smartRewindEnabled,
            ),
            SettingSlider<int>(
              label: context.l10n.settingLongRewindAmount,
              description: context.l10n.settingLongRewindAmountDescription,
              disabledReason: context.l10n.permissionEnableSettingToChangeOption(context.l10n.settingSmartRewind),
              values: _longRewindValues,
              valueLabels: _longRewindValues
                  .map((seconds) => Duration(seconds: seconds).toCompactRemainingString(localizations: context.l10n))
                  .toList(growable: false),
              settingKey: SettingKeys.smartRewindLongRewindSeconds,
              enabled: smartRewindEnabled,
            ),
          ],
        ),
      ],
    );
  }
}
