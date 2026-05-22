import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/util/extensions.dart';

class LocalHistoryEventGroup {
  LocalHistoryEventGroup({required this.type, required this.entries}) : assert(entries.isNotEmpty);

  final String type;
  final List<PlayerHistoryEntry> entries;

  bool get isGrouped => entries.length > 1;

  PlayerHistoryEntry get latestEntry => entries.first;

  PlayerHistoryEntry get oldestEntry => entries.last;
}

class PlayHistoryEventGroupTile extends StatelessWidget {
  static final DateFormat _timeFormat = DateFormat('HH:mm:ss');

  const PlayHistoryEventGroupTile({
    super.key,
    required this.group,
    required this.icon,
    required this.color,
    required this.typeDisplayName,
    required this.canSeek,
    this.onSeek,
  });

  final LocalHistoryEventGroup group;
  final IconData icon;
  final Color color;
  final String typeDisplayName;
  final bool canSeek;
  final ValueChanged<PlayerHistoryEntry>? onSeek;

  @override
  Widget build(BuildContext context) {
    final latestEntry = group.latestEntry;
    final latestTimestamp = _timeFormat.format(latestEntry.created.toLocal());
    final summaryPositionText = latestEntry.currentTime.toDuration.toHhMmString();
    final seekEnabled = canSeek && onSeek != null;

    if (!group.isGrouped) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        elevation: 2,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          leading: CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.2),
            child: Icon(icon, color: color, size: 20),
          ),
          title: Text(
            typeDisplayName,
            style: TextStyle(fontWeight: FontWeight.w500, color: color),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '$latestTimestamp - Position: $summaryPositionText',
            style: TextStyle(color: Colors.grey[700]),
          ),
          onTap: seekEnabled ? () => onSeek?.call(latestEntry) : null,
          trailing: seekEnabled ? Icon(Icons.play_arrow, color: color) : null,
        ),
      );
    }

    final oldestTimestamp = _timeFormat.format(group.oldestEntry.created.toLocal());

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: PageStorageKey<String>('history-group-${group.type}-${latestEntry.id}-${group.entries.length}'),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          childrenPadding: const EdgeInsets.only(bottom: 8),
          leading: CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.2),
            child: Icon(icon, color: color, size: 20),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  typeDisplayName,
                  style: TextStyle(fontWeight: FontWeight.w500, color: color),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  '${group.entries.length} events',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
                ),
              ),
            ],
          ),
          subtitle: Text(
            'Latest: $latestTimestamp - Earliest: $oldestTimestamp',
            style: TextStyle(color: Colors.grey[700]),
          ),
          children: group.entries.map((entry) => _buildDetailTile(entry)).toList(growable: false),
        ),
      ),
    );
  }

  Widget _buildDetailTile(PlayerHistoryEntry entry) {
    final seekEnabled = canSeek && onSeek != null;
    final timestampText = _timeFormat.format(entry.created.toLocal());
    final positionText = entry.currentTime.toDuration.toHhMmString();

    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      leading: const Icon(Icons.subdirectory_arrow_right, size: 18),
      title: Text(timestampText, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      subtitle: Text('Position: $positionText'),
      onTap: seekEnabled ? () => onSeek?.call(entry) : null,
      trailing: seekEnabled ? Icon(Icons.play_arrow, color: color) : null,
    );
  }
}
