part of 'smart_download_provider.dart';

extension AutomaticDownloadRetries on SmartDownloadManager {
  void recordAutomaticDownloadFailure({required String userId, required String itemId, String? episodeId}) {
    if (_managerRef.read(currentUserProvider).value?.id != userId) {
      return;
    }

    final key = '$itemId::${episodeId ?? ''}';
    _retryAfter[key] = DateTime.now().add(const Duration(minutes: 1));
    _scheduleAutomaticDownloadRetry();
    requestReconcile(reason: 'automatic download failed', refreshSources: false);
  }

  void _scheduleAutomaticDownloadRetry() {
    _retryTimer?.cancel();
    if (_retryAfter.isEmpty) {
      return;
    }

    final nextAttempt = _retryAfter.values.reduce((left, right) => left.isBefore(right) ? left : right);
    final delay = nextAttempt.difference(DateTime.now());
    _retryTimer = Timer(delay.isNegative ? Duration.zero : delay, () {
      final now = DateTime.now();
      _retryAfter.removeWhere((key, retryAt) => !retryAt.isAfter(now));
      _scheduleAutomaticDownloadRetry();
      requestReconcile(reason: 'automatic download retry', refreshSources: false);
    });
  }
}
