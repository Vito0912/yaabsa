import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/features/upload/upload_progress_tracker.dart';

void main() {
  test('throttles progress updates while retaining the latest byte sample', () {
    final startedAt = DateTime.utc(2026, 1, 1);
    final tracker = UploadProgressTracker.start(startedAt);

    final earlyUpdate = tracker.update(
      sentBytes: 100,
      totalBytes: 1000,
      now: startedAt.add(const Duration(milliseconds: 100)),
    );
    expect(earlyUpdate, isNull);

    final visibleUpdate = tracker.update(
      sentBytes: 200,
      totalBytes: 1000,
      now: startedAt.add(const Duration(milliseconds: 180)),
    );

    expect(visibleUpdate?.progress, 0.2);
    expect(visibleUpdate?.uploadedBytes, 200);
    expect(visibleUpdate?.totalBytes, 1000);
    expect(visibleUpdate?.isComplete, isFalse);
    expect(visibleUpdate?.uploadSpeedBytesPerSecond, closeTo(1096.53, 0.01));
  });

  test('smooths transfer rate and reports completion without waiting for the interval', () {
    final startedAt = DateTime.utc(2026, 1, 1);
    final tracker = UploadProgressTracker.start(startedAt);

    final firstUpdate = tracker.update(
      sentBytes: 1000,
      totalBytes: 2000,
      now: startedAt.add(const Duration(milliseconds: 200)),
    );
    expect(firstUpdate?.uploadSpeedBytesPerSecond, 5000);

    final secondUpdate = tracker.update(
      sentBytes: 1500,
      totalBytes: 2000,
      now: startedAt.add(const Duration(milliseconds: 400)),
    );
    expect(secondUpdate?.uploadSpeedBytesPerSecond, closeTo(3937.5, 0.01));

    final throttledUpdate = tracker.update(
      sentBytes: 1600,
      totalBytes: 2000,
      now: startedAt.add(const Duration(milliseconds: 450)),
    );
    expect(throttledUpdate, isNull);

    final completedUpdate = tracker.update(
      sentBytes: 2000,
      totalBytes: 2000,
      now: startedAt.add(const Duration(milliseconds: 580)),
    );
    expect(completedUpdate?.progress, 1);
    expect(completedUpdate?.isComplete, isTrue);
    expect(completedUpdate?.uploadSpeedBytesPerSecond, closeTo(3495.34, 0.1));
  });
}
