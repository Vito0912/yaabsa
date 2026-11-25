import 'package:yaabsa/components/app/app_switcher_chip.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/components/app/user_switcher_avatar.dart';
import 'package:yaabsa/components/platform_builder.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/core/user_scope_invalidation.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/ui/components/menus/yaabsa_context_menu_button.dart';
import 'package:yaabsa/util/l10n.dart';

const String _addNewUserValue = '__ADD_NEW_USER__';

class UserSwitcher extends ConsumerWidget {
  const UserSwitcher({super.key});

  void _onMenuItemSelected(String value, WidgetRef ref, User? currentUser, BuildContext context) async {
    final bool hasActiveSession = audioHandler.currentMediaItem != null || audioHandler.queueTransitionLoading;
    if (!context.mounted) {
      return;
    }
    if (hasActiveSession) {
      final shouldSwitch = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(context.l10n.headingSwitchUser),
            content: Text(context.l10n.promptSwitchUserDuringPlayback),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(context.l10n.actionCancel)),
              TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(context.l10n.actionSwitch)),
            ],
          );
        },
      );
      if (shouldSwitch == null || !shouldSwitch) {
        return;
      }
    }

    if (!context.mounted) {
      return;
    }

    if (value == _addNewUserValue) {
      context.push('/add-user');
    } else {
      if (value == currentUser?.id) {
        return;
      }
      final db = ref.read(appDatabaseProvider);
      await db.setActiveUserId(value);
      invalidateUserScopedProviders(ref);
    }
  }

  List<PopupMenuEntry<String>> _buildMenuItems(BuildContext context, List<User> allUsers, User? currentUser) {
    final List<PopupMenuEntry<String>> items = [];

    for (final user in allUsers) {
      items.add(
        PopupMenuItem<String>(
          value: user.id,
          child: Text(
            user.username,
            style: TextStyle(
              fontWeight: user.id == currentUser?.id ? FontWeight.bold : FontWeight.normal,
              color: user.id == currentUser?.id
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
      );
    }

    if (allUsers.isNotEmpty) {
      items.add(const PopupMenuDivider());
    }

    items.add(
      PopupMenuItem<String>(
        value: _addNewUserValue,
        child: Row(
          children: [
            const Icon(Icons.add_circle_outline_rounded, size: 20),
            const SizedBox(width: 8),
            Text(context.l10n.actionAddUser),
          ],
        ),
      ),
    );
    return items;
  }

  Widget _buildMobilePopupChild(BuildContext context, User? currentUser, {required bool? serverReachable}) {
    return _selectorContainer(context, currentUser, compact: true, serverReachable: serverReachable);
  }

  Widget _buildMobile(
    BuildContext context,
    WidgetRef ref,
    User? currentUser,
    List<User> allUsers, {
    required bool? serverReachable,
  }) {
    return YaabsaContextMenuButton<String>(
      tooltip: context.l10n.actionManageUsers,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      onSelected: (value) => _onMenuItemSelected(value, ref, currentUser, context),
      itemBuilder: (ctx) => _buildMenuItems(ctx, allUsers, currentUser),
      child: _buildMobilePopupChild(context, currentUser, serverReachable: serverReachable),
    );
  }

  Widget _buildTabletDesktopPopupChild(
    BuildContext context,
    User? currentUser, {
    required bool isTablet,
    required bool? serverReachable,
  }) {
    return _selectorContainer(context, currentUser, compact: false, serverReachable: serverReachable);
  }

  Widget _selectorContainer(
    BuildContext context,
    User? currentUser, {
    required bool compact,
    required bool? serverReachable,
    bool loading = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    final loadingMinWidth = compact ? 68.0 : 140.0;

    return AppSwitcherChip(
      minWidth: loading ? loadingMinWidth : 0,
      horizontalPadding: compact ? 8 : 10,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          UserSwitcherAvatar(
            username: currentUser?.username,
            compact: compact,
            serverReachable: serverReachable,
            loading: loading,
          ),
          if (!compact) ...[
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 130),
              child: Text(
                currentUser?.username ?? context.l10n.labelUsers,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
          Icon(Icons.arrow_drop_down_rounded, color: colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }

  Widget _buildTabletOrDesktop(
    BuildContext context,
    WidgetRef ref,
    User? currentUser,
    List<User> allUsers, {
    required bool isTablet,
    required bool? serverReachable,
  }) {
    return YaabsaContextMenuButton<String>(
      tooltip: context.l10n.actionManageUsers,
      offset: const Offset(0, 55),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isTablet ? 16.0 : 10.0)),
      onSelected: (value) => _onMenuItemSelected(value, ref, currentUser, context),
      itemBuilder: (ctx) => _buildMenuItems(ctx, allUsers, currentUser),
      child: _buildTabletDesktopPopupChild(context, currentUser, isTablet: isTablet, serverReachable: serverReachable),
    );
  }

  Widget _buildLoading(BuildContext context, User? currentUser) {
    return PlatformBuilder(
      mobileBuilder: (ctx) => _selectorContainer(ctx, currentUser, compact: true, serverReachable: null, loading: true),
      tabletBuilder: (ctx) =>
          _selectorContainer(ctx, currentUser, compact: false, serverReachable: null, loading: true),
      desktopBuilder: (ctx) =>
          _selectorContainer(ctx, currentUser, compact: false, serverReachable: null, loading: true),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final allUsersAsync = ref.watch(allStoredUsersProvider);
    final serverStatusAsync = ref.watch(serverStatusProvider);

    return currentUserAsync.when(
      data: (currentUser) {
        final bool? serverReachable = currentUser == null ? null : serverStatusAsync.value;

        return allUsersAsync.when(
          data: (allUsers) {
            return PlatformBuilder(
              mobileBuilder: (ctx) => _buildMobile(ctx, ref, currentUser, allUsers, serverReachable: serverReachable),
              tabletBuilder: (ctx) => _buildTabletOrDesktop(
                ctx,
                ref,
                currentUser,
                allUsers,
                isTablet: true,
                serverReachable: serverReachable,
              ),
              desktopBuilder: (ctx) => _buildTabletOrDesktop(
                ctx,
                ref,
                currentUser,
                allUsers,
                isTablet: false,
                serverReachable: serverReachable,
              ),
            );
          },
          loading: () => _buildLoading(context, currentUser),
          error: (error, stack) => Center(child: Text(context.l10n.errorCouldNotLoadUsers)),
        );
      },
      loading: () => _buildLoading(context, currentUserAsync.value),
      error: (error, stack) => Tooltip(
        message: context.l10n.errorCouldNotLoadUser,
        child: SizedBox(
          width: 40,
          height: 40,
          child: IconButton(
            tooltip: context.l10n.actionRetry,
            onPressed: () {
              ref.invalidate(currentUserProvider);
              ref.invalidate(allStoredUsersProvider);
              ref.invalidate(serverStatusProvider);
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ),
      ),
    );
  }
}
