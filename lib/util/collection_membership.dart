import 'package:yaabsa/api/list/collection.dart';

enum CollectionMembership { present, absent, unknown }

class BookCollectionMemberships {
  BookCollectionMemberships({
    required Iterable<Collection> collections,
    required String libraryId,
    required String bookId,
    this.error,
    this.hasMore = false,
    this.isLoadingMore = false,
  }) {
    final containing = <Collection>[];
    var unknown = false;
    for (final collection in collections) {
      if (collection.libraryId != libraryId) {
        continue;
      }
      switch (collectionMembership(collection, bookId)) {
        case CollectionMembership.present:
          containing.add(collection);
        case CollectionMembership.unknown:
          unknown = true;
        case CollectionMembership.absent:
          break;
      }
    }
    items = List.unmodifiable(containing);
    hasUnknown = unknown;
  }

  late final List<Collection> items;
  late final bool hasUnknown;
  final Object? error;
  final bool hasMore;
  final bool isLoadingMore;
}

/// Null or malformed book lists cannot establish non-membership.
CollectionMembership collectionMembership(Collection collection, String bookId) {
  final books = collection.items;
  if (books == null) {
    return CollectionMembership.unknown;
  }
  if (books.any((book) => book.id == bookId)) {
    return CollectionMembership.present;
  }
  if (!hasCompleteCollectionBooks(collection)) {
    return CollectionMembership.unknown;
  }
  return CollectionMembership.absent;
}

bool hasCompleteCollectionBooks(Collection collection) {
  final books = collection.items;
  return books != null &&
      (collection.numBooks == null || collection.numBooks == books.length) &&
      books.every((book) => book.id.isNotEmpty) &&
      books.map((book) => book.id).toSet().length == books.length;
}

bool canRemoveCollectionMembership(Collection collection, String bookId) {
  return hasCompleteCollectionBooks(collection) &&
      collectionMembership(collection, bookId) == CollectionMembership.present;
}

/// Only explicit edits are applied; untouched collections may change elsewhere.
Map<String, bool> collectionMembershipChanges({
  required Iterable<Collection> original,
  required String libraryId,
  required String bookId,
  required Set<String> selectedIds,
}) {
  final changes = <String, bool>{};
  for (final entry in original) {
    if (entry.libraryId != libraryId) {
      continue;
    }

    final membership = collectionMembership(entry, bookId);
    final selected = selectedIds.contains(entry.id);
    if (membership != CollectionMembership.unknown && (membership == CollectionMembership.present) != selected) {
      changes[entry.id] = selected;
    }
  }

  return changes;
}

bool sameCollectionMembershipRevision(Collection original, Collection current) {
  if (original.libraryId != current.libraryId || original.lastUpdate != current.lastUpdate) {
    return false;
  }
  if (!hasCompleteCollectionBooks(original) || !hasCompleteCollectionBooks(current)) {
    return false;
  }
  final originalIds = original.items!.map((book) => book.id).toSet();
  final currentIds = current.items!.map((book) => book.id).toSet();
  return originalIds.length == currentIds.length && originalIds.containsAll(currentIds);
}
