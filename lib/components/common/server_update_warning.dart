import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/server_update_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/setting_key.dart';

enum ServerUpdateWarningVariant { mobile, sidebarCollapsed, sidebarTablet, sidebarDesktop }

class ServerUpdateWarning extends ConsumerWidget {
  const ServerUpdateWarning({super.key, required this.variant, required this.latestVersion});

  final ServerUpdateWarningVariant variant;
  final String latestVersion;

  static void showUpdateDetailsDialog(BuildContext context, WidgetRef ref, String latestVersion) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Server Update Available'),
        content: Text('A new update (version $latestVersion) is available for your Audiobookshelf server.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
          TextButton(
            onPressed: () {
              ref.read(serverUpdateStateProvider.notifier).dismiss();
              Navigator.of(context).pop();
            },
            child: const Text('Dismiss Warning'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(appDatabaseProvider);
    final currentUser = ref.watch(currentUserProvider).value;
    if (currentUser == null) return const SizedBox.shrink();

    final currentVersion = currentUser.setting?.version;
    if (currentVersion == null || currentVersion.trim().isEmpty) return const SizedBox.shrink();

    final dismissedVersion =
        ref
            .watch(
              StreamProvider.autoDispose<String>(
                (ref) => db
                    .watchUserSetting(currentUser.id, SettingKeys.dismissedUpdateServerVersion)
                    .map((entry) => entry?.value ?? ''),
              ),
            )
            .value ??
        '';

    if (dismissedVersion == currentVersion) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;

    switch (variant) {
      case ServerUpdateWarningVariant.mobile:
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.system_update_rounded, color: colorScheme.onErrorContainer),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Server Update Available',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: colorScheme.onErrorContainer),
                    ),
                    Text(
                      'Version $latestVersion is ready',
                      style: TextStyle(fontSize: 12, color: colorScheme.onErrorContainer.withValues(alpha: 0.85)),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => ref.read(serverUpdateStateProvider.notifier).dismiss(),
                child: Text(
                  'Dismiss',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onErrorContainer),
                ),
              ),
            ],
          ),
        );

      case ServerUpdateWarningVariant.sidebarDesktop:
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.errorContainer.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.error.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.system_update_rounded, size: 16, color: colorScheme.error),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Server Update',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 16),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => ref.read(serverUpdateStateProvider.notifier).dismiss(),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Version $latestVersion is available.',
                style: TextStyle(fontSize: 12, color: colorScheme.onErrorContainer),
              ),
            ],
          ),
        );

      case ServerUpdateWarningVariant.sidebarTablet:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: InkWell(
            onTap: () => showUpdateDetailsDialog(context, ref, latestVersion),
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.system_update_rounded, size: 22, color: colorScheme.error),
                const SizedBox(height: 2),
                Text(
                  'Update $latestVersion',
                  style: TextStyle(color: colorScheme.error, fontSize: 11),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );

      case ServerUpdateWarningVariant.sidebarCollapsed:
        return Tooltip(
          message: 'Server update available: $latestVersion',
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: IconButton(
              icon: Icon(Icons.system_update_rounded, color: colorScheme.error),
              onPressed: () => showUpdateDetailsDialog(context, ref, latestVersion),
            ),
          ),
        );
    }
  }
}
