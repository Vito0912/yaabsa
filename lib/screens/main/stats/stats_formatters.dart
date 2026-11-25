import 'package:intl/intl.dart';
import 'package:yaabsa/util/item_formatters.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/provider/core/locale_provider.dart';

String formatListeningSeconds(num? seconds, {String? fallback}) {
  if (seconds == null || seconds <= 0) {
    if (fallback != null) {
      return fallback;
    }

    return currentAppLocalizations().durationMinutes(0);
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
    return currentAppLocalizations().statusUnknown;
  }

  final locale = currentAppLocale().toLanguageTag();
  return DateFormat.yMMMd(locale).add_jm().format(dateTime.toLocal());
}

String formatWeekdayName(String name) {
  final weekday = switch (name.toLowerCase()) {
    'monday' => DateTime.monday,
    'tuesday' => DateTime.tuesday,
    'wednesday' => DateTime.wednesday,
    'thursday' => DateTime.thursday,
    'friday' => DateTime.friday,
    'saturday' => DateTime.saturday,
    'sunday' => DateTime.sunday,
    _ => null,
  };
  if (weekday == null) {
    return name;
  }

  final locale = currentAppLocale().toLanguageTag();
  final date = DateTime.utc(2024, 1, weekday);
  return DateFormat.EEEE(locale).format(date);
}

String formatMonthBucket(String value) {
  final parts = value.split('-');
  if (parts.length != 2) {
    return value;
  }

  final year = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  if (year == null || month == null || month < 1 || month > 12) {
    return value;
  }

  final locale = currentAppLocale().toLanguageTag();
  return DateFormat.MMMM(locale).format(DateTime(year, month));
}

String formatHourBucket(String value) {
  final hour = int.tryParse(value.split(':').first);
  if (hour == null || hour < 0 || hour > 23) {
    return value;
  }

  final locale = currentAppLocale().toLanguageTag();
  return DateFormat.jm(locale).format(DateTime(2024, 1, 1, hour));
}

String formatNumber(num value) {
  final locale = currentAppLocale().toLanguageTag();
  return NumberFormat.decimalPattern(locale).format(value);
}

String formatCompactWeekday(DateTime date) {
  final locale = currentAppLocale().toLanguageTag();
  return DateFormat.E(locale).format(date);
}

String formatWeekdayAbbreviation(int mondayBasedIndex) {
  if (mondayBasedIndex < 0 || mondayBasedIndex > 6) {
    return '';
  }

  final date = DateTime.utc(2024, 1, mondayBasedIndex + 1);
  return formatCompactWeekday(date);
}

String formatShortDate(DateTime date) {
  final locale = currentAppLocale().toLanguageTag();
  return DateFormat.Md(locale).format(date);
}

String formatFullDate(DateTime date) {
  final locale = currentAppLocale().toLanguageTag();
  return DateFormat.yMMMd(locale).format(date);
}

String formatMonthName(DateTime date) {
  final locale = currentAppLocale().toLanguageTag();
  return DateFormat.MMMM(locale).format(date);
}

String formatCompactTimeAxis(double seconds) {
  if (seconds <= 0) {
    return formatNumber(0);
  }

  final localizations = currentAppLocalizations();
  if (seconds < 3600) {
    return localizations.durationCompactMinutes((seconds / 60).round());
  }

  return localizations.durationCompactHours((seconds / 3600).round());
}

DateTime? fromEpochMs(int? value) {
  if (value == null || value <= 0) {
    return null;
  }

  return DateTime.fromMillisecondsSinceEpoch(value);
}

String ordinalRank(int index) {
  final rank = index + 1;
  final locale = currentAppLocale().toLanguageTag();
  return NumberFormat.decimalPattern(locale).format(rank);
}
