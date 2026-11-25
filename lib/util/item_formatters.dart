import 'package:intl/intl.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/extensions.dart';

bool hasText(String? value) => value != null && value.trim().isNotEmpty;

String seriesLabel(String name, String? sequence) {
  if (!hasText(sequence)) {
    return name;
  }
  return '$name #$sequence';
}

String formatDurationShort(Duration duration) {
  return duration.toHhMmString();
}

String formatDurationLong(Duration duration, {AppLocalizations? localizations}) {
  final l10n = localizations ?? currentAppLocalizations();
  if (duration.inHours > 0) {
    final minutes = duration.inMinutes.remainder(60);
    if (minutes == 0) {
      return l10n.durationHours(duration.inHours);
    }
    return l10n.durationHoursMinutes(duration.inHours, minutes);
  }
  if (duration.inMinutes == 0) {
    return l10n.durationSeconds(duration.inSeconds);
  }
  return l10n.durationMinutes(duration.inMinutes);
}

String formatBytes(int bytes, {AppLocalizations? localizations}) {
  final l10n = localizations ?? currentAppLocalizations();
  final units = [
    l10n.byteUnitBytes,
    l10n.byteUnitKilobytes,
    l10n.byteUnitMegabytes,
    l10n.byteUnitGigabytes,
    l10n.byteUnitTerabytes,
  ];
  var size = bytes.toDouble();
  var unitIndex = 0;

  while (size >= 1024 && unitIndex < units.length - 1) {
    size /= 1024;
    unitIndex++;
  }

  final decimalDigits = size >= 100 ? 0 : 2;
  final formatted = NumberFormat.decimalPatternDigits(
    locale: l10n.localeName,
    decimalDigits: decimalDigits,
  ).format(size);
  return l10n.byteSize(formatted, units[unitIndex]);
}

Duration chapterDuration(double startSeconds, double endSeconds) {
  final raw = endSeconds - startSeconds;
  final safe = raw < 0 ? 0 : raw;
  return Duration(seconds: safe.round());
}
