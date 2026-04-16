// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_item_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LibraryItemsNotifier)
final libraryItemsProvider = LibraryItemsNotifierFamily._();

final class LibraryItemsNotifierProvider extends $AsyncNotifierProvider<LibraryItemsNotifier, LibraryItemState> {
  LibraryItemsNotifierProvider._({
    required LibraryItemsNotifierFamily super.from,
    required (
      String, {
      String? initialSort,
      int? initialDesc,
      String? initialFilter,
      int? initialCollapseSeries,
      String? initialInclude,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'libraryItemsProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryItemsNotifierHash();

  @override
  String toString() {
    return r'libraryItemsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LibraryItemsNotifier create() => LibraryItemsNotifier();

  @override
  bool operator ==(Object other) {
    return other is LibraryItemsNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryItemsNotifierHash() => r'e2c7a3c6dae8336ea19a700b4f9d5d8b8677649c';

final class LibraryItemsNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          LibraryItemsNotifier,
          AsyncValue<LibraryItemState>,
          LibraryItemState,
          FutureOr<LibraryItemState>,
          (
            String, {
            String? initialSort,
            int? initialDesc,
            String? initialFilter,
            int? initialCollapseSeries,
            String? initialInclude,
          })
        > {
  LibraryItemsNotifierFamily._()
    : super(
        retry: null,
        name: r'libraryItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  LibraryItemsNotifierProvider call(
    String libraryId, {
    String? initialSort,
    int? initialDesc,
    String? initialFilter,
    int? initialCollapseSeries,
    String? initialInclude,
  }) => LibraryItemsNotifierProvider._(
    argument: (
      libraryId,
      initialSort: initialSort,
      initialDesc: initialDesc,
      initialFilter: initialFilter,
      initialCollapseSeries: initialCollapseSeries,
      initialInclude: initialInclude,
    ),
    from: this,
  );

  @override
  String toString() => r'libraryItemsProvider';
}

abstract class _$LibraryItemsNotifier extends $AsyncNotifier<LibraryItemState> {
  late final _$args =
      ref.$arg
          as (
            String, {
            String? initialSort,
            int? initialDesc,
            String? initialFilter,
            int? initialCollapseSeries,
            String? initialInclude,
          });
  String get libraryId => _$args.$1;
  String? get initialSort => _$args.initialSort;
  int? get initialDesc => _$args.initialDesc;
  String? get initialFilter => _$args.initialFilter;
  int? get initialCollapseSeries => _$args.initialCollapseSeries;
  String? get initialInclude => _$args.initialInclude;

  FutureOr<LibraryItemState> build(
    String libraryId, {
    String? initialSort,
    int? initialDesc,
    String? initialFilter,
    int? initialCollapseSeries,
    String? initialInclude,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LibraryItemState>, LibraryItemState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LibraryItemState>, LibraryItemState>,
              AsyncValue<LibraryItemState>,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(
        _$args.$1,
        initialSort: _$args.initialSort,
        initialDesc: _$args.initialDesc,
        initialFilter: _$args.initialFilter,
        initialCollapseSeries: _$args.initialCollapseSeries,
        initialInclude: _$args.initialInclude,
      ),
    );
  }
}

@ProviderFor(libraryItem)
final libraryItemProvider = LibraryItemFamily._();

final class LibraryItemProvider extends $FunctionalProvider<AsyncValue<LibraryItem>, LibraryItem, FutureOr<LibraryItem>>
    with $FutureModifier<LibraryItem>, $FutureProvider<LibraryItem> {
  LibraryItemProvider._({required LibraryItemFamily super.from, required (String, {String? episodeId}) super.argument})
    : super(
        retry: null,
        name: r'libraryItemProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryItemHash();

  @override
  String toString() {
    return r'libraryItemProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<LibraryItem> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<LibraryItem> create(Ref ref) {
    final argument = this.argument as (String, {String? episodeId});
    return libraryItem(ref, argument.$1, episodeId: argument.episodeId);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryItemProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryItemHash() => r'0fdbded8f4f1a28c117ca21ba753d5a16b667037';

final class LibraryItemFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<LibraryItem>, (String, {String? episodeId})> {
  LibraryItemFamily._()
    : super(
        retry: null,
        name: r'libraryItemProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibraryItemProvider call(String itemId, {String? episodeId}) =>
      LibraryItemProvider._(argument: (itemId, episodeId: episodeId), from: this);

  @override
  String toString() => r'libraryItemProvider';
}
