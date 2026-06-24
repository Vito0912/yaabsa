import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/settings/management_settings_section.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/user_scope_invalidation.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/android_auto_settings.dart';
import 'package:yaabsa/screens/settings/appearance_settings.dart';
import 'package:yaabsa/screens/settings/caching_settings.dart';
import 'package:yaabsa/screens/settings/player/global_player_settings.dart';
import 'package:yaabsa/screens/settings/player/player_settings.dart';
import 'package:yaabsa/screens/settings/library_settings.dart';
import 'package:yaabsa/screens/settings/license_settings.dart';
import 'package:yaabsa/screens/settings/log_view.dart';
import 'package:yaabsa/screens/settings/reader_settings.dart';
import 'package:yaabsa/screens/settings/server_connection_settings.dart';
import 'package:yaabsa/screens/settings/server_management_settings.dart';
import 'package:yaabsa/util/aaos_service.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/network/dio_factory.dart';

class SettingsSearchItem {
  final String title;
  final String description;
  final String categoryPath;
  final String route;

  const SettingsSearchItem({
    required this.title,
    required this.description,
    required this.categoryPath,
    required this.route,
  });
}

final List<SettingsSearchItem> searchableSettings = [
  const SettingsSearchItem(
    title: 'Server Connection',
    description: 'Configure server URL, authentication, and connection details',
    categoryPath: 'Settings > Active Account',
    route: '/settings/server-connection',
  ),
  const SettingsSearchItem(
    title: 'Server Management',
    description: 'Configure visibility for collections, editing, deletion, and uploading',
    categoryPath: 'Settings > Active Account',
    route: '/settings/server-management',
  ),
  const SettingsSearchItem(
    title: 'Timeline mode',
    description: 'Choose whether the seek bar tracks a chapter, the full audiobook, or both',
    categoryPath: 'Settings > Player > General',
    route: '/settings/player/general',
  ),
  const SettingsSearchItem(
    title: 'Timeline markers',
    description: 'Choose whether the full timeline displays chapter markers, bookmark markers, both, or none',
    categoryPath: 'Settings > Player > General',
    route: '/settings/player/general',
  ),
  const SettingsSearchItem(
    title: 'Fast forward interval',
    description: 'How many seconds to skip when jumping forward',
    categoryPath: 'Settings > Player > General',
    route: '/settings/player/general',
  ),
  const SettingsSearchItem(
    title: 'Rewind interval',
    description: 'How many seconds to skip when rewinding',
    categoryPath: 'Settings > Player > General',
    route: '/settings/player/general',
  ),
  const SettingsSearchItem(
    title: 'Remember playback speed per book',
    description: 'Each book remembers its own speed and new books start with your last used speed',
    categoryPath: 'Settings > Player > General',
    route: '/settings/player/general',
  ),
  const SettingsSearchItem(
    title: 'Auto queue',
    description: 'Automatically queue upcoming books when playback starts',
    categoryPath: 'Settings > Player > General',
    route: '/settings/player/general',
  ),
  const SettingsSearchItem(
    title: 'Auto queue everywhere',
    description: 'Auto queue books from the first linked series even when starting playback outside a series view',
    categoryPath: 'Settings > Player > General',
    route: '/settings/player/general',
  ),
  const SettingsSearchItem(
    title: 'Smart rewind',
    description: 'When resuming after a pause, rewind by an amount based on pause duration',
    categoryPath: 'Settings > Player > Smart rewind',
    route: '/settings/player/smart-rewind',
  ),
  const SettingsSearchItem(
    title: 'Short-pause threshold',
    description: 'If paused up to this amount, the short smart rewind value is used',
    categoryPath: 'Settings > Player > Smart rewind',
    route: '/settings/player/smart-rewind',
  ),
  const SettingsSearchItem(
    title: 'Long-pause threshold',
    description:
        'If paused longer than the short threshold and up to this amount, the medium smart rewind value is used',
    categoryPath: 'Settings > Player > Smart rewind',
    route: '/settings/player/smart-rewind',
  ),
  const SettingsSearchItem(
    title: 'Short rewind amount',
    description: 'Rewind amount used for short pauses',
    categoryPath: 'Settings > Player > Smart rewind',
    route: '/settings/player/smart-rewind',
  ),
  const SettingsSearchItem(
    title: 'Medium rewind amount',
    description: 'Rewind amount used for medium pauses',
    categoryPath: 'Settings > Player > Smart rewind',
    route: '/settings/player/smart-rewind',
  ),
  const SettingsSearchItem(
    title: 'Long rewind amount',
    description: 'Rewind amount used for long pauses',
    categoryPath: 'Settings > Player > Smart rewind',
    route: '/settings/player/smart-rewind',
  ),
  const SettingsSearchItem(
    title: 'Sleep timer end action',
    description: 'Choose whether playback is stopped or paused when the sleep timer expires',
    categoryPath: 'Settings > Player > Sleep timer',
    route: '/settings/player/sleep-timer',
  ),
  const SettingsSearchItem(
    title: 'Sleep timer end rewind',
    description: 'After sleep timer stops playback, rewind this much when the same item is played again',
    categoryPath: 'Settings > Player > Sleep timer',
    route: '/settings/player/sleep-timer',
  ),
  const SettingsSearchItem(
    title: 'Fade audio',
    description: 'Gradually lower playback volume before the sleep timer ends',
    categoryPath: 'Settings > Player > Sleep timer',
    route: '/settings/player/sleep-timer',
  ),
  const SettingsSearchItem(
    title: 'Auto-restart timer on playback start',
    description: 'Automatically start a new sleep timer using your last duration on playback start',
    categoryPath: 'Settings > Player > Sleep timer',
    route: '/settings/player/sleep-timer',
  ),
  const SettingsSearchItem(
    title: 'Only auto-restart during a time range',
    description: 'Limit automatic sleep timer restart to specific hours',
    categoryPath: 'Settings > Player > Sleep timer',
    route: '/settings/player/sleep-timer',
  ),
  const SettingsSearchItem(
    title: 'Auto-restart range start',
    description: 'Sleep timer auto-restart becomes active at this time',
    categoryPath: 'Settings > Player > Sleep timer',
    route: '/settings/player/sleep-timer',
  ),
  const SettingsSearchItem(
    title: 'Auto-restart range end',
    description: 'Sleep timer auto-restart remains active until this time',
    categoryPath: 'Settings > Player > Sleep timer',
    route: '/settings/player/sleep-timer',
  ),
  const SettingsSearchItem(
    title: 'Enable subtitles',
    description: 'Show subtitle tracks (.srt and .vtt) during playback when available',
    categoryPath: 'Settings > Player > Subtitles',
    route: '/settings/player/subtitles',
  ),
  const SettingsSearchItem(
    title: 'Highlight speaker labels',
    description: 'Highlight speaker names in subtitles',
    categoryPath: 'Settings > Player > Subtitles',
    route: '/settings/player/subtitles',
  ),
  const SettingsSearchItem(
    title: 'Enable read along',
    description: 'Highlight currently spoken words in subtitles',
    categoryPath: 'Settings > Player > Subtitles',
    route: '/settings/player/subtitles',
  ),
  const SettingsSearchItem(
    title: 'Shake to reset sleep timer',
    description: 'Shake to reset an active sleep timer back to its full duration',
    categoryPath: 'Settings > Player > Shake controls',
    route: '/settings/player/shake-controls',
  ),
  const SettingsSearchItem(
    title: 'Shake to rewind',
    description: 'Shake while playing to rewind by the configured rewind interval',
    categoryPath: 'Settings > Player > Shake controls',
    route: '/settings/player/shake-controls',
  ),
  const SettingsSearchItem(
    title: 'Shake sensitivity',
    description: 'Lower values trigger more easily, higher values require a stronger shake',
    categoryPath: 'Settings > Player > Shake controls',
    route: '/settings/player/shake-controls',
  ),
  const SettingsSearchItem(
    title: 'Shake vibration feedback',
    description: 'Vibrate when a shake action is triggered',
    categoryPath: 'Settings > Player > Shake controls',
    route: '/settings/player/shake-controls',
  ),
  const SettingsSearchItem(
    title: 'Shelf Sections',
    description: 'Choose which shelf sections are visible and their order',
    categoryPath: 'Settings > General',
    route: '/settings/library',
  ),
  const SettingsSearchItem(
    title: 'Library Grid Scale',
    description: 'Scales library item cards in all grid views',
    categoryPath: 'Settings > General',
    route: '/settings/library',
  ),
  const SettingsSearchItem(
    title: 'Collapse Series',
    description: 'Collapse books in series into a single entry',
    categoryPath: 'Settings > General',
    route: '/settings/library',
  ),
  const SettingsSearchItem(
    title: 'Show Shelf Play Button',
    description: 'Adds a play-all button on Continue Listening and Newest shelves',
    categoryPath: 'Settings > General',
    route: '/settings/library',
  ),
  const SettingsSearchItem(
    title: 'Check Server Updates',
    description: 'Checks for ABS updates via GitHub',
    categoryPath: 'Settings > General',
    route: '/settings/library',
  ),
  const SettingsSearchItem(
    title: 'Download Location',
    description: 'Configure directory to save downloaded audiobooks',
    categoryPath: 'Settings > General',
    route: '/settings/library',
  ),
  const SettingsSearchItem(
    title: 'Theme Settings',
    description: 'Configure Theme mode (light, dark, amoled, system), preset palette, and custom accent color',
    categoryPath: 'Settings > Appearance',
    route: '/settings/appearance/theme',
  ),
  const SettingsSearchItem(
    title: 'Navigation Settings',
    description: 'Configure displayed tabs, their order, and the default view',
    categoryPath: 'Settings > Appearance',
    route: '/settings/appearance/navigation',
  ),
  const SettingsSearchItem(
    title: 'Language',
    description: 'Configure app display language',
    categoryPath: 'Settings > Appearance',
    route: '/settings/appearance',
  ),
  const SettingsSearchItem(
    title: 'Max buffer size',
    description: 'Maximum size of the audio buffer in bytes (hint for the OS)',
    categoryPath: 'Settings > Global Player',
    route: '/settings/global-player',
  ),
  const SettingsSearchItem(
    title: 'Keep Screen On',
    description: 'Prevent screen from turning off during playback',
    categoryPath: 'Settings > Global Player',
    route: '/settings/global-player',
  ),
  const SettingsSearchItem(
    title: 'Lock Media Notification',
    description: 'Keep media controls visible in system notification panel',
    categoryPath: 'Settings > Global Player',
    route: '/settings/global-player',
  ),
  const SettingsSearchItem(
    title: 'Media notification type',
    description: 'Choose whether notification progress tracks the full book or current chapter',
    categoryPath: 'Settings > Global Player',
    route: '/settings/global-player',
  ),
  const SettingsSearchItem(
    title: 'Media Notification Actions',
    description: 'Customize the actions available in the media notification',
    categoryPath: 'Settings > Global Player',
    route: '/settings/player/notification',
  ),
  const SettingsSearchItem(
    title: 'Auto-play last played on app start',
    description: 'Resume the last played item on app launch if it is not finished',
    categoryPath: 'Settings > Global Player',
    route: '/settings/global-player',
  ),
  const SettingsSearchItem(
    title: 'Always show mini player',
    description: 'Keep the mini player visible for your most recently played item',
    categoryPath: 'Settings > Global Player',
    route: '/settings/global-player',
  ),
  const SettingsSearchItem(
    title: 'Keep websocket active in background',
    description: 'Keep websocket connected in the background to sync updates (may increase battery usage)',
    categoryPath: 'Settings > Global Player',
    route: '/settings/global-player',
  ),
  const SettingsSearchItem(
    title: 'Enable caching',
    description: 'Enable response caching for API requests',
    categoryPath: 'Settings > Caching',
    route: '/settings/caching/general',
  ),
  const SettingsSearchItem(
    title: 'Speedup mode',
    description: 'Combine caching with background refreshes to load faster',
    categoryPath: 'Settings > Caching',
    route: '/settings/caching/general',
  ),
  const SettingsSearchItem(
    title: 'Remove authors without books',
    description: 'Add a button in the author section to delete authors without books',
    categoryPath: 'Settings > Tools',
    route: '/settings/tools',
  ),
  const SettingsSearchItem(
    title: 'Force metadata refresh',
    description: 'Add a button to force recreation of metadata files in Admin Server Settings',
    categoryPath: 'Settings > Tools',
    route: '/settings/tools',
  ),
  const SettingsSearchItem(
    title: 'Match audiobook chapters',
    description: 'Add a quick match option for fast chapter matching, including bulk mode',
    categoryPath: 'Settings > Tools',
    route: '/settings/tools',
  ),
  const SettingsSearchItem(
    title: 'Split genres/tags',
    description: 'Add a button to split genres and tags in Admin Server Settings',
    categoryPath: 'Settings > Tools',
    route: '/settings/tools',
  ),
  const SettingsSearchItem(
    title: 'Log Level',
    description: 'Choose the minimum severity level of logs to capture',
    categoryPath: 'Settings > Logs',
    route: '/settings/logs',
  ),
  const SettingsSearchItem(
    title: 'Reader Theme',
    description: 'Background and text color theme of the reader',
    categoryPath: 'Settings > Ebook-Reader',
    route: '/settings/reader',
  ),
  const SettingsSearchItem(
    title: 'Reader Font Size',
    description: 'Adjust the size of the reader text',
    categoryPath: 'Settings > Ebook-Reader',
    route: '/settings/reader',
  ),
  const SettingsSearchItem(
    title: 'Reader Line Spacing',
    description: 'Adjust the line spacing of the reader text',
    categoryPath: 'Settings > Ebook-Reader',
    route: '/settings/reader',
  ),
  const SettingsSearchItem(
    title: 'Reader Layout Mode',
    description: 'Choose between paginated columns or vertical infinite scroll',
    categoryPath: 'Settings > Ebook-Reader',
    route: '/settings/reader',
  ),
  const SettingsSearchItem(
    title: 'Hide mini player when reading',
    description: 'Hides the bottom audio mini player in the book reader',
    categoryPath: 'Settings > Ebook-Reader',
    route: '/settings/reader',
  ),
  const SettingsSearchItem(
    title: 'Start session when reading',
    description: 'Track reading time on the server with direct play',
    categoryPath: 'Settings > Ebook-Reader',
    route: '/settings/reader',
  ),
];

