import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/api/list/collection.dart';
import 'package:yaabsa/api/list/response/library_list_page.dart';
import 'package:yaabsa/provider/common/collection_lookup_provider.dart';
import 'package:yaabsa/provider/common/collection_state.dart';
import 'package:yaabsa/provider/common/library_list_pagination.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/collection_membership.dart';
import 'package:yaabsa/util/list_item_ids.dart';

export 'collection_state.dart';
export 'collection_lookup_provider.dart';

part 'collection_provider.g.dart';
part 'collection_provider_memberships.dart';
part 'collection_provider_sync.dart';

@Riverpod(keepAlive: true)
class CollectionsNotifier extends _$CollectionsNotifier with _CollectionMembershipMutations, _CollectionServerSync {
  @override
  int get membershipRevision => _revision;

  Future<void>? _refreshInFlight;
  int _revision = 0;
  int _refreshRevision = 0;
  bool _refreshForcesServer = false;
  bool _refreshRequiresServer = false;
  Future<void>? _nextPageInFlight;
  bool _paginationDirty = false;
  @override
  final Map<String, int> itemRevisions = {};

  @override
  void invalidateListRequests() {
    _revision++;
    _paginationDirty = true;
  }

  Future<LibraryListPage<Collection>> _fetchPage(int page, {bool forceServer = false, bool requireServer = false}) =>
      fetchCollectionListPage(ref, libraryId, page, forceServer: forceServer, requireServer: requireServer);

  Future<CollectionsState> _fetchCollections({bool forceServer = false, bool requireServer = false}) async {
    final targetCount = state.value?.items.length ?? libraryListPageSize;
    var pagination = const LibraryListPagination<Collection>();
    final items = <String, Collection>{};
    var initial = true;

    do {
      final batch = await pagination.loadNext(
        (page) => _fetchPage(page, forceServer: forceServer, requireServer: requireServer),
        initial: initial,
      );
      initial = false;
      pagination = batch.pagination;
      for (final item in batch.items) {
        if (item.libraryId == libraryId) {
          items[item.id] = item;
        }
      }
    } while (items.length < targetCount && pagination.hasNextPage);

    return CollectionsState(
      items: items.values.toList(growable: false),
      libraryId: libraryId,
      totalItems: pagination.total,
      pagination: pagination,
    );
  }

  @override
  Future<CollectionsState> build(String libraryId) async {
    while (true) {
      final revision = _revision;
      final loaded = await _fetchCollections(forceServer: revision != 0, requireServer: revision != 0);
      if (!ref.mounted) {
        return loaded;
      }
      if (revision == _revision) {
        _paginationDirty = false;
        return loaded;
      }
    }
  }

  @override
  void applyServerUpdate(Collection item) {
    if (!ref.mounted || item.libraryId != libraryId) {
      return;
    }
    _revision++;
    itemRevisions.update(item.id, (revision) => revision + 1, ifAbsent: () => 1);
    _paginationDirty = true;
    ref.invalidate(collectionByIdProvider(libraryId, item.id));
    final current = state.value;
    if (current == null) {
      return;
    }
    final itemsById = {for (final entry in current.items) entry.id: entry};
    itemsById[item.id] = item;
    final items = itemsById.values.toList(growable: false);
    state = AsyncData(
      current.copyWith(
        items: items,
        totalItems: current.totalItems > items.length ? current.totalItems : items.length,
        clearError: true,
        clearNextPageError: true,
        isLoadingNextPage: false,
      ),
    );
  }

  @override
  void applyServerRemoval(String id) {
    if (!ref.mounted) {
      return;
    }
    _revision++;
    itemRevisions.update(id, (revision) => revision + 1, ifAbsent: () => 1);
    _paginationDirty = true;
    ref.invalidate(collectionByIdProvider(libraryId, id));
    final current = state.value;
    if (current == null) {
      return;
    }
    final items = current.items.where((entry) => entry.id != id).toList(growable: false);
    state = AsyncData(
      current.copyWith(
        items: items,
        totalItems: current.items.any((entry) => entry.id == id) && current.totalItems > 0
            ? current.totalItems - 1
            : current.totalItems,
        clearError: true,
        clearNextPageError: true,
        isLoadingNextPage: false,
      ),
    );
  }

