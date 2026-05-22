import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yaabsa/components/common/scroll_to_top_button.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/player/components/play_history_event_group_tile.dart';
import 'package:yaabsa/util/extensions.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/audio_handler/player_history_handler.dart';

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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(appDatabaseProvider);
    final user = ref.watch(currentUserProvider).value;

    if (user == null) {
      return const Center(child: Text('No active user.'));
    }

    return StreamBuilder<List<PlayerHistoryEntry>>(
      stream: db.watchPlayerHistoryByItem(
        widget.itemId,
        user.id,
        episodeId: widget.episodeId,
        limit: _historyQueryLimit,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No play history available', style: TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
          );
        }

        final history = snapshot.data!;
        final groupedHistory = _groupHistoryByDate(history);

        return Stack(
          children: [
            Positioned.fill(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                itemCount: groupedHistory.length,
                itemBuilder: (context, index) {
                  final dateGroup = groupedHistory[index];
                  return _buildDateGroup(context, dateGroup);
                },
              ),
            ),
            ScrollToTopButton(controller: _scrollController),
          ],
        );
      },
    );
  }

  List<_DateGroup> _groupHistoryByDate(List<PlayerHistoryEntry> history) {
    if (history.isEmpty) {
      return <_DateGroup>[];
    }

    final grouped = <_DateGroup>[];

    DateTime? activeDay;
    String? activeType;
    final activeEntries = <PlayerHistoryEntry>[];
    final activeDayGroups = <LocalHistoryEventGroup>[];

    void flushEventGroup() {
      if (activeType == null || activeEntries.isEmpty) {
        return;
      }

      activeDayGroups.add(
        LocalHistoryEventGroup(type: activeType!, entries: List<PlayerHistoryEntry>.from(activeEntries)),
      );
      activeEntries.clear();
    }

    void flushDayGroup() {
      flushEventGroup();

      if (activeDay == null) {
        return;
      }

      grouped.add(_DateGroup(date: activeDay!, eventGroups: List<LocalHistoryEventGroup>.from(activeDayGroups)));

      activeDayGroups.clear();
      activeDay = null;
      activeType = null;
    }

    for (final entry in history) {
      final localCreated = entry.created.toLocal();
      final dayKey = DateTime(localCreated.year, localCreated.month, localCreated.day);

      if (activeDay == null || !_isSameDay(activeDay!, dayKey)) {
        flushDayGroup();
        activeDay = dayKey;
      }

      if (activeType != entry.type) {
        flushEventGroup();
        activeType = entry.type;
      }

      activeEntries.add(entry);
    }

    flushDayGroup();

    return grouped;
  }

  bool _isSameDay(DateTime left, DateTime right) {
    return left.year == right.year && left.month == right.month && left.day == right.day;
  }

  Widget _buildDateGroup(BuildContext context, _DateGroup dateGroup) {
    final isToday = _isToday(dateGroup.date);
    final isYesterday = _isYesterday(dateGroup.date);

    final dateLabel = isToday
        ? 'Today'
        : isYesterday
        ? 'Yesterday'
        : DateFormat('MMMM d, yyyy').format(dateGroup.date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            dateLabel,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          elevation: 0,
          color: Colors.transparent,
          child: Column(
            children: dateGroup.eventGroups
                .map((eventGroup) {
                  final type = _getPlayerHistoryType(eventGroup.type);

                  return PlayHistoryEventGroupTile(
                    group: eventGroup,
                    icon: _getIconForType(type),
                    color: _getColorForType(context, type),
                    typeDisplayName: _getTypeDisplayName(type),
                    canSeek: _canSeek(type),
                    onSeek: (entry) => audioHandler.seek(entry.currentTime.toDuration),
                  );
                })
                .toList(growable: false),
          ),
        ),
      ],
    );
  }

  PlayerHistoryType _getPlayerHistoryType(String type) {
    return PlayerHistoryType.values.firstWhere((e) => e.name == type, orElse: () => PlayerHistoryType.sync);
  }

  IconData _getIconForType(PlayerHistoryType type) {
    switch (type) {
      case PlayerHistoryType.play:
        return Icons.play_arrow;
      case PlayerHistoryType.pause:
        return Icons.pause;
      case PlayerHistoryType.stop:
        return Icons.stop;
      case PlayerHistoryType.seek:
        return Icons.fast_forward;
      case PlayerHistoryType.sync:
        return Icons.sync;
      case PlayerHistoryType.syncOffline:
        return Icons.sync_disabled;
      case PlayerHistoryType.localSync:
        return Icons.sync_alt;
    }
  }

  Color _getColorForType(BuildContext context, PlayerHistoryType type) {
    switch (type) {
      case PlayerHistoryType.play:
        return Colors.green;
      case PlayerHistoryType.pause:
        return Colors.orange;
      case PlayerHistoryType.stop:
        return Colors.red;
      case PlayerHistoryType.seek:
        return Colors.blue;
      case PlayerHistoryType.sync:
        return Theme.of(context).colorScheme.primary;
      case PlayerHistoryType.syncOffline:
        return Colors.grey;
      case PlayerHistoryType.localSync:
        return Colors.purple;
    }
  }

  String _getTypeDisplayName(PlayerHistoryType type) {
    switch (type) {
      case PlayerHistoryType.play:
        return 'Play';
      case PlayerHistoryType.pause:
        return 'Pause';
      case PlayerHistoryType.stop:
        return 'Stop';
      case PlayerHistoryType.seek:
        return 'Seek';
      case PlayerHistoryType.sync:
        return 'Sync';
      case PlayerHistoryType.syncOffline:
        return 'Sync Offline';
      case PlayerHistoryType.localSync:
        return 'Local Sync';
    }
  }

  bool _canSeek(PlayerHistoryType type) {
    return type == PlayerHistoryType.play || type == PlayerHistoryType.pause || type == PlayerHistoryType.stop;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
  }
}

class _DateGroup {
  _DateGroup({required this.date, required this.eventGroups});

  final DateTime date;
  final List<LocalHistoryEventGroup> eventGroups;
}
