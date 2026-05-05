class ListeningActivityStats {
  ListeningActivityStats({
    required Map<int, double> dailyListeningSeconds,
    required this.loadedPages,
    required this.loadedSessions,
  }) : dailyListeningSeconds = Map.unmodifiable(dailyListeningSeconds);

  const ListeningActivityStats.empty()
    : dailyListeningSeconds = const <int, double>{},
      loadedPages = 0,
      loadedSessions = 0;

  final Map<int, double> dailyListeningSeconds;
  final int loadedPages;
  final int loadedSessions;

  double totalForLastDays(int days, {DateTime? reference}) {
    if (days <= 0) {
      return 0;
    }

    final end = _normalizeLocalDay(reference ?? DateTime.now());
    var total = 0.0;

    for (var offset = 0; offset < days; offset++) {
      final day = end.subtract(Duration(days: offset));
      total += dailyListeningSeconds[dayKeyFromDate(day)] ?? 0;
    }

    return total;
  }

  List<double> valuesForLastDays(int days, {DateTime? reference}) {
    if (days <= 0) {
      return const <double>[];
    }

    final end = _normalizeLocalDay(reference ?? DateTime.now());
    final start = end.subtract(Duration(days: days - 1));

    return List<double>.generate(days, (index) {
      final day = start.add(Duration(days: index));
      return dailyListeningSeconds[dayKeyFromDate(day)] ?? 0;
    }, growable: false);
  }
}

int dayKeyFromDate(DateTime value) {
  final day = _normalizeLocalDay(value);
  return day.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
}

DateTime dayFromKey(int key) {
  return DateTime.fromMillisecondsSinceEpoch(key * Duration.millisecondsPerDay);
}

DateTime _normalizeLocalDay(DateTime value) {
  final local = value.toLocal();
  return DateTime(local.year, local.month, local.day);
}
