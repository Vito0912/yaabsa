extension DurationExtensions on Duration {
  double get inSecondsPrecise => inMicroseconds / Duration.microsecondsPerSecond;

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  String toHhMmString() {
    final totalHours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    if (totalHours > 0) {
      return '${_twoDigits(totalHours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
    }
    return '${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  }

  String toPlaybackTimeString() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    if (hours > 0) {
      return '$hours:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
    }
    return '${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  }

  String toCompactClockString() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    if (hours > 0) {
      return '$hours:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
    }
    return '$minutes:${_twoDigits(seconds)}';
  }

  String toHoursMinutesSecondsString() {
    return '$inHours:${_twoDigits(inMinutes.remainder(60))}:${_twoDigits(inSeconds.remainder(60))}';
  }

  String toLargestUnitCompactString() {
    if (inHours > 0) {
      return '${inHours}h';
    }
    if (inMinutes > 0) {
      return '${inMinutes}m';
    }
    return '${inSeconds}s';
  }

  String toCompactRemainingString() {
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    if (inHours > 0) {
      return '${inHours}h ${minutes}m';
    }
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }
}

extension DoubleExtensions on double {
  Duration get toDuration => Duration(microseconds: (this * Duration.microsecondsPerSecond).toInt());
}
