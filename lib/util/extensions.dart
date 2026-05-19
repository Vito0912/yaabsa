import 'package:intl/intl.dart';

extension DurationExtensions on Duration {
  double get inSecondsPrecise => inMicroseconds / Duration.microsecondsPerSecond;

  String toHhMmString() {
    final totalHours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    final twoDigits = NumberFormat('00', Intl.getCurrentLocale());
    if (totalHours > 0) {
      return '${twoDigits.format(totalHours)}:${twoDigits.format(minutes)}:${twoDigits.format(seconds)}';
    } else {
      return '${twoDigits.format(minutes)}:${twoDigits.format(seconds)}';
    }
  }
}

extension DoubleExtensions on double {
  Duration get toDuration => Duration(microseconds: (this * Duration.microsecondsPerSecond).toInt());
}
