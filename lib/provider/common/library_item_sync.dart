import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/common/library_item_events.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/interceptors/cache_interceptor.dart';
import 'package:yaabsa/util/logger.dart';

final Map<String, String> _lastItemUpdateSignatureById = <String, String>{};

Future<void> processLibraryItemAdded({
  required ProviderContainer container,
  required LibraryItem item,
  String source = 'unknown',
}) async {
  container.read(libraryItemMutationProvider.notifier).emitAdded(item, source: source);

  try {
    await _updateStoredDownloadSnapshot(container: container, item: item);
    await invalidateCachedLibraryItemEntries(container: container, itemId: item.id, libraryId: item.libraryId);
  } catch (e, s) {
    logger('Failed to sync local item add for ${item.id}: $e\n$s', tag: 'LibraryItemSync', level: InfoLevel.warning);
  }
}

Future<void> processLibraryItemUpdate({
  required ProviderContainer container,
  required LibraryItem item,
  String source = 'unknown',
}) async {
  if (!_registerUpdateSignature(item)) {
    logger(
      'Skipping duplicate library item update for ${item.id} from $source',
      tag: 'LibraryItemSync',
      level: InfoLevel.debug,
    );
    return;
  }

  container.read(libraryItemMutationProvider.notifier).emitUpdated(item, source: source);

  try {
    await _updateStoredDownloadSnapshot(container: container, item: item);
    await invalidateCachedLibraryItemEntries(container: container, itemId: item.id, libraryId: item.libraryId);
  } catch (e, s) {
    logger('Failed to sync local item update for ${item.id}: $e\n$s', tag: 'LibraryItemSync', level: InfoLevel.warning);
  }
}

Future<void> processLibraryItemRemoved({
  required ProviderContainer container,
  required LibraryItem item,
  String source = 'unknown',
}) async {
  await processLibraryItemRemovedById(
    container: container,
    itemId: item.id,
    libraryId: item.libraryId,
    item: item,
    source: source,
  );
}

Future<void> processLibraryItemRemovedById({
  required ProviderContainer container,
  required String itemId,
  String? libraryId,
  LibraryItem? item,
  String source = 'unknown',
}) async {
  final normalizedItemId = itemId.trim();
  if (normalizedItemId.isEmpty) {
    return;
  }

  container
      .read(libraryItemMutationProvider.notifier)
      .emitRemoved(itemId: normalizedItemId, libraryId: libraryId, item: item, source: source);

  try {
    await invalidateCachedLibraryItemEntries(container: container, itemId: normalizedItemId, libraryId: libraryId);
  } catch (e, s) {
    logger(
      'Failed to sync local item removal for $normalizedItemId: $e\n$s',
      tag: 'LibraryItemSync',
      level: InfoLevel.warning,
    );
  }
}

Future<void> processLibraryItemsAdded({
  required ProviderContainer container,
  required List<LibraryItem> items,
  String source = 'unknown',
}) async {
  for (final item in items) {
    await processLibraryItemAdded(container: container, item: item, source: source);
  }
}

Future<void> processLibraryItemsUpdated({
  required ProviderContainer container,
  required List<LibraryItem> items,
  String source = 'unknown',
}) async {
  for (final item in items) {
    await processLibraryItemUpdate(container: container, item: item, source: source);
  }
}

Future<void> _updateStoredDownloadSnapshot({required ProviderContainer container, required LibraryItem item}) async {
  final userId = container.read(currentUserProvider).value?.id ?? container.read(absApiProvider)?.user?.id;
  if (userId == null || userId.isEmpty) {
    return;
  }

  await container
      .read(appDatabaseProvider)
      .updateStoredDownloadItemSnapshot(itemId: item.id, userId: userId, item: item);
}

bool _registerUpdateSignature(LibraryItem item) {
  final signature = _signatureFor(item);
  final previous = _lastItemUpdateSignatureById[item.id];
  if (previous == signature) {
    return false;
  }

  _lastItemUpdateSignatureById[item.id] = signature;
  return true;
}

String _signatureFor(LibraryItem item) {
  try {
    return jsonEncode(item.toJson()).hashCode.toString();
  } catch (_) {
    return '${item.updatedAt ?? ''}|${item.lastScan ?? ''}|${item.mtimeMs ?? ''}|${item.id}';
  }
}
