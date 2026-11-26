import 'package:yaabsa/features/settings/model/setting_definition.dart';
import 'package:yaabsa/screens/player/layout/player_presentation_config.dart';
import 'package:yaabsa/util/audio_handler/playback_keep_alive_level.dart';
import 'package:yaabsa/util/bluetooth_auto_resume.dart';
import 'package:yaabsa/util/setting_key.dart';

String _decodeSeekBarMode(String raw) => PlayerSeekBarMode.fromSettingValue(raw).name;

String _decodeSeekBarMarkerMode(String raw) => SeekBarMarkerMode.fromSettingValue(raw).name;

String _decodeSleepTimerExpireAction(String raw) => SleepTimerExpireAction.fromSettingValue(raw).name;

String _decodeMediaNotificationType(String raw) => MediaNotificationType.fromSettingValue(raw).name;

String _decodeKeepAliveLevel(String raw) => PlaybackKeepAliveLevel.fromSettingValue(raw).name;

String _decodeTransportMode(String raw) => PlayerTransportMode.fromSettingValue(raw).name;

String _decodeAdaptivePreset(String raw) => PlayerAdaptivePreset.fromSettingValue(raw).name;

String _decodeCoverSize(String raw) => PlayerCoverSize.fromSettingValue(raw).name;

String _decodeMobileLeftAction(String raw) =>
    decodeOptionalPlayerAction(raw, fallback: defaultMobilePlayerLeftAction)?.name ?? 'none';

String _decodeMobileRightAction(String raw) =>
    decodeOptionalPlayerAction(raw, fallback: defaultMobilePlayerRightAction)?.name ?? 'none';

Set<String> _decodeBluetoothAddresses(String raw) => decodeBluetoothDeviceAddresses(raw);

String _encodeBluetoothAddresses(Set<String> addresses) => encodeBluetoothDeviceAddresses(addresses);

class PlayerSettingDefs {
  const PlayerSettingDefs._();

  static const playerSeekBarMode = SettingDefinition<String>(
    key: SettingKeys.playerSeekBarMode,
    scope: SettingScope.app,
    defaultValue: 'full',
    decode: _decodeSeekBarMode,
  );

  static const playerSeekBarMarkerMode = SettingDefinition<String>(
    key: SettingKeys.playerSeekBarMarkerMode,
    scope: SettingScope.app,
    defaultValue: 'both',
    decode: _decodeSeekBarMarkerMode,
  );

  static const fullPlayerTransportMode = SettingDefinition<String>(
    key: SettingKeys.fullPlayerTransportMode,
    scope: SettingScope.app,
    defaultValue: 'both',
    decode: _decodeTransportMode,
  );

  static const mobilePlayerLeftAction = SettingDefinition<String>(
    key: SettingKeys.mobilePlayerLeftAction,
    scope: SettingScope.app,
    defaultValue: 'speed',
    decode: _decodeMobileLeftAction,
  );

  static const mobilePlayerRightAction = SettingDefinition<String>(
    key: SettingKeys.mobilePlayerRightAction,
    scope: SettingScope.app,
    defaultValue: 'sleepTimer',
    decode: _decodeMobileRightAction,
  );

  static const miniPlayerTransportMode = SettingDefinition<String>(
    key: SettingKeys.miniPlayerTransportMode,
    scope: SettingScope.app,
    defaultValue: 'both',
    decode: _decodeTransportMode,
  );

  static const fastForwardInterval = SettingDefinition<int>(
    key: SettingKeys.fastForwardInterval,
    scope: SettingScope.app,
    defaultValue: 10,
  );

  static const rewindInterval = SettingDefinition<int>(
    key: SettingKeys.rewindInterval,
    scope: SettingScope.app,
    defaultValue: 10,
  );

  static const playbackSpeedPerBook = SettingDefinition<bool>(
    key: SettingKeys.playbackSpeedPerBook,
    scope: SettingScope.app,
    defaultValue: false,
  );

  static const startPlaybackFromLocalProgress = SettingDefinition<bool>(
    key: SettingKeys.startPlaybackFromLocalProgress,
    scope: SettingScope.app,
    defaultValue: false,
  );

  static const restartListeningSessionAtMidnight = SettingDefinition<bool>(
    key: SettingKeys.restartListeningSessionAtMidnight,
    scope: SettingScope.app,
    defaultValue: true,
  );

  static const desktopSkipControlsSeek = SettingDefinition<bool>(
    key: SettingKeys.desktopSkipControlsSeek,
    scope: SettingScope.app,
    defaultValue: false,
  );

  static const preventWordClipping = SettingDefinition<String>(
    key: SettingKeys.preventWordClipping,
    scope: SettingScope.app,
    defaultValue: 'off',
    decode: _decodeKeepAliveLevel,
  );

  static const skipSilence = SettingDefinition<bool>(
    key: SettingKeys.skipSilence,
    scope: SettingScope.app,
    defaultValue: false,
  );

