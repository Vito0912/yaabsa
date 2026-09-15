import 'dart:async';

import 'player_mutation_barrier.dart';

enum PlaybackStartAttemptStatus { pending, started, superseded, rejected, failed, unsupported }

class PlaybackStartAttempt {
  PlaybackStartAttempt._({
    required this.id,
    required this.lease,
    required this.sourceGeneration,
    required this.reservedQueueEntryId,
  });

  final int id;
  final PlayerMutationLease lease;
  final int sourceGeneration;
  final String? reservedQueueEntryId;
  PlaybackStartAttemptStatus _status = PlaybackStartAttemptStatus.pending;

  PlaybackStartAttemptStatus get status => _status;
  bool get isPending => _status == PlaybackStartAttemptStatus.pending;
}

class PlaybackStartAttemptLedger {
  int _sequence = 0;
  PlaybackStartAttempt? _active;

  PlaybackStartAttempt begin({
    required PlayerMutationLease lease,
    required int sourceGeneration,
    String? reservedQueueEntryId,
  }) {
    final previous = _active;
    if (previous != null && previous.isPending) {
      previous._status = PlaybackStartAttemptStatus.superseded;
    }
    final attempt = PlaybackStartAttempt._(
      id: ++_sequence,
      lease: lease,
      sourceGeneration: sourceGeneration,
      reservedQueueEntryId: reservedQueueEntryId,
    );
    _active = attempt;
    return attempt;
  }

  bool isCurrent(
    PlaybackStartAttempt attempt, {
    required PlayerMutationBarrier barrier,
    required int currentSourceGeneration,
    required bool isDisposing,
    required bool Function(String queueEntryId) reservationIsCurrent,
  }) {
    if (!identical(_active, attempt) ||
        !attempt.isPending ||
        isDisposing ||
        !barrier.isCurrent(attempt.lease) ||
        attempt.sourceGeneration != currentSourceGeneration) {
      return false;
    }
    final reservationId = attempt.reservedQueueEntryId;
    return reservationId == null || reservationIsCurrent(reservationId);
  }

  bool settle(PlaybackStartAttempt attempt, PlaybackStartAttemptStatus status) {
    if (status == PlaybackStartAttemptStatus.pending) {
      throw ArgumentError.value(status, 'status', 'Terminal playback-start status required');
    }
    if (!attempt.isPending) {
      return false;
    }
    attempt._status = status;
    if (identical(_active, attempt)) {
      _active = null;
    }
    return true;
  }

  PlaybackStartAttempt? get active => _active;
}

Future<T> awaitPlaybackStartOrLeaseInvalidated<T>({
  required PlayerMutationLease lease,
  required Future<T> backendResult,
  required T supersededValue,
}) {
  if (lease.isInvalidated) {
    return Future<T>.value(supersededValue);
  }
  return Future.any<T>([backendResult, lease.invalidated.then((_) => supersededValue)]);
}
