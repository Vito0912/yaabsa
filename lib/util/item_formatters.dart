import 'package:yaabsa/util/extensions.dart';
import 'package:intl/intl.dart';

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

String formatDurationLong(Duration duration) {
  if (duration.inHours > 0) {
    final minutes = duration.inMinutes.remainder(60);
    if (minutes == 0) {
      return '${duration.inHours} hr';
    }
    return '${duration.inHours} hr $minutes min';
  }
  if (duration.inMinutes == 0) {
    final seconds = duration.inSeconds;
    return '$seconds sec';
  }
  return '${duration.inMinutes} min';
}

String formatBytes(int bytes) {
  const units = ['B', 'KB', 'MB', 'GB', 'TB'];
  double size = bytes.toDouble();
  int unitIndex = 0;

  while (size >= 1024 && unitIndex < units.length - 1) {
    size /= 1024;
    unitIndex++;
  }

  final decimalDigits = size >= 100 ? 0 : 2;
  final formatter = NumberFormat.decimalPatternDigits(locale: Intl.getCurrentLocale(), decimalDigits: decimalDigits);
  final formatted = formatter.format(size);
  return '$formatted ${units[unitIndex]}';
}

Duration chapterDuration(double startSeconds, double endSeconds) {
  final raw = endSeconds - startSeconds;
  final safe = raw < 0 ? 0 : raw;
  return Duration(seconds: safe.round());
}
