extension DurationExtensions on Duration {
  double get inSecondsPrecise => inMicroseconds / Duration.microsecondsPerSecond;

  String toHhMmString() {
    int totalHours = inHours;
    int minutes = inMinutes.remainder(60);
    int seconds = inSeconds.remainder(60);
    if (totalHours > 0) {
      return '${totalHours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}

extension DoubleExtensions on double {
  Duration get toDuration => Duration(microseconds: (this * Duration.microsecondsPerSecond).toInt());
}
