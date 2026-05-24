import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/social/social_synced_playback_section.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/social/user_message_consents_provider.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/screens/settings/social/social_connections_settings.dart';

class SocialSettings extends ConsumerWidget {
  const SocialSettings({super.key});

  static const String routeName = '/settings/social';

  bool _canManageByRole(String? userType) {
    final normalizedType = (userType ?? '').trim().toLowerCase();
    return normalizedType == 'root' || normalizedType == 'admin' || normalizedType == 'user';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value;

    return SettingsPageScaffold(
      title: 'Social',
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        if (currentUser == null)
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Text('No active user. Sign in to manage social settings.'),
          )
        else
          ref
              .watch(userMessageConsentsProvider)
              .when(
                data: (socialState) {
                  if (!socialState.serverSupportsSocial) {
                    return const Padding(
                      padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
                      child: Text('Social features are unavailable for this server.'),
                    );
                  }

                  final canManageByRole = _canManageByRole(currentUser.type);
                  final canManageConsents = canManageByRole && !socialState.accessDenied;
                  final hasConnectedUsers = socialState.consents.consents.isNotEmpty;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: Text(
                          'If these features are enabled, adding a user lets them invite you to synced playback and allows them to change your progress for specific books. They cannot communicate with you. Both of you must know each other\'s UUID.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      if (!canManageConsents)
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: Text('This account cannot manage social messaging requests.'),
                        ),
                      if (canManageConsents)
                        SettingsNavigationSection(
                          title: '',
                          showSectionTitle: false,
                          topPadding: 20,
                          items: [
                            SettingsNavigationItem(
                              icon: Icons.people_alt_outlined,
                              title: 'Connections and Requests',
                              subtitle: 'Open social management subsettings.',
                              onTap: () => context.push(SocialConnectionsSettings.routeName),
                            ),
                          ],
                        ),
                      if (canManageConsents)
                        SocialSyncedPlaybackSection(userId: currentUser.id, hasConnectedUsers: hasConnectedUsers),
                    ],
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Text(
                    'Failed to load social settings: $error',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ),
      ],
    );
  }
}
