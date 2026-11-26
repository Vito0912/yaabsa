import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/setting_key.dart';

class LocalLogSettingsSection extends StatelessWidget {
  const LocalLogSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SettingsNavigationSection(
      title: l10n.settingsCategoryLogs,
      topPadding: 0,
      showSectionTitle: false,
      settings: [
        SettingDropdown<String>(
          label: l10n.settingLogLevel,
          description: l10n.settingLogLevelDescription,
          values: InfoLevel.values.map((e) => e.toString()).toList(),
          valueLabels: InfoLevel.values
              .map((level) {
                return switch (level) {
                  InfoLevel.debug => l10n.logLevelDebug,
                  InfoLevel.info => l10n.logLevelInfo,
                  InfoLevel.warning => l10n.statusWarning,
                  InfoLevel.error => l10n.logLevelError,
                };
              })
              .toList(growable: false),
          valueDescriptions: [
            l10n.logLevelDebugDescription,
            l10n.logLevelInfoDescription,
            l10n.logLevelWarningDescription,
            l10n.logLevelErrorDescription,
          ],
          settingKey: SettingKeys.appLogLevel,
        ),
      ],
    );
  }
}
