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
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:yaabsa/generated/l10n.dart';

class MainSettingsScreen extends ConsumerWidget {
  const MainSettingsScreen({super.key});

  static const String routeName = '/settings';

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.current.screensSettingsSettingsScreenDeletedUser(user.username))));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.current.screensSettingsSettingsScreenFailedToDeleteUser(user.username, e.toString()))),
      );
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

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(S.current.screensSettingsSettingsScreenSwitchedTo(user.username))));
  }

  void _showDeleteUserConfirmationDialog(BuildContext context, User user, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(S.current.screensSettingsSettingsScreenDeleteUser),
          content: Text(S.current.screensSettingsSettingsScreenAreYouSureYouWantTo(user.username)),
          actions: <Widget>[
            TextButton(
              child: Text(S.current.screensSettingsSettingsScreenCancel),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(
                S.current.screensSettingsSettingsScreenDelete,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
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
          title: Text(S.current.screensSettingsSettingsScreenSignOutCurrentAccount),
          content: Text(S.current.screensSettingsSettingsScreenSignOutFromOnThisDevice(user.username)),
          actions: <Widget>[
            TextButton(
              child: Text(S.current.screensSettingsSettingsScreenCancel),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(
                S.current.screensSettingsSettingsScreenSignOut,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
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
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
              child: Text(
                S.current.screensSettingsSettingsScreenActiveACCOUNT,
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
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
                            S.current.screensSettingsSettingsScreenNoActiveUser,
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
                      label: Text(S.current.screensSettingsSettingsScreenManageAccounts),
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
                      label: Text(S.current.screensSettingsSettingsScreenAddAccount),
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
                      title: S.current.screensSettingsSettingsScreenEbookReaderSettings,
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
        child: Text(
          S.current.screensSettingsSettingsScreenErrorLoadingUserData(e.toString()),
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }

  void _showManageAccountsBottomSheet(BuildContext context, WidgetRef ref, User? currentUser, List<User> otherUsers) {
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
                    child: Text(
                      S.current.screensSettingsSettingsScreenManageAccounts,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        if (currentUser != null)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                            child: Text(
                              S.current.screensSettingsSettingsScreenCurrentAccount,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        if (currentUser != null)
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                              child: Text(currentUser.username.substring(0, 1).toUpperCase()),
                            ),
                            title: Text(currentUser.username),
                            subtitle: Text(currentUser.server?.url ?? S.current.screensSettingsSettingsScreenNoServer),
                            trailing: IconButton(
                              icon: Icon(Icons.logout_rounded, color: Theme.of(context).colorScheme.error),
                              tooltip: S.current.screensSettingsSettingsScreenSignOutThisAccount,
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
                            child: Text(
                              S.current.screensSettingsSettingsScreenOtherAccounts,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        if (otherUsers.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              S.current.screensSettingsSettingsScreenNoOtherAccountsAvailable,
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
                            subtitle: Text(user.server?.url ?? S.current.screensSettingsSettingsScreenNoServer),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.swap_horiz_rounded, color: Theme.of(context).colorScheme.primary),
                                  tooltip: S.current.screensSettingsSettingsScreenSwitchToThisUser,
                                  onPressed: () async {
                                    Navigator.pop(bottomSheetContext);
                                    await _switchActiveUser(context, ref, user);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_outline_rounded, color: Theme.of(context).colorScheme.error),
                                  tooltip: S.current.screensSettingsSettingsScreenDeleteThisUser,
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
  Widget build(BuildContext context, WidgetRef ref) {
    final showAndroidAutoSettings = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: <Widget>[
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
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
                            title: S.current.screensSettingsSettingsScreenCarIntegration,
                            items: [
                              SettingsNavigationItem(
                                icon: Icons.play_circle_outline,
                                title: S.current.screensSettingsSettingsScreenOpenCarLibrary,
                                subtitle: S.current.screensSettingsSettingsScreenSwitchToTheSystemMediaCenter,
                                onTap: () async {
                                  await AaosService.instance.launchMediaCenter(finishActivity: true);
                                },
                              ),
                            ],
                          ),
                        SettingsNavigationSection(
                          title: S.current.screensSettingsSettingsScreenApplicationSettings,
                          items: [
                            SettingsNavigationItem(
                              icon: Icons.palette_outlined,
                              title: S.current.screensSettingsSettingsScreenAppearance,
                              onTap: () => context.push(AppearanceSettings.routeName),
                            ),
                            SettingsNavigationItem(
                              icon: Icons.play_circle_outline_outlined,
                              title: S.current.screensSettingsSettingsScreenGlobalPlayer,
                              onTap: () => context.push(GlobalPlayerSettings.routeName),
                            ),
                            SettingsNavigationItem(
                              icon: Icons.library_books_outlined,
                              title: S.current.screensSettingsSettingsScreenLibraryBehaviour,
                              onTap: () => context.push(LibrarySettings.routeName),
                            ),
                            if (showAndroidAutoSettings)
                              SettingsNavigationItem(
                                icon: Icons.directions_car_filled_outlined,
                                title: aaosState.isAutomotiveDevice
                                    ? S.current.commonAaos
                                    : S.current.commonAndroidAuto,
                                onTap: () => context.push(AndroidAutoSettings.routeName),
                              ),
                            SettingsNavigationItem(
                              icon: Icons.cached_outlined,
                              title: S.current.screensSettingsSettingsScreenCaching,
                              onTap: () => context.push(CachingSettings.routeName),
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
                  title: S.current.screensSettingsSettingsScreenAboutAndSupport,
                  items: [
                    SettingsNavigationItem(
                      icon: Icons.code_rounded,
                      title: S.current.screensSettingsSettingsScreenViewOnGitHub,
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(S.current.screensSettingsSettingsScreenNavigateToViewOnGitHub)),
                      ),
                    ),
                    SettingsNavigationItem(
                      icon: Icons.bug_report_outlined,
                      title: S.current.screensSettingsSettingsScreenReportAnIssue,
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(S.current.screensSettingsSettingsScreenNavigateToReportAnIssue)),
                      ),
                    ),
                    SettingsNavigationItem(
                      icon: Icons.article_outlined,
                      title: S.current.screensSettingsSettingsScreenLogs,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LogView())),
                    ),
                    SettingsNavigationItem(
                      icon: Icons.info_outline_rounded,
                      title: S.current.screensSettingsSettingsScreenInformationAndAttribution,
                      subtitle: S.current.screensSettingsSettingsScreenLicensesAppVersionAndAttribution,
                      onTap: () => LicenseSettings.showLicensePage(context: context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
