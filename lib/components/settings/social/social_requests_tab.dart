import 'package:flutter/material.dart';
import 'package:yaabsa/api/me/user_message_consents.dart';
import 'package:yaabsa/components/settings/settings_category.dart';
import 'package:yaabsa/components/settings/social/social_user_id_tile.dart';

class SocialRequestsTab extends StatelessWidget {
  const SocialRequestsTab({
    required this.incomingRequests,
    required this.busyUserIds,
    required this.onAccept,
    required this.onBlock,
    super.key,
  });

  final List<UserMessageIncomingRequest> incomingRequests;
  final Set<String> busyUserIds;
  final ValueChanged<String> onAccept;
  final ValueChanged<String> onBlock;

  @override
  Widget build(BuildContext context) {
    if (incomingRequests.isEmpty) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(16, 18, 16, 0),
        child: Text('No incoming social requests right now.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SettingsCategory(
          title: 'Incoming Requests',
          description: 'Accept to add users to your own consent list, or block to reject requests.',
          icon: Icons.mark_chat_unread_outlined,
          topPadding: 18,
        ),
        ...incomingRequests.map((request) {
          final isBusy = busyUserIds.contains(request.userId);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Card(
              elevation: 0,
              child: SocialUserIdTile(
                userId: request.userId,
                username: request.username,
                leadingIcon: Icons.person_add_alt_1_rounded,
                subtitle: 'Incoming social request',
                trailing: isBusy
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: Padding(padding: EdgeInsets.all(3), child: CircularProgressIndicator(strokeWidth: 2)),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Accept request',
                            onPressed: () => onAccept(request.userId),
                            icon: const Icon(Icons.check_circle_outline_rounded),
                          ),
                          IconButton(
                            tooltip: 'Block user',
                            onPressed: () => onBlock(request.userId),
                            icon: const Icon(Icons.block_outlined),
                          ),
                        ],
                      ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
