class UploadProgressTracker {
  UploadProgressTracker._(DateTime now) : _startedAt = now, _lastUpdateAt = now, _lastUiUpdateAt = now;

  factory UploadProgressTracker.start(DateTime now) => UploadProgressTracker._(now);

  final DateTime _startedAt;
  DateTime _lastUpdateAt;
  DateTime _lastUiUpdateAt;
  int _sentBytes = 0;
  double _smoothedBytesPerSecond = 0;

  UploadProgressUpdate? update({required int sentBytes, required int totalBytes, required DateTime now}) {
    final deltaMilliseconds = now.difference(_lastUpdateAt).inMilliseconds;
    final deltaSeconds = deltaMilliseconds <= 0 ? 0.0 : deltaMilliseconds / 1000;
    final instantRate = deltaSeconds > 0 ? (sentBytes - _sentBytes) / deltaSeconds : 0.0;

    final smoothedRate = _smoothedBytesPerSecond <= 0
        ? instantRate
        : (_smoothedBytesPerSecond * 0.75) + (instantRate * 0.25);

    final elapsedMilliseconds = now.difference(_startedAt).inMilliseconds;
    final elapsedSeconds = elapsedMilliseconds <= 0 ? 0.0 : elapsedMilliseconds / 1000;
    final averageRate = elapsedSeconds > 0 ? sentBytes / elapsedSeconds : 0.0;
    final blendedRate = (averageRate * 0.7) + (smoothedRate * 0.3);
    final shouldUpdateUi = now.difference(_lastUiUpdateAt).inMilliseconds >= 180 || sentBytes >= totalBytes;

    _sentBytes = sentBytes;
    _lastUpdateAt = now;
    _smoothedBytesPerSecond = smoothedRate;

    if (!shouldUpdateUi) {
      return null;
    }

    _lastUiUpdateAt = now;
    return UploadProgressUpdate(
      progress: sentBytes / totalBytes,
      uploadSpeedBytesPerSecond: blendedRate,
      uploadedBytes: sentBytes,
      totalBytes: totalBytes,
      isComplete: sentBytes >= totalBytes,
    );
  }
}

class UploadProgressUpdate {
  const UploadProgressUpdate({
    required this.progress,
    required this.uploadSpeedBytesPerSecond,
    required this.uploadedBytes,
    required this.totalBytes,
    required this.isComplete,
  });

  final double progress;
  final double uploadSpeedBytesPerSecond;
  final int uploadedBytes;
  final int totalBytes;
  final bool isComplete;
}
