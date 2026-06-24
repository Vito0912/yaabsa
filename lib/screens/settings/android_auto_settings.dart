import 'dart:async';

import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/android_auto/android_auto_library_settings.dart';
import 'package:yaabsa/screens/settings/android_auto/android_auto_podcast_library_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/aaos_service.dart';
import 'package:yaabsa/util/setting_key.dart';

class AndroidAutoSettings extends ConsumerStatefulWidget {
  const AndroidAutoSettings({super.key});

  static const String routeName = '/settings/android-auto';

  @override
  ConsumerState<AndroidAutoSettings> createState() => _AndroidAutoSettingsState();
}

class _AndroidAutoSettingsState extends ConsumerState<AndroidAutoSettings> {
  @override
  void initState() {
    super.initState();
    unawaited(AaosService.instance.initialize());
  }

  Widget _buildAndroidAutoSettings(String userId, String integrationLabel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsNavigationSection(
          title: 'General',
          topPadding: 0,
          settings: [
            SettingSwitchTile(
              userId: userId,
              label: 'Group Large Lists By First Letter',
              subtitle: 'Group entries alphabetically for faster rotary browsing in long $integrationLabel lists',
              settingKey: SettingKeys.androidAutoGroupByLetters,
              defaultValue: true,
            ),
          ],
        ),
        SettingsNavigationSection(
          title: 'Library Browse Settings',
          topPadding: 20,
          items: [
            SettingsNavigationItem(
              icon: Icons.library_books_outlined,
              title: 'Library',
              subtitle: 'Configure sorting for audiobook library browsing in $integrationLabel',
              onTap: () => context.push(AndroidAutoLibrarySettings.routeName),
            ),
            SettingsNavigationItem(
              icon: Icons.podcasts_outlined,
              title: 'Podcast Library',
              subtitle: 'Configure sorting for podcast library browsing in $integrationLabel',
              onTap: () => context.push(AndroidAutoPodcastLibrarySettings.routeName),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final isIOS = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
    final integrationLabel = isIOS ? 'CarPlay' : 'Android Auto';

    return StreamBuilder<AaosTelemetryState>(
      stream: AaosService.instance.stream,
      initialData: AaosService.instance.currentState,
      builder: (context, snapshot) {
        final aaosState = snapshot.data ?? AaosService.instance.currentState;
        final isAaos = aaosState.isAutomotiveDevice;

        return SettingsPageScaffold(
          title: isAaos ? 'AAOS Settings' : '$integrationLabel Settings',
          embedded: true,
          showEmbeddedBackButton: true,
          children: [
            currentUser.when(
              data: (user) {
                if (user == null) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Text('Sign in to configure car browse settings'),
                  );
                }

                return _buildAndroidAutoSettings(user.id, integrationLabel);
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) =>
                  Padding(padding: const EdgeInsets.all(16), child: Text('Failed to load user settings: $error')),
            ),
          ],
        );
      },
    );
  }
}
