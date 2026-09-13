import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/util/app_update_checker.dart';

void main() {
  group('AppUpdateChecker.isUpdateAvailable', () {
    test('detects a newer stable release with a v prefix', () {
      expect(AppUpdateChecker.isUpdateAvailable('1.11.0', 'v1.12.0'), isTrue);
    });

    test('treats build metadata as the same app version', () {
      expect(AppUpdateChecker.isUpdateAvailable('1.11.0+138', 'v1.11.0'), isFalse);
    });

    test('does not downgrade a newer installed version', () {
      expect(AppUpdateChecker.isUpdateAvailable('1.12.1', 'v1.12.0'), isFalse);
    });

    test('treats a stable release as newer than the matching prerelease', () {
      expect(AppUpdateChecker.isUpdateAvailable('1.12.0-beta.1', 'v1.12.0'), isTrue);
    });

    test('fails closed for malformed versions', () {
      expect(AppUpdateChecker.isUpdateAvailable('1.11.0', 'release-next'), isFalse);
      expect(AppUpdateChecker.isUpdateAvailable('unknown', 'v1.12.0'), isFalse);
      expect(AppUpdateChecker.isUpdateAvailable('1.11.0', 'v1.12.0+meta..broken'), isFalse);
      expect(AppUpdateChecker.isUpdateAvailable('1.11.0', 'v1.12.0-alpha..1'), isFalse);
    });
  });

  group('AppUpdateChecker.check', () {
    late Dio dio;

    setUp(() {
      dio = Dio();
    });

    tearDown(() {
      dio.close(force: true);
    });

    test('queries the upstream latest-release endpoint and returns the available version', () async {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            expect(options.uri.toString(), AppUpdateChecker.latestReleaseUrl);
            expect(options.headers['Accept'], 'application/vnd.github.v3+json');
            expect(options.headers['User-Agent'], 'Yaabsa-App');

            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                statusCode: 200,
                data: const {'tag_name': 'v1.12.0', 'draft': false, 'prerelease': false},
              ),
            );
          },
        ),
      );

      final result = await AppUpdateChecker(dio: dio).check('1.11.0');

      expect(result.status, AppUpdateCheckStatus.success);
      expect(result.currentVersion, '1.11.0');
      expect(result.latestVersion, '1.12.0');
      expect(result.isUpdateAvailable, isTrue);
      expect(result.rateLimitResetMs, isNull);
    });

    test('returns a successful no-update result for the installed release', () async {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                statusCode: 200,
                data: const {'tag_name': 'v1.11.0', 'draft': false, 'prerelease': false},
              ),
            );
          },
        ),
      );

      final result = await AppUpdateChecker(dio: dio).check('1.11.0');

      expect(result.status, AppUpdateCheckStatus.success);
      expect(result.latestVersion, '1.11.0');
      expect(result.isUpdateAvailable, isFalse);
    });

    test('rejects malformed or non-stable release responses', () async {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                statusCode: 200,
                data: const {'tag_name': 'next', 'draft': false, 'prerelease': false},
              ),
            );
          },
        ),
      );

      final result = await AppUpdateChecker(dio: dio).check('1.11.0');

      expect(result.status, AppUpdateCheckStatus.failed);
      expect(result.latestVersion, isNull);
      expect(result.isUpdateAvailable, isFalse);
    });

    test('rejects a prerelease tag even when GitHub metadata marks it stable', () async {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response<Map<String, dynamic>>(
                requestOptions: options,
                statusCode: 200,
                data: const {'tag_name': 'v1.12.0-rc.1', 'draft': false, 'prerelease': false},
              ),
            );
          },
        ),
      );

      final result = await AppUpdateChecker(dio: dio).check('1.11.0');

      expect(result.status, AppUpdateCheckStatus.failed);
      expect(result.latestVersion, isNull);
      expect(result.isUpdateAvailable, isFalse);
    });

    test('surfaces GitHub rate-limit reset time', () async {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.reject(
              DioException(
                requestOptions: options,
                response: Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 403,
                  headers: Headers.fromMap(const {
                    'x-ratelimit-reset': ['1789228800'],
                  }),
                ),
                type: DioExceptionType.badResponse,
              ),
            );
          },
        ),
      );

      final result = await AppUpdateChecker(dio: dio).check('1.11.0');

      expect(result.status, AppUpdateCheckStatus.rateLimited);
      expect(result.isUpdateAvailable, isFalse);
      expect(result.rateLimitResetMs, 1789228800000);
    });

    test('does not make a request for an invalid installed version', () async {
      var requestMade = false;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requestMade = true;
            handler.next(options);
          },
        ),
      );

      final result = await AppUpdateChecker(dio: dio).check('unknown');

      expect(result.status, AppUpdateCheckStatus.failed);
      expect(result.isUpdateAvailable, isFalse);
      expect(requestMade, isFalse);
    });
  });
}
