part of 'session_provider.dart';

extension ReaderSessions on SessionRepository {
  Future<void> closeReadingSession(PlaybackSessionBinding binding) async {
    await _sessionSyncQueues[binding.sessionId];
    await closeSessionBinding(binding);
  }

  Future<PlaybackSessionBinding?> openReadingSession(String itemId, {required double currentTime}) async {
    await ref.read(currentUserProvider.future);

    final userId = _activeUserId;
    if (userId == null) {
      return null;
    }

    final session = await createLocalSession(
      const Uuid().v4(),
      itemId,
      userId,
      DateTime.now(),
      initialTimeListening: 0,
      currentPosition: currentTime,
    );
    final readingSession = session.copyWith(mediaPlayer: '$appName reader');

    _localBoundSessionVersions[readingSession.id] = readingSession;

    return PlaybackSessionBinding(session: readingSession, isLocal: true);
  }
}
