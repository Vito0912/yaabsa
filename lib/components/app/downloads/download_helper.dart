import 'package:yaabsa/components/app/item/item_progress_actions.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/file_formats.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/setting_key.dart';

import 'download_type_dialog.dart';

Future<void> triggerBookDownload(BuildContext context, WidgetRef ref, String itemId, {String? episodeId}) async {
  final user = ref.read(currentUserProvider).value;
  if (user == null) return;

  LibraryItem? item = ref.read(libraryItemProvider(itemId)).asData?.value;
  if (item == null) {
    try {
      item = await ref.read(libraryItemProvider(itemId).future);
    } catch (_) {}
  }

  if (item == null) return;

  final hasAudio = (item.media?.bookMedia?.audioFiles?.isNotEmpty ?? false) || (item.mediaType == 'podcast');
  bool hasEbook = item.media?.bookMedia?.ebookFile != null;
  if (!hasEbook && item.libraryFiles != null) {
    hasEbook = item.libraryFiles!.any((file) => FileFormats.isEbook(file.metadata.ext));
  }

  if (hasAudio && !hasEbook) {
    await downloadHandler.downloadFile(itemId, episodeId: episodeId, downloadType: 'audiobook');
    return;
  }

  if (hasEbook && !hasAudio) {
    await downloadHandler.downloadFile(itemId, episodeId: episodeId, downloadType: 'ebook');
    return;
  }

  final settings = ref.read(settingsManagerProvider.notifier);
  final pref = settings.getUserSetting<String>(
    user.id,
    SettingKeys.downloadTypePreference,
    defaultValue: 'askEveryTime',
  );

  if (pref != 'askEveryTime') {
    await downloadHandler.downloadFile(itemId, episodeId: episodeId, downloadType: pref);
    return;
  }

  if (!context.mounted) return;

  final result = await showDialog<DownloadTypeDialogResult>(
    context: context,
    builder: (context) => const DownloadTypeDialog(),
  );

  if (result == null) {
    return;
  }

  if (result.remember) {
    await settings.setUserSetting<String>(user.id, SettingKeys.downloadTypePreference, result.type);
  }

  await downloadHandler.downloadFile(itemId, episodeId: episodeId, downloadType: result.type);
}

Future<void> triggerMultiBookDownload(BuildContext context, WidgetRef ref, List<String> itemIds) async {
  final user = ref.read(currentUserProvider).value;
  if (user == null) return;

  final settings = ref.read(settingsManagerProvider.notifier);
  final pref = settings.getUserSetting<String>(
    user.id,
    SettingKeys.downloadTypePreference,
    defaultValue: 'askEveryTime',
  );

  String downloadType = pref;
  if (pref == 'askEveryTime') {
    final result = await showDialog<DownloadTypeDialogResult>(
      context: context,
      builder: (context) => const DownloadTypeDialog(isMulti: true),
    );

    if (result == null) {
      return;
    }

    if (result.remember) {
      await settings.setUserSetting<String>(user.id, SettingKeys.downloadTypePreference, result.type);
    }
    downloadType = result.type;
  }

  var count = 0;
  for (final itemId in itemIds) {
    try {
      await downloadHandler.downloadFile(itemId, downloadType: downloadType);
      count++;
    } catch (e) {
      logger('Could not download $itemId: $e', tag: 'DownloadHelper', level: InfoLevel.error);
    }
  }

  if (context.mounted) {
    final message = count == 1 ? '1 download added to queue.' : '$count downloads added to queue.';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

Future<void> triggerMultiLibraryItemDownload(BuildContext context, WidgetRef ref, List<LibraryItem> items) async {
  if (!(ref.read(currentUserProvider).value?.permissions.download ?? false)) {
    return;
  }

  final episodeItems = <String, LibraryItem>{
    for (final item in items)
      if (selectablePodcastEpisode(item)?.audioFile != null) libraryItemSelectionKey(item): item,
  };
  var count = 0;
  for (final item in episodeItems.values) {
    try {
      await downloadHandler.downloadFile(
        item.id,
        episodeId: selectablePodcastEpisode(item)!.id,
        downloadType: 'audiobook',
      );
      count++;
    } catch (error) {
      logger(
        'Could not download ${libraryItemSelectionKey(item)}: $error',
        tag: 'DownloadHelper',
        level: InfoLevel.error,
      );
    }
  }
  if (!context.mounted) {
    return;
  }
  if (episodeItems.isNotEmpty) {
    final message = count == 1 ? '1 episode download added to queue.' : '$count episode downloads added to queue.';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
  final bookIds = items.where((item) => selectablePodcastEpisode(item) == null).map((item) => item.id).toSet().toList();
  if (bookIds.isNotEmpty) {
    await triggerMultiBookDownload(context, ref, bookIds);
  }
}