  static const autoQueue = SettingDefinition<bool>(
    key: SettingKeys.autoQueue,
    scope: SettingScope.app,
    defaultValue: true,
  );

  static const autoQueueIncludeSeriesOutsideContext = SettingDefinition<bool>(
    key: SettingKeys.autoQueueIncludeSeriesOutsideContext,
    scope: SettingScope.app,
    defaultValue: false,
  );

  static const showPlayerLoopShuffle = SettingDefinition<String>(
    key: SettingKeys.showPlayerLoopShuffle,
    scope: SettingScope.app,
    defaultValue: 'music_only',
  );

  static const autoResumeOnBluetoothConnection = SettingDefinition<bool>(
    key: SettingKeys.autoResumeOnBluetoothConnection,
    scope: SettingScope.app,
    defaultValue: false,
  );

  static const restrictAutoResumeToSelectedBluetoothDevices = SettingDefinition<bool>(
    key: SettingKeys.restrictAutoResumeToSelectedBluetoothDevices,
    scope: SettingScope.app,
    defaultValue: false,
  );

  static const autoResumeBluetoothDeviceAddresses = SettingDefinition<Set<String>>(
    key: SettingKeys.autoResumeBluetoothDeviceAddresses,
    scope: SettingScope.app,
    defaultValue: <String>{},
    decode: _decodeBluetoothAddresses,
    encode: _encodeBluetoothAddresses,
  );

  static const playerLayoutMode = SettingDefinition<String>(
    key: SettingKeys.playerLayoutMode,
    scope: SettingScope.app,
    defaultValue: '',
  );

  static const playerLayoutModeExplicit = SettingDefinition<bool>(
    key: SettingKeys.playerLayoutModeExplicit,
    scope: SettingScope.app,
    defaultValue: false,
  );

  static const playerLayoutConfig = SettingDefinition<String>(
    key: SettingKeys.playerLayoutConfig,
    scope: SettingScope.app,
    defaultValue: '',
  );

  static const playerAdaptivePreset = SettingDefinition<String>(
    key: SettingKeys.playerAdaptivePreset,
    scope: SettingScope.app,
    defaultValue: 'full',
    decode: _decodeAdaptivePreset,
  );

  static const playerCoverSize = SettingDefinition<String>(
    key: SettingKeys.playerCoverSize,
    scope: SettingScope.app,
    defaultValue: 'automatic',
    decode: _decodeCoverSize,
  );

  static const playerImmersiveColors = SettingDefinition<bool>(
    key: SettingKeys.playerImmersiveColors,
    scope: SettingScope.app,
    defaultValue: true,
  );

  static const audioAnnouncementMode = SettingDefinition<String>(
    key: SettingKeys.audioAnnouncementMode,
    scope: SettingScope.app,
    defaultValue: 'duck',
  );

  static const bufferSize = SettingDefinition<int>(
    key: SettingKeys.bufferSize,
    scope: SettingScope.app,
    defaultValue: 5 * 1024 * 1024,
  );

  static final keepScreenOn = SettingDefinition<bool>(
    key: SettingKeys.keepScreenOn,
    scope: SettingScope.app,
    defaultValue: (defaultSettings[SettingKeys.keepScreenOn] as bool?) ?? false,
  );

  static const autoPlayLastPlayedOnLaunch = SettingDefinition<bool>(
    key: SettingKeys.autoPlayLastPlayedOnLaunch,
    scope: SettingScope.app,
    defaultValue: false,
  );

  static const showLastPlayedMiniPlayerAlways = SettingDefinition<bool>(
    key: SettingKeys.showLastPlayedMiniPlayerAlways,
    scope: SettingScope.app,
    defaultValue: false,
  );

  static final keepWebsocketConnectionInBackground = SettingDefinition<bool>(
    key: SettingKeys.keepWebsocketConnectionInBackground,
    scope: SettingScope.app,
    defaultValue: (defaultSettings[SettingKeys.keepWebsocketConnectionInBackground] as bool?) ?? true,
  );

  static const lockMediaNotification = SettingDefinition<bool>(
    key: SettingKeys.lockMediaNotification,
    scope: SettingScope.app,
    defaultValue: false,
  );

  static const mediaNotificationType = SettingDefinition<String>(
    key: SettingKeys.mediaNotificationType,
    scope: SettingScope.app,
    defaultValue: 'full',
    decode: _decodeMediaNotificationType,
  );

  static const smartRewindEnabled = SettingDefinition<bool>(
    key: SettingKeys.smartRewindEnabled,
    scope: SettingScope.app,
    defaultValue: false,
  );

  static const smartRewindShortPauseThresholdSeconds = SettingDefinition<int>(
    key: SettingKeys.smartRewindShortPauseThresholdSeconds,
    scope: SettingScope.app,
    defaultValue: 60,
  );

  static const smartRewindLongPauseThresholdSeconds = SettingDefinition<int>(
    key: SettingKeys.smartRewindLongPauseThresholdSeconds,
    scope: SettingScope.app,
    defaultValue: 900,
  );

