import 'package:yaabsa/util/l10n.dart';

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

  String toLargestUnitCompactString({AppLocalizations? localizations}) {
    final l10n = localizations ?? currentAppLocalizations();
    if (inHours > 0) {
      return l10n.durationCompactHours(inHours);
    }
    if (inMinutes > 0) {
      return l10n.durationCompactMinutes(inMinutes);
    }
    return l10n.durationCompactSeconds(inSeconds);
  }

  String toCompactRemainingString({AppLocalizations? localizations}) {
    final l10n = localizations ?? currentAppLocalizations();
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    if (inHours > 0) {
      return l10n.durationCompactHoursMinutes(inHours, minutes);
    }
    if (minutes > 0) {
      return l10n.durationCompactMinutesSeconds(minutes, seconds);
    }
    return l10n.durationCompactSeconds(seconds);
  }
}

extension DoubleExtensions on double {
  Duration get toDuration => Duration(microseconds: (this * Duration.microsecondsPerSecond).toInt());
}
