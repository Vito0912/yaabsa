import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/common/collection_provider.dart';
import 'package:yaabsa/provider/common/library_author_provider.dart';
import 'package:yaabsa/provider/common/library_filter_data_provider.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/library_search_provider.dart';
import 'package:yaabsa/provider/common/playlist_provider.dart';
import 'package:yaabsa/provider/common/series_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/library/personalized_library_provider.dart';
import 'package:yaabsa/util/interceptors/cache_interceptor.dart';
import 'package:yaabsa/util/logger.dart';

final Map<String, String> _lastItemUpdateSignatureById = <String, String>{};

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

  try {
    final userId = container.read(currentUserProvider).value?.id ?? container.read(absApiProvider)?.user?.id;
    if (userId != null && userId.isNotEmpty) {
      await container
          .read(appDatabaseProvider)
          .updateStoredDownloadItemSnapshot(itemId: item.id, userId: userId, item: item);
    }

    await invalidateCachedLibraryItemEntries(container: container, itemId: item.id, libraryId: item.libraryId);
  } catch (e, s) {
    logger('Failed to sync local item update for ${item.id}: $e\n$s', tag: 'LibraryItemSync', level: InfoLevel.warning);
  } finally {
    invalidateLibraryItemConsumers(container: container, itemId: item.id);
  }
}

void invalidateLibraryItemConsumers({required ProviderContainer container, String? itemId}) {
  if (itemId != null && itemId.isNotEmpty) {
    container.invalidate(libraryItemProvider(itemId));
  }

  container.invalidate(libraryItemsProvider);
  container.invalidate(personalizedLibraryProvider);
  container.invalidate(seriesBooksProvider);
  container.invalidate(seriesProvider);
  container.invalidate(seriesByIdProvider);
  container.invalidate(collectionsProvider);
  container.invalidate(playlistsProvider);
  container.invalidate(libraryAuthorProvider);
  container.invalidate(libraryAuthorsProvider);
  container.invalidate(librarySearchProvider);
  container.invalidate(libraryFilterDataProvider);
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
