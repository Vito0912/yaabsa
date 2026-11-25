import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/util/audio_handler/player_history_handler.dart';
import 'package:yaabsa/util/extensions.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

class LocalHistoryEventGroup {
  LocalHistoryEventGroup({required this.type, required this.entries}) : assert(entries.isNotEmpty);

  final PlayerHistoryType type;
  final List<PlayerHistoryEntry> entries;

  bool get isGrouped => entries.length > 1;
  PlayerHistoryEntry get latestEntry => entries.first;
  PlayerHistoryEntry get oldestEntry => entries.last;
}

class PlayHistoryEventGroupTile extends StatelessWidget {
  const PlayHistoryEventGroupTile({
    super.key,
    required this.group,
    required this.onPlayFromHere,
    required this.expanded,
    required this.onToggleExpanded,
    this.pendingEntryId,
  });

  final LocalHistoryEventGroup group;
  final ValueChanged<PlayerHistoryEntry> onPlayFromHere;
  final int? pendingEntryId;
  final bool expanded;
  final VoidCallback onToggleExpanded;

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
    return Semantics(
      expanded: expanded,
      child: ListTile(
        onTap: onToggleExpanded,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: _EventIcon(type: group.type, color: eventColor),
        title: Text(
          context.l10n.historyEventProgressUpdates,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          context.l10n.eventCount(group.entries.length),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        trailing: Icon(expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded),
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
                        _eventTitle(type, context.l10n),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _timeLabel(entry, Localizations.localeOf(context).toLanguageTag()),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  _eventDescription(entry, type, context.l10n),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          if (canPlay) ...[
            const SizedBox(width: 6),
            IconButton(
              tooltip: context.l10n.playbackPlayFromHere,
              visualDensity: VisualDensity.compact,
              onPressed: pending ? null : () => onPlayFromHere(entry),
              icon: pending
                  ? const SizedBox.square(dimension: 18, child: YaabsaCircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.play_arrow_rounded),
            ),
          ],
        ],
      ),
    );
  }
}

