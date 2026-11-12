// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_lookup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bookPlaylistMemberships)
final bookPlaylistMembershipsProvider = BookPlaylistMembershipsFamily._();

final class BookPlaylistMembershipsProvider
    extends
        $FunctionalProvider<
          AsyncValue<BookPlaylistMemberships>,
          AsyncValue<BookPlaylistMemberships>,
          AsyncValue<BookPlaylistMemberships>
        >
    with $Provider<AsyncValue<BookPlaylistMemberships>> {
  BookPlaylistMembershipsProvider._({
    required BookPlaylistMembershipsFamily super.from,
    required ({String bookId, String libraryId}) super.argument,
  }) : super(
         retry: null,
         name: r'bookPlaylistMembershipsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookPlaylistMembershipsHash();

  @override
  String toString() {
    return r'bookPlaylistMembershipsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<BookPlaylistMemberships>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AsyncValue<BookPlaylistMemberships> create(Ref ref) {
    final argument = this.argument as ({String bookId, String libraryId});
    return bookPlaylistMemberships(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<BookPlaylistMemberships> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<BookPlaylistMemberships>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BookPlaylistMembershipsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookPlaylistMembershipsHash() => r'cfa1d2adbaa238500ce69dd1c85b46e3d5d236f4';

final class BookPlaylistMembershipsFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<BookPlaylistMemberships>, ({String bookId, String libraryId})> {
  BookPlaylistMembershipsFamily._()
    : super(
        retry: null,
        name: r'bookPlaylistMembershipsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BookPlaylistMembershipsProvider call(({String bookId, String libraryId}) key) =>
      BookPlaylistMembershipsProvider._(argument: key, from: this);

  @override
  String toString() => r'bookPlaylistMembershipsProvider';
}

@ProviderFor(playlistById)
final playlistByIdProvider = PlaylistByIdFamily._();

final class PlaylistByIdProvider extends $FunctionalProvider<AsyncValue<Playlist>, Playlist, FutureOr<Playlist>>
    with $FutureModifier<Playlist>, $FutureProvider<Playlist> {
  PlaylistByIdProvider._({required PlaylistByIdFamily super.from, required (String, String) super.argument})
    : super(
        retry: null,
        name: r'playlistByIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playlistByIdHash();

  @override
  String toString() {
    return r'playlistByIdProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Playlist> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Playlist> create(Ref ref) {
    final argument = this.argument as (String, String);
    return playlistById(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaylistByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playlistByIdHash() => r'40e984694d9c50c355b97ed7960700a4ebb7a2da';

final class PlaylistByIdFamily extends $Family with $FunctionalFamilyOverride<FutureOr<Playlist>, (String, String)> {
  PlaylistByIdFamily._()
    : super(
        retry: null,
        name: r'playlistByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PlaylistByIdProvider call(String libraryId, String id) =>
      PlaylistByIdProvider._(argument: (libraryId, id), from: this);

  @override
  String toString() => r'playlistByIdProvider';
}
