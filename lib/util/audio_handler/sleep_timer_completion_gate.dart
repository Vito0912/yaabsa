bool playbackStatePlayingForSleepTimerCompletion({
  required bool playerPlaying,
  required bool suppressCompletedAutoAdvance,
}) {
  return playerPlaying && !suppressCompletedAutoAdvance;
}

class SleepTimerCompletionGateToken {
  SleepTimerCompletionGateToken._(this._id);

  final int _id;

  @override
  String toString() => 'SleepTimerCompletionGateToken($_id)';
}

class SleepTimerCompletionGateClaim {
  const SleepTimerCompletionGateClaim({required this.token, required this.itemId, required this.episodeId});

  final SleepTimerCompletionGateToken token;
  final String itemId;
  final String? episodeId;
}

class SleepTimerCompletionGateLedger {
  int _sequence = 0;
  SleepTimerCompletionGateClaim? _armedGate;

  SleepTimerCompletionGateToken arm({required String itemId, String? episodeId}) {
    final token = SleepTimerCompletionGateToken._(++_sequence);
    _armedGate = SleepTimerCompletionGateClaim(token: token, itemId: itemId, episodeId: episodeId);
    return token;
  }

  bool clear(SleepTimerCompletionGateToken token) {
    final armedGate = _armedGate;
    if (armedGate == null || !identical(armedGate.token, token)) {
      return false;
    }

    _armedGate = null;
    return true;
  }

  SleepTimerCompletionGateClaim? claimWhere(bool Function(String itemId, String? episodeId) matches) {
    final armedGate = _armedGate;
    if (armedGate == null || !matches(armedGate.itemId, armedGate.episodeId)) {
      return null;
    }

    return armedGate;
  }

  SleepTimerCompletionGateToken? get armedToken => _armedGate?.token;
  bool get hasArmedGate => _armedGate != null;
}
