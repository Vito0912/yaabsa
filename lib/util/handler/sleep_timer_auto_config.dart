import 'sleep_timer_data.dart';

class SleepTimerAutoConfig {
  const SleepTimerAutoConfig({
    required this.enabled,
    required this.mode,
    required this.minutes,
    required this.chapters,
    required this.useTimeRange,
    required this.startMinutes,
    required this.endMinutes,
  });

  final bool enabled;
  final SleepTimerMode mode;
  final int minutes;
  final int chapters;
  final bool useTimeRange;
  final int startMinutes;
  final int endMinutes;

  bool shouldStart({required DateTime now, required bool active, required bool playing, required bool hasChapters}) {
    if (!enabled || active || !playing) return false;
    if (mode == SleepTimerMode.chapters && !hasChapters) return false;
    if (!useTimeRange) return true;

    final start = startMinutes % 1440;
    final end = endMinutes % 1440;
    final minute = now.hour * 60 + now.minute;

    if (start == end) return true;
    if (start < end) return minute >= start && minute < end;
    return minute >= start || minute < end;
  }
}
