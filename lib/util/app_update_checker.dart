import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/services.dart' show appFlavor;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:yaabsa/util/logger.dart';

const String appUpdateSettingKey = 'check_for_app_updates';
const bool _isDirectDistribution = bool.fromEnvironment('YAABSA_DIRECT_DISTRIBUTION', defaultValue: false);

bool get isAppUpdateCheckEligible => AppUpdateEligibility.isEligible(
  isWeb: kIsWeb,
  platform: defaultTargetPlatform,
  isDirectDistribution: _isDirectDistribution,
  flavor: appFlavor,
);

class AppUpdateEligibility {
  const AppUpdateEligibility._();

  static bool isEligible({
    required bool isWeb,
    required TargetPlatform platform,
    required bool isDirectDistribution,
    String? flavor,
  }) {
    if (isWeb) return false;
    if (platform == TargetPlatform.linux) return true;
    return platform == TargetPlatform.android && isDirectDistribution && flavor == 'auto';
  }
}

class AppUpdateCandidate {
  final String currentVersion;
  final String latestVersion;
  final Uri releaseUri;

  const AppUpdateCandidate({required this.currentVersion, required this.latestVersion, required this.releaseUri});
}

typedef AppUpdateConsentReader = Future<bool> Function();

class AppUpdateChecker {
  static const String latestReleaseUrl = 'https://api.github.com/repos/Vito0912/yaabsa/releases/latest';
  static final RegExp _installedVersionPattern = RegExp(r'^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$');
  static final RegExp _releaseTagPattern = RegExp(r'^v(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$');

  final HttpClientAdapter Function()? adapterFactory;
  final Duration timeout;

  const AppUpdateChecker({this.adapterFactory, this.timeout = const Duration(seconds: 5)});

  Future<AppUpdateCandidate?> check({
    required String currentVersion,
    required AppUpdateConsentReader hasConsent,
  }) async {
    final parsedCurrent = _parseInstalledVersion(currentVersion);
    if (parsedCurrent == null) {
      logger(
        'Skipping app update check because the installed version is invalid: $currentVersion',
        tag: 'AppUpdateChecker',
        level: InfoLevel.warning,
      );
      return null;
    }

    final dio = Dio(BaseOptions(connectTimeout: timeout, sendTimeout: timeout, receiveTimeout: timeout));

    final factory = adapterFactory;
    if (factory != null) {
      dio.httpClientAdapter = factory();
    }
    dio.httpClientAdapter = _ConsentCheckingAdapter(dio.httpClientAdapter, hasConsent);

    try {
      final response = await dio
          .get<Map<String, dynamic>>(
            latestReleaseUrl,
            options: Options(
              headers: const {'Accept': 'application/vnd.github+json', 'User-Agent': 'Yaabsa-App'},
              responseType: ResponseType.json,
              followRedirects: false,
              maxRedirects: 0,
              validateStatus: (status) => status == 200,
            ),
          )
          .timeout(timeout);

      final tagName = response.data?['tag_name'];
      if (tagName is! String) {
        logger(
          'GitHub latest-release response did not contain a string tag_name.',
          tag: 'AppUpdateChecker',
          level: InfoLevel.warning,
        );
        return null;
      }

      final parsedLatest = _parseReleaseTag(tagName);
      if (parsedLatest == null) {
        logger(
          'Skipping app update notification because the latest release tag is invalid: $tagName',
          tag: 'AppUpdateChecker',
          level: InfoLevel.warning,
        );
        return null;
      }

      if (_compareVersions(parsedLatest, parsedCurrent) <= 0) {
        return null;
      }

      final latestVersion = tagName.substring(1);
      return AppUpdateCandidate(
        currentVersion: currentVersion,
        latestVersion: latestVersion,
        releaseUri: Uri.https('github.com', '/Vito0912/yaabsa/releases/tag/$tagName'),
      );
    } on DioException catch (e, s) {
      logger(
        'App update check failed without affecting startup: $e\n$s',
        tag: 'AppUpdateChecker',
        level: InfoLevel.warning,
      );
      return null;
    } catch (e, s) {
      logger(
        'App update check failed without affecting startup: $e\n$s',
        tag: 'AppUpdateChecker',
        level: InfoLevel.warning,
      );
      return null;
    } finally {
      dio.close(force: true);
    }
  }

