import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/personalized_shelf_sections_editor.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/home_navigation_preferences.dart';

class LibraryShelfSettings extends ConsumerWidget {
  const LibraryShelfSettings({super.key});

  static const String routeName = '/settings/library/shelf';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return SettingsPageScaffold(
      title: 'Shelf Sections',
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        currentUser.when(
          data: (user) {
            if (user == null) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text('Sign in to configure shelf sections'),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PersonalizedShelfSectionsEditor(userId: user.id, mediaType: HomeLibraryMediaType.book),
                PersonalizedShelfSectionsEditor(userId: user.id, mediaType: HomeLibraryMediaType.podcast),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) =>
              Padding(padding: const EdgeInsets.all(16), child: Text('Failed to load shelf settings: $error')),
        ),
      ],
    );
  }
}
