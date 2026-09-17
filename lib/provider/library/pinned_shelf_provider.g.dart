// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pinned_shelf_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PinnedShelfController)
final pinnedShelfControllerProvider = PinnedShelfControllerProvider._();

final class PinnedShelfControllerProvider
    extends $NotifierProvider<PinnedShelfController, Map<String, List<PinnedShelfEntry>>> {
  PinnedShelfControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinnedShelfControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinnedShelfControllerHash();

  @$internal
  @override
  PinnedShelfController create() => PinnedShelfController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, List<PinnedShelfEntry>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, List<PinnedShelfEntry>>>(value),
    );
  }
}

String _$pinnedShelfControllerHash() => r'bd85df5b135372defaf87d9c105911783f335951';

abstract class _$PinnedShelfController extends $Notifier<Map<String, List<PinnedShelfEntry>>> {
  Map<String, List<PinnedShelfEntry>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Map<String, List<PinnedShelfEntry>>, Map<String, List<PinnedShelfEntry>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, List<PinnedShelfEntry>>, Map<String, List<PinnedShelfEntry>>>,
              Map<String, List<PinnedShelfEntry>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(pinnedShelfContains)
final pinnedShelfContainsProvider = PinnedShelfContainsFamily._();

final class PinnedShelfContainsProvider extends $FunctionalProvider<bool, bool, bool> with $Provider<bool> {
  PinnedShelfContainsProvider._({
    required PinnedShelfContainsFamily super.from,
    required ({String libraryId, String itemId, String? episodeId}) super.argument,
  }) : super(
         retry: null,
         name: r'pinnedShelfContainsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pinnedShelfContainsHash();

  @override
  String toString() {
    return r'pinnedShelfContainsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as ({String libraryId, String itemId, String? episodeId});
    return pinnedShelfContains(
      ref,
      libraryId: argument.libraryId,
      itemId: argument.itemId,
      episodeId: argument.episodeId,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<bool>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is PinnedShelfContainsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pinnedShelfContainsHash() => r'c45abf8aa75f7794f7058545df7171892d32527b';

final class PinnedShelfContainsFamily extends $Family
    with $FunctionalFamilyOverride<bool, ({String libraryId, String itemId, String? episodeId})> {
  PinnedShelfContainsFamily._()
    : super(
        retry: null,
        name: r'pinnedShelfContainsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PinnedShelfContainsProvider call({required String libraryId, required String itemId, String? episodeId}) =>
      PinnedShelfContainsProvider._(argument: (libraryId: libraryId, itemId: itemId, episodeId: episodeId), from: this);

  @override
  String toString() => r'pinnedShelfContainsProvider';
}

@ProviderFor(pinnedShelfItems)
final pinnedShelfItemsProvider = PinnedShelfItemsFamily._();

final class PinnedShelfItemsProvider
    extends $FunctionalProvider<AsyncValue<List<LibraryItem>>, List<LibraryItem>, FutureOr<List<LibraryItem>>>
    with $FutureModifier<List<LibraryItem>>, $FutureProvider<List<LibraryItem>> {
  PinnedShelfItemsProvider._({required PinnedShelfItemsFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'pinnedShelfItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinnedShelfItemsHash();

  @override
  String toString() {
    return r'pinnedShelfItemsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<LibraryItem>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LibraryItem>> create(Ref ref) {
    final argument = this.argument as String;
    return pinnedShelfItems(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PinnedShelfItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pinnedShelfItemsHash() => r'0d9178db7f80aca7d255fd2a26b486dc9c9b7dc4';

final class PinnedShelfItemsFamily extends $Family with $FunctionalFamilyOverride<FutureOr<List<LibraryItem>>, String> {
  PinnedShelfItemsFamily._()
    : super(
        retry: null,
        name: r'pinnedShelfItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PinnedShelfItemsProvider call(String libraryId) => PinnedShelfItemsProvider._(argument: libraryId, from: this);

  @override
  String toString() => r'pinnedShelfItemsProvider';
}
