import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/features/settings/model/setting_definition.dart';
import 'package:yaabsa/util/app_update_checker.dart' as app_update_checker;
import 'package:yaabsa/util/device_capabilities.dart';
import 'package:yaabsa/util/download_destination.dart' as download_destination;
import 'package:yaabsa/util/l10n.dart';

sealed class SettingsAvailability {
  const SettingsAvailability();

  const factory SettingsAvailability.available() = SettingsAvailable;
  const factory SettingsAvailability.hidden() = SettingsHidden;
  const factory SettingsAvailability.disabled(String reason) = SettingsDisabled;

  bool get isVisible => this is! SettingsHidden;
  bool get isEnabled => this is SettingsAvailable;

  String? get disabledReason {
    final current = this;
    if (current is SettingsDisabled) {
      return current.reason;
    }

    return null;
  }
}

final class SettingsAvailable extends SettingsAvailability {
  const SettingsAvailable();
}

final class SettingsHidden extends SettingsAvailability {
  const SettingsHidden();
}

final class SettingsDisabled extends SettingsAvailability {
  const SettingsDisabled(this.reason);

  final String reason;
}

class SettingsContext {
  const SettingsContext({
    required this.l10n,
    required this.platform,
    required this.isWeb,
    required this.isAaos,
    required this.supportsShakeActions,
    required this.supportsCustomDownloadLocation,
    required this.isAppUpdateCheckEligible,
    required this.currentUser,
    required this.readRawGlobal,
    required this.readRawUser,
  });

  final AppLocalizations l10n;
  final TargetPlatform platform;
  final bool isWeb;
  final bool isAaos;
  final bool supportsShakeActions;
  final bool supportsCustomDownloadLocation;
  final bool isAppUpdateCheckEligible;
  final User? currentUser;
  final String? Function(String key) readRawGlobal;
  final String? Function(String userId, String key) readRawUser;

  bool get isAndroid => !isWeb && platform == TargetPlatform.android;
  bool get isIOS => !isWeb && platform == TargetPlatform.iOS;
  bool get isLinux => !isWeb && platform == TargetPlatform.linux;
  bool get isWindows => !isWeb && platform == TargetPlatform.windows;
  bool get isMobilePlatform => isAndroid || isIOS;
  bool get isSignedIn => currentUser != null;
  String? get userId => currentUser?.id;

  bool get hasAnyServerManagementPermission {
    final user = currentUser;
    if (user == null) {
      return false;
    }

    return user.permissions.update || user.permissions.delete || user.permissions.upload;
  }

  bool get isAdminUser {
    final normalized = (currentUser?.type ?? '').trim().toLowerCase();
    return normalized == 'admin' || normalized == 'root';
  }

  /// Reads and decodes [definition] from the current snapshot.
  T readSetting<T>(SettingDefinition<T> definition) {
    if (definition.scope == SettingScope.account) {
      final id = userId;
      if (id == null) {
        return definition.defaultValue;
      }

      return definition.decodeRaw(readRawUser(id, definition.key));
    }

    return definition.decodeRaw(readRawGlobal(definition.key));
  }

  static SettingsContext fromEnvironment({
    required AppLocalizations l10n,
    required bool isAaos,
    required User? currentUser,
    required String? Function(String key) readRawGlobal,
    required String? Function(String userId, String key) readRawUser,
  }) {
    return SettingsContext(
      l10n: l10n,
      platform: defaultTargetPlatform,
      isWeb: kIsWeb,
      isAaos: isAaos,
      supportsShakeActions: DeviceCapabilities.supportsShakeActions,
      supportsCustomDownloadLocation: download_destination.supportsCustomDownloadLocation,
      isAppUpdateCheckEligible: app_update_checker.isAppUpdateCheckEligible,
      currentUser: currentUser,
      readRawGlobal: readRawGlobal,
      readRawUser: readRawUser,
    );
  }
}

typedef SettingsAvailabilityRule = SettingsAvailability Function(SettingsContext ctx);

SettingsAvailability alwaysAvailable(SettingsContext _) => const SettingsAvailability.available();
