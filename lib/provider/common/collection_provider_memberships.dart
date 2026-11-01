part of 'collection_provider.dart';

mixin _CollectionMembershipMutations on _$CollectionsNotifier {
  int get membershipRevision;

  void applyServerUpdate(Collection item);

  Future<void> refresh({
    bool withLoading = true,
    bool forceServer = true,
    bool requireServer = false,
    bool invalidatePending = false,
  });

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
    if (changes.isEmpty) {
      return;
    }

    final hasRemovals = changes.containsValue(false);
    final api = ref.read(absApiProvider);
    if (api == null) {
      throw Exception('API not available.');
    }

    final loaded = state.value;
    if (loaded == null || loaded.error != null) {
      throw Exception('Reload collections before editing.');
    }
    final currentById = {for (final item in loaded.items) item.id: item};
    try {
      if (hasRemovals) {
        final validationRevision = membershipRevision;
        for (final id in changes.keys) {
          final current = (await api.getListApi().getCollection(
            id,
            extra: const {'noCache': true, 'skipCacheOnError': true},
          )).data;
          if (!ref.mounted || validationRevision != membershipRevision) {
            throw Exception('Collections changed during validation. Reload before retrying.');
          }
          if (current == null || current.libraryId != libraryId) {
            throw Exception('Could not validate the collection.');
          }
          currentById[id] = current;
        }
      }
      final originalById = {for (final collection in original) collection.id: collection};
      for (final edit in changes.entries) {
        final current = currentById[edit.key];
        if (current == null || !sameCollectionMembershipRevision(originalById[edit.key]!, current)) {
          throw Exception(
            'Collections changed or their contents are unavailable. Review the updated selections and try again.',
          );
        }
        if (!edit.value && !canRemoveCollectionMembership(current, bookId)) {
          throw Exception('Full book list unavailable for "${current.name}". Reload collections before editing.');
        }
      }
    } catch (_) {
      if (ref.mounted) {
        await refresh(withLoading: false, requireServer: true, invalidatePending: true);
      }
      rethrow;
    }

    checkPermission();
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
          throw Exception('The server did not confirm the collection changes.');
        }
        if (!ref.mounted) {
          throw Exception('The active user changed. Reload before editing.');
        }

        succeeded++;
        applyServerUpdate(updated);
      } catch (error) {
        failures.add('${collection.name}: $error');
      }
    }

    if (!hasRemovals && failures.isEmpty) {
      unawaited(refresh(withLoading: false, forceServer: true, requireServer: true));
      return;
    }

    if (!ref.mounted) {
      throw Exception('The active user changed. Reload before editing.');
    }

    await refresh(withLoading: false, requireServer: true, invalidatePending: true);
    final syncError = state.value?.error ?? state.error;
    if (failures.isNotEmpty || syncError != null) {
      throw Exception(
        [
          'Collections updated: $succeeded of ${changes.length}.',
          ...failures,
          if (syncError != null) 'Could not reload collections. Retry loading before editing again: $syncError',
          'Review the updated selections before retrying.',
        ].join('\n'),
      );
    }
  }
}
