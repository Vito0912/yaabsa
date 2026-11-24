part of 'cache_interceptor.dart';

final StoreRef<String, dynamic> _cacheStore = StoreRef.main();
final _cacheOperationOwners = Expando<_CacheOperations>();

_CacheOperations _cacheOperations(ProviderContainer container) {
  return _cacheOperationOwners[container] ??= _CacheOperations();
}

class _CacheOperations {
  Future<void> pending = Future<void>.value();
  final Set<String> refreshing = <String>{};
  final Map<String, Set<String>> invalidations = <String, Set<String>>{};
  Completer<void>? invalidation;
  int epoch = 0;

  Future<void> enqueue(Future<void> Function() operation) {
    final result = pending.then((_) => operation());
    pending = result.catchError((Object error, StackTrace stack) {});
    return result;
  }

  Future<void> invalidate(String userId, Set<String> fragments) {
    epoch++;
    invalidations.putIfAbsent(userId, () => <String>{}).addAll(fragments);
    final existing = invalidation;
    if (existing != null) {
      return existing.future;
    }

    final completion = Completer<void>();
    invalidation = completion;
    Timer.run(() async {
      final batches = Map<String, Set<String>>.from(invalidations);
      invalidations.clear();
      invalidation = null;

      try {
        await enqueue(() async {
          final keys = await _cacheStore.findKeys(cacheDb);
          final keysToDelete = keys
              .where((key) {
                for (final entry in batches.entries) {
                  if (key.startsWith(entry.key) && entry.value.any(key.contains)) {
                    return true;
                  }
                }
                return false;
              })
              .toList(growable: false);

          if (keysToDelete.isNotEmpty) {
            await _cacheStore.records(keysToDelete).delete(cacheDb);
          }
        });
        completion.complete();
      } catch (error, stack) {
        completion.completeError(error, stack);
      }
    });
    return completion.future;
  }
}

Future<void> invalidateCachedLibraryItemEntries({
  required ProviderContainer container,
  required String itemId,
  String? libraryId,
}) {
  return invalidateCachedLibraryItemsEntries(container: container, items: [(itemId: itemId, libraryId: libraryId)]);
}

Future<void> invalidateCachedLibraryItemsEntries({
  required ProviderContainer container,
  required Iterable<({String itemId, String? libraryId})> items,
}) async {
  final userId = container.read(currentUserProvider).value?.id ?? container.read(absApiProvider)?.user?.id;
  if (userId == null || userId.isEmpty) {
    return;
  }

  final fragments = <String>{};
  for (final item in items) {
    fragments.addAll({
      '/api/items/${item.itemId}',
      '/api/playlists',
      '/api/collections',
      '/api/series/',
      '/api/authors/',
    });
    final libraryId = item.libraryId;
    if (libraryId != null && libraryId.isNotEmpty) {
      fragments.add('/api/libraries/$libraryId');
    }
  }

  if (fragments.isNotEmpty) {
    await _cacheOperations(container).invalidate(userId, fragments);
  }
}
