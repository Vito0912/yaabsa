import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/util/audio_handler/player_history_handler.dart';
import 'package:yaabsa/util/extensions.dart';

class LocalHistoryEventGroup {
  LocalHistoryEventGroup({required this.type, required this.entries}) : assert(entries.isNotEmpty);

  final PlayerHistoryType type;
  final List<PlayerHistoryEntry> entries;

  bool get isGrouped => entries.length > 1;
  PlayerHistoryEntry get latestEntry => entries.first;
  PlayerHistoryEntry get oldestEntry => entries.last;
}

class PlayHistoryEventGroupTile extends StatelessWidget {
  const PlayHistoryEventGroupTile({super.key, required this.group, required this.onPlayFromHere, this.pendingEntryId});

  final LocalHistoryEventGroup group;
  final ValueChanged<PlayerHistoryEntry> onPlayFromHere;
  final int? pendingEntryId;

  @override
  Widget build(BuildContext context) {
    if (!group.isGrouped) {
      return _HistoryEventRow(
        entry: group.latestEntry,
        type: group.type,
        onPlayFromHere: onPlayFromHere,
        pending: pendingEntryId == group.latestEntry.id,
      );
    }

    final colorScheme = Theme.of(context).colorScheme;
    final eventColor = _eventColor(colorScheme, group.type);
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        key: PageStorageKey<String>('history-${group.type.name}-${group.latestEntry.id}-${group.entries.length}'),
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
        leading: _EventIcon(type: group.type, color: eventColor),
        title: Text(
          _eventTitle(group.type),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${group.entries.length} events',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        children: [
          for (final entry in group.entries)
            _GroupedEventDetail(
              entry: entry,
              type: group.type,
              onPlayFromHere: onPlayFromHere,
              pending: pendingEntryId == entry.id,
            ),
        ],
      ),
    );
  }
}

class _HistoryEventRow extends StatelessWidget {
  const _HistoryEventRow({
    required this.entry,
    required this.type,
    required this.onPlayFromHere,
    required this.pending,
  });

  final PlayerHistoryEntry entry;
  final PlayerHistoryType type;
  final ValueChanged<PlayerHistoryEntry> onPlayFromHere;
  final bool pending;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final eventColor = _eventColor(colorScheme, type);
    final canPlay = _canPlayFrom(type);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EventIcon(type: type, color: eventColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _eventTitle(type),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _timeLabel(entry),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  _eventDescription(entry, type),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          if (canPlay) ...[
            const SizedBox(width: 6),
            IconButton(
              tooltip: 'Play from here',
              visualDensity: VisualDensity.compact,
              onPressed: pending ? null : () => onPlayFromHere(entry),
              icon: pending
                  ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.play_arrow_rounded),
            ),
          ],
        ],
      ),
    );
  }
}

class _GroupedEventDetail extends StatelessWidget {
  const _GroupedEventDetail({
    required this.entry,
    required this.type,
    required this.onPlayFromHere,
    required this.pending,
  });

  final PlayerHistoryEntry entry;
  final PlayerHistoryType type;
  final ValueChanged<PlayerHistoryEntry> onPlayFromHere;
  final bool pending;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final canPlay = _canPlayFrom(type);
    return Padding(
      padding: const EdgeInsets.only(left: 48, top: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${_timeLabel(entry)} • ${_eventDescription(entry, type)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ),
          if (canPlay)
            IconButton(
              tooltip: 'Play from here',
              visualDensity: VisualDensity.compact,
              onPressed: pending ? null : () => onPlayFromHere(entry),
              icon: pending
                  ? const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.play_arrow_rounded, size: 20),
            ),
        ],
      ),
    );
  }
}

class _EventIcon extends StatelessWidget {
  const _EventIcon({required this.type, required this.color});

  final PlayerHistoryType type;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(color: color.withValues(alpha: 0.13), borderRadius: BorderRadius.circular(12)),
      alignment: Alignment.center,
      child: Icon(_eventIcon(type), size: 20, color: color),
    );
  }
}

String _timeLabel(PlayerHistoryEntry entry) => DateFormat.Hms().format(entry.created.toLocal());

String _positionLabel(num seconds) =>
    Duration(microseconds: (seconds.toDouble() * Duration.microsecondsPerSecond).round()).toHhMmString();

num? _numberDetail(Map<String, dynamic> details, String key) {
  final value = details[key];
  return value is num ? value : null;
}