  static bool isUpdateAvailable(String currentVersion, String releaseTag) {
    final current = _parseInstalledVersion(currentVersion);
    final latest = _parseReleaseTag(releaseTag);
    return current != null && latest != null && _compareVersions(latest, current) > 0;
  }

  static _ParsedVersion? _parseInstalledVersion(String value) => _parseVersion(value, _installedVersionPattern);

  static _ParsedVersion? _parseReleaseTag(String value) => _parseVersion(value, _releaseTagPattern);

  static _ParsedVersion? _parseVersion(String value, RegExp pattern) {
    final match = pattern.firstMatch(value);
    if (match == null) return null;

    final major = int.tryParse(match.group(1)!);
    final minor = int.tryParse(match.group(2)!);
    final patch = int.tryParse(match.group(3)!);
    if (major == null || minor == null || patch == null) return null;

    return _ParsedVersion(major, minor, patch);
  }

  static int _compareVersions(_ParsedVersion first, _ParsedVersion second) {
    final major = first.major.compareTo(second.major);
    if (major != 0) return major;
    final minor = first.minor.compareTo(second.minor);
    if (minor != 0) return minor;
    return first.patch.compareTo(second.patch);
  }
}

class AppUpdateCoordinator {
  final AppUpdateChecker checker;
  final Future<PackageInfo> Function() _packageInfoLoader;
  final bool Function() _isEligible;
  final Duration metadataTimeout;

  bool _attempted = false;

  AppUpdateCoordinator({
    AppUpdateChecker? checker,
    Future<PackageInfo> Function()? packageInfoLoader,
    bool Function()? isEligible,
    this.metadataTimeout = const Duration(seconds: 2),
  }) : checker = checker ?? const AppUpdateChecker(),
       _packageInfoLoader = packageInfoLoader ?? PackageInfo.fromPlatform,
       _isEligible = isEligible ?? _defaultEligibility;

  Future<AppUpdateCandidate?> attempt({required AppUpdateConsentReader hasConsent}) async {
    if (_attempted) return null;
    _attempted = true;

    if (!await _readConsentSafely(hasConsent)) return null;
    if (!_isEligible()) return null;

    final PackageInfo packageInfo;
    try {
      packageInfo = await _packageInfoLoader().timeout(metadataTimeout);
    } catch (e, s) {
      logger(
        'Skipping app update check because package metadata is unavailable: $e\n$s',
        tag: 'AppUpdateCoordinator',
        level: InfoLevel.warning,
      );
      return null;
    }

    if (!await _readConsentSafely(hasConsent)) return null;

    final candidate = await checker.check(currentVersion: packageInfo.version, hasConsent: hasConsent);
    if (candidate == null) return null;

    if (!await _readConsentSafely(hasConsent)) return null;
    return candidate;
  }

  Future<bool> _readConsentSafely(AppUpdateConsentReader hasConsent) async {
    try {
      return await hasConsent();
    } catch (e, s) {
      logger(
        'Treating app update consent as disabled because it could not be read: $e\n$s',
        tag: 'AppUpdateCoordinator',
        level: InfoLevel.warning,
      );
      return false;
    }
  }

  static bool _defaultEligibility() => isAppUpdateCheckEligible;
}

class _ConsentCheckingAdapter implements HttpClientAdapter {
  final HttpClientAdapter _delegate;
  final AppUpdateConsentReader _hasConsent;

  _ConsentCheckingAdapter(this._delegate, this._hasConsent);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (!await _hasConsent()) {
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.cancel,
        message: 'App update request cancelled because consent is not active.',
      );
    }

    return _delegate.fetch(options, requestStream, cancelFuture);
  }

  @override
  void close({bool force = false}) {
    _delegate.close(force: force);
  }
}

class _ParsedVersion {
  final int major;
  final int minor;
  final int patch;

  const _ParsedVersion(this.major, this.minor, this.patch);
}
