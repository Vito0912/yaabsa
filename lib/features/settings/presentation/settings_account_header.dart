import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/magic/magic_config.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/components/settings/admin_users/magic_config_dialog.dart';
import 'package:yaabsa/features/settings/presentation/settings_manage_accounts_sheet.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/aaos_service.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/logger.dart';

class SettingsAccountHeader extends ConsumerWidget {
  const SettingsAccountHeader({super.key, this.compact = false});

  final bool compact;

  Future<MagicConfigKeyMarker?> _readAuthenticationCodeKey(WidgetRef ref) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      return null;
    }

    try {
      final status = (await api.getMeApi().getStatus()).data;
      final customMessage = status?.authFormData?.authLoginCustomMessage;
      return MagicConfigKeyMarker.extract(customMessage) ??
          MagicConfigKeyMarker.fromSerializedName(MagicConfigKeyMarker.extractFromSanitizedHtml(customMessage));
    } catch (error, stackTrace) {
      logger(
        'Could not read the Authentication Code key from server status: $error\n$stackTrace',
        tag: 'SettingsAccountHeader',
        level: InfoLevel.warning,
      );
      return null;
    }
  }

  Future<void> _showOwnMagicConfig(BuildContext context, WidgetRef ref, User user) async {
    final server = user.server;
    if (server == null || server.url.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.settingsNoServerAddress)));
      return;
    }

    await showMagicConfigDialog(
      context,
      serverUrl: server.url,
      localServerUrl: server.localUrl,
      username: user.username,
      password: null,
      headers: Map<String, String>.from(server.headers ?? const <String, String>{}),
      allowPassword: false,
      ensureMarker: () => _readAuthenticationCodeKey(ref),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCurrentUser = ref.watch(currentUserProvider);
    final asyncAllUsers = ref.watch(allStoredUsersProvider);

    return asyncCurrentUser.when(
      data: (currentUser) {
        final allUsersList = asyncAllUsers.asData?.value ?? <User>[];
        final otherUsers = currentUser != null
            ? allUsersList.where((user) => user.id != currentUser.id).toList()
            : allUsersList;

        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final horizontalMargin = compact ? 0.0 : 8.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(compact ? 4 : 12, compact ? 4 : 16, 12, 8),
              child: Text(
                context.l10n.settingsActiveAccount.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalMargin),
              child: Card(
                elevation: 0.5,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                color: colorScheme.primaryContainer,
                child: Padding(
                  padding: EdgeInsets.all(compact ? 14.0 : 20.0),
                  child: currentUser != null
                      ? Row(
                          children: [
                            CircleAvatar(
                              radius: compact ? 20 : 28,
                              backgroundColor: colorScheme.primary,
                              child: Text(
                                currentUser.username.substring(0, 1).toUpperCase(),
                                style: TextStyle(fontSize: compact ? 18 : 24, color: colorScheme.onPrimary),
                              ),
                            ),
                            SizedBox(width: compact ? 12 : 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentUser.username,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: (compact ? theme.textTheme.titleMedium : theme.textTheme.headlineSmall)
                                        ?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onPrimaryContainer),
                                  ),
                                  Text(
                                    currentUser.server?.url ?? context.l10n.errorConnectionUnavailable,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              onPressed: () => _showOwnMagicConfig(context, ref, currentUser),
                              icon: const Icon(Icons.qr_code_2_rounded),
                              color: colorScheme.onPrimaryContainer,
                              tooltip: context.l10n.settingsCreateAuthenticationCode,
                            ),
                            if (!compact)
                              IconButton(
                                tooltip: context.l10n.settingsServerConnection,
                                icon: const Icon(Icons.dns_outlined),
                                color: colorScheme.onPrimaryContainer,
                                onPressed: () => context.push(SettingsRoutes.serverConnection),
                              ),
                          ],
                        )
                      : Center(
                          child: Text(
                            context.l10n.errorNoActiveUser,
                            style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onPrimaryContainer),
                          ),
                        ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.manage_accounts_outlined, size: 18),
                      label: Text(context.l10n.settingsManageAccounts, overflow: TextOverflow.ellipsis, maxLines: 1),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: compact ? 10 : 12, horizontal: 8),
                        foregroundColor: colorScheme.primary,
                        side: BorderSide(color: colorScheme.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      ),
                      onPressed: () => unawaited(
                        showManageAccountsSheet(
                          context: context,
                          ref: ref,
                          currentUser: currentUser,
                          otherUsers: otherUsers,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.person_add_alt_1_outlined, size: 18),
                      label: Text(context.l10n.settingsAddAccount, overflow: TextOverflow.ellipsis, maxLines: 1),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: compact ? 10 : 12, horizontal: 8),
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      ),
                      onPressed: () {
                        if (AaosService.instance.currentState.isAutomotiveDevice) {
                          context.go('/add-user');
                          return;
                        }

                        context.push('/add-user');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(child: YaabsaCircularProgressIndicator()),
      ),
      error: (e, st) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(context.l10n.errorCouldNotLoadUser, style: TextStyle(color: Theme.of(context).colorScheme.error)),
      ),
    );
  }
}
