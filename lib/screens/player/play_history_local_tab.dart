import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yaabsa/components/common/scroll_to_top_button.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/player/components/play_history_event_group_tile.dart';
import 'package:yaabsa/util/audio_handler/player_history_handler.dart';
import 'package:yaabsa/util/extensions.dart';
import 'package:yaabsa/util/globals.dart';

class PlayHistoryLocalTab extends ConsumerStatefulWidget {
  const PlayHistoryLocalTab({super.key, required this.itemId, required this.episodeId});

  final String itemId;
  final String? episodeId;

  @override
  ConsumerState<PlayHistoryLocalTab> createState() => _PlayHistoryLocalTabState();
}

class _PlayHistoryLocalTabState extends ConsumerState<PlayHistoryLocalTab> {
  static const int _historyQueryLimit = 1200;

  final ScrollController _scrollController = ScrollController();
  final Set<int> _expandedGroupIds = <int>{};
  Stream<List<PlayerHistoryEntry>>? _historyStream;
  AppDatabase? _historyDatabase;
  String? _historyUserId;
  int? _pendingEntryId;

  @override
  void didUpdateWidget(covariant PlayHistoryLocalTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemId != widget.itemId || oldWidget.episodeId != widget.episodeId) {
      _historyStream = null;
      _expandedGroupIds.clear();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    if (user == null) {
      return const _HistoryMessage(
        icon: Icons.person_off_outlined,
        title: 'No active user',
        message: 'Sign in to view playback activity.',
      );
    }

    final database = ref.watch(appDatabaseProvider);
    if (_historyStream == null || _historyDatabase != database || _historyUserId != user.id) {
      if (_historyDatabase != database || _historyUserId != user.id) {
        _expandedGroupIds.clear();
      }

      _historyDatabase = database;
      _historyUserId = user.id;
      _historyStream = database.watchPlayerHistoryByItem(
        widget.itemId,
        user.id,
        episodeId: widget.episodeId,
        limit: _historyQueryLimit,
      );
    }

    return StreamBuilder<List<PlayerHistoryEntry>>(
      key: ValueKey((database, user.id, widget.itemId, widget.episodeId)),
      stream: _historyStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _HistoryMessage(
            icon: Icons.error_outline_rounded,
            title: 'Could not load activity',
            message: snapshot.error.toString(),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildHistory(context, snapshot.data!);
      },
    );
  }

