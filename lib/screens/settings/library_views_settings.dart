import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/home_navigation_preferences_editor.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/home_navigation_preferences.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

class LibraryViewsSettings extends ConsumerWidget {
  const LibraryViewsSettings({super.key});

  static const String routeName = '/settings/library/views';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return SettingsPageScaffold(
      title: context.l10n.settingLibraryViews,
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

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HomeNavigationPreferencesEditor(userId: user.id, mediaType: HomeLibraryMediaType.book),
                HomeNavigationPreferencesEditor(userId: user.id, mediaType: HomeLibraryMediaType.podcast),
              ],
            );
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
  }
}