class MainSettingsScreen extends ConsumerStatefulWidget {
  const MainSettingsScreen({super.key});

  static const String routeName = '/settings';

  @override
  ConsumerState<MainSettingsScreen> createState() => _MainSettingsScreenState();
}

class _MainSettingsScreenState extends ConsumerState<MainSettingsScreen> {
  static final Uri _githubRepoUri = Uri.parse('https://github.com/Vito0912/yaabsa/');
  static final Uri _githubIssueUri = Uri.parse('https://github.com/Vito0912/yaabsa/issues');
  static final Uri _githubSponsorUri = Uri.parse('https://github.com/sponsors/Vito0912');

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  IconData _getIconForRoute(String route) {
    if (route.contains('/player')) {
      return Icons.play_circle_outline_rounded;
    }
    if (route.contains('/library')) {
      return Icons.library_books_outlined;
    }
    if (route.contains('/appearance')) {
      return Icons.palette_outlined;
    }
    if (route.contains('/android-auto') || route.contains('/aaos')) {
      return Icons.directions_car_filled_outlined;
    }
    if (route.contains('/caching')) {
      return Icons.cached_outlined;
    }
    if (route.contains('/tools')) {
      return Icons.construction_rounded;
    }
    if (route.contains('/logs')) {
      return Icons.article_outlined;
    }
    return Icons.settings_outlined;
  }

