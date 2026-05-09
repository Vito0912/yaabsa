import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/components/common/managed_list_operations.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

bool supportsFinishedProgressUpdates(LibraryItem item) {
  return item.mediaType == 'book' || item.media?.bookMedia != null;
}

Future<void> markLibraryItemAsFinished({
  required BuildContext context,
  required WidgetRef ref,
  required LibraryItem item,
}) async {
  if (!supportsFinishedProgressUpdates(item)) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mark as finished is currently available for books only.')));
    return;
  }

  await runManagedListMutation(
    context: context,
    action: () async {
      final api = ref.read(absApiProvider);
      if (api == null) {
        throw Exception('API not available');
      }

      await api.getMeApi().patchMediaProgress(item.id, updatePayload: const <String, dynamic>{'isFinished': true});
      await ref.read(mediaProgressProvider.notifier).fetchOrRefreshIndividualProgress(item.id);
    },
    successMessage: 'Marked "${item.title}" as finished.',
    errorFallback: 'Could not mark item as finished.',
  );
}

Future<void> markLibraryItemsAsFinished({
  required BuildContext context,
  required WidgetRef ref,
  required List<LibraryItem> items,
  VoidCallback? onSuccess,
}) async {
  final selectedBookIds = <String>[];
  for (final item in items) {
    if (!supportsFinishedProgressUpdates(item)) {
      continue;
    }
    if (!selectedBookIds.contains(item.id)) {
      selectedBookIds.add(item.id);
    }
  }

  if (selectedBookIds.isEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('No selected books can be marked as finished.')));
    return;
  }

  await runManagedListMutation(
    context: context,
    action: () async {
      final api = ref.read(absApiProvider);
      if (api == null) {
        throw Exception('API not available');
      }

      final payloads = selectedBookIds
          .map((id) => <String, dynamic>{'libraryItemId': id, 'isFinished': true})
          .toList(growable: false);

      await api.getMeApi().batchUpdateMediaProgress(payloads);
      ref.read(mediaProgressProvider.notifier).refreshAllProgress(clearBefore: false);
    },
    successMessage: 'Marked ${selectedBookIds.length} selected item(s) as finished.',
    errorFallback: 'Could not mark selected items as finished.',
    onSuccess: onSuccess,
  );
}
