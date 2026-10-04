class ChapterSleepTimer {
  ChapterSleepTimer({required List<Duration> endings, required Duration position, required int chapters})
    : endings = List.unmodifiable(endings),
      _position = position,
      remainingChapters = chapters {
    rebase(position);
  }

  final List<Duration> endings;
  Duration _position;
  int remainingChapters;
  int targetIndex = 0;
  int currentIndex = 0;

  Duration get target => endings[targetIndex];
  bool get expired => remainingChapters == 0;

  int _chapterAt(Duration position) {
    final index = endings.indexWhere((ending) => ending > position);
    return index < 0 ? endings.length : index;
  }

  void rebase(Duration position) {
    _position = position;
    currentIndex = _chapterAt(position);
    targetIndex = (currentIndex + remainingChapters - 1).clamp(0, endings.length - 1);
  }

  void update(Duration position) {
    if (expired) return;

    if (position >= target) {
      _position = position;
      remainingChapters = 0;
      return;
    }
    final nextIndex = _chapterAt(position);
    if (nextIndex < currentIndex) return;

    _position = position;
    if (nextIndex > currentIndex) {
      remainingChapters = (remainingChapters - (nextIndex - currentIndex)).clamp(0, endings.length);
      currentIndex = nextIndex;
    }
  }

  void extend() {
    if (expired) return;

    remainingChapters++;
    targetIndex = (currentIndex + remainingChapters - 1).clamp(0, endings.length - 1);
  }

  Duration remainingTime(double speed) {
    final micros = (target - _position).inMicroseconds;
    if (micros <= 0) return Duration.zero;

    return Duration(microseconds: (micros / (speed.isFinite && speed > 0 ? speed : 1)).round());
  }
}
