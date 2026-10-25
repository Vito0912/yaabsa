import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/list/collection.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/collection_membership.dart';
import 'package:yaabsa/util/setting_key.dart';

final collectionMembershipEditingAllowedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider).value;
  ref.watch(userSettingsWatcherProvider);
  return user != null &&
      user.permissions.update &&
      ref
          .read(settingsManagerProvider.notifier)
          .getUserSetting<bool>(user.id, SettingKeys.serverManagementCollections, defaultValue: true);
});

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

/// Recompute only when collection state changes, rather than on book/player
/// rebuilds. The underlying collection list and HTTP cache remain shared.
final bookCollectionMembershipsProvider = Provider.autoDispose
    .family<AsyncValue<BookCollectionMemberships>, ({String libraryId, String bookId})>((ref, key) {
      return ref
          .watch(collectionsProvider(key.libraryId))
          .whenData(
            (state) => BookCollectionMemberships(
              collections: state.items,
              libraryId: key.libraryId,
              bookId: key.bookId,
              error: state.error,
            ),
          );
    });

class CollectionsNotifier extends AsyncNotifier<CollectionsState> {
  CollectionsNotifier(this.libraryId);

  final String libraryId;
  Future<void>? _refreshInFlight;
  int _revision = 0;
  int _refreshRevision = 0;
  bool _refreshForcesServer = false;
  bool _refreshRequiresServer = false;

  Future<CollectionsState> _fetchCollections({bool forceServer = false, bool requireServer = false}) async {
    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final response = await absApi.getListApi().getCollections(
      forceServer: forceServer || requireServer,
      extra: requireServer ? const {'skipCacheOnError': true} : null,
    );
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

  Future<void> refresh({
    bool withLoading = true,
    bool forceServer = true,
    bool requireServer = false,
    bool invalidatePending = false,
  }) {
    if (!ref.mounted) return Future.value();
    // A known server change or explicit validation must not reuse an older response.
    if (invalidatePending) _revision++;
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
    if (withLoading) {
      state = const AsyncValue.loading();
    }

    try {
      final refreshed = await _fetchCollections(forceServer: forceServer, requireServer: requireServer);
      if (ref.mounted && revision == _revision) state = AsyncData(refreshed);
    } catch (e, s) {
      if (!ref.mounted || revision != _revision) return;
      final currentState = state.value;
      if (currentState != null) {
        state = AsyncData(currentState.copyWith(error: e, stackTrace: s));
      } else {
        state = AsyncError(e, s);
      }
    }
  }

  /// Additions use the loaded snapshot and the server's updated collection.
  /// Removals require a fresh snapshot before sending any mutations.
  /// Only send this book's ID so concurrent changes to other books survive.
  Future<void> updateBookMemberships({
    required String bookId,
    required List<Collection> original,
    required Set<String> selectedIds,
  }) async {
    void checkPermission() {
      if (!ref.read(collectionMembershipEditingAllowedProvider)) {
        throw Exception('Collection editing is not allowed.');
      }
    }

    checkPermission();
    final changes = collectionMembershipChanges(
      original: original,
      libraryId: libraryId,
      bookId: bookId,
      selectedIds: selectedIds,
    );
    if (changes.isEmpty) return;

    final hasRemovals = changes.containsValue(false);
    if (hasRemovals) {
      final validation = refresh(withLoading: false, requireServer: true, invalidatePending: true);
      final validationRevision = _revision;
      await validation;
      if (validationRevision != _revision) {
        throw Exception('Collections changed during validation. Reload and review the selections before retrying.');
      }
    }
    final loaded = state.value;
    if (loaded == null || loaded.error != null) {
      throw Exception('Reload collections before editing their memberships.');
    }
    final currentById = {for (final collection in loaded.items) collection.id: collection};
    final originalById = {for (final collection in original) collection.id: collection};
    for (final edit in changes.entries) {
      final current = currentById[edit.key];
      if (current == null || !sameCollectionMembershipRevision(originalById[edit.key]!, current)) {
        throw Exception('Collections changed or membership is unknown. Review the updated selections and try again.');
      }
      if (!edit.value && !canRemoveCollectionMembership(current, bookId)) {
        throw Exception('Collections cannot be empty. Keep at least one book in "${current.name}".');
      }
    }
    checkPermission();
    final api = ref.read(absApiProvider);
    if (api == null) throw Exception('API not available.');
    final failures = <String>[];
    var succeeded = 0;
    for (final edit in changes.entries) {
      final collection = currentById[edit.key]!;
      try {
        checkPermission();
        final response = edit.value
            ? await api.getListApi().addBooksToCollection(edit.key, bookIds: [bookId])
            : await api.getListApi().removeBooksFromCollection(edit.key, bookIds: [bookId]);
        final updated = response.data;
        if (updated == null ||
            updated.id != edit.key ||
            updated.libraryId != libraryId ||
            collectionMembership(updated, bookId) !=
                (edit.value ? CollectionMembership.present : CollectionMembership.absent)) {
          throw Exception('The server did not confirm the membership change.');
        }
        succeeded++;
        _revision++;
        // Publish confirmed responses immediately, including partial successes.
        final current = state.value!;
        state = AsyncData(
          CollectionsState(
            libraryId: libraryId,
            items: current.items.map((item) => item.id == updated.id ? updated : item).toList(growable: false),
            totalItems: current.totalItems,
          ),
        );
      } catch (error) {
        failures.add('${collection.name}: $error');
      }
    }

    if (!hasRemovals && failures.isEmpty) {
      // Do not keep Save blocked while reloading every collection and its books.
      // Equivalent refreshes share work; older requests cannot overwrite this edit.
      unawaited(refresh(withLoading: false, forceServer: true, requireServer: true));
      return;
    }

    await refresh(withLoading: false, requireServer: true, invalidatePending: true);
    final syncError = state.value?.error ?? state.error;
    if (failures.isNotEmpty || syncError != null) {
      throw Exception(
        [
          '$succeeded of ${changes.length} collection change(s) confirmed.',
          ...failures,
          if (syncError != null) 'Could not reload collections. Retry loading before editing again: $syncError',
          'Review the updated selections before retrying.',
        ].join('\n'),
      );
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

    _revision++;
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

    _revision++;
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

    _revision++;
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

    _revision++;
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
