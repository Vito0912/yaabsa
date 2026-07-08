import 'dart:math';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/setting_key.dart';

part 'server_update_provider.g.dart';

class ServerUpdateInfo {
  final bool isUpdateAvailable;
  final String currentVersion;
  final String latestVersion;
  final bool isDismissed;

  const ServerUpdateInfo({
    required this.isUpdateAvailable,
    required this.currentVersion,
    required this.latestVersion,
    required this.isDismissed,
  });

  ServerUpdateInfo copyWith({
    bool? isUpdateAvailable,
    String? currentVersion,
    String? latestVersion,
    bool? isDismissed,
  }) {
    return ServerUpdateInfo(
      isUpdateAvailable: isUpdateAvailable ?? this.isUpdateAvailable,
      currentVersion: currentVersion ?? this.currentVersion,
      latestVersion: latestVersion ?? this.latestVersion,
      isDismissed: isDismissed ?? this.isDismissed,
    );
  }
}

class _VersionFetchResult {
  final String? version;
  final bool isRateLimited;
  final int? rateLimitResetMs;

  const _VersionFetchResult({this.version, this.isRateLimited = false, this.rateLimitResetMs});
}

@Riverpod(keepAlive: true)
class ServerUpdateState extends _$ServerUpdateState {
  @override
  FutureOr<ServerUpdateInfo?> build() async {
    final currentUser = ref.watch(currentUserProvider).value;
    ref.watch(settingsManagerProvider);
    ref.watch(userSettingsWatcherProvider);

    if (currentUser == null) return null;

    final type = currentUser.type.trim().toLowerCase();
    final isAdminOrRoot = type == 'admin' || type == 'root';
    if (!isAdminOrRoot) return null;

    final settingsManager = ref.read(settingsManagerProvider.notifier);
    final checkForUpdates = settingsManager.getGlobalSetting<bool>(
      SettingKeys.checkForServerUpdates,
      defaultValue: false,
    );

    if (!checkForUpdates) return null;

    final currentVersion = currentUser.setting?.version;
    if (currentVersion == null || currentVersion.trim().isEmpty) return null;

    final nextCheckAllowed = settingsManager.getGlobalSetting<int>(
      SettingKeys.nextServerVersionCheckAllowed,
      defaultValue: 0,
    );
    final savedLatestVersion = settingsManager.getGlobalSetting<String>(
      SettingKeys.latestServerVersion,
      defaultValue: '',
    );

    final now = DateTime.now().millisecondsSinceEpoch;
    final needsCheck = now >= nextCheckAllowed;

    String? latestVersion;
    if (!needsCheck) {
      latestVersion = savedLatestVersion;
    } else {
      final result = await _fetchLatestABSVersion();
      if (result.version != null) {
        latestVersion = result.version;
        await settingsManager.setGlobalSetting<String>(SettingKeys.latestServerVersion, latestVersion!);
        await settingsManager.setGlobalSetting<int>(SettingKeys.nextServerVersionCheckAllowed, now + 60 * 60 * 1000);
      } else {
        if (result.isRateLimited) {
          final resetTime = result.rateLimitResetMs ?? (now + 60 * 60 * 1000);
          await settingsManager.setGlobalSetting<int>(SettingKeys.nextServerVersionCheckAllowed, resetTime);
        } else {
          await settingsManager.setGlobalSetting<int>(SettingKeys.nextServerVersionCheckAllowed, now + 5 * 60 * 1000);
        }

        if (savedLatestVersion.isNotEmpty) {
          latestVersion = savedLatestVersion;
        }
      }
    }

    if (latestVersion == null || latestVersion.isEmpty) return null;

    final updateAvailable = _isUpdateAvailable(currentVersion, latestVersion);

    final dismissedVersion = settingsManager.getUserSetting<String>(
      currentUser.id,
      SettingKeys.dismissedUpdateServerVersion,
      defaultValue: '',
    );
    final isDismissed = (dismissedVersion == latestVersion);

    return ServerUpdateInfo(
      isUpdateAvailable: updateAvailable,
      currentVersion: currentVersion,
      latestVersion: latestVersion,
      isDismissed: isDismissed,
    );
  }

  Future<void> dismiss() async {
    final stateValue = state.value;
    if (stateValue == null) return;

    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) return;

    await ref
        .read(settingsManagerProvider.notifier)
        .setUserSetting<String>(currentUser.id, SettingKeys.dismissedUpdateServerVersion, stateValue.latestVersion);
  }

  Future<_VersionFetchResult> _fetchLatestABSVersion() async {
    final dio = Dio();
    try {
      logger(
        'Fetching latest Audiobookshelf release from GitHub API...',
        tag: 'ServerUpdateProvider',
        level: InfoLevel.info,
      );
      final response = await dio.get<Map<String, dynamic>>(
        'https://api.github.com/repos/advplyr/audiobookshelf/releases/latest',
        options: Options(
          headers: {'Accept': 'application/vnd.github.v3+json', 'User-Agent': 'Yaabsa-App'},
          responseType: ResponseType.json,
        ),
      );
      final data = response.data;
      if (data != null && data.containsKey('tag_name')) {
        return _VersionFetchResult(version: data['tag_name']?.toString());
      }
    } on DioException catch (e, s) {
      final isRateLimited = e.response?.statusCode == 403;
      int? rateLimitResetMs;
      if (isRateLimited) {
        final resetHeader = e.response?.headers.value('x-ratelimit-reset');
        if (resetHeader != null) {
          final resetEpochSeconds = int.tryParse(resetHeader);
          if (resetEpochSeconds != null) {
            rateLimitResetMs = resetEpochSeconds * 1000;
          }
        }
      }
      logger(
        'Failed to fetch latest ABS version from GitHub (Rate Limited: $isRateLimited): $e\n$s',
        tag: 'ServerUpdateProvider',
        level: InfoLevel.warning,
      );
      return _VersionFetchResult(isRateLimited: isRateLimited, rateLimitResetMs: rateLimitResetMs);
    } catch (e, s) {
      logger(
        'Failed to fetch latest ABS version from GitHub: $e\n$s',
        tag: 'ServerUpdateProvider',
        level: InfoLevel.warning,
      );
    } finally {
      dio.close();
    }
    return const _VersionFetchResult();
  }

  bool _isUpdateAvailable(String currentVersion, String latestVersion) {
    String cleanCurrent = currentVersion.trim().toLowerCase();
    if (cleanCurrent.startsWith('v')) {
      cleanCurrent = cleanCurrent.substring(1);
    }
    String cleanLatest = latestVersion.trim().toLowerCase();
    if (cleanLatest.startsWith('v')) {
      cleanLatest = cleanLatest.substring(1);
    }

    final currentParts = cleanCurrent.split('-').first.split('.');
    final latestParts = cleanLatest.split('-').first.split('.');

    for (int i = 0; i < max(currentParts.length, latestParts.length); i++) {
      final currentPart = i < currentParts.length ? int.tryParse(currentParts[i]) ?? 0 : 0;
      final latestPart = i < latestParts.length ? int.tryParse(latestParts[i]) ?? 0 : 0;

      if (latestPart > currentPart) {
        return true;
      } else if (currentPart > latestPart) {
        return false;
      }
    }
    return false;
  }
}