  @override
  Future<void> refresh({
    bool withLoading = true,
    bool forceServer = true,
    bool requireServer = false,
    bool invalidatePending = false,
  }) {
    if (!ref.mounted) {
      return Future.value();
    }
    if (invalidatePending) {
      _revision++;
    }
    final inFlight = _refreshInFlight;
    if (inFlight != null) {
      if (_refreshRevision == _revision &&
          (!(forceServer || requireServer) || _refreshForcesServer) &&
          (!requireServer || _refreshRequiresServer)) {
        return inFlight;
      }
      // A request started before a confirmed edit, or one that permits an
      // offline cache fallback, cannot satisfy a fresh synchronization request.
      return inFlight.then(
        (_) => refresh(withLoading: withLoading, forceServer: forceServer, requireServer: requireServer),
      );
    }
    _revision++;
    _refreshRevision = _revision;
    _refreshForcesServer = forceServer || requireServer;
    _refreshRequiresServer = requireServer;
    final request = _refreshCollections(
      withLoading: withLoading,
      forceServer: forceServer,
      requireServer: requireServer,
      revision: _revision,
    );
    _refreshInFlight = request;
    return request.whenComplete(() => _refreshInFlight = null);
  }

  Future<void> _refreshCollections({
    required bool withLoading,
    required bool forceServer,
    required bool requireServer,
    required int revision,
  }) async {
    if (withLoading && !state.hasValue) {
      state = const AsyncValue.loading();
    }

    try {
      final refreshed = await _fetchCollections(forceServer: forceServer, requireServer: requireServer);
      if (ref.mounted && revision == _revision) {
        _paginationDirty = false;
        state = AsyncData(refreshed);
      }
    } catch (e, s) {
      if (!ref.mounted || revision != _revision) {
        return;
      }
      final currentState = state.value;
      if (currentState != null) {
        state = AsyncData(currentState.copyWith(error: e, stackTrace: s, isLoadingNextPage: false));
      } else {
        state = AsyncError(e, s);
      }
    }
  }

  Future<void> loadNextPage() {
    final pending = _nextPageInFlight;
    if (pending != null) {
      return pending;
    }

    final operation = _loadNextPage();
    _nextPageInFlight = operation.whenComplete(() {
      _nextPageInFlight = null;
    });
    return _nextPageInFlight!;
  }

  Future<void> _loadNextPage() async {
    await _refreshInFlight;
    if (!ref.mounted) {
      return;
    }
    if (_paginationDirty) {
      await refresh(withLoading: false, requireServer: true, invalidatePending: true);
    }
    if (!ref.mounted) {
      return;
    }

    final current = state.value;
    if (current == null || current.error != null || !current.hasNextPage) {
      return;
    }

    final revision = _revision;
    state = AsyncData(current.copyWith(isLoadingNextPage: true, clearNextPageError: true));
    try {
      final batch = await current.pagination.loadNext((page) => _fetchPage(page, forceServer: true));
      if (!ref.mounted || revision != _revision) {
        return;
      }

      final items = {for (final item in current.items) item.id: item};
      for (final item in batch.items) {
        if (item.libraryId == libraryId) {
          items[item.id] = item;
        }
      }
      state = AsyncData(
        current.copyWith(
          items: items.values.toList(growable: false),
          pagination: batch.pagination,
          totalItems: batch.pagination.total,
          isLoadingNextPage: false,
          clearNextPageError: true,
        ),
      );
    } catch (error) {
      if (ref.mounted && revision == _revision) {
        state = AsyncData(current.copyWith(nextPageError: error, isLoadingNextPage: false));
      }
    }
  }

  Future<void> ensureAllLoaded() async {
    await future;
    if (!ref.mounted) {
      return;
    }

    if (state.requireValue.error != null) {
      await refresh(withLoading: false, requireServer: true);
    } else if (state.requireValue.nextPageError != null) {
      await loadNextPage();
    }

    while (ref.mounted) {
      final current = state.requireValue;
      final error = current.error ?? current.nextPageError;
      if (error != null) {
        throw error;
      }
      if (!current.hasNextPage) {
        return;
      }

      await loadNextPage();
    }
  }

