import 'package:timezone/data/latest.dart' as data;
import 'package:timezone/timezone.dart' as tz;

class ListeningSessionClock {
  static bool _initialized = false;
  final tz.Location? _location;

  ListeningSessionClock(String? timeZone) : _location = _resolveLocation(timeZone);

  static tz.Location? _resolveLocation(String? timeZone) {
    if (timeZone == null || timeZone.trim().isEmpty) return null;
    if (!_initialized) {
      data.initializeTimeZones();
      _initialized = true;
    }
    return tz.timeZoneDatabase.locations[timeZone.trim()];
  }

  DateTime calendarDate(DateTime instant) {
    final location = _location;
    return location == null ? instant.toLocal() : tz.TZDateTime.from(instant, location);
  }

  DateTime nextMidnight(DateTime instant) {
    final date = calendarDate(instant);
    final location = _location;
    return location == null
        ? DateTime(date.year, date.month, date.day + 1)
        : tz.TZDateTime(location, date.year, date.month, date.day + 1);
  }
}
