import 'package:yaabsa/features/settings/model/setting_definition.dart';
import 'package:yaabsa/util/app_update_checker.dart';
import 'package:yaabsa/util/setting_key.dart';

class AppSystemSettingDefs {
  const AppSystemSettingDefs._();

  static const readerFontFamily = SettingDefinition<String>(
    key: SettingKeys.readerFontFamily,
    scope: SettingScope.app,
    defaultValue: 'publisher',
  );

  static const readerFontSizeMultiplier = SettingDefinition<double>(
    key: SettingKeys.readerFontSizeMultiplier,
    scope: SettingScope.app,
    defaultValue: 1.0,
  );

  static const readerLineHeight = SettingDefinition<double>(
    key: SettingKeys.readerLineHeight,
    scope: SettingScope.app,
    defaultValue: 1.5,
  );

  static const readerPageMargin = SettingDefinition<double>(
    key: SettingKeys.readerPageMargin,
    scope: SettingScope.app,
    defaultValue: 32.0,
  );

  static const readerPageWidth = SettingDefinition<double>(
    key: SettingKeys.readerPageWidth,
    scope: SettingScope.app,
    defaultValue: 720.0,
  );

  static const readerTextAlignment = SettingDefinition<String>(
    key: SettingKeys.readerTextAlignment,
    scope: SettingScope.app,
    defaultValue: 'publisher',
  );

  static const readerLetterSpacing = SettingDefinition<double>(
    key: SettingKeys.readerLetterSpacing,
    scope: SettingScope.app,
    defaultValue: 0.0,
  );

  static const readerLayout = SettingDefinition<String>(
    key: SettingKeys.readerLayout,
    scope: SettingScope.app,
    defaultValue: 'paginated_2',
  );

  static const readerHideMiniPlayer = SettingDefinition<bool>(
    key: SettingKeys.readerHideMiniPlayer,
    scope: SettingScope.app,
    defaultValue: false,
  );

  static const readerStartSession = SettingDefinition<bool>(
    key: SettingKeys.readerStartSession,
    scope: SettingScope.app,
    defaultValue: false,
  );

  static const language = SettingDefinition<String>(
    key: SettingKeys.language,
    scope: SettingScope.app,
    defaultValue: 'system',
  );

  static const caching = SettingDefinition<bool>(key: SettingKeys.caching, scope: SettingScope.app, defaultValue: true);

  static const boostLoading = SettingDefinition<bool>(
    key: SettingKeys.boostLoading,
    scope: SettingScope.app,
    defaultValue: true,
  );

  static const checkForAppUpdates = SettingDefinition<bool>(
    key: appUpdateSettingKey,
    scope: SettingScope.app,
    defaultValue: false,
  );

  static const checkForServerUpdates = SettingDefinition<bool>(
    key: SettingKeys.checkForServerUpdates,
    scope: SettingScope.app,
    defaultValue: false,
  );
}