  Future<void> _openSupportLink(BuildContext context, Uri uri, String label) async {
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (opened || !context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not open $label')));
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not open $label')));
    }
  }

  Future<void> _deleteUser(BuildContext context, WidgetRef ref, User user) async {
    final db = ref.read(appDatabaseProvider);

    try {
      final refreshToken = user.refreshToken;
      if (user.server != null && refreshToken != null && refreshToken.isNotEmpty) {
        try {
          final api = ABSApi(
            dio: createNativeDio(
              options: BaseOptions(baseUrl: user.server!.url, headers: user.server!.headers),
            ),
            basePathOverride: user.server!.url,
          );
          final authToken = user.preferredAuthToken;
          if (authToken != null && authToken.isNotEmpty) {
            api.setBearerAuth('BearerAuth', authToken);
          }
          await api.getMeApi().logout(refreshToken: refreshToken, extra: const {'skip_auth_refresh': true});
        } catch (e, s) {
          logger(
            'Failed to notify server logout before deleting user ${user.username}: $e. Stack: $s',
            tag: 'MainSettingsScreen',
            level: InfoLevel.warning,
          );
        }
      }

      final activeUserId = (await db.getGlobalSetting('activeUserId'))?.value;
      final wasActiveUser = activeUserId == user.id;

      await db.deleteStoredUser(user.id);

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

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleted user ${user.username}')));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete user ${user.username}: $e')));
    }
  }

  bool _hasAnyServerManagementPermission(User user) {
    final permissions = user.permissions;
    return permissions.update || permissions.delete || permissions.upload;
  }

  Future<void> _switchActiveUser(BuildContext context, WidgetRef ref, User user) async {
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
        tag: 'MainSettingsScreen',
        level: InfoLevel.debug,
      );
    }

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Switched to ${user.username}')));
  }

  void _showDeleteUserConfirmationDialog(BuildContext context, User user, WidgetRef ref) {
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
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _deleteUser(context, ref, user);
              },
            ),
          ],
        );
      },
    );
  }

  void _showSignOutCurrentUserConfirmationDialog(BuildContext context, User user, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Sign Out Current Account?'),
          content: Text('Sign out from "${user.username}" on this device?'),
          actions: <Widget>[
            TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(dialogContext).pop()),
            TextButton(
              child: Text('Sign Out', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _deleteUser(context, ref, user);
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
        final otherUsers = currentUser != null
            ? allUsersList.where((user) => user.id != currentUser.id).toList()
            : allUsersList;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text(
                'ACTIVE ACCOUNT',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 0.5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: currentUser != null
                      ? Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: Text(
                                currentUser.username.substring(0, 1).toUpperCase(),
                                style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.onPrimary),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentUser.username,
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                  Text(
                                    currentUser.server?.url ?? 'No server connected',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
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
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
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
            if (currentUser != null) ...[
              SettingsNavigationSection(
                title: "${currentUser.username}'s Preferences",
                items: [
                  SettingsNavigationItem(
                    icon: Icons.dns_outlined,
                    title: 'Server Connection',
                    onTap: () => context.push(ServerConnectionSettings.routeName),
                  ),
                  if (!AaosService.instance.currentState.isAutomotiveDevice &&
                      _hasAnyServerManagementPermission(currentUser))
                    SettingsNavigationItem(
                      icon: Icons.admin_panel_settings_outlined,
                      title: 'Server Management',
                      onTap: () => context.push(ServerManagementSettings.routeName),
                    ),
                  SettingsNavigationItem(
                    icon: Icons.play_circle_outline_rounded,
                    title: 'Player Settings',
                    onTap: () => context.push(PlayerSettings.routeName),
                  ),
                  if (!AaosService.instance.currentState.isAutomotiveDevice)
                    SettingsNavigationItem(
                      icon: Icons.menu_book_rounded,
                      title: 'Ebook-Reader Settings',
                      onTap: () => context.push(ReaderSettings.routeName),
                    ),
                ],
              ),
            ],
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Error loading user data: $e', style: TextStyle(color: Theme.of(context).colorScheme.error)),
      ),
    );
  }

  void _showManageAccountsBottomSheet(BuildContext context, WidgetRef ref, User? currentUser, List<User> otherUsers) {
    showModalBottomSheet(
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
                        if (currentUser != null)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                            child: Text('Current Account', style: Theme.of(context).textTheme.labelLarge),
                          ),
                        if (currentUser != null)
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                              child: Text(currentUser.username.substring(0, 1).toUpperCase()),
                            ),
                            title: Text(currentUser.username),
                            subtitle: Text(currentUser.server?.url ?? 'No server'),
                            trailing: IconButton(
                              icon: Icon(Icons.logout_rounded, color: Theme.of(context).colorScheme.error),
                              tooltip: 'Sign out this account',
                              onPressed: () {
                                Navigator.pop(bottomSheetContext);
                                _showSignOutCurrentUserConfirmationDialog(context, currentUser, ref);
                              },
                            ),
                          ),
                        if (currentUser != null) const Divider(height: 1),
                        if (otherUsers.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                            child: Text('Other Accounts', style: Theme.of(context).textTheme.labelLarge),
                          ),
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
                              child: Text(user.username.substring(0, 1).toUpperCase()),
                            ),
                            title: Text(user.username),
                            subtitle: Text(user.server?.url ?? 'No server'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.swap_horiz_rounded, color: Theme.of(context).colorScheme.primary),
                                  tooltip: 'Switch to this user',
                                  onPressed: () async {
                                    Navigator.pop(bottomSheetContext);
                                    await _switchActiveUser(context, ref, user);
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
                        }),
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
  Widget build(BuildContext context) {
    final isAndroid = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    final isIOS = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
    final showCarIntegrationSettings = isAndroid || isIOS;

    final filteredSettings = searchableSettings.where((item) {
      final query = _searchQuery.trim().toLowerCase();
      if (query.isEmpty) return false;
      return item.title.toLowerCase().contains(query) || item.description.toLowerCase().contains(query);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: SearchBar(
            leading: const Icon(Icons.search),
            hintText: 'Search settings...',
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            trailing: _searchQuery.isNotEmpty
                ? [
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    ),
                  ]
                : null,
            controller: _searchController,
            elevation: const WidgetStatePropertyAll<double>(1.0),
            shape: WidgetStatePropertyAll<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: <Widget>[
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: _searchQuery.trim().isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (filteredSettings.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.search_off_rounded,
                                        size: 48,
                                        color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        "No settings found for '$_searchQuery'",
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              SettingsNavigationSection(
                                title: 'Search Results',
                                topPadding: 12,
                                items: filteredSettings.map((item) {
                                  return SettingsNavigationItem(
                                    icon: _getIconForRoute(item.route),
                                    title: item.title,
                                    subtitle: '${item.categoryPath}\n${item.description}',
                                    onTap: () {
                                      if (item.route == '/settings/logs') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const LogView()),
                                        );
                                      } else {
                                        context.push(item.route);
                                      }
                                    },
                                  );
                                }).toList(),
                              ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildUserManagementSection(context, ref),
                            StreamBuilder<AaosTelemetryState>(
                              stream: AaosService.instance.stream,
                              initialData: AaosService.instance.currentState,
                              builder: (context, snapshot) {
                                final aaosState = snapshot.data ?? AaosService.instance.currentState;
                                final isAaos = aaosState.isAutomotiveDevice;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    if (isAaos)
                                      SettingsNavigationSection(
                                        title: 'Car Integration',
                                        items: [
                                          SettingsNavigationItem(
                                            icon: Icons.play_circle_outline,
                                            title: 'Open Car Library',
                                            subtitle: 'Switch to the system Media Center',
                                            onTap: () async {
                                              await AaosService.instance.launchMediaCenter(finishActivity: true);
                                            },
                                          ),
                                        ],
                                      ),
                                    SettingsNavigationSection(
                                      title: 'Application Settings',
                                      items: [
                                        SettingsNavigationItem(
                                          icon: Icons.library_books_outlined,
                                          title: 'General',
                                          onTap: () => context.push(LibrarySettings.routeName),
                                        ),
                                        SettingsNavigationItem(
                                          icon: Icons.palette_outlined,
                                          title: 'Appearance',
                                          onTap: () => context.push(AppearanceSettings.routeName),
                                        ),
                                        SettingsNavigationItem(
                                          icon: Icons.play_circle_outline_outlined,
                                          title: 'Global Player',
                                          onTap: () => context.push(GlobalPlayerSettings.routeName),
                                        ),
                                        if (showCarIntegrationSettings)
                                          SettingsNavigationItem(
                                            icon: Icons.directions_car_filled_outlined,
                                            title: aaosState.isAutomotiveDevice
                                                ? 'AAOS'
                                                : (isIOS ? 'CarPlay' : 'Android Auto'),
                                            onTap: () => context.push(AndroidAutoSettings.routeName),
                                          ),
                                        SettingsNavigationItem(
                                          icon: Icons.cached_outlined,
                                          title: 'Caching',
                                          onTap: () => context.push(CachingSettings.routeName),
                                        ),
                                        SettingsNavigationItem(
                                          icon: Icons.menu_book_outlined,
                                          title: 'Ebook Reader',
                                          onTap: () => context.push(ReaderSettings.routeName),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                            ref
                                .watch(currentUserProvider)
                                .when(
                                  data: (currentUser) {
                                    if (currentUser == null || AaosService.instance.currentState.isAutomotiveDevice) {
                                      return const SizedBox.shrink();
                                    }

                                    return ManagementSettingsSection(currentUser: currentUser);
                                  },
                                  loading: () => const SizedBox.shrink(),
                                  error: (error, stackTrace) => const SizedBox.shrink(),
                                ),
                            SettingsNavigationSection(
                              title: 'About & Support',
                              items: [
                                SettingsNavigationItem(
                                  icon: Icons.code_rounded,
                                  title: 'View on GitHub',
                                  onTap: () => _openSupportLink(context, _githubRepoUri, 'GitHub repository'),
                                ),
                                SettingsNavigationItem(
                                  icon: Icons.bug_report_outlined,
                                  title: 'Report bug or enhancement',
                                  onTap: () => _openSupportLink(context, _githubIssueUri, 'issue tracker'),
                                ),
                                SettingsNavigationItem(
                                  icon: Icons.favorite_outline,
                                  title: 'Sponsor',
                                  subtitle: 'Help covering active costs and support development',
                                  onTap: () => _openSupportLink(context, _githubSponsorUri, 'GitHub Sponsors page'),
                                ),
                                SettingsNavigationItem(
                                  icon: Icons.article_outlined,
                                  title: 'Logs',
                                  onTap: () =>
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LogView())),
                                ),
                                SettingsNavigationItem(
                                  icon: Icons.info_outline_rounded,
                                  title: 'Information & Attribution',
                                  subtitle: 'Licenses, app version, licenses, and more',
                                  onTap: () => LicenseSettings.showLicensePage(context: context),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
