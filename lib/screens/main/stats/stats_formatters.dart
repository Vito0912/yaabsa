import 'package:yaabsa/util/item_formatters.dart';
import 'package:intl/intl.dart';

import 'package:yaabsa/generated/l10n.dart';

String formatListeningSeconds(num? seconds, {String? fallback}) {
  final resolvedFallback = fallback ?? S.current.screensMainStatsStatsFormattersZeroMinutes;
  if (seconds == null || seconds <= 0) {
    return resolvedFallback;
  }

  return formatDurationLong(Duration(seconds: seconds.round()));
}

String formatListeningSecondsShort(num? seconds, {String? fallback}) {
  final resolvedFallback = fallback ?? S.current.screensMainStatsStatsFormattersZeroClock;
  if (seconds == null || seconds <= 0) {
    return resolvedFallback;
  }

  return formatDurationShort(Duration(seconds: seconds.round()));
}

String formatDateLabel(DateTime? dateTime, {String? fallback}) {
  final resolvedFallback = fallback ?? S.current.screensMainStatsStatsFormattersUnknown;
  if (dateTime == null) {
    return resolvedFallback;
  }

  return DateFormat.yMd(Intl.getCurrentLocale()).format(dateTime);
}

String formatDateTimeLabel(DateTime? dateTime, {String? fallback}) {
  final resolvedFallback = fallback ?? S.current.screensMainStatsStatsFormattersUnknown;
  if (dateTime == null) {
    return resolvedFallback;
  }

  return DateFormat.yMd(Intl.getCurrentLocale()).add_Hm().format(dateTime);
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
