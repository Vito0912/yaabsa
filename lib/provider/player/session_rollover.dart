part of 'session_provider.dart';

extension SessionRollover on SessionRepository {
  bool restartListeningSession({
    required DateTime startedAt,
    required DateTime calendarDate,
    required double position,
  }) {
    final session = _currentSession;
    if (session == null) return false;

    if (!_isLocalSession) _streamSessionId = session.id;
    _currentSession = session.copyWith(
      id: const Uuid().v4(),
      date: _formatDateString(calendarDate),
      dayOfWeek: _getWeekdayString(calendarDate),
      startedAt: startedAt.millisecondsSinceEpoch,
      updatedAt: startedAt.millisecondsSinceEpoch,
      startTime: position,
      currentTime: position,
      timeListening: 0,
    );
    _recordingStartedAt = startedAt;
    _isLocalSession = true;
    logger('Listening session rotated to ${_currentSession!.id}', tag: 'SessionRepository');
    return true;
  }
}
