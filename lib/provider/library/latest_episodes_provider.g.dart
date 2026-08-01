// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latest_episodes_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LatestEpisodes)
final latestEpisodesProvider = LatestEpisodesFamily._();

final class LatestEpisodesProvider extends $AsyncNotifierProvider<LatestEpisodes, LatestEpisodesState> {
  LatestEpisodesProvider._({required LatestEpisodesFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'latestEpisodesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$latestEpisodesHash();

  @override
  String toString() {
    return r'latestEpisodesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LatestEpisodes create() => LatestEpisodes();

  @override
  bool operator ==(Object other) {
    return other is LatestEpisodesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$latestEpisodesHash() => r'69632f8c6d338cd3b4731773d434df6e15514df5';

final class LatestEpisodesFamily extends $Family
    with
        $ClassFamilyOverride<
          LatestEpisodes,
          AsyncValue<LatestEpisodesState>,
          LatestEpisodesState,
          FutureOr<LatestEpisodesState>,
          String
        > {
  LatestEpisodesFamily._()
    : super(
        retry: null,
        name: r'latestEpisodesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LatestEpisodesProvider call(String libraryId) => LatestEpisodesProvider._(argument: libraryId, from: this);

  @override
  String toString() => r'latestEpisodesProvider';
}

abstract class _$LatestEpisodes extends $AsyncNotifier<LatestEpisodesState> {
  late final _$args = ref.$arg as String;
  String get libraryId => _$args;

  FutureOr<LatestEpisodesState> build(String libraryId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LatestEpisodesState>, LatestEpisodesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LatestEpisodesState>, LatestEpisodesState>,
              AsyncValue<LatestEpisodesState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
