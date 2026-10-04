import 'dart:async';
import 'dart:math' as math;

class SleepTimerFade {
  SleepTimerFade({required this.readVolume, required this.writeVolume});

  static const duration = Duration(seconds: 30);

  final double Function() readVolume;
  final Future<void> Function(double) writeVolume;

  double? _baseVolume;
  Future<void> _pending = Future.value();
  int _revision = 0;

  Future<void> _enqueue(double volume, {int? revision}) {
    _pending = _pending.then((_) async {
      if (revision != null && revision != _revision) return;
      await writeVolume(volume);
    });
    return _pending;
  }

  Future<void> restore() {
    _revision++;
    final base = _baseVolume;
    if (base == null) return _pending;

    final revision = _revision;
    return _enqueue(base).then((_) {
      if (revision == _revision) _baseVolume = null;
    });
  }

  void apply(Duration remaining, {required bool enabled}) {
    if (!enabled || remaining > duration) {
      unawaited(restore());
      return;
    }

    _baseVolume ??= readVolume();
    final progress = (remaining.inMicroseconds / duration.inMicroseconds).clamp(0.0, 1.0);
    final volume = _baseVolume! * math.pow(progress, 1.8);
    unawaited(_enqueue(volume, revision: ++_revision));
  }
}
