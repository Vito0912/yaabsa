import 'package:yaabsa/util/item_formatters.dart';

String formatListeningSeconds(num? seconds, {String fallback = '0 min'}) {
  if (seconds == null || seconds <= 0) {
    return fallback;
  }

  return formatDurationLong(Duration(seconds: seconds.round()));
}

String formatListeningSecondsShort(num? seconds, {String fallback = '0:00'}) {
  if (seconds == null || seconds <= 0) {
    return fallback;
  }

  return formatDurationShort(Duration(seconds: seconds.round()));
}

String formatDateTimeLabel(DateTime? dateTime) {
  if (dateTime == null) {
    return 'Unknown';
  }

  final year = dateTime.year.toString().padLeft(4, '0');
  final month = dateTime.month.toString().padLeft(2, '0');
  final day = dateTime.day.toString().padLeft(2, '0');
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  return '$year-$month-$day $hour:$minute';
}

DateTime? fromEpochMs(int? value) {
  if (value == null || value <= 0) {
    return null;
  }

  return DateTime.fromMillisecondsSinceEpoch(value);
}

String ordinalRank(int index) {
  final rank = index + 1;
  if (rank >= 11 && rank <= 13) {
    return '${rank}th';
  }

  switch (rank % 10) {
    case 1:
      return '${rank}st';
    case 2:
      return '${rank}nd';
    case 3:
      return '${rank}rd';
    default:
      return '${rank}th';
  }
}
