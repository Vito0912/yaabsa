import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/setting_key.dart';

part 'wear_preferences_provider.g.dart';

class WearPreferences {
  const WearPreferences({
    required this.speed,
    required this.rewindSeconds,
    required this.forwardSeconds,
    required this.coverBackground,
    required this.ambientMetadata,
    required this.itemProgress,
    required this.coverGrid,
    required this.flatScrolling,
  });

  final double speed;
  final int rewindSeconds;
  final int forwardSeconds;
  final bool coverBackground;
  final bool ambientMetadata;
  final bool itemProgress;
  final bool coverGrid;
  final bool flatScrolling;
}

@Riverpod(keepAlive: true)
WearPreferences wearPreferences(Ref ref) {
  T read<T>(String key, T fallback) {
    final value = ref.watch(globalSettingByKeyProvider(key)).value;
    final cached = ref.read(settingsManagerProvider.notifier).getGlobalSetting<T>(key, defaultValue: fallback);
    return SettingsParser.decodeValue(value, cached);
  }

  final speed = read<double>(SettingKeys.playbackSpeed, 1.0);
  return WearPreferences(
    speed: speed.isFinite ? speed.clamp(0.5, 3.0) : 1.0,
    rewindSeconds: read<int>(SettingKeys.rewindInterval, 15).clamp(5, 60),
    forwardSeconds: read<int>(SettingKeys.fastForwardInterval, 30).clamp(5, 60),
    coverBackground: read<bool>(SettingKeys.wearCoverBackground, true),
    ambientMetadata: read<bool>(SettingKeys.wearAmbientMetadata, true),
    itemProgress: read<bool>(SettingKeys.wearItemProgress, true),
    coverGrid: read<bool>(SettingKeys.wearCoverGrid, false),
    flatScrolling: read<bool>(SettingKeys.wearFlatScrolling, false),
  );
}
