import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/util/app_update_checker.dart';
import 'package:yaabsa/util/app_update_state.dart';

void main() {
  const now = 1_789_200_000_000;

  group('AppUpdateCoordinator', () {
    late Dio dio;
    late _MemoryAppUpdateStateStore store;

    setUp(() {
      dio = Dio();
      store = _MemoryAppUpdateStateStore();
    });

    tearDown(() {
      dio.close(force: true);
    });

    test('does not query GitHub before the persisted cooldown expires', () async {
      var requestMade = false;
      store.nextCheckAllowed = now + const Duration(hours: 1).inMilliseconds;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requestMade = true;
            handler.next(options);
          },
        ),
      );

      final coordinator = AppUpdateCoordinator(
        checker: AppUpdateChecker(dio: dio),
        stateStore: store,
        nowMs: () => now,
      );

      final result = await coordinator.checkIfDue('1.11.0');

      expect(result, isNull);
      expect(requestMade, isFalse);
      expect(store.nextCheckAllowed, now + const Duration(hours: 1).inMilliseconds);
    });

    test('persists a six-hour cooldown after a successful check', () async {
      _respondWithRelease(dio, 'v1.12.0');
      final coordinator = AppUpdateCoordinator(
        checker: AppUpdateChecker(dio: dio),
        stateStore: store,
        nowMs: () => now,
      );

      final result = await coordinator.checkIfDue('1.11.0');

      expect(result?.status, AppUpdateCheckStatus.success);
      expect(store.nextCheckAllowed, now + AppUpdateCoordinator.successCooldown.inMilliseconds);
    });

    test('persists a one-hour retry delay after a normal failure', () async {
      _rejectWithStatus(dio, 500);
      final coordinator = AppUpdateCoordinator(
        checker: AppUpdateChecker(dio: dio),
        stateStore: store,
        nowMs: () => now,
      );

      final result = await coordinator.checkIfDue('1.11.0');

      expect(result?.status, AppUpdateCheckStatus.failed);
      expect(store.nextCheckAllowed, now + AppUpdateCoordinator.failureCooldown.inMilliseconds);
    });

    test('uses GitHub rate-limit reset time when it is in the future', () async {
      final reset = now + const Duration(minutes: 20).inMilliseconds;
      _rejectWithStatus(dio, 403, rateLimitResetSeconds: reset ~/ 1000);
      final coordinator = AppUpdateCoordinator(
        checker: AppUpdateChecker(dio: dio),
        stateStore: store,
        nowMs: () => now,
      );

      final result = await coordinator.checkIfDue('1.11.0');

      expect(result?.status, AppUpdateCheckStatus.rateLimited);
      expect(store.nextCheckAllowed, reset);
    });

    test('falls back to one hour when a rate-limit reset is absent or stale', () async {
      _rejectWithStatus(dio, 403, rateLimitResetSeconds: (now ~/ 1000) - 10);
      final coordinator = AppUpdateCoordinator(
        checker: AppUpdateChecker(dio: dio),
        stateStore: store,
        nowMs: () => now,
      );

      final result = await coordinator.checkIfDue('1.11.0');

      expect(result?.status, AppUpdateCheckStatus.rateLimited);
      expect(store.nextCheckAllowed, now + AppUpdateCoordinator.failureCooldown.inMilliseconds);
    });

    test('stores skipped versions globally and normalizes the v prefix', () async {
      final coordinator = AppUpdateCoordinator(
        checker: AppUpdateChecker(dio: dio),
        stateStore: store,
        nowMs: () => now,
      );

      await coordinator.skipVersion('v1.12.0');

      expect(store.skippedVersion, '1.12.0');
      expect(coordinator.isSkippedVersion('1.12.0'), isTrue);
      expect(coordinator.isSkippedVersion('v1.12.0'), isTrue);
      expect(coordinator.isSkippedVersion('1.12.1'), isFalse);
    });

    test('notifies only for a successful newer release that was not skipped', () {
      final coordinator = AppUpdateCoordinator(
        checker: AppUpdateChecker(dio: dio),
        stateStore: store,
        nowMs: () => now,
      );
      const result = AppUpdateCheckResult(
        status: AppUpdateCheckStatus.success,
        currentVersion: '1.11.0',
        latestVersion: '1.12.0',
        isUpdateAvailable: true,
      );

      expect(coordinator.shouldNotify(result), isTrue);

      store.skippedVersion = 'v1.12.0';
      expect(coordinator.shouldNotify(result), isFalse);
    });

    test('does not notify for failed or current-version checks', () {
      final coordinator = AppUpdateCoordinator(
        checker: AppUpdateChecker(dio: dio),
        stateStore: store,
        nowMs: () => now,
      );
      final failed = AppUpdateCheckResult.failed(currentVersion: '1.11.0');
      const current = AppUpdateCheckResult(
        status: AppUpdateCheckStatus.success,
        currentVersion: '1.11.0',
        latestVersion: '1.11.0',
        isUpdateAvailable: false,
      );

      expect(coordinator.shouldNotify(failed), isFalse);
      expect(coordinator.shouldNotify(current), isFalse);
    });
  });
}

void _respondWithRelease(Dio dio, String tagName) {
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        handler.resolve(
          Response<Map<String, dynamic>>(
            requestOptions: options,
            statusCode: 200,
            data: {'tag_name': tagName, 'draft': false, 'prerelease': false},
          ),
        );
      },
    ),
  );
}

void _rejectWithStatus(Dio dio, int statusCode, {int? rateLimitResetSeconds}) {
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final headers = Headers();
        if (rateLimitResetSeconds != null) {
          headers.set('x-ratelimit-reset', rateLimitResetSeconds.toString());
        }
        handler.reject(
          DioException(
            requestOptions: options,
            response: Response<Map<String, dynamic>>(
              requestOptions: options,
              statusCode: statusCode,
              headers: headers,
            ),
            type: DioExceptionType.badResponse,
          ),
        );
      },
    ),
  );
}

class _MemoryAppUpdateStateStore implements AppUpdateStateStore {
  @override
  int nextCheckAllowed = 0;

  @override
  String skippedVersion = '';

  @override
  Future<void> setNextCheckAllowed(int value) async {
    nextCheckAllowed = value;
  }

  @override
  Future<void> setSkippedVersion(String value) async {
    skippedVersion = value;
  }
}