  static const smartRewindShortRewindSeconds = SettingDefinition<int>(
    key: SettingKeys.smartRewindShortRewindSeconds,
    scope: SettingScope.app,
    defaultValue: 5,
  );

  static const smartRewindMediumRewindSeconds = SettingDefinition<int>(
    key: SettingKeys.smartRewindMediumRewindSeconds,
    scope: SettingScope.app,
    defaultValue: 30,
  );

  static const smartRewindLongRewindSeconds = SettingDefinition<int>(
    key: SettingKeys.smartRewindLongRewindSeconds,
    scope: SettingScope.app,
    defaultValue: 60,
  );

  static const sleepTimerExpireAction = SettingDefinition<String>(
    key: SettingKeys.sleepTimerExpireAction,
    scope: SettingScope.app,
    defaultValue: 'pause',
    decode: _decodeSleepTimerExpireAction,
  );

  static const sleepTimerAutoRewindMinutes = SettingDefinition<int>(
    key: SettingKeys.sleepTimerAutoRewindMinutes,
    scope: SettingScope.app,
    defaultValue: 0,
  );

  static const sleepTimerFadeOutEnabled = SettingDefinition<bool>(
    key: SettingKeys.sleepTimerFadeOutEnabled,
    scope: SettingScope.app,
    defaultValue: true,
  );

  static const sleepTimerShowMarker = SettingDefinition<bool>(
    key: SettingKeys.sleepTimerShowMarker,
    scope: SettingScope.app,
    defaultValue: false,
  );

  static const sleepTimerAutoRestartEnabled = SettingDefinition<bool>(
    key: SettingKeys.sleepTimerAutoRestartEnabled,
    scope: SettingScope.app,
    defaultValue: false,
  );

  static const sleepTimerAutoMode = SettingDefinition<String>(
    key: SettingKeys.sleepTimerAutoMode,
    scope: SettingScope.app,
    defaultValue: 'minutes',
  );

  static const sleepTimerAutoMinutes = SettingDefinition<int>(
    key: SettingKeys.sleepTimerAutoMinutes,
    scope: SettingScope.app,
    defaultValue: 0,
  );

  static const sleepTimerAutoChapters = SettingDefinition<int>(
    key: SettingKeys.sleepTimerAutoChapters,
    scope: SettingScope.app,
    defaultValue: 1,
  );

  static const sleepTimerLastDurationMinutes = SettingDefinition<int>(
    key: SettingKeys.sleepTimerLastDurationMinutes,
    scope: SettingScope.app,
    defaultValue: 30,
  );

  static const sleepTimerAutoRestartUseTimeRange = SettingDefinition<bool>(
    key: SettingKeys.sleepTimerAutoRestartUseTimeRange,
    scope: SettingScope.app,
    defaultValue: false,
  );

  static const sleepTimerAutoRestartRangeStartMinutes = SettingDefinition<int>(
    key: SettingKeys.sleepTimerAutoRestartRangeStartMinutes,
    scope: SettingScope.app,
    defaultValue: 21 * 60,
  );

  static const sleepTimerAutoRestartRangeEndMinutes = SettingDefinition<int>(
    key: SettingKeys.sleepTimerAutoRestartRangeEndMinutes,
    scope: SettingScope.app,
    defaultValue: 7 * 60,
  );

  static const subtitlesEnabled = SettingDefinition<bool>(
    key: SettingKeys.subtitlesEnabled,
    scope: SettingScope.account,
    defaultValue: false,
  );

  static const subtitleSpeakerHighlighting = SettingDefinition<bool>(
    key: SettingKeys.subtitleSpeakerHighlighting,
    scope: SettingScope.account,
    defaultValue: true,
  );

  static const subtitleReadAlong = SettingDefinition<bool>(
    key: SettingKeys.subtitleReadAlong,
    scope: SettingScope.account,
    defaultValue: true,
  );

  static const shakeToResetSleepTimer = SettingDefinition<bool>(
    key: SettingKeys.shakeToResetSleepTimer,
    scope: SettingScope.app,
    defaultValue: true,
  );

  static const shakeToRewind = SettingDefinition<bool>(
    key: SettingKeys.shakeToRewind,
    scope: SettingScope.app,
    defaultValue: false,
  );

  static const shakeSensitivity = SettingDefinition<double>(
    key: SettingKeys.shakeSensitivity,
    scope: SettingScope.app,
    defaultValue: 2.0,
  );

  static const shakeVibrate = SettingDefinition<bool>(
    key: SettingKeys.shakeVibrate,
    scope: SettingScope.app,
    defaultValue: true,
  );

  static const disableFdkAacDecoder = SettingDefinition<bool>(
    key: SettingKeys.disableFdkAacDecoder,
    scope: SettingScope.app,
    defaultValue: false,
  );

  static const enableIndexSeeking = SettingDefinition<bool>(
    key: SettingKeys.enableIndexSeeking,
    scope: SettingScope.app,
    defaultValue: false,
  );
}
