import 'dart:convert';

import 'package:yaabsa/util/lru_cache.dart';

import 'package:yaabsa/provider/common/library_filter_data_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/common/library_item_events.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/interceptors/cache_interceptor.dart';
import 'package:yaabsa/util/logger.dart';

final Map<String, String> _lastItemUpdateSignatureById = LruCache<String, String>();

Future<void> processLibraryItemAdded({
  required ProviderContainer container,
  required LibraryItem item,
  String source = 'unknown',
}) async {
  container.read(libraryItemMutationProvider.notifier).emitAdded(item, source: source);

  try {
    await _updateStoredDownloadSnapshot(container: container, item: item);
    await invalidateCachedLibraryItemEntries(container: container, itemId: item.id, libraryId: item.libraryId);
    container.invalidate(libraryFilterDataProvider);
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

  final previousItem = getLiveLibraryItemSnapshot(item.id);
  container.read(libraryItemMutationProvider.notifier).emitUpdated(item, previousItem: previousItem, source: source);

  try {
    await _updateStoredDownloadSnapshot(container: container, item: item);
    await invalidateCachedLibraryItemEntries(container: container, itemId: item.id, libraryId: item.libraryId);
    container.invalidate(libraryFilterDataProvider);
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
    container.invalidate(libraryFilterDataProvider);
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
}) {
  return _processLibraryItemBatch(container: container, items: items, source: source, added: true);
}

Future<void> processLibraryItemsUpdated({
  required ProviderContainer container,
  required List<LibraryItem> items,
  String source = 'unknown',
}) {
  return _processLibraryItemBatch(container: container, items: items, source: source, added: false);
}

Future<void> _processLibraryItemBatch({
  required ProviderContainer container,
  required List<LibraryItem> items,
  required String source,
  required bool added,
}) async {
  final changedItems = <LibraryItem>[];
  for (final item in items) {
    if (!added && !_registerUpdateSignature(item)) {
      continue;
    }

    final mutations = container.read(libraryItemMutationProvider.notifier);
    if (added) {
      mutations.emitAdded(item, source: source);
    } else {
      final previousItem = getLiveLibraryItemSnapshot(item.id);
      mutations.emitUpdated(item, previousItem: previousItem, source: source);
    }
    changedItems.add(item);

    try {
      await _updateStoredDownloadSnapshot(container: container, item: item);
    } catch (error) {
      logger(
        'Failed to update downloaded snapshot for ${item.id}: $error',
        tag: 'LibraryItemSync',
        level: InfoLevel.warning,
      );
    }
  }

  if (changedItems.isEmpty) {
    return;
  }
  try {
    await invalidateCachedLibraryItemsEntries(
      container: container,
      items: changedItems.map((item) => (itemId: item.id, libraryId: item.libraryId)),
    );
    container.invalidate(libraryFilterDataProvider);
  } catch (error) {
    logger('Failed to invalidate cache for item batch: $error', tag: 'LibraryItemSync', level: InfoLevel.warning);
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
