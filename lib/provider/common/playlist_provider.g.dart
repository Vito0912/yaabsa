// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlaylistsNotifier)
final playlistsProvider = PlaylistsNotifierFamily._();

final class PlaylistsNotifierProvider extends $AsyncNotifierProvider<PlaylistsNotifier, PlaylistsState> {
  PlaylistsNotifierProvider._({required PlaylistsNotifierFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'playlistsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playlistsNotifierHash();

  @override
  String toString() {
    return r'playlistsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PlaylistsNotifier create() => PlaylistsNotifier();

  @override
  bool operator ==(Object other) {
    return other is PlaylistsNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playlistsNotifierHash() => r'9d1d934f108c87cd30d26d95f2d3dde15be36f77';

final class PlaylistsNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          PlaylistsNotifier,
          AsyncValue<PlaylistsState>,
          PlaylistsState,
          FutureOr<PlaylistsState>,
          String
        > {
  PlaylistsNotifierFamily._()
    : super(
        retry: null,
        name: r'playlistsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  PlaylistsNotifierProvider call(String libraryId) => PlaylistsNotifierProvider._(argument: libraryId, from: this);

  @override
  String toString() => r'playlistsProvider';
}

abstract class _$PlaylistsNotifier extends $AsyncNotifier<PlaylistsState> {
  late final _$args = ref.$arg as String;
  String get libraryId => _$args;

  FutureOr<PlaylistsState> build(String libraryId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PlaylistsState>, PlaylistsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PlaylistsState>, PlaylistsState>,
              AsyncValue<PlaylistsState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