String _eventDescription(PlayerHistoryEntry entry, PlayerHistoryType type) {
  final details = decodePlayerHistoryDetails(entry.detailsJson);
  final position = _positionLabel(entry.currentTime);
  final fromPosition = _numberDetail(details, 'fromPosition');
  final toPosition = _numberDetail(details, 'toPosition');
  final duration = _numberDetail(details, 'durationSeconds');
  final remaining = _numberDetail(details, 'remainingSeconds');
  final additional = _numberDetail(details, 'additionalSeconds');
  final chapterTitle = details['chapterTitle'] as String?;

  switch (type) {
    case PlayerHistoryType.play:
      return position;
    case PlayerHistoryType.pause:
      return 'Paused at $position';
    case PlayerHistoryType.stop:
      return 'Stopped at $position';
    case PlayerHistoryType.completed:
      return 'Finished';
    case PlayerHistoryType.seek:
      if (fromPosition != null && toPosition != null) {
        return '${_positionLabel(fromPosition)} - ${_positionLabel(toPosition)}';
      }
      return 'To $position';
    case PlayerHistoryType.skipForward:
      return chapterTitle == null ? 'To $position' : 'To $chapterTitle';
    case PlayerHistoryType.skipBackward:
      return chapterTitle == null ? 'To $position' : 'To $chapterTitle';
    case PlayerHistoryType.speedChanged:
      final previousSpeed = _numberDetail(details, 'previousSpeed');
      final speed = _numberDetail(details, 'speed');
      return previousSpeed == null || speed == null
          ? 'Changed'
          : '${previousSpeed.toStringAsFixed(2)}× - ${speed.toStringAsFixed(2)}×';
    case PlayerHistoryType.sleepTimerStarted:
      if (details['source'] == 'resume') {
        return duration == null ? 'Resumed' : '${_positionLabel(duration)} left';
      }
      return duration == null ? 'Started' : 'For ${_positionLabel(duration)}';
    case PlayerHistoryType.sleepTimerAutoStarted:
      return duration == null ? 'Auto-started' : 'For ${_positionLabel(duration)}';
    case PlayerHistoryType.sleepTimerExtended:
      if (additional != null && remaining != null) {
        return '+${_positionLabel(additional)} • ${_positionLabel(remaining)} left';
      }
      return 'Extended';
    case PlayerHistoryType.sleepTimerStopped:
      final prefix = details['source'] == 'playback'
          ? 'Paused with'
          : details['source'] == 'reset'
          ? 'Reset with'
          : 'Stopped with';
      return remaining == null ? 'Stopped' : '$prefix ${_positionLabel(remaining)} left';
    case PlayerHistoryType.sleepTimerExpired:
      return details['action'] == 'pause' ? 'Paused playback' : 'Stopped playback';
    case PlayerHistoryType.sync:
      return 'Synced at $position';
    case PlayerHistoryType.syncOffline:
      return 'Saved at $position';
    case PlayerHistoryType.localSync:
      return 'Uploaded at $position';
    case PlayerHistoryType.unknown:
      return position;
  }
}

String _eventTitle(PlayerHistoryType type) {
  switch (type) {
    case PlayerHistoryType.play:
      return 'Playback started';
    case PlayerHistoryType.pause:
      return 'Paused';
    case PlayerHistoryType.stop:
      return 'Stopped';
    case PlayerHistoryType.completed:
      return 'Completed';
    case PlayerHistoryType.seek:
      return 'Position changed';
    case PlayerHistoryType.skipForward:
      return 'Skipped forward';
    case PlayerHistoryType.skipBackward:
      return 'Skipped back';
    case PlayerHistoryType.speedChanged:
      return 'Speed changed';
    case PlayerHistoryType.sleepTimerStarted:
      return 'Sleep timer started';
    case PlayerHistoryType.sleepTimerAutoStarted:
      return 'Sleep timer auto-started';
    case PlayerHistoryType.sleepTimerExtended:
      return 'Sleep timer extended';
    case PlayerHistoryType.sleepTimerStopped:
      return 'Sleep timer stopped';
    case PlayerHistoryType.sleepTimerExpired:
      return 'Sleep timer ended';
    case PlayerHistoryType.sync:
      return 'Progress synced';
    case PlayerHistoryType.syncOffline:
      return 'Offline progress saved';
    case PlayerHistoryType.localSync:
      return 'Offline progress synced';
    case PlayerHistoryType.unknown:
      return 'Activity';
  }
}

IconData _eventIcon(PlayerHistoryType type) {
  switch (type) {
    case PlayerHistoryType.play:
      return Icons.play_arrow_rounded;
    case PlayerHistoryType.pause:
      return Icons.pause_rounded;
    case PlayerHistoryType.stop:
      return Icons.stop_rounded;
    case PlayerHistoryType.completed:
      return Icons.check_rounded;
    case PlayerHistoryType.seek:
      return Icons.swap_horiz_rounded;
    case PlayerHistoryType.skipForward:
      return Icons.forward_10_rounded;
    case PlayerHistoryType.skipBackward:
      return Icons.replay_10_rounded;
    case PlayerHistoryType.speedChanged:
      return Icons.speed_rounded;
    case PlayerHistoryType.sleepTimerStarted:
    case PlayerHistoryType.sleepTimerAutoStarted:
      return Icons.bedtime_outlined;
    case PlayerHistoryType.sleepTimerExtended:
      return Icons.more_time_rounded;
    case PlayerHistoryType.sleepTimerStopped:
      return Icons.alarm_off_rounded;
    case PlayerHistoryType.sleepTimerExpired:
      return Icons.bedtime_rounded;
    case PlayerHistoryType.sync:
    case PlayerHistoryType.localSync:
      return Icons.sync_rounded;
    case PlayerHistoryType.syncOffline:
      return Icons.cloud_off_rounded;
    case PlayerHistoryType.unknown:
      return Icons.circle_outlined;
  }
}

Color _eventColor(ColorScheme colorScheme, PlayerHistoryType type) {
  return switch (type.category) {
    PlayerHistoryCategory.playback => colorScheme.primary,
    PlayerHistoryCategory.sleepTimer => colorScheme.tertiary,
    PlayerHistoryCategory.sync => colorScheme.secondary,
    PlayerHistoryCategory.unknown => colorScheme.onSurfaceVariant,
  };
}

bool _canPlayFrom(PlayerHistoryType type) {
  return type.category == PlayerHistoryCategory.playback && type != PlayerHistoryType.completed;
}
