import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/api/list/collection.dart';
import 'package:yaabsa/util/collection_membership.dart';

import 'collection_test_support.dart';

void main() {
  test('membership uses IDs and distinguishes absent from unknown', () {
    expect(collectionMembership(collection('yes', books: [testBook]), 'book'), CollectionMembership.present);
    expect(collectionMembership(collection('no', books: [otherBook]), 'book'), CollectionMembership.absent);
    expect(collectionMembership(collection('empty'), 'book'), CollectionMembership.absent);
    expect(collectionMembership(collection('unknown', books: null), 'book'), CollectionMembership.unknown);
    final malformed = otherBook.copyWith(id: '');
    expect(collectionMembership(collection('invalid', books: [malformed]), 'book'), CollectionMembership.unknown);
    expect(
      collectionMembership(collection('duplicate', books: [otherBook, otherBook]), 'book'),
      CollectionMembership.unknown,
    );
  });

  test('a count larger than the supplied preview is unknown', () {
    final data = Collection.fromJson({
      'id': 'preview',
      'libraryId': 'library',
      'name': 'Preview',
      'lastUpdate': 1,
      'createdAt': 0,
      'numBooks': 2,
      'books': [],
    });
    expect(collectionMembership(data, 'book'), CollectionMembership.unknown);
    final partial = collection('partial', books: [testBook]).copyWith(numBooks: 2);
    expect(collectionMembership(partial, 'book'), CollectionMembership.present);
    expect(collectionMembership(partial, 'other'), CollectionMembership.unknown);
    expect(canRemoveCollectionMembership(partial, 'book'), isFalse);
  });

  test('diff includes only explicit changes in this library and skips unknown', () {
    final original = [
      collection('remove', books: [testBook, otherBook]),
      collection('keep', books: [testBook]),
      collection('add'),
      collection('untouched'),
      collection('unknown', books: null),
      collection('elsewhere', libraryId: 'another', books: [testBook]),
    ];
    expect(
      collectionMembershipChanges(
        original: original,
        libraryId: 'library',
        bookId: 'book',
        selectedIds: {'keep', 'add'},
      ),
      {'remove': false, 'add': true},
    );
  });

  test('allows removing the only book but not editing an incomplete list', () {
    expect(canRemoveCollectionMembership(collection('only', books: [testBook]), 'book'), isTrue);
    expect(canRemoveCollectionMembership(collection('many', books: [testBook, otherBook]), 'book'), isTrue);
    expect(canRemoveCollectionMembership(collection('unknown', books: null), 'book'), isFalse);
  });

  test('detects revised or changed books even when revision is unchanged', () {
    final original = collection('a', books: [testBook, otherBook]);
    expect(sameCollectionMembershipRevision(original, original), isTrue);
    expect(sameCollectionMembershipRevision(original, original.copyWith(lastUpdate: 2)), isFalse);
    expect(sameCollectionMembershipRevision(original, original.copyWith(items: [testBook])), isFalse);
    expect(sameCollectionMembershipRevision(original, original.copyWith(items: null)), isFalse);
  });
}
