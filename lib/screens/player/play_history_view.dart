import 'package:buchshelfly/api/me/user.dart';
import 'package:buchshelfly/database/app_database.dart';
import 'package:buchshelfly/provider/core/user_providers.dart';
import 'package:buchshelfly/util/extensions.dart';
import 'package:buchshelfly/util/globals.dart';
import 'package:buchshelfly/util/handler/player_history_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class PlayHistoryView extends ConsumerWidget {
  const PlayHistoryView({super.key});

  static const routeName = '/play-history';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(appDatabaseProvider);
    final User? user = ref.read(currentUserProvider).value;

    if (user == null || audioHandler.currentMediaItem == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Play History'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('No user or media item available', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Play History'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: StreamBuilder<List<PlayerHistoryEntry>>(
        stream: db.watchPlayerHistoryByItem(
          audioHandler.currentMediaItem!.itemId,
          user!.id,
          episodeId: audioHandler.currentMediaItem!.episodeId,
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

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: groupedHistory.length,
            itemBuilder: (context, index) {
              final dateGroup = groupedHistory[index];
              return _buildDateGroup(context, dateGroup);
            },
          );
        },
      ),
    );
  }

  List<DateGroup> _groupHistoryByDate(List<PlayerHistoryEntry> history) {
    final Map<String, List<PlayerHistoryEntry>> grouped = {};

    for (final entry in history) {
      final dateKey = DateFormat('yyyy-MM-dd').format(entry.created);
      grouped.putIfAbsent(dateKey, () => []).add(entry);
    }

    return grouped.entries
        .map(
          (entry) => DateGroup(
            date: DateTime.parse(entry.key),
            entries: entry.value..sort((a, b) => b.created.compareTo(a.created)),
          ),
        )
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Widget _buildDateGroup(BuildContext context, DateGroup dateGroup) {
    final isToday = _isToday(dateGroup.date);
    final isYesterday = _isYesterday(dateGroup.date);

    String dateLabel;
    if (isToday) {
      dateLabel = 'Today';
    } else if (isYesterday) {
      dateLabel = 'Yesterday';
    } else {
      dateLabel = DateFormat('MMMM d, yyyy').format(dateGroup.date);
    }

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
          elevation: 2,
          child: Column(children: dateGroup.entries.map((entry) => _buildHistoryItem(context, entry)).toList()),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(BuildContext context, PlayerHistoryEntry entry) {
    final type = _getPlayerHistoryType(entry.type);
    final icon = _getIconForType(type);
    final color = _getColorForType(context, type);
    final timeText = entry.currentTime.toDuration.toHhMmString();
    final timestampText = DateFormat('HH:mm:ss').format(entry.created);

    return ListTile(
      leading: CircleAvatar(backgroundColor: color.withOpacity(0.2), child: Icon(icon, color: color, size: 20)),
      title: Row(
        children: [
          Text(_getTypeDisplayName(type), style: TextStyle(fontWeight: FontWeight.w500, color: color)),
          const Spacer(),
          Text(timestampText, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
      subtitle: Text('Position: $timeText', style: TextStyle(color: Colors.grey[700])),
      onTap: _canSeek(type) ? () => audioHandler.seek(entry.currentTime.toDuration) : null,
      trailing: _canSeek(type) ? Icon(Icons.play_arrow, color: color) : null,
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

class DateGroup {
  final DateTime date;
  final List<PlayerHistoryEntry> entries;

  DateGroup({required this.date, required this.entries});
}
