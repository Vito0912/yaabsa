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

@Riverpod(keepAlive: true)
class ServerUpdateState extends _$ServerUpdateState {
  static String? _cachedLatestVersion;

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

    String? latestVersion = _cachedLatestVersion;
    if (latestVersion == null) {
      latestVersion = await _fetchLatestABSVersion();
      if (latestVersion != null) {
        _cachedLatestVersion = latestVersion;
      }
    }
    if (latestVersion == null) return null;

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

  Future<String?> _fetchLatestABSVersion() async {
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
        return data['tag_name']?.toString();
      }
    } catch (e, s) {
      logger(
        'Failed to fetch latest ABS version from GitHub: $e\n$s',
        tag: 'ServerUpdateProvider',
        level: InfoLevel.warning,
      );
    } finally {
      dio.close();
    }
    return null;
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
