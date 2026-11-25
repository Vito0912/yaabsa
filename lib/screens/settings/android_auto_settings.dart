import 'dart:async';

import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/android_auto/android_auto_library_settings.dart';
import 'package:yaabsa/screens/settings/android_auto/android_auto_podcast_library_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/aaos_service.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

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
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingsNavigationSection(
          title: l10n.settingsCategoryGeneral,
          topPadding: 0,
          settings: [
            SettingSwitchTile(
              userId: userId,
              label: l10n.settingGroupListsByFirstLetter,
              subtitle: l10n.settingGroupListsByFirstLetterDescription(integrationLabel),
              settingKey: SettingKeys.androidAutoGroupByLetters,
              defaultValue: true,
            ),
          ],
        ),
        SettingsNavigationSection(
          title: l10n.headingBrowseSettings,
          topPadding: 20,
          items: [
            SettingsNavigationItem(
              icon: Icons.library_books_outlined,
              title: l10n.navLibrary,
              subtitle: l10n.settingBrowseSortDescription(l10n.mediaTypeAudiobook, integrationLabel),
              onTap: () => context.push(AndroidAutoLibrarySettings.routeName),
            ),
            SettingsNavigationItem(
              icon: Icons.podcasts_outlined,
              title: l10n.navPodcastLibrary,
              subtitle: l10n.settingBrowseSortDescription(l10n.mediaTypePodcast, integrationLabel),
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
    final integrationLabel = isIOS ? context.l10n.settingsCarPlay : context.l10n.settingsAndroidAuto;

    return StreamBuilder<AaosTelemetryState>(
      stream: AaosService.instance.stream,
      initialData: AaosService.instance.currentState,
      builder: (context, snapshot) {
        final aaosState = snapshot.data ?? AaosService.instance.currentState;
        final isAaos = aaosState.isAutomotiveDevice;

        return SettingsPageScaffold(
          title: isAaos
              ? context.l10n.settingsAndroidAutomotive
              : context.l10n.headingIntegrationSettings(integrationLabel),
          embedded: true,
          showEmbeddedBackButton: true,
          children: [
            currentUser.when(
              data: (user) {
                if (user == null) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Text(context.l10n.promptSignInToManageSettings),
                  );
                }

                return _buildAndroidAutoSettings(user.id, integrationLabel);
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: YaabsaCircularProgressIndicator()),
              ),
              error: (error, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text(context.l10n.errorOperationFailed(context.l10n.operationLoadSettings, error.toString())),
              ),
            ),
          ],
        );
      },
    );
  }
}
