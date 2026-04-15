import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/components/platform_builder.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

const String _addNewUserValue = '__ADD_NEW_USER__';

class UserSwitcher extends ConsumerWidget {
  const UserSwitcher({super.key});

  void _onMenuItemSelected(String value, WidgetRef ref, User? currentUser, BuildContext context) async {
    final bool showPlayer = await audioHandler.shouldShowPlayer.first;
    if (!context.mounted) {
      return;
    }
    if (showPlayer) {
      final shouldSwitch = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Switch User'),
            content: const Text(
              'Are you sure you want to switch users? When you switch the user, the player will not be able to sync the progress. It will still be saved locally and sync with the server after an app restart.',
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
              TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Switch')),
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
      if (value == currentUser?.id) return;
      final db = ref.read(appDatabaseProvider);
      await db.setActiveUserId(value);
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
      const PopupMenuItem<String>(
        value: _addNewUserValue,
        child: Row(
          children: [Icon(Icons.add_circle_outline_rounded, size: 20), SizedBox(width: 8), Text('Add New User')],
        ),
      ),
    );
    return items;
  }

  Widget _buildMobilePopupChild(BuildContext context, User? currentUser) {
    return _selectorContainer(context, currentUser, compact: true);
  }

  Widget _buildMobile(BuildContext context, WidgetRef ref, User? currentUser, List<User> allUsers) {
    return PopupMenuButton<String>(
      tooltip: 'Switch or Add User',
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      onSelected: (value) => _onMenuItemSelected(value, ref, currentUser, context),
      itemBuilder: (ctx) => _buildMenuItems(ctx, allUsers, currentUser),
      child: _buildMobilePopupChild(context, currentUser),
    );
  }

  Widget _buildTabletDesktopPopupChild(BuildContext context, User? currentUser, {required bool isTablet}) {
    return _selectorContainer(context, currentUser, compact: false);
  }

  Widget _selectorContainer(BuildContext context, User? currentUser, {required bool compact}) {
    final avatarRadius = compact ? 13.0 : 14.0;
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 10, vertical: compact ? 6 : 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(compact ? 12 : 14),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              currentUser?.username.isNotEmpty == true ? currentUser!.username[0].toUpperCase() : 'U',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: compact ? 10 : 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (!compact) ...[
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 130),
              child: Text(
                currentUser?.username ?? 'Users',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
          Icon(Icons.arrow_drop_down_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
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
  }) {
    return PopupMenuButton<String>(
      tooltip: 'Switch or Add User',
      offset: const Offset(0, 55),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isTablet ? 16.0 : 10.0)),
      onSelected: (value) => _onMenuItemSelected(value, ref, currentUser, context),
      itemBuilder: (ctx) => _buildMenuItems(ctx, allUsers, currentUser),
      child: _buildTabletDesktopPopupChild(context, currentUser, isTablet: isTablet),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final allUsersAsync = ref.watch(allStoredUsersProvider);

    return currentUserAsync.when(
      data: (currentUser) {
        return allUsersAsync.when(
          data: (allUsers) {
            if (allUsers.isEmpty) context.go('/add-user');
            return PlatformBuilder(
              mobileBuilder: (ctx) => _buildMobile(ctx, ref, currentUser, allUsers),
              tabletBuilder: (ctx) => _buildTabletOrDesktop(ctx, ref, currentUser, allUsers, isTablet: true),
              desktopBuilder: (ctx) => _buildTabletOrDesktop(ctx, ref, currentUser, allUsers, isTablet: false),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error loading users: $error')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error loading current user: $error')),
    );
  }
}
