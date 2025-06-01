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
              color:
                  user.id == currentUser?.id
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
    final double avatarRadius = 18.0;
    final double avatarFontSize = 12.0;
    final double placeholderIconSize = 22.0;

    if (currentUser != null) {
      return CircleAvatar(
        radius: avatarRadius,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          currentUser.username.isNotEmpty ? currentUser.username[0].toUpperCase() : 'U',
          style: TextStyle(color: Colors.white, fontSize: avatarFontSize, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      return CircleAvatar(
        radius: avatarRadius,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.person_add_alt_1_rounded,
          size: placeholderIconSize,
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }
  }

  Widget _buildMobile(BuildContext context, WidgetRef ref, User? currentUser, List<User> allUsers) {
    return PopupMenuButton<String>(
      tooltip: 'Switch or Add User',
      offset: const Offset(0, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      onSelected: (value) => _onMenuItemSelected(value, ref, currentUser, context),
      itemBuilder: (ctx) => _buildMenuItems(ctx, allUsers, currentUser),
      child: Padding(padding: const EdgeInsets.all(8.0), child: _buildMobilePopupChild(context, currentUser)),
    );
  }

  Widget _buildTabletDesktopPopupChild(BuildContext context, User? currentUser, {required bool isTablet}) {
    final double horizontalPadding = isTablet ? 16.0 : 18.0;
    final double verticalPadding = isTablet ? 10.0 : 12.0;
    final double borderRadius = isTablet ? 16.0 : 10.0;
    final double avatarRadius = isTablet ? 16.0 : 18.0;
    final double avatarFontSize = isTablet ? 12.0 : 13.0;
    final double usernameFontSize = isTablet ? 15.0 : 16.0;
    final double spacingAfterAvatar = isTablet ? 8.0 : 10.0;
    final double spacingAfterText = isTablet ? 6.0 : 8.0;
    final double dropdownIconSize = isTablet ? 20.0 : 22.0;
    final double placeholderFontSize = isTablet ? 15.0 : 16.0;

    Widget content;

    if (currentUser != null) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              currentUser.username.isNotEmpty ? currentUser.username[0].toUpperCase() : 'U',
              style: TextStyle(color: Colors.white, fontSize: avatarFontSize, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(width: spacingAfterAvatar),
          Flexible(
            child: Text(
              currentUser.username,
              style: TextStyle(
                fontSize: usernameFontSize,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.labelLarge?.color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: spacingAfterText),
          Icon(
            Icons.arrow_drop_down_rounded,
            size: dropdownIconSize,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
          ),
        ],
      );
    } else {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people_alt_outlined, size: avatarRadius * 1.2, color: Theme.of(context).colorScheme.primary),
          SizedBox(width: spacingAfterAvatar),
          Text(
            'Manage Users',
            style: TextStyle(
              fontSize: placeholderFontSize,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.labelLarge?.color,
            ),
          ),
          SizedBox(width: spacingAfterText),
          Icon(
            Icons.arrow_drop_down_rounded,
            size: dropdownIconSize,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
          ),
        ],
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: null,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).chipTheme.backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Theme.of(context).chipTheme.secondarySelectedColor ?? Theme.of(context).colorScheme.outlineVariant,
              width: 1.0,
            ),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3.0, offset: Offset(0, 2))],
          ),
          child: content,
        ),
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
