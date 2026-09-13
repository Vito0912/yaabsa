import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/app_update_checker.dart';

abstract interface class AppUpdateStateStore {
  int get nextCheckAllowed;
  String get skippedVersion;

  Future<void> setNextCheckAllowed(int value);
  Future<void> setSkippedVersion(String value);
}

class SettingsManagerAppUpdateStateStore implements AppUpdateStateStore {
  static const String nextCheckAllowedKey = 'next_app_update_check_allowed';
  static const String skippedVersionKey = 'skipped_app_update_version';

  final SettingsManager _settingsManager;

  const SettingsManagerAppUpdateStateStore(this._settingsManager);

  @override
  int get nextCheckAllowed => _settingsManager.getGlobalSetting<int>(nextCheckAllowedKey, defaultValue: 0);

  @override
  String get skippedVersion => _settingsManager.getGlobalSetting<String>(skippedVersionKey, defaultValue: '');

  @override
  Future<void> setNextCheckAllowed(int value) {
    return _settingsManager.setGlobalSetting<int>(nextCheckAllowedKey, value);
  }

  @override
  Future<void> setSkippedVersion(String value) {
    return _settingsManager.setGlobalSetting<String>(skippedVersionKey, value);
  }
}

class AppUpdateCoordinator {
  static const Duration successCooldown = Duration(hours: 6);
  static const Duration failureCooldown = Duration(hours: 1);

  final AppUpdateChecker _checker;
  final AppUpdateStateStore _stateStore;
  final int Function() _nowMs;

  factory AppUpdateCoordinator({
    required AppUpdateChecker checker,
    required AppUpdateStateStore stateStore,
    int Function()? nowMs,
  }) => AppUpdateCoordinator._(checker, stateStore, nowMs ?? (() => DateTime.now().millisecondsSinceEpoch));

  AppUpdateCoordinator._(this._checker, this._stateStore, this._nowMs);

  Future<AppUpdateCheckResult?> checkIfDue(String currentVersion) async {
    final now = _nowMs();
    if (now < _stateStore.nextCheckAllowed) {
      return null;
    }

    final result = await _checker.check(currentVersion);
    await _stateStore.setNextCheckAllowed(_nextCheckAllowed(result, now));
    return result;
  }

  bool shouldNotify(AppUpdateCheckResult result) {
    final latestVersion = result.latestVersion;
    return result.status == AppUpdateCheckStatus.success &&
        result.isUpdateAvailable &&
        latestVersion != null &&
        !isSkippedVersion(latestVersion);
  }

  bool isSkippedVersion(String latestVersion) {
    return _normalizeVersion(_stateStore.skippedVersion) == _normalizeVersion(latestVersion);
  }

  Future<void> skipVersion(String latestVersion) {
    return _stateStore.setSkippedVersion(_normalizeVersion(latestVersion));
  }

  static int _nextCheckAllowed(AppUpdateCheckResult result, int now) {
    switch (result.status) {
      case AppUpdateCheckStatus.success:
        return now + successCooldown.inMilliseconds;
      case AppUpdateCheckStatus.rateLimited:
        final reset = result.rateLimitResetMs;
        if (reset != null && reset > now) {
          return reset;
        }
        return now + failureCooldown.inMilliseconds;
      case AppUpdateCheckStatus.failed:
        return now + failureCooldown.inMilliseconds;
    }
  }

  static String _normalizeVersion(String version) {
    final trimmed = version.trim();
    if (trimmed.startsWith('v') || trimmed.startsWith('V')) {
      return trimmed.substring(1);
    }
    return trimmed;
  }
}