  Widget _buildHistory(BuildContext context, List<PlayerHistoryEntry> history) {
    if (history.isEmpty) {
      return const _HistoryMessage(
        icon: Icons.history_rounded,
        title: 'No activity yet',
        message: 'Playback controls, sleep timer changes, and sync activity will appear here.',
      );
    }

    final rows = _buildRows(_groupHistoryByDate(history));

    return Stack(
      children: [
        Positioned.fill(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(child: _buildHistoryHeader(context, history.length)),
              SliverList.builder(
                itemCount: rows.length,
                itemBuilder: (context, index) {
                  final row = rows[index];
                  final group = row.group;
                  if (group == null) {
                    return _DateHeader(date: row.date!);
                  }

                  final entry = row.entry;
                  return _HistoryCardRow(
                    first: row.first,
                    last: row.last,
                    showDivider: !row.first && entry == null,
                    child: entry == null
                        ? PlayHistoryEventGroupTile(
                            group: group,
                            pendingEntryId: _pendingEntryId,
                            onPlayFromHere: _playFromHistory,
                            expanded: _expandedGroupIds.contains(group.oldestEntry.id),
                            onToggleExpanded: () => _toggleGroup(group),
                          )
                        : PlayHistoryGroupedEventDetail(
                            entry: entry,
                            type: playerHistoryTypeFromName(entry.type),
                            onPlayFromHere: _playFromHistory,
                            pending: _pendingEntryId == entry.id,
                          ),
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
        ScrollToTopButton(controller: _scrollController),
      ],
    );
  }

  void _toggleGroup(LocalHistoryEventGroup group) {
    setState(() {
      final id = group.oldestEntry.id;
      if (!_expandedGroupIds.remove(id)) {
        _expandedGroupIds.add(id);
      }
    });
  }

  List<_HistoryListRow> _buildRows(List<_DateGroup> days) {
    final rows = <_HistoryListRow>[];
    for (final day in days) {
      rows.add(_HistoryListRow(date: day.date));

      for (var index = 0; index < day.eventGroups.length; index++) {
        final group = day.eventGroups[index];
        final expanded = group.isGrouped && _expandedGroupIds.contains(group.oldestEntry.id);
        final lastGroup = index == day.eventGroups.length - 1;
        rows.add(_HistoryListRow(group: group, first: index == 0, last: lastGroup && !expanded));

        if (expanded) {
          for (var entryIndex = 0; entryIndex < group.entries.length; entryIndex++) {
            rows.add(
              _HistoryListRow(
                group: group,
                entry: group.entries[entryIndex],
                last: lastGroup && entryIndex == group.entries.length - 1,
              ),
            );
          }
        }
      }
    }

    return rows;
  }

  Widget _buildHistoryHeader(BuildContext context, int eventCount) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'On this device',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '$eventCount ${eventCount == 1 ? 'event' : 'events'}',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  List<_DateGroup> _groupHistoryByDate(List<PlayerHistoryEntry> history) {
    final groups = <_DateGroup>[];
    DateTime? activeDay;
    List<LocalHistoryEventGroup> activeEvents = <LocalHistoryEventGroup>[];

    void flushDay() {
      final dayToFlush = activeDay;
      if (dayToFlush == null || activeEvents.isEmpty) {
        return;
      }
      groups.add(_DateGroup(date: dayToFlush, eventGroups: activeEvents));
      activeEvents = <LocalHistoryEventGroup>[];
    }

    for (final entry in history) {
      final localCreated = entry.created.toLocal();
      final day = DateTime(localCreated.year, localCreated.month, localCreated.day);
      final currentDay = activeDay;
      if (currentDay == null || !_isSameDay(currentDay, day)) {
        flushDay();
        activeDay = day;
      }

      final type = playerHistoryTypeFromName(entry.type);
      final canJoinPrevious =
          type.category == PlayerHistoryCategory.sync &&
          activeEvents.isNotEmpty &&
          activeEvents.last.type.category == PlayerHistoryCategory.sync;
      if (canJoinPrevious) {
        activeEvents.last.entries.add(entry);
      } else {
        activeEvents.add(LocalHistoryEventGroup(type: type, entries: <PlayerHistoryEntry>[entry]));
      }
    }

    flushDay();
    return groups;
  }

  Future<void> _playFromHistory(PlayerHistoryEntry entry) async {
    if (_pendingEntryId != null) {
      return;
    }

    setState(() => _pendingEntryId = entry.id);
    final started = await audioHandler.playItemFromPosition(
      itemId: widget.itemId,
      episodeId: widget.episodeId,
      position: entry.currentTime.toDuration,
    );

    if (!mounted) {
      return;
    }

    setState(() => _pendingEntryId = null);
    if (started) {
      await PlayerHistoryHandler.addPlayerHistory(
        PlayerHistoryType.seek,
        position: entry.currentTime.toDuration,
        details: <String, Object?>{'toPosition': entry.currentTime, 'source': 'history'},
      );
      if (!mounted) {
        return;
      }
      context.go('/player');
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Could not start playback from this position.')));
  }
}

class _HistoryListRow {
  const _HistoryListRow({this.date, this.group, this.entry, this.first = false, this.last = false});

  final DateTime? date;
  final LocalHistoryEventGroup? group;
  final PlayerHistoryEntry? entry;
  final bool first;
  final bool last;
}

class _HistoryCardRow extends StatelessWidget {
  const _HistoryCardRow({required this.first, required this.last, required this.showDivider, required this.child});

  final bool first;
  final bool last;
  final bool showDivider;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 14 : 0),
      child: Material(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(first ? 18 : 0),
          bottom: Radius.circular(last ? 18 : 0),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showDivider) Divider(height: 1, indent: 64, color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            child,
          ],
        ),
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 7),
      child: Text(_dateLabel(date), style: Theme.of(context).textTheme.titleSmall),
    );
  }

  String _dateLabel(DateTime date) {
    final now = DateTime.now();
    if (_isSameDay(now, date)) {
      return 'Today';
    }
    if (_isSameDay(now.subtract(const Duration(days: 1)), date)) {
      return 'Yesterday';
    }
    return DateFormat.yMMMMd().format(date);
  }
}

class _HistoryMessage extends StatelessWidget {
  const _HistoryMessage({required this.icon, required this.title, required this.message});

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 38, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(
              message,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateGroup {
  const _DateGroup({required this.date, required this.eventGroups});

  final DateTime date;
  final List<LocalHistoryEventGroup> eventGroups;
}

bool _isSameDay(DateTime left, DateTime right) {
  return left.year == right.year && left.month == right.month && left.day == right.day;
}