class PlayHistoryGroupedEventDetail extends StatelessWidget {
  const PlayHistoryGroupedEventDetail({
    super.key,
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
      padding: const EdgeInsets.fromLTRB(62, 8, 14, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.historyTimeAndDescription(
                _timeLabel(entry, Localizations.localeOf(context).toLanguageTag()),
                _eventDescription(entry, type, context.l10n),
              ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ),
          if (canPlay)
            IconButton(
              tooltip: context.l10n.playbackPlayFromHere,
              visualDensity: VisualDensity.compact,
              onPressed: pending ? null : () => onPlayFromHere(entry),
              icon: pending
                  ? const SizedBox.square(dimension: 16, child: YaabsaCircularProgressIndicator(strokeWidth: 2))
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

String _timeLabel(PlayerHistoryEntry entry, String locale) => DateFormat.jms(locale).format(entry.created.toLocal());

String _positionLabel(num seconds) =>
    Duration(microseconds: (seconds.toDouble() * Duration.microsecondsPerSecond).round()).toHhMmString();

num? _numberDetail(Map<String, dynamic> details, String key) {
  final value = details[key];
  return value is num ? value : null;
}

String _eventDescription(PlayerHistoryEntry entry, PlayerHistoryType type, AppLocalizations l10n) {
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
      return l10n.historyPausedAt(position);
    case PlayerHistoryType.stop:
      return l10n.historyStoppedAt(position);
    case PlayerHistoryType.completed:
      return 'Finished';
    case PlayerHistoryType.seek:
      if (fromPosition != null && toPosition != null) {
        return l10n.historyPositionRange(_positionLabel(fromPosition), _positionLabel(toPosition));
      }
      return l10n.historyToPosition(position);
    case PlayerHistoryType.skipForward:
      return chapterTitle == null ? l10n.historyToPosition(position) : l10n.historyToChapter(chapterTitle);
    case PlayerHistoryType.skipBackward:
      return chapterTitle == null ? l10n.historyToPosition(position) : l10n.historyToChapter(chapterTitle);
    case PlayerHistoryType.speedChanged:
      final previousSpeed = _numberDetail(details, 'previousSpeed');
      final speed = _numberDetail(details, 'speed');
      if (previousSpeed == null || speed == null) {
        return l10n.historyEventSpeedChanged;
      }
      return l10n.historySpeedRange(previousSpeed.toDouble(), speed.toDouble());
    case PlayerHistoryType.sleepTimerStarted:
      if (details['mode'] == 'chapters') {
        return l10n.historyForValue(_chapterCountLabel(l10n, details['chapters']));
      }
      if (details['source'] == 'resume') {
        return duration == null ? l10n.historySleepTimerResumed : l10n.historyDurationLeft(_positionLabel(duration));
      }
      return duration == null ? l10n.historySleepTimerStarted : l10n.historyForValue(_positionLabel(duration));
    case PlayerHistoryType.sleepTimerAutoStarted:
      if (details['mode'] == 'chapters') {
        return l10n.historyForValue(_chapterCountLabel(l10n, details['chapters']));
      }
      return duration == null ? l10n.historySleepTimerAutoStarted : l10n.historyForValue(_positionLabel(duration));
    case PlayerHistoryType.sleepTimerExtended:
      if (details['mode'] == 'chapters') {
        final additionalChapters = _chapterCountLabel(l10n, details['additionalChapters']);
        final remainingChapters = _chapterCountLabel(l10n, details['remainingChapters']);
        return l10n.historySleepTimerExtended(additionalChapters, remainingChapters);
      }
      if (additional != null && remaining != null) {
        return l10n.historySleepTimerExtended(_positionLabel(additional), _positionLabel(remaining));
      }
      return l10n.historyEventSleepTimerExtended;
    case PlayerHistoryType.sleepTimerStopped:
      if (details['mode'] == 'chapters') {
        return l10n.historyDurationLeft(_chapterCountLabel(l10n, details['remainingChapters']));
      }
      if (remaining == null) {
        return l10n.historySleepTimerStopped;
      }
      final source = details['source'];
      String action;
      if (source == 'playback') {
        action = 'pause';
      } else if (source == 'reset') {
        action = 'reset';
      } else {
        action = 'stop';
      }
      return l10n.historySleepTimerRemaining(action, _positionLabel(remaining));
    case PlayerHistoryType.sleepTimerExpired:
      return l10n.historyPlaybackEndedByTimer(details['action'] as String? ?? 'stop');
    case PlayerHistoryType.sync:
      return l10n.historyProgressAtPosition(l10n.statusSynced, position);
    case PlayerHistoryType.syncOffline:
      return l10n.historyProgressAtPosition(l10n.statusSaved, position);
    case PlayerHistoryType.localSync:
      return l10n.historyProgressAtPosition(l10n.statusUploaded, position);
    case PlayerHistoryType.unknown:
      return position;
  }
}

String _eventTitle(PlayerHistoryType type, AppLocalizations l10n) {
  switch (type) {
    case PlayerHistoryType.play:
      return l10n.historyEventPlaybackStarted;
    case PlayerHistoryType.pause:
      return l10n.statusPaused;
    case PlayerHistoryType.stop:
      return l10n.historyEventStopped;
    case PlayerHistoryType.completed:
      return l10n.statusFinished;
    case PlayerHistoryType.seek:
      return l10n.historyEventPositionChanged;
    case PlayerHistoryType.skipForward:
      return l10n.historyEventSkippedForward;
    case PlayerHistoryType.skipBackward:
      return l10n.historyEventSkippedBack;
    case PlayerHistoryType.speedChanged:
      return l10n.historyEventSpeedChanged;
    case PlayerHistoryType.sleepTimerStarted:
      return l10n.historyEventSleepTimerStarted;
    case PlayerHistoryType.sleepTimerAutoStarted:
      return l10n.historyEventSleepTimerAutoStarted;
    case PlayerHistoryType.sleepTimerExtended:
      return l10n.historyEventSleepTimerExtended;
    case PlayerHistoryType.sleepTimerStopped:
      return l10n.historyEventSleepTimerStopped;
    case PlayerHistoryType.sleepTimerExpired:
      return l10n.historyEventSleepTimerEnded;
    case PlayerHistoryType.sync:
      return l10n.historyEventProgressSynced;
    case PlayerHistoryType.syncOffline:
      return l10n.historyEventOfflineProgressSaved;
    case PlayerHistoryType.localSync:
      return l10n.historyEventOfflineProgressSynced;
    case PlayerHistoryType.unknown:
      return l10n.headingActivity;
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

String _chapterCountLabel(AppLocalizations l10n, Object? value) {
  final int count;
  if (value is num) {
    count = value.round();
  } else {
    count = int.tryParse(value?.toString() ?? '') ?? 0;
  }

  return l10n.chapterCount(count);
}
