import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/core/user_scope_invalidation.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/util/auth/account_removal.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/logger.dart';

Future<void> showManageAccountsSheet({
  required BuildContext context,
  required WidgetRef ref,
  required User? currentUser,
  required List<User> otherUsers,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (BuildContext bottomSheetContext) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (_, scrollController) {
          return _ManageAccountsSheetContent(
            parentContext: context,
            bottomSheetContext: bottomSheetContext,
            scrollController: scrollController,
            ref: ref,
            currentUser: currentUser,
            otherUsers: otherUsers,
          );
        },
      );
    },
  );
}

class _ManageAccountsSheetContent extends StatelessWidget {
  const _ManageAccountsSheetContent({
    required this.parentContext,
    required this.bottomSheetContext,
    required this.scrollController,
    required this.ref,
    required this.currentUser,
    required this.otherUsers,
  });

  final BuildContext parentContext;
  final BuildContext bottomSheetContext;
  final ScrollController scrollController;
  final WidgetRef ref;
  final User? currentUser;
  final List<User> otherUsers;

  Future<void> _deleteUser(User user) async {
    final db = ref.read(appDatabaseProvider);

    try {
      final wasActiveUser = await removeStoredAccount(db: db, user: user);

      if (wasActiveUser) {
        final remainingUsers = await db.getAllStoredUsers();
        if (remainingUsers.isNotEmpty) {
          await db.setActiveUserId(remainingUsers.first.id);
        } else {
          await db.clearActiveUserId();
        }
      }

      ref.invalidate(allStoredUsersProvider);
      ref.invalidate(currentUserProvider);
      invalidateUserScopedProviders(ref);

      if (!parentContext.mounted) {
        return;
      }

      ScaffoldMessenger.of(parentContext)
          .showSnackBar(SnackBar(content: Text(parentContext.l10n.settingsAccountRemoved(user.username))));
    } catch (_) {
      if (!parentContext.mounted) {
        return;
      }

      ScaffoldMessenger.of(parentContext)
          .showSnackBar(SnackBar(content: Text(parentContext.l10n.settingsAccountRemovalFailed(user.username))));
    }
  }

  Future<void> _switchActiveUser(User user) async {
    final db = ref.read(appDatabaseProvider);

    await db.setActiveUserId(user.id);
    ref.invalidate(currentUserProvider);
    ref.invalidate(allStoredUsersProvider);
    invalidateUserScopedProviders(ref);

    try {
      await db
          .watchGlobalSetting('activeUserId')
          .map((setting) => setting?.value)
          .firstWhere((activeUserId) => activeUserId == user.id)
          .timeout(const Duration(seconds: 2));
    } on TimeoutException {
      logger(
        'Timed out waiting for activeUserId to publish ${user.id} after account switch.',
        tag: 'SettingsAccountHeader',
        level: InfoLevel.debug,
      );
    }

    if (!parentContext.mounted) {
      return;
    }

    ScaffoldMessenger.of(parentContext)
        .showSnackBar(SnackBar(content: Text(parentContext.l10n.settingsAccountSwitched(user.username))));
  }

  void _showDeleteConfirmation(User user) {
    showDialog<void>(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(parentContext.l10n.settingsRemoveAccountTitle),
          content: Text(parentContext.l10n.settingsRemoveAccountPrompt(user.username)),
          actions: <Widget>[
            TextButton(
              child: Text(parentContext.l10n.actionCancel),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(
                parentContext.l10n.actionRemove,
                style: TextStyle(color: Theme.of(parentContext).colorScheme.error),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _deleteUser(user);
              },
            ),
          ],
        );
      },
    );
  }

  void _showSignOutConfirmation(User user) {
    showDialog<void>(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(parentContext.l10n.actionSignOut),
          content: Text(parentContext.l10n.settingsSignOutPrompt(user.username)),
          actions: <Widget>[
            TextButton(
              child: Text(parentContext.l10n.actionCancel),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(
                parentContext.l10n.actionSignOut,
                style: TextStyle(color: Theme.of(parentContext).colorScheme.error),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _deleteUser(user);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activeUser = currentUser;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(context.l10n.settingsManageAccounts, style: theme.textTheme.titleLarge),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                children: [
                  if (activeUser != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                      child: Text(context.l10n.settingsCurrentAccount, style: theme.textTheme.labelLarge),
                    ),
                  if (activeUser != null)
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colorScheme.primaryContainer,
                        child: Text(activeUser.username.substring(0, 1).toUpperCase()),
                      ),
                      title: Text(activeUser.username),
                      subtitle: Text(activeUser.server?.url ?? context.l10n.errorConnectionUnavailable),
                      trailing: IconButton(
                        icon: Icon(Icons.logout_rounded, color: colorScheme.error),
                        tooltip: context.l10n.actionSignOut,
                        onPressed: () {
                          Navigator.pop(bottomSheetContext);
                          _showSignOutConfirmation(activeUser);
                        },
                      ),
                    ),
                  if (activeUser != null) const Divider(height: 1),
                  if (otherUsers.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Text(context.l10n.settingsOtherAccounts, style: theme.textTheme.labelLarge),
                    ),
                  if (otherUsers.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        context.l10n.settingsNoOtherAccounts,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ...otherUsers.map((user) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colorScheme.secondaryContainer,
                        child: Text(user.username.substring(0, 1).toUpperCase()),
                      ),
                      title: Text(user.username),
                      subtitle: Text(user.server?.url ?? context.l10n.errorConnectionUnavailable),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.swap_horiz_rounded, color: colorScheme.primary),
                            tooltip: context.l10n.settingsSwitchToUser,
                            onPressed: () async {
                              Navigator.pop(bottomSheetContext);
                              await _switchActiveUser(user);
                            },
                          ),
                          YaabsaDeleteIconButton(
                            tooltip: context.l10n.actionRemove,
                            onPressed: () {
                              Navigator.pop(bottomSheetContext);
                              _showDeleteConfirmation(user);
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
