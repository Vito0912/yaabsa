import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/social/social_consents_tab.dart';
import 'package:yaabsa/components/settings/social/social_own_user_id_card.dart';
import 'package:yaabsa/components/settings/social/social_requests_tab.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/social/user_message_consents_provider.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/screens/settings/social_settings.dart';

class SocialConnectionsSettings extends ConsumerStatefulWidget {
  const SocialConnectionsSettings({super.key});

  static const String routeName = '/settings/social/connections';

  @override
  ConsumerState<SocialConnectionsSettings> createState() => _SocialConnectionsSettingsState();
}

class _SocialConnectionsSettingsState extends ConsumerState<SocialConnectionsSettings> {
  final TextEditingController _requestUserIdController = TextEditingController();
  static final RegExp _uuidPattern = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
  );

  bool _isSubmittingRequest = false;
  String _requestUserId = '';

  bool _canManageByRole(String? userType) {
    final normalizedType = (userType ?? '').trim().toLowerCase();
    return normalizedType == 'root' || normalizedType == 'admin' || normalizedType == 'user';
  }

  bool get _isRequestUserIdValid => _uuidPattern.hasMatch(_requestUserId);

  void _showMessage(String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return;
    }

    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _runMutation({
    required Future<void> Function() action,
    required String successMessage,
    required String failurePrefix,
  }) async {
    try {
      await action();
      if (!mounted) {
        return;
      }
      _showMessage(successMessage);
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showMessage('$failurePrefix: $error');
    }
  }

  Future<void> _sendUserRequest({required String currentUserId}) async {
    final userId = _requestUserId.trim();

    if (!_uuidPattern.hasMatch(userId)) {
      _showMessage('Please enter a valid user ID UUID.');
      return;
    }

    if (userId == currentUserId) {
      _showMessage('You cannot request yourself.');
      return;
    }

    setState(() {
      _isSubmittingRequest = true;
    });

    try {
      await ref.read(userMessageConsentsProvider.notifier).addConsent(userId);
      _requestUserIdController.clear();
      setState(() {
        _requestUserId = '';
      });
      if (!mounted) {
        return;
      }
      _showMessage('Request sent.');
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showMessage('Failed to send request: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingRequest = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future<void>(() {
      if (!mounted) {
        return;
      }
      ref.read(userMessageConsentsProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _requestUserIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).value;

    return SettingsPageScaffold(
      title: 'Social Connections',
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: SocialSettings.routeName,
      children: [
        if (currentUser == null)
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Text('No active user. Sign in to manage social connections.'),
          )
        else
          ref
              .watch(userMessageConsentsProvider)
              .when(
                data: (socialState) {
                  final canManageByRole = _canManageByRole(currentUser.type);
                  final canManageConsents =
                      socialState.serverSupportsSocial && canManageByRole && !socialState.accessDenied;

                  if (!canManageConsents) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SocialOwnUserIdCard(userId: currentUser.id),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
                          child: Text('Social connections are unavailable for this server/account.'),
                        ),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SocialOwnUserIdCard(userId: currentUser.id),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Card(
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text('Request User', style: Theme.of(context).textTheme.titleSmall),
                                const SizedBox(height: 6),
                                Text(
                                  'Enter the other user\'s UUID. You both need to add each other',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _requestUserIdController,
                                  onChanged: (value) {
                                    setState(() {
                                      _requestUserId = value.trim();
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'User ID (UUID)',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: FilledButton.icon(
                                    onPressed: _isSubmittingRequest || !_isRequestUserIdValid
                                        ? null
                                        : () => _sendUserRequest(currentUserId: currentUser.id),
                                    icon: _isSubmittingRequest
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : const Icon(Icons.person_add_alt_1_rounded),
                                    label: const Text('Send Request'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SocialRequestsTab(
                        incomingRequests: socialState.consents.incomingRequests,
                        busyUserIds: socialState.busyUserIds,
                        onAccept: (userId) {
                          _runMutation(
                            action: () => ref.read(userMessageConsentsProvider.notifier).addConsent(userId),
                            successMessage: 'Request accepted.',
                            failurePrefix: 'Failed to accept request',
                          );
                        },
                        onBlock: (userId) {
                          _runMutation(
                            action: () => ref.read(userMessageConsentsProvider.notifier).blockUser(userId),
                            successMessage: 'User blocked.',
                            failurePrefix: 'Failed to block user',
                          );
                        },
                      ),
                      SocialConsentsTab(
                        consents: socialState.consents.consents,
                        blockedUserIds: socialState.consents.blockedUserIds,
                        busyUserIds: socialState.busyUserIds,
                        onRemoveConsent: (userId) {
                          _runMutation(
                            action: () => ref.read(userMessageConsentsProvider.notifier).removeConsent(userId),
                            successMessage: 'Consent removed.',
                            failurePrefix: 'Failed to remove consent',
                          );
                        },
                        onBlock: (userId) {
                          _runMutation(
                            action: () => ref.read(userMessageConsentsProvider.notifier).blockUser(userId),
                            successMessage: 'User blocked.',
                            failurePrefix: 'Failed to block user',
                          );
                        },
                        onUnblock: (userId) {
                          _runMutation(
                            action: () => ref.read(userMessageConsentsProvider.notifier).unblockUser(userId),
                            successMessage: 'User unblocked.',
                            failurePrefix: 'Failed to unblock user',
                          );
                        },
                      ),
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
                    'Failed to load social connections: $error',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ),
      ],
    );
  }
}
