import 'package:flutter/material.dart';

enum SyncedPlaybackInviteDialogDecision { accept, decline, ignore }

class SyncedPlaybackInvitePromptDialog extends StatelessWidget {
  const SyncedPlaybackInvitePromptDialog({required this.senderName, super.key});

  final String senderName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Synced Playback Invite'),
      content: Text('$senderName invited you to start synced playback.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(SyncedPlaybackInviteDialogDecision.ignore),
          child: const Text('Ignore'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(SyncedPlaybackInviteDialogDecision.decline),
          child: const Text('Decline'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(SyncedPlaybackInviteDialogDecision.accept),
          child: const Text('Accept'),
        ),
      ],
    );
  }
}
