import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/list/collection.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

class CollectionsState {
  const CollectionsState({
    this.items = const <Collection>[],
    required this.libraryId,
    this.error,
    this.stackTrace,
    this.totalItems = 0,
  });

  final List<Collection> items;
  final String libraryId;
  final Object? error;
  final StackTrace? stackTrace;
  final int totalItems;

  CollectionsState copyWith({
    List<Collection>? items,
    String? libraryId,
    Object? error,
    StackTrace? stackTrace,
    int? totalItems,
  }) {
    return CollectionsState(
      items: items ?? this.items,
      libraryId: libraryId ?? this.libraryId,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

final collectionsProvider = AsyncNotifierProvider.family<CollectionsNotifier, CollectionsState, String>(
  CollectionsNotifier.new,
);

class CollectionsNotifier extends AsyncNotifier<CollectionsState> {
  CollectionsNotifier(this.libraryId);

  final String libraryId;

  Future<CollectionsState> _fetchCollections({bool forceServer = false}) async {
    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final response = await absApi.getListApi().getCollections(forceServer: forceServer);
    final data = response.data;
    if (data == null) {
      throw Exception('No collections data received from API.');
    }

    final filteredCollections = data.items.where((item) => item.libraryId == libraryId).toList(growable: false)
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return CollectionsState(items: filteredCollections, libraryId: libraryId, totalItems: filteredCollections.length);
  }

  @override
  Future<CollectionsState> build() async {
    return _fetchCollections();
  }

  Future<void> refresh({bool withLoading = true, bool forceServer = true}) async {
    if (withLoading) {
      state = const AsyncValue.loading();
    }

    try {
      final refreshed = await _fetchCollections(forceServer: forceServer);
      state = AsyncData(refreshed);
    } catch (e, s) {
      final currentState = state.value;
      if (currentState != null) {
        state = AsyncData(currentState.copyWith(error: e, stackTrace: s));
      } else {
        state = AsyncError(e, s);
      }
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

    await refresh(withLoading: false, forceServer: true);
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

    await refresh(withLoading: false, forceServer: true);
    return updated;
  }

  Future<Collection> replaceBooksInCollection(
    String collectionId, {
    required List<String> currentBookIds,
    required List<String> desiredBookIds,
  }) async {
    final normalizedCurrent = _normalizeItemIds(currentBookIds);
    final normalizedDesired = _normalizeItemIds(desiredBookIds);

    if (normalizedDesired.isEmpty) {
      throw Exception('Collections cannot be empty. Keep at least one book selected.');
    }

    if (_sameOrder(normalizedCurrent, normalizedDesired)) {
      await refresh(withLoading: false, forceServer: true);
      for (final collection in state.value?.items ?? const <Collection>[]) {
        if (collection.id == collectionId) {
          return collection;
        }
      }
      throw Exception('Collection could not be refreshed.');
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

    await refresh(withLoading: false, forceServer: true);

    final updated = updatedResponse.data;
    if (updated != null) {
      return updated;
    }

    for (final collection in state.value?.items ?? const <Collection>[]) {
      if (collection.id == collectionId) {
        return collection;
      }
    }

    throw Exception('No collection data returned from replace request.');
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

    await refresh(withLoading: false, forceServer: true);
  }
}

List<String> _normalizeItemIds(List<String> ids) {
  final normalized = <String>[];
  final seen = <String>{};

  for (final id in ids) {
    if (id.isEmpty || !seen.add(id)) {
      continue;
    }
    normalized.add(id);
  }

  return normalized;
}

bool _sameOrder(List<String> left, List<String> right) {
  if (left.length != right.length) {
    return false;
  }

  for (var i = 0; i < left.length; i++) {
    if (left[i] != right[i]) {
      return false;
    }
  }

  return true;
}
