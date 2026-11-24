// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wear_browse_feed_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WearBrowseFeed)
final wearBrowseFeedProvider = WearBrowseFeedFamily._();

final class WearBrowseFeedProvider extends $AsyncNotifierProvider<WearBrowseFeed, WearBrowseFeedState> {
  WearBrowseFeedProvider._({required WearBrowseFeedFamily super.from, required CompactBrowseQuery super.argument})
    : super(
        retry: null,
        name: r'wearBrowseFeedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wearBrowseFeedHash();

  @override
  String toString() {
    return r'wearBrowseFeedProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  WearBrowseFeed create() => WearBrowseFeed();

  @override
  bool operator ==(Object other) {
    return other is WearBrowseFeedProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$wearBrowseFeedHash() => r'8a0875b22f0ec8af7b73504c9db0c090221631bb';

final class WearBrowseFeedFamily extends $Family
    with
        $ClassFamilyOverride<
          WearBrowseFeed,
          AsyncValue<WearBrowseFeedState>,
          WearBrowseFeedState,
          FutureOr<WearBrowseFeedState>,
          CompactBrowseQuery
        > {
  WearBrowseFeedFamily._()
    : super(
        retry: null,
        name: r'wearBrowseFeedProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WearBrowseFeedProvider call(CompactBrowseQuery query) => WearBrowseFeedProvider._(argument: query, from: this);

  @override
  String toString() => r'wearBrowseFeedProvider';
}

abstract class _$WearBrowseFeed extends $AsyncNotifier<WearBrowseFeedState> {
  late final _$args = ref.$arg as CompactBrowseQuery;
  CompactBrowseQuery get query => _$args;

  FutureOr<WearBrowseFeedState> build(CompactBrowseQuery query);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<WearBrowseFeedState>, WearBrowseFeedState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<WearBrowseFeedState>, WearBrowseFeedState>,
              AsyncValue<WearBrowseFeedState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
