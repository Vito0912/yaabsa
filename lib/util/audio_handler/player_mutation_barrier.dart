import 'dart:async';

class PlayerMutationLease {
  PlayerMutationLease._(this._id);

  final int _id;
  final Completer<void> _invalidated = Completer<void>();

  Future<void> get invalidated => _invalidated.future;
  bool get isInvalidated => _invalidated.isCompleted;

  void _markInvalidated() {
    if (!_invalidated.isCompleted) {
      _invalidated.complete();
    }
  }

  @override
  String toString() => 'PlayerMutationLease($_id)';
}

class PlayerMutationBarrier {
  int _sequence = 0;
  PlayerMutationLease? _currentLease;
  Future<void> _tail = Future<void>.value();

  PlayerMutationLease? get currentLease => _currentLease;

  PlayerMutationLease acquire() {
    _currentLease?._markInvalidated();
    final lease = PlayerMutationLease._(++_sequence);
    _currentLease = lease;
    return lease;
  }

  bool isCurrent(PlayerMutationLease lease) => identical(_currentLease, lease) && !lease.isInvalidated;

  bool invalidate(PlayerMutationLease lease) {
    if (!identical(_currentLease, lease)) {
      lease._markInvalidated();
      return false;
    }

    lease._markInvalidated();
    _currentLease = null;
    return true;
  }

  Future<T?> run<T>(PlayerMutationLease lease, Future<T> Function() mutation) {
    final previous = _tail;
    final operation = () async {
      await previous;
      if (!isCurrent(lease)) {
        return null;
      }
      return mutation();
    }();

    _tail = operation.then<void>((_) {}, onError: (_, _) {});
    return operation;
  }

  Future<void> get drained => _tail;
}

class DeferredPlayerMutationGuard {
  const DeferredPlayerMutationGuard({
    required this.lease,
    required this.playbackContextGeneration,
    required this.seekGeneration,
    required this.mediaKey,
  });

  final PlayerMutationLease lease;
  final int playbackContextGeneration;
  final int seekGeneration;
  final String mediaKey;

  bool isCurrent({
    required PlayerMutationBarrier barrier,
    required int playbackContextGeneration,
    required int seekGeneration,
    required String? mediaKey,
  }) {
    return barrier.isCurrent(lease) &&
        this.playbackContextGeneration == playbackContextGeneration &&
        this.seekGeneration == seekGeneration &&
        this.mediaKey == mediaKey;
  }
}
