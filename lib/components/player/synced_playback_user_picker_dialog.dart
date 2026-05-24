import 'package:flutter/material.dart';
import 'package:yaabsa/models/social/synced_playback_invite_user.dart';

class SyncedPlaybackUserPickerDialog extends StatelessWidget {
  const SyncedPlaybackUserPickerDialog({required this.users, super.key});

  final List<SyncedPlaybackInviteUser> users;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Start Synced Playback'),
      content: SizedBox(
        width: 420,
        child: users.isEmpty
            ? const Text('No connected users are available right now.')
            : ListView.separated(
                shrinkWrap: true,
                itemCount: users.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    dense: true,
                    leading: Icon(user.isSelf ? Icons.devices_outlined : Icons.person_outline_rounded),
                    title: Text(user.displayName),
                    onTap: () => Navigator.of(context).pop(user.userId),
                  );
                },
              ),
      ),
      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel'))],
    );
  }
}
