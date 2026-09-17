import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:yaabsa/util/app_update_checker.dart';

void main() {
  group('AppUpdateEligibility', () {
    test('allows only marked auto Android builds', () {
      expect(
        AppUpdateEligibility.isEligible(
          isWeb: false,
          platform: TargetPlatform.android,
          isDirectDistribution: true,
          flavor: 'auto',
        ),
        isTrue,
      );
      expect(
        AppUpdateEligibility.isEligible(
          isWeb: false,
          platform: TargetPlatform.android,
          isDirectDistribution: false,
          flavor: 'auto',
        ),
        isFalse,
      );
      expect(
        AppUpdateEligibility.isEligible(
          isWeb: false,
          platform: TargetPlatform.android,
          isDirectDistribution: true,
          flavor: 'automotive',
        ),
        isFalse,
      );
      expect(
        AppUpdateEligibility.isEligible(
          isWeb: false,
          platform: TargetPlatform.android,
          isDirectDistribution: true,
          flavor: 'wear',
        ),
        isFalse,
      );
    });

    test('rejects Web and unsupported desktop/mobile platforms', () {
      for (final platform in TargetPlatform.values) {
        expect(
          AppUpdateEligibility.isEligible(isWeb: true, platform: platform, isDirectDistribution: true, flavor: 'auto'),
          isFalse,
        );
      }

      for (final platform in [
        TargetPlatform.iOS,
        TargetPlatform.macOS,
        TargetPlatform.windows,
        TargetPlatform.linux,
        TargetPlatform.fuchsia,
      ]) {
        expect(
          AppUpdateEligibility.isEligible(isWeb: false, platform: platform, isDirectDistribution: true, flavor: 'auto'),
          isFalse,
        );
      }
    });
  });

  group('AppUpdateChecker.isUpdateAvailable', () {
    test('uses numeric MAJOR.MINOR.PATCH ordering', () {
      expect(AppUpdateChecker.isUpdateAvailable('1.9.9', 'v1.10.0'), isTrue);
      expect(AppUpdateChecker.isUpdateAvailable('1.10.0', 'v1.10.0'), isFalse);
      expect(AppUpdateChecker.isUpdateAvailable('1.11.0', 'v1.10.0'), isFalse);
    });

    test('rejects anything outside the strict version contract', () {
      for (final remote in ['1.12.0', 'V1.12.0', 'v1.12', 'v1.12.0-beta.1', 'v1.12.0+1', ' v1.12.0', 'v01.12.0']) {
        expect(AppUpdateChecker.isUpdateAvailable('1.11.0', remote), isFalse, reason: remote);
      }

      for (final installed in ['v1.11.0', '1.11', '1.11.0+138', '1.11.0-beta.1', ' 1.11.0', '01.11.0']) {
        expect(AppUpdateChecker.isUpdateAvailable(installed, 'v1.12.0'), isFalse, reason: installed);
      }
    });
  });

  group('AppUpdateChecker transport', () {
    test('does not dispatch when consent is absent at the transport boundary', () async {
      final adapter = _RecordingAdapter(body: '{"tag_name":"v1.12.0"}');
      final checker = AppUpdateChecker(adapterFactory: () => adapter);

      final candidate = await checker.check(currentVersion: '1.11.0', hasConsent: () async => false);

      expect(candidate, isNull);
      expect(adapter.fetchCount, 0);
    });

    test('returns a candidate from a valid response and fixed release URL', () async {
      final adapter = _RecordingAdapter(body: '{"tag_name":"v1.12.0"}');
      final checker = AppUpdateChecker(adapterFactory: () => adapter);

      final candidate = await checker.check(currentVersion: '1.11.0', hasConsent: () async => true);

      expect(adapter.fetchCount, 1);
      expect(candidate?.currentVersion, '1.11.0');
      expect(candidate?.latestVersion, '1.12.0');
      expect(candidate?.releaseUri.toString(), 'https://github.com/Vito0912/yaabsa/releases/tag/v1.12.0');
    });

    test('fails closed for malformed release tags', () async {
      final adapter = _RecordingAdapter(body: '{"tag_name":"latest"}');
      final checker = AppUpdateChecker(adapterFactory: () => adapter);

      final candidate = await checker.check(currentVersion: '1.11.0', hasConsent: () async => true);

      expect(adapter.fetchCount, 1);
      expect(candidate, isNull);
    });

    test('fails closed for missing, wrong-type, and invalid JSON responses', () async {
      for (final body in ['{}', '{"tag_name":123}', 'not json']) {
        final adapter = _RecordingAdapter(body: body);
        final checker = AppUpdateChecker(adapterFactory: () => adapter);

        final candidate = await checker.check(currentVersion: '1.11.0', hasConsent: () async => true);

        expect(adapter.fetchCount, 1, reason: body);
        expect(candidate, isNull, reason: body);
      }
    });

    test('fails closed for non-200 responses including rate limits', () async {
      for (final statusCode in [403, 429, 500]) {
        final adapter = _RecordingAdapter(body: '{"tag_name":"v1.12.0"}', statusCode: statusCode);
        final checker = AppUpdateChecker(adapterFactory: () => adapter);

        final candidate = await checker.check(currentVersion: '1.11.0', hasConsent: () async => true);

        expect(adapter.fetchCount, 1, reason: '$statusCode');
        expect(candidate, isNull, reason: '$statusCode');
      }
    });

    test('fails closed for transport errors', () async {
      final adapter = _RecordingAdapter(body: '{"tag_name":"v1.12.0"}', throwConnectionError: true);
      final checker = AppUpdateChecker(adapterFactory: () => adapter);

      final candidate = await checker.check(currentVersion: '1.11.0', hasConsent: () async => true);

      expect(adapter.fetchCount, 1);
      expect(candidate, isNull);
    });

    test('fails closed when the request exceeds the bounded timeout', () async {
      final adapter = _RecordingAdapter(body: '{"tag_name":"v1.12.0"}', delay: const Duration(milliseconds: 100));
      final checker = AppUpdateChecker(adapterFactory: () => adapter, timeout: const Duration(milliseconds: 10));

      final candidate = await checker.check(currentVersion: '1.11.0', hasConsent: () async => true);

      expect(adapter.fetchCount, 1);
      expect(candidate, isNull);
    });
  });

  group('AppUpdateCoordinator', () {
    test('attempts at most once per application lifetime', () async {
      final adapter = _RecordingAdapter(body: '{"tag_name":"v1.12.0"}');
      final coordinator = AppUpdateCoordinator(
        checker: AppUpdateChecker(adapterFactory: () => adapter),
        packageInfoLoader: () async => _packageInfo('1.11.0'),
        isEligible: () => true,
      );

      final first = await coordinator.attempt(hasConsent: () async => true);
      final second = await coordinator.attempt(hasConsent: () async => true);

      expect(first, isNotNull);
      expect(second, isNull);
      expect(adapter.fetchCount, 1);
    });

    test('concurrent triggers still dispatch at most once', () async {
      final adapter = _RecordingAdapter(body: '{"tag_name":"v1.12.0"}', delay: const Duration(milliseconds: 20));
      final coordinator = AppUpdateCoordinator(
        checker: AppUpdateChecker(adapterFactory: () => adapter),
        packageInfoLoader: () async => _packageInfo('1.11.0'),
        isEligible: () => true,
      );

      final results = await Future.wait([
        coordinator.attempt(hasConsent: () async => true),
        coordinator.attempt(hasConsent: () async => true),
      ]);

      expect(results.whereType<AppUpdateCandidate>().length, 1);
      expect(adapter.fetchCount, 1);
    });

    test('ineligible distribution stops before metadata and network', () async {
      final adapter = _RecordingAdapter(body: '{"tag_name":"v1.12.0"}');
      var metadataReads = 0;
      final coordinator = AppUpdateCoordinator(
        checker: AppUpdateChecker(adapterFactory: () => adapter),
        packageInfoLoader: () async {
          metadataReads += 1;
          return _packageInfo('1.11.0');
        },
        isEligible: () => false,
      );

      final candidate = await coordinator.attempt(hasConsent: () async => true);

      expect(candidate, isNull);
      expect(metadataReads, 0);
      expect(adapter.fetchCount, 0);
    });

    test('consent read failures fail closed before metadata and network', () async {
      final adapter = _RecordingAdapter(body: '{"tag_name":"v1.12.0"}');
      var metadataReads = 0;
      final coordinator = AppUpdateCoordinator(
        checker: AppUpdateChecker(adapterFactory: () => adapter),
        packageInfoLoader: () async {
          metadataReads += 1;
          return _packageInfo('1.11.0');
        },
        isEligible: () => true,
      );

      final candidate = await coordinator.attempt(hasConsent: () async => throw StateError('settings unavailable'));

      expect(candidate, isNull);
      expect(metadataReads, 0);
      expect(adapter.fetchCount, 0);
    });

    test('metadata failure stops before network dispatch', () async {
      final adapter = _RecordingAdapter(body: '{"tag_name":"v1.12.0"}');
      final coordinator = AppUpdateCoordinator(
        checker: AppUpdateChecker(adapterFactory: () => adapter),
        packageInfoLoader: () async => throw StateError('metadata unavailable'),
        isEligible: () => true,
      );

      final candidate = await coordinator.attempt(hasConsent: () async => true);

      expect(candidate, isNull);
      expect(adapter.fetchCount, 0);
    });

    test('metadata timeout stops before network dispatch', () async {
      final adapter = _RecordingAdapter(body: '{"tag_name":"v1.12.0"}');
      final coordinator = AppUpdateCoordinator(
        checker: AppUpdateChecker(adapterFactory: () => adapter),
        packageInfoLoader: () async {
          await Future<void>.delayed(const Duration(milliseconds: 100));
          return _packageInfo('1.11.0');
        },
        isEligible: () => true,
        metadataTimeout: const Duration(milliseconds: 10),
      );

      final candidate = await coordinator.attempt(hasConsent: () async => true);

      expect(candidate, isNull);
      expect(adapter.fetchCount, 0);
    });

    test('revocation after metadata prevents dispatch', () async {
      final adapter = _RecordingAdapter(body: '{"tag_name":"v1.12.0"}');
      var consent = true;
      final coordinator = AppUpdateCoordinator(
        checker: AppUpdateChecker(adapterFactory: () => adapter),
        packageInfoLoader: () async {
          consent = false;
          return _packageInfo('1.11.0');
        },
        isEligible: () => true,
      );

      final candidate = await coordinator.attempt(hasConsent: () async => consent);

      expect(candidate, isNull);
      expect(adapter.fetchCount, 0);
    });

    test('transport-boundary revocation prevents the delegate fetch', () async {
      final adapter = _RecordingAdapter(body: '{"tag_name":"v1.12.0"}');
      var consentReads = 0;
      final coordinator = AppUpdateCoordinator(
        checker: AppUpdateChecker(adapterFactory: () => adapter),
        packageInfoLoader: () async => _packageInfo('1.11.0'),
        isEligible: () => true,
      );

      Future<bool> readConsent() async {
        consentReads += 1;
        return consentReads <= 2;
      }

      final candidate = await coordinator.attempt(hasConsent: readConsent);

      expect(candidate, isNull);
      expect(adapter.fetchCount, 0);
      expect(consentReads, 3);
    });
  });
}

PackageInfo _packageInfo(String version) {
  return PackageInfo(appName: 'Yaabsa', packageName: 'de.vito0912.yaabsa', version: version, buildNumber: '138');
}

class _RecordingAdapter implements HttpClientAdapter {
  final String body;
  final int statusCode;
  final Duration delay;
  final bool throwConnectionError;
  int fetchCount = 0;

  _RecordingAdapter({
    required this.body,
    this.statusCode = 200,
    this.delay = Duration.zero,
    this.throwConnectionError = false,
  });

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    fetchCount += 1;

    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }

    if (throwConnectionError) {
      throw DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
        message: 'Simulated connection failure',
      );
    }

    return ResponseBody.fromString(
      body,
      statusCode,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
