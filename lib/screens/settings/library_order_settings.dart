import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

class LibraryOrderSettings extends ConsumerWidget {
  const LibraryOrderSettings({super.key});

  static const String routeName = '/settings/library/order';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final userLibrariesAsync = ref.watch(userLibrariesProvider);
    final db = ref.watch(appDatabaseProvider);

    return SettingsPageScaffold(
      title: context.l10n.navLibraries,
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

            return userLibrariesAsync.when(
              data: (libraries) {
                if (libraries.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Center(child: Text(context.l10n.statusNoLibrariesFound)),
                  );
                }

                return ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: libraries.length,
                  buildDefaultDragHandles: false,
                  itemBuilder: (context, index) {
                    final library = libraries[index];
                    return Card(
                      key: ValueKey(library.id),
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: ListTile(
                        leading: ReorderableDragStartListener(index: index, child: const Icon(Icons.drag_handle)),
                        title: Text(library.name),
                        subtitle: StreamBuilder<UserSettingEntry?>(
                          stream: db.watchUserSetting(user.id, 'music_library_${library.id}'),
                          builder: (context, snapshot) {
                            final isMusic = snapshot.data?.value == 'true';
                            return Text(
                              isMusic ? context.l10n.libraryTypeMusic : context.l10n.libraryTypeDefault,
                              style: TextStyle(
                                color: isMusic ? Theme.of(context).colorScheme.primary : null,
                                fontWeight: isMusic ? FontWeight.w500 : null,
                              ),
                            );
                          },
                        ),
                        trailing: StreamBuilder<UserSettingEntry?>(
                          stream: db.watchUserSetting(user.id, 'music_library_${library.id}'),
                          builder: (context, snapshot) {
                            final isMusic = snapshot.data?.value == 'true';
                            return IconButton(
                              icon: Icon(
                                isMusic ? Icons.music_note : Icons.music_note_outlined,
                                color: isMusic
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                              ),
                              onPressed: () async {
                                await ref
                                    .read(settingsManagerProvider.notifier)
                                    .setUserSetting<bool>(user.id, 'music_library_${library.id}', !isMusic);
                              },
                              tooltip: context.l10n.actionChangeLibraryType(
                                isMusic ? context.l10n.libraryTypeDefault : context.l10n.libraryTypeMusic,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  onReorderItem: (oldIndex, newIndex) async {
                    final nextList = List<Library>.from(libraries);
                    final moved = nextList.removeAt(oldIndex);
                    nextList.insert(newIndex, moved);

                    final nextOrder = nextList.map((lib) => lib.id).toList();
                    await ref
                        .read(settingsManagerProvider.notifier)
                        .setUserSetting<String>(user.id, 'libraries_order', jsonEncode(nextOrder));
                  },
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: YaabsaCircularProgressIndicator()),
              ),
              error: (error, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text(context.l10n.errorOperationFailed(context.l10n.operationLoadLibraries, error.toString())),
              ),
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: YaabsaCircularProgressIndicator()),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text(context.l10n.errorOperationFailed(context.l10n.operationLoadUser, error.toString())),
          ),
        ),
      ],
    );
  }
}
