import 'package:flutter/material.dart';
import 'package:yaabsa/api/me/user_message_consents.dart';
import 'package:yaabsa/components/settings/settings_category.dart';
import 'package:yaabsa/components/settings/social/social_user_id_tile.dart';

class SocialConsentsTab extends StatelessWidget {
  const SocialConsentsTab({
    required this.consents,
    required this.blockedUserIds,
    required this.busyUserIds,
    required this.onRemoveConsent,
    required this.onBlock,
    required this.onUnblock,
    super.key,
  });

  final List<UserMessageConsentEntry> consents;
  final List<String> blockedUserIds;
  final Set<String> busyUserIds;
  final ValueChanged<String> onRemoveConsent;
  final ValueChanged<String> onBlock;
  final ValueChanged<String> onUnblock;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SettingsCategory(title: 'Connected Users', icon: Icons.people_alt_outlined, topPadding: 18),
        if (consents.isEmpty)
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text('No users added yet. Accept a request to establish a social connection.'),
          ),
        ...consents.map((consent) {
          final isBusy = busyUserIds.contains(consent.userId);
          final subtitle = consent.otherAccepted
              ? 'Mutual consent established.'
              : 'Awaiting acceptance from the other user.';

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Card(
              elevation: 0,
              child: SocialUserIdTile(
                userId: consent.userId,
                username: consent.username,
                leadingIcon: consent.otherAccepted ? Icons.people_outline_rounded : Icons.hourglass_empty_rounded,
                subtitle: subtitle,
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
                            tooltip: 'Remove consent',
                            onPressed: () => onRemoveConsent(consent.userId),
                            icon: const Icon(Icons.person_remove_outlined),
                          ),
                          IconButton(
                            tooltip: 'Block user',
                            onPressed: () => onBlock(consent.userId),
                            icon: const Icon(Icons.block_outlined),
                          ),
                        ],
                      ),
              ),
            ),
          );
        }),
        const SettingsCategory(title: 'Blocked Users', icon: Icons.block_outlined, topPadding: 24),
        if (blockedUserIds.isEmpty)
          const Padding(padding: EdgeInsets.fromLTRB(16, 8, 16, 0), child: Text('No blocked users.')),
        ...blockedUserIds.map((userId) {
          final isBusy = busyUserIds.contains(userId);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Card(
              elevation: 0,
              child: SocialUserIdTile(
                userId: userId,
                leadingIcon: Icons.person_off_outlined,
                subtitle: 'Blocked',
                trailing: isBusy
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: Padding(padding: EdgeInsets.all(3), child: CircularProgressIndicator(strokeWidth: 2)),
                      )
                    : IconButton(
                        tooltip: 'Unblock user',
                        onPressed: () => onUnblock(userId),
                        icon: const Icon(Icons.undo_rounded),
                      ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