  Future<Collection> createCollection({
    required String name,
    String? description,
    required List<String> bookIds,
  }) async {
    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final createdResponse = await absApi.getListApi().createCollection(
      libraryId: libraryId,
      name: name,
      description: description,
      bookIds: bookIds,
    );

    final created = createdResponse.data;
    if (created == null) {
      throw Exception('No collection data returned from create request.');
    }

    applyServerUpdate(created);
    return created;
  }

  Future<Collection> updateCollection(String collectionId, {required String name, String? description}) async {
    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final updatedResponse = await absApi.getListApi().updateCollection(
      collectionId,
      name: name,
      description: description,
    );

    final updated = updatedResponse.data;
    if (updated == null) {
      throw Exception('No collection data returned from update request.');
    }

    ref.invalidate(collectionByIdProvider(libraryId, collectionId));
    _revision++;
    await refresh(withLoading: false, forceServer: true);
    return updated;
  }

  Future<Collection> addBooksToCollection(String collectionId, {required List<String> bookIds}) async {
    if (bookIds.isEmpty) {
      throw Exception('No books selected.');
    }

    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final updatedResponse = await absApi.getListApi().addBooksToCollection(collectionId, bookIds: bookIds);

    final updated = updatedResponse.data;
    if (updated == null) {
      throw Exception('No collection data returned from add request.');
    }

    ref.invalidate(collectionByIdProvider(libraryId, collectionId));
    _revision++;
    await refresh(withLoading: false, forceServer: true);
    return updated;
  }

  Future<Collection> removeBooksFromCollection(String collectionId, {required List<String> bookIds}) async {
    if (bookIds.isEmpty) {
      throw Exception('No books selected.');
    }

    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final updatedResponse = await absApi.getListApi().removeBooksFromCollection(collectionId, bookIds: bookIds);

    final updated = updatedResponse.data;
    if (updated == null) {
      throw Exception('No collection data returned from remove request.');
    }

    ref.invalidate(collectionByIdProvider(libraryId, collectionId));
    _revision++;
    await refresh(withLoading: false, forceServer: true);
    return updated;
  }

  Future<Collection> replaceBooksInCollection(
    String collectionId, {
    required List<String> currentBookIds,
    required List<String> desiredBookIds,
  }) async {
    final normalizedCurrent = normalizeListItemIds(currentBookIds);
    final normalizedDesired = normalizeListItemIds(desiredBookIds);

    if (normalizedDesired.isEmpty) {
      throw Exception('Collections cannot be empty. Keep at least one book selected.');
    }

    if (sameListItemOrder(normalizedCurrent, normalizedDesired)) {
      return ref.refresh(collectionByIdProvider(libraryId, collectionId).future);
    }

    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final currentSet = normalizedCurrent.toSet();
    final desiredSet = normalizedDesired.toSet();

    final booksToAdd = normalizedDesired.where((id) => !currentSet.contains(id)).toList(growable: false);
    final booksToRemove = normalizedCurrent.where((id) => !desiredSet.contains(id)).toList(growable: false);

    if (booksToAdd.isNotEmpty) {
      await absApi.getListApi().addBooksToCollection(collectionId, bookIds: booksToAdd);
    }

    if (booksToRemove.isNotEmpty) {
      await absApi.getListApi().removeBooksFromCollection(collectionId, bookIds: booksToRemove);
    }

    final updatedResponse = await absApi.getListApi().updateCollection(collectionId, books: normalizedDesired);

    ref.invalidate(collectionByIdProvider(libraryId, collectionId));
    _revision++;
    await refresh(withLoading: false, forceServer: true);

    final updated = updatedResponse.data;
    if (updated != null) {
      return updated;
    }

    return ref.refresh(collectionByIdProvider(libraryId, collectionId).future);
  }

  Future<void> deleteCollection(String collectionId) async {
    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final deleted = await absApi.getListApi().deleteCollection(collectionId);
    if (!deleted) {
      throw Exception('Collection delete request failed.');
    }

    ref.invalidate(collectionByIdProvider(libraryId, collectionId));
    _revision++;
    await refresh(withLoading: false, forceServer: true);
  }
}
