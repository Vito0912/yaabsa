import 'package:buchshelfly/provider/core/user_providers.dart';
import 'package:buchshelfly/screens/settings/appearance_settings.dart';
import 'package:buchshelfly/screens/settings/caching_settings.dart';
import 'package:buchshelfly/screens/settings/global_player_settings.dart';
import 'package:buchshelfly/screens/settings/library_settings.dart';
import 'package:buchshelfly/screens/settings/license_settings.dart';
import 'package:buchshelfly/screens/settings/log_view.dart';
import 'package:buchshelfly/screens/settings/player_settings.dart';
import 'package:buchshelfly/screens/settings/reader_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MainSettingsScreen extends ConsumerWidget {
  const MainSettingsScreen({super.key});

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 28.0, 20.0, 12.0),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildSettingsCardTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Widget? trailing,
    bool isFirstInCard = false,
    bool isLastInCard = false,
  }) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: isFirstInCard ? const Radius.circular(16.0) : Radius.zero,
        bottom: isLastInCard ? const Radius.circular(16.0) : Radius.zero,
      ),
    );

    return Material(
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
      shape: shape,
      child: InkWell(
        onTap: onTap,
        customBorder: shape,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
                    if (subtitle != null && subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              trailing ??
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider({bool isWithinCard = false}) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.withOpacity(0.1),
      indent: isWithinCard ? 58 : 20,
      endIndent: isWithinCard ? 0 : 20,
    );
  }

  void _showDeleteUserConfirmationDialog(BuildContext context, dynamic user, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Delete User?'),
          content: Text('Are you sure you want to delete "${user.username}"? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(dialogContext).pop()),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('User ${user.username} delete action triggered')));
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserManagementSection(BuildContext context, WidgetRef ref) {
    final asyncCurrentUser = ref.watch(currentUserProvider);
    final asyncAllUsers = ref.watch(allStoredUsersProvider);

    return asyncCurrentUser.when(
      data: (currentUser) {
        final allUsersList = asyncAllUsers.asData?.value ?? [];
        final otherUsers =
            currentUser != null
                ? allUsersList.where((user) => user.username != currentUser.username).toList()
                : allUsersList;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle(context, 'Active Account'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 0.5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child:
                      currentUser != null
                          ? Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                child: Text(
                                  currentUser.username?.substring(0, 1).toUpperCase() ?? 'U',
                                  style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.onPrimary),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentUser.username ?? 'Current User',
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                    Text(
                                      currentUser.server?.url ?? 'No server connected',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                          : Center(
                            child: Text(
                              'No active user.',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.manage_accounts_outlined),
                      label: const Text('Manage Accounts'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        side: BorderSide(color: Theme.of(context).colorScheme.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      ),
                      onPressed: () {
                        _showManageAccountsBottomSheet(context, ref, currentUser, otherUsers);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.person_add_alt_1_outlined),
                      label: const Text('Add Account'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Navigate to Add User Screen')));
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (currentUser != null) ...[
              _buildSectionTitle(context, "${currentUser.username}'s Preferences"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Column(
                    children: [
                      _buildSettingsCardTile(
                        context: context,
                        icon: Icons.play_circle_outline_rounded,
                        title: 'Player Settings',
                        onTap: () => context.push(PlayerSettings.routeName),
                        isFirstInCard: true,
                      ),
                      _buildDivider(isWithinCard: true),
                      _buildSettingsCardTile(
                        context: context,
                        icon: Icons.menu_book_rounded,
                        title: 'Ebook-Reader Settings',
                        onTap: () => context.push(ReaderSettings.routeName),
                        isLastInCard: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        );
      },
      loading: () => const Padding(padding: EdgeInsets.all(32.0), child: Center(child: CircularProgressIndicator())),
      error:
          (e, st) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Error loading user data: $e', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
    );
  }

  void _showManageAccountsBottomSheet(
    BuildContext context,
    WidgetRef ref,
    dynamic currentUser,
    List<dynamic> otherUsers,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext bottomSheetContext) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Manage Accounts', style: Theme.of(context).textTheme.titleLarge),
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        if (otherUsers.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'No other accounts available.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ...otherUsers.map((user) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                              child: Text(user.username?.substring(0, 1).toUpperCase() ?? 'U'),
                            ),
                            title: Text(user.username ?? 'Unknown User'),
                            subtitle: Text(user.server?.url ?? 'No server'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.swap_horiz_rounded, color: Theme.of(context).colorScheme.primary),
                                  tooltip: 'Switch to this user',
                                  onPressed: () {
                                    Navigator.pop(bottomSheetContext);
                                    ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(SnackBar(content: Text('Switching to ${user.username ?? 'user'}')));
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_outline_rounded, color: Theme.of(context).colorScheme.error),
                                  tooltip: 'Delete this user',
                                  onPressed: () {
                                    Navigator.pop(bottomSheetContext);
                                    _showDeleteUserConfirmationDialog(context, user, ref);
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: <Widget>[
            _buildUserManagementSection(context, ref),
            _buildSectionTitle(context, 'Application Settings'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Column(
                  children: [
                    _buildSettingsCardTile(
                      context: context,
                      icon: Icons.palette_outlined,
                      title: 'Appearance',
                      onTap: () => context.push(AppearanceSettings.routeName),
                      isFirstInCard: true,
                    ),
                    _buildDivider(isWithinCard: true),
                    _buildSettingsCardTile(
                      context: context,
                      icon: Icons.play_circle_outline_outlined,
                      title: 'Global Player',
                      onTap: () => context.push(GlobalPlayerSettings.routeName),
                    ),
                    _buildDivider(isWithinCard: true),
                    _buildSettingsCardTile(
                      context: context,
                      icon: Icons.library_books_outlined,
                      title: 'Library Behaviour',
                      onTap: () => context.push(LibrarySettings.routeName),
                    ),
                    _buildDivider(isWithinCard: true),
                    _buildSettingsCardTile(
                      context: context,
                      icon: Icons.cached_outlined,
                      title: 'Caching',
                      onTap: () => context.push(CachingSettings.routeName),
                      isLastInCard: true,
                    ),
                  ],
                ),
              ),
            ),
            _buildSectionTitle(context, 'About & Support'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Column(
                  children: [
                    _buildSettingsCardTile(
                      context: context,
                      icon: Icons.code_rounded,
                      title: 'View on GitHub',
                      onTap:
                          () => ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(const SnackBar(content: Text('Navigate to View on GitHub'))),
                      isFirstInCard: true,
                    ),
                    _buildDivider(isWithinCard: true),
                    _buildSettingsCardTile(
                      context: context,
                      icon: Icons.bug_report_outlined,
                      title: 'Report an Issue',
                      onTap:
                          () => ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(const SnackBar(content: Text('Navigate to Report an Issue'))),
                    ),
                    _buildDivider(isWithinCard: true),
                    _buildSettingsCardTile(
                      context: context,
                      icon: Icons.article_outlined,
                      title: 'Logs',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LogView())),
                    ),
                    _buildDivider(isWithinCard: true),
                    _buildSettingsCardTile(
                      context: context,
                      icon: Icons.info_outline_rounded,
                      title: 'Information & Attribution',
                      subtitle: 'Licenses, App version, licenses, etc.',
                      onTap: () => LicenseSettings.showLicensePage(context: context),
                      isLastInCard: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
