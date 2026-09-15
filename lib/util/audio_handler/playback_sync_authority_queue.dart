import 'dart:async';

typedef PlaybackSyncDispatch = Future<bool> Function({
  required Duration position,
  required double listenedTime,
  required String sessionId,
});

/// Serializes progress writes and gives a backend-confirmed position authority
/// over older in-flight writes without discarding their listening-time delta.
///
/// Historical/offline replay also passes through this queue. A replay keeps
/// its accumulated listening time, but never replaces a newer live position
/// for the same open session. If newer live authority appears while a replay
/// request is already in flight, the queued live write follows it and wins.
class PlaybackSyncAuthorityQueue {
  Future<void> _tail = Future<void>.value();
  int _revision = 0;
  Duration? _authoritativePosition;
  String? _authoritativeSessionId;
  Duration? _latestLivePosition;
  String? _latestLiveSessionId;

  int get revision => _revision;

  Future<bool> enqueue({
    required Duration position,
    required double listenedTime,
    required String sessionId,
    required PlaybackSyncDispatch dispatch,
  }) {
    _recordLivePosition(position, sessionId);
    return _enqueue(
      position: position,
      listenedTime: listenedTime,
      sessionId: sessionId,
      capturedRevision: _revision,
      dispatch: dispatch,
    );
  }

  Future<bool> correct({
    required Duration position,
    required String sessionId,
    required PlaybackSyncDispatch dispatch,
  }) {
    final correctionRevision = ++_revision;
    _authoritativePosition = position;
    _authoritativeSessionId = sessionId;
    _recordLivePosition(position, sessionId);
    return _enqueue(
      position: position,
      listenedTime: 0,
      sessionId: sessionId,
      capturedRevision: correctionRevision,
      dispatch: dispatch,
    );
  }

  Future<bool> enqueueHistorical({
    required Duration position,
    required double listenedTime,
    required String sessionId,
    required PlaybackSyncDispatch dispatch,
  }) async {
    var result = false;
    final operation = _tail.catchError((_) {}).then((_) async {
      final latestLivePosition = _latestLiveSessionId == sessionId ? _latestLivePosition : null;
      result = await dispatch(
        position: latestLivePosition ?? position,
        listenedTime: listenedTime,
        sessionId: sessionId,
      );
    });
    _tail = operation;
    await operation;
    return result;
  }

  void _recordLivePosition(Duration position, String sessionId) {
    _latestLivePosition = position;
    _latestLiveSessionId = sessionId;
  }

  Future<bool> _enqueue({
    required Duration position,
    required double listenedTime,
    required String sessionId,
    required int capturedRevision,
    required PlaybackSyncDispatch dispatch,
  }) async {
    var result = false;
    final operation = _tail.catchError((_) {}).then((_) async {
      result = await dispatch(position: position, listenedTime: listenedTime, sessionId: sessionId);

      final latestPosition = _authoritativePosition;
      if (capturedRevision < _revision && latestPosition != null && _authoritativeSessionId == sessionId) {
        final correctionResult = await dispatch(position: latestPosition, listenedTime: 0, sessionId: sessionId);
        result = result && correctionResult;
      }
    });
    _tail = operation;
    await operation;
    return result;
  }

  Future<void> drain() async {
    await _tail.catchError((_) {});
  }
}
