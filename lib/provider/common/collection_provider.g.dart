// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CollectionsNotifier)
final collectionsProvider = CollectionsNotifierFamily._();

final class CollectionsNotifierProvider extends $AsyncNotifierProvider<CollectionsNotifier, CollectionsState> {
  CollectionsNotifierProvider._({required CollectionsNotifierFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'collectionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionsNotifierHash();

  @override
  String toString() {
    return r'collectionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CollectionsNotifier create() => CollectionsNotifier();

  @override
  bool operator ==(Object other) {
    return other is CollectionsNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$collectionsNotifierHash() => r'1e810369c5bd9e4e3cda7495229d4ddbfea9100a';

final class CollectionsNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          CollectionsNotifier,
          AsyncValue<CollectionsState>,
          CollectionsState,
          FutureOr<CollectionsState>,
          String
        > {
  CollectionsNotifierFamily._()
    : super(
        retry: null,
        name: r'collectionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  CollectionsNotifierProvider call(String libraryId) => CollectionsNotifierProvider._(argument: libraryId, from: this);

  @override
  String toString() => r'collectionsProvider';
}

abstract class _$CollectionsNotifier extends $AsyncNotifier<CollectionsState> {
  late final _$args = ref.$arg as String;
  String get libraryId => _$args;

  FutureOr<CollectionsState> build(String libraryId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<CollectionsState>, CollectionsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CollectionsState>, CollectionsState>,
              AsyncValue<CollectionsState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
