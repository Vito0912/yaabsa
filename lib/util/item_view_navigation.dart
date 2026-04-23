import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/library_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/setting_key.dart';

Future<void> openLibraryWithFilter(BuildContext context, WidgetRef ref, {required String filter}) async {
  final selectedLibrary = ref.read(selectedLibraryProvider);
  final currentUser = ref.read(currentUserProvider).value;
  if (selectedLibrary == null || currentUser == null) {
    context.go('/?tab=library&intent=${DateTime.now().microsecondsSinceEpoch}');
    return;
  }

  final collapseSeriesFallback = ref
      .read(settingsManagerProvider.notifier)
      .getUserSetting<bool>(currentUser.id, SettingKeys.collapseSeries, defaultValue: false);
  final initialCollapseSeries = selectedLibrary.mediaType == 'book' && collapseSeriesFallback ? 1 : 0;

  final provider = libraryItemsProvider(selectedLibrary.id, initialCollapseSeries: initialCollapseSeries);
  await ref.read(provider.future);
  await ref.read(provider.notifier).setFilter(filter);

  if (context.mounted) {
    context.go('/?tab=library&intent=${DateTime.now().microsecondsSinceEpoch}');
  }
}
