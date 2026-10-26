# Collection and playlist membership checks

From the repository root, with Flutter on PATH:

```sh
flutter --version
flutter pub get
flutter analyze
flutter test test/collections test/playlists
flutter test
```

The SDK must satisfy the Dart and Flutter requirements in `pubspec.yaml` and
`pubspec.lock`. A fresh checkout also needs its pinned Git submodules:

```sh
git -c url.https://github.com/.insteadOf=git@github.com: submodule update --init --recursive
```

Generated model files are included in the change; no code-generation step is
needed to test it.

The automated tests use in-memory HTTP fixtures; they need no Audiobookshelf
server or credentials. They cover membership classification, missing/incomplete
book lists, diffs, caching, permissions/preferences, concurrent edits, mutation
and synchronization failures, selection/cancellation, navigation, responsive
scrolling, metadata updates, and the existing multi-book add pickers. Playlist
tests also cover ownership, entry order, episode identities and the existing
podcast-episode addition method. Refresh tests cover incoming server changes,
background pagination, the library bulk-add action, and provider disposal during
background work. Later-page failures retain the complete previous list.

## Manual checks against Audiobookshelf

Launch on a configured device with `flutter run -d <device_id>`. Android uses
`flutter run --flavor auto -d <device_id>`, as described in `CONTRIBUTING.md`.
Use disposable test collections for mutation checks.

1. Open a book with no collection memberships. Its metadata should show
   **Collections: No collections** after loading. Repeat with one and several
   memberships; click each name to open its collection. Check a book from a
   different library, if available.
2. With update permission and the collection-management preference enabled,
   choose **More actions → Manage collections**. Existing memberships are
   checked. Only collections from the book's library appear.
3. Check and uncheck several collections, then choose **Cancel**. Reopen the
   dialog and verify that the original memberships remain, including in the
   server's web client.
4. Repeat and choose **Save changes**. Controls should be disabled while saving.
   The dialog closes on success, a confirmation appears, and the metadata and
   server web client reflect all changes.
5. Remove the book from every collection containing it. The metadata should
   now show **No collections**. Removing the only book leaves an empty collection
   available in the server web client.
6. Sign in without update permission, then separately disable collection
   management in settings. Metadata links should still work; the management
   action should be unavailable.
7. Open the dialog, select a removal, change that collection through the server
   web client, then save in yaabsa. No edits should be sent from the stale snapshot; an
   explanation and updated selections should appear for review.
8. Disconnect the server. Previously cached metadata may remain visible. A
   first load without cached data should show an error with Retry, never
   **No collections**. Removals must fail before mutations if a fresh server
   check cannot complete. Additions contact the mutation endpoint directly and
   report failures if it is unavailable.
9. For a partial failure, use an HTTP proxy to reject one selected collection's
   mutation request. Confirm successful changes remain visible, failed changes
   are reported, and the dialog stays open with refreshed selections. Reject
   the background list request after a successful addition separately: Save
   should complete and retain the confirmed membership, while metadata shows
   a reload error with Retry.
10. In the library, select several books and add them to one collection using
    the existing bulk picker. All selected IDs should be added as before.
11. Try a narrow window and a library with many collections. The dialog should
    scroll while Cancel and Save stay accessible.
12. With more than 50 collections or playlists, verify that entries beyond the
    first page appear and their memberships are correct. Refresh while watching
    the list; existing entries should stay visible. Switch libraries and verify
    that only entries from the selected library appear.
13. Keep the list screen, a collection/playlist detail page, or book metadata
    open. In the server web client, add, rename, change and delete a list. The
    open view should update from the websocket without a manual refresh.
14. With automatic queue enabled, start playback from collections and playlists,
    including lists beyond the first API page. Verify item order after edits
    made in the web client. When an Android Auto device is available, repeat
    browsing and playback there, including playlists containing episodes.

Repeat the applicable checks for **Playlists** and **Manage playlists**. Playlist
editing follows the existing ownership rule and does not require the server's
update permission or the collection-management preference. Verify that an owner
without update permission can still edit their playlists. Any playlist belonging
to another user that appears in loaded data must remain read-only. Only playlists
returned for the current user by the library-playlist endpoint can be displayed;
this does not expose other users' private playlists.

For playlists, also verify that removing a book preserves the other entries and
their order, and that existing multi-book and podcast-episode additions still
work. Removing the only item opens a confirmation naming the playlists that
Audiobookshelf will delete. Cancel must leave every selected change local;
Continue saves the changes and removes the deleted playlists from the UI.
Collections remain available when their last book is removed.

## Loading and caching

Collections and playlists use their existing library-specific endpoints,
requesting 50 entries per page. Pages load sequentially in the background and the provider
publishes the combined list after all pages succeed. Existing results stay visible
throughout refreshes. List and detail screens, pickers, and Android Auto keep
receiving complete lists; no additional UI pagination is required. If a server
returns an oversized page, the next request starts after the returned range to
avoid downloading duplicate entries. Short or inconsistent pages fail loading.

The page URLs reuse the existing collection and playlist cache preferences.
Riverpod retains the combined results, so opening another book in the same
library does not fetch the pages again. Websocket events update this state
directly, including visible membership metadata and detail titles. Automatic
queue loading reads the same providers, so it also sees socket changes and
avoids fetching a second list when the library is already loaded.

`noCache` bypasses the interceptor's initial lookup, but its error handler can
still return a cached response after a network failure. `skipCacheOnError`
disables that fallback for removal validation and post-save synchronization:
these requests must not mistake stale cached data for a fresh server response
or overwrite a confirmed edit. Unlike `doNotCache`, this still allows successful
responses to update the cache. Normal browsing retains its offline fallback.

## Safety limits

Collection mutations use the existing single-collection batch add/remove
endpoints. The server does not provide a transaction covering several
collections or a conditional revision check through these client methods.
Add-only saves reuse the loaded snapshot, send only the current book ID, and
publish the server's returned collection immediately. The batch-add endpoint
preserves other books and tolerates a book already being present. Cache
synchronization runs in the background, so Save does not wait for a full list
reload. Equivalent overlapping refreshes share a request; a refresh started
before a confirmed edit cannot overwrite the updated provider state.
Incoming socket changes update the shared list directly and invalidate older
pending responses. The library bulk-add action schedules a fresh synchronization
while sharing equivalent work.
Background synchronization stops publishing if the provider has been disposed.

Saves containing removals validate one fresh snapshot before any writes and
reload once after the batch. Partial failures also reload before allowing
review and retry. A change made after validation can still race with a mutation.
No automatic rollback is attempted.
A server change received during removal validation aborts the save before any
membership writes; reload and review the selections before retrying.

Playlist mutations use the equivalent existing item batch endpoints with the
current book's `libraryItemId` and no episode ID. They preserve other entries and
their order; podcast episodes are not mistaken for book memberships. Additions
reuse loaded data and synchronize in the background, while removals validate a
fresh snapshot. Missing expanded book metadata does not make membership unknown
if the entry IDs are available. Missing item lists, empty IDs and duplicate entry
identities disable editing. The same transaction and concurrency limits apply.

A missing book list, mismatched `numBooks`, empty item ID, or duplicate item ID
cannot establish non-membership. Such data disables editing for that collection.
An explicitly listed book remains a known member even when the rest of the
list is incomplete. Reload may restore complete data; the dialog does not
issue a separate request for every unknown collection.
