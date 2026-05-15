import 'package:flutter/material.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/components/sessions/listening_session_utils.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';

class ListeningSessionTile extends StatelessWidget {
  const ListeningSessionTile({
    required this.session,
    super.key,
    this.username,
    this.onTap,
    this.showDivider = true,
    this.showSelection = false,
    this.isSelected = false,
    this.onSelectionChanged,
  });

  final PlaybackSession session;
  final String? username;
  final VoidCallback? onTap;
  final bool showDivider;
  final bool showSelection;
  final bool isSelected;
  final ValueChanged<bool>? onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final subtitleParts = <String>[];

    final author = listeningSessionAuthor(session);
    if (author.isNotEmpty) {
      subtitleParts.add(author);
    }

    if (username != null && username!.trim().isNotEmpty) {
      subtitleParts.add(username!.trim());
    }

    subtitleParts.add(formatDateTimeLabel(listeningSessionDateTime(session)));

    final deviceLabel = listeningSessionDeviceLabel(session);
    if (deviceLabel.isNotEmpty) {
      subtitleParts.add(deviceLabel);
    }

    final progressLabel = listeningSessionProgressLabel(session);

    return Column(
      children: [
        ListTile(
          dense: false,
          minVerticalPadding: 2,
          contentPadding: const EdgeInsets.symmetric(horizontal: 6),
          leading: showSelection
              ? Checkbox(
                  value: isSelected,
                  onChanged: onSelectionChanged == null
                      ? null
                      : (value) {
                          if (value == null) {
                            return;
                          }
                          onSelectionChanged!(value);
                        },
                )
              : null,
          title: Text(listeningSessionTitle(session), maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(subtitleParts.join(' • '), maxLines: 2, overflow: TextOverflow.ellipsis),
          trailing: SizedBox(
            width: 92,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  listeningSessionListeningTimeLabel(session),
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                if (progressLabel.isNotEmpty)
                  Text(
                    progressLabel,
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          onTap: onTap,
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }
}
