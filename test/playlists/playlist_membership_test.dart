import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/api/list/playlist_item.dart';
import 'package:yaabsa/util/playlist_membership.dart';

import 'playlist_test_support.dart';

void main() {
  test('matches book IDs without requiring expanded metadata and ignores episodes', () {
    expect(playlistMembership(playlist('yes', items: [bookEntry]), 'book'), PlaylistMembership.present);
    expect(playlistMembership(playlist('empty'), 'book'), PlaylistMembership.absent);
    expect(playlistMembership(playlist('unknown', items: null), 'book'), PlaylistMembership.unknown);
    expect(
      playlistMembership(
        playlist(
          'episode',
          items: [const PlaylistItem(itemId: 'book', episodeId: 'ep')],
        ),
        'book',
      ),
      PlaylistMembership.absent,
    );
  });

  test('malformed or duplicate entries cannot establish non-membership', () {
    for (final items in [
      [const PlaylistItem(itemId: '')],
      [otherEntry, otherEntry],
    ]) {
      expect(playlistMembership(playlist('invalid', items: items), 'book'), PlaylistMembership.unknown);
    }
    final partial = playlist(
      'partial',
      items: [
        bookEntry,
        const PlaylistItem(itemId: ''),
      ],
    );
    expect(playlistMembership(partial, 'book'), PlaylistMembership.present);
    expect(canRemovePlaylistMembership(partial, 'book'), isFalse);
  });

  test('diff filters libraries and excludes unknown memberships', () {
    expect(
      playlistMembershipChanges(
        original: [
          playlist('remove', items: [bookEntry, otherEntry]),
          playlist('add'),
          playlist('keep', items: [bookEntry]),
          playlist('unknown', items: null),
          playlist('elsewhere', libraryId: 'another', items: [bookEntry]),
        ],
        libraryId: 'library',
        bookId: 'book',
        selectedIds: {'add', 'keep'},
      ),
      {'remove': false, 'add': true},
    );
  });

  test('ownership is independent of server management permissions', () {
    expect(canEditPlaylistMembership(playlist('mine'), 'user'), isTrue);
    expect(canEditPlaylistMembership(playlist('other', userId: 'someone'), 'user'), isFalse);
    expect(canEditPlaylistMembership(playlist('mine'), null), isFalse);
  });

  test('last-item removal is allowed and revision includes order and ownership', () {
    final original = playlist('a', items: [bookEntry, otherEntry]);
    expect(canRemovePlaylistMembership(playlist('only', items: [bookEntry]), 'book'), isTrue);
    expect(canRemovePlaylistMembership(original, 'book'), isTrue);
    expect(samePlaylistMembershipRevision(original, original), isTrue);
    expect(samePlaylistMembershipRevision(original, original.copyWith(items: [otherEntry, bookEntry])), isFalse);
    expect(samePlaylistMembershipRevision(original, original.copyWith(userId: 'someone')), isFalse);
    expect(samePlaylistMembershipRevision(original, original.copyWith(items: null)), isFalse);
  });
}
