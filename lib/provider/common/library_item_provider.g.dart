// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_item_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$libraryItemHash() => r'41fae2c883a21307e0a30f172bdf41650bfe697a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [libraryItem].
@ProviderFor(libraryItem)
const libraryItemProvider = LibraryItemFamily();

/// See also [libraryItem].
class LibraryItemFamily extends Family<AsyncValue<LibraryItem>> {
  /// See also [libraryItem].
  const LibraryItemFamily();

  /// See also [libraryItem].
  LibraryItemProvider call(String itemId) {
    return LibraryItemProvider(itemId);
  }

  @override
  LibraryItemProvider getProviderOverride(
    covariant LibraryItemProvider provider,
  ) {
    return call(provider.itemId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'libraryItemProvider';
}

/// See also [libraryItem].
class LibraryItemProvider extends AutoDisposeFutureProvider<LibraryItem> {
  /// See also [libraryItem].
  LibraryItemProvider(String itemId)
    : this._internal(
        (ref) => libraryItem(ref as LibraryItemRef, itemId),
        from: libraryItemProvider,
        name: r'libraryItemProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$libraryItemHash,
        dependencies: LibraryItemFamily._dependencies,
        allTransitiveDependencies: LibraryItemFamily._allTransitiveDependencies,
        itemId: itemId,
      );

  LibraryItemProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.itemId,
  }) : super.internal();

  final String itemId;

  @override
  Override overrideWith(
    FutureOr<LibraryItem> Function(LibraryItemRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LibraryItemProvider._internal(
        (ref) => create(ref as LibraryItemRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        itemId: itemId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<LibraryItem> createElement() {
    return _LibraryItemProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryItemProvider && other.itemId == itemId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, itemId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LibraryItemRef on AutoDisposeFutureProviderRef<LibraryItem> {
  /// The parameter `itemId` of this provider.
  String get itemId;
}

class _LibraryItemProviderElement
    extends AutoDisposeFutureProviderElement<LibraryItem>
    with LibraryItemRef {
  _LibraryItemProviderElement(super.provider);

  @override
  String get itemId => (origin as LibraryItemProvider).itemId;
}

String _$libraryItemsNotifierHash() =>
    r'9a0febe3b7c43c209408c7cbf80210cfc6f25be8';

abstract class _$LibraryItemsNotifier
    extends BuildlessAsyncNotifier<LibraryItemState> {
  late final String libraryId;
  late final String? initialSort;
  late final int? initialDesc;
  late final String? initialFilter;
  late final int? initialCollapseSeries;
  late final String? initialInclude;

  FutureOr<LibraryItemState> build(
    String libraryId, {
    String? initialSort,
    int? initialDesc,
    String? initialFilter,
    int? initialCollapseSeries,
    String? initialInclude,
  });
}

/// See also [LibraryItemsNotifier].
@ProviderFor(LibraryItemsNotifier)
const libraryItemsNotifierProvider = LibraryItemsNotifierFamily();

/// See also [LibraryItemsNotifier].
class LibraryItemsNotifierFamily extends Family<AsyncValue<LibraryItemState>> {
  /// See also [LibraryItemsNotifier].
  const LibraryItemsNotifierFamily();

  /// See also [LibraryItemsNotifier].
  LibraryItemsNotifierProvider call(
    String libraryId, {
    String? initialSort,
    int? initialDesc,
    String? initialFilter,
    int? initialCollapseSeries,
    String? initialInclude,
  }) {
    return LibraryItemsNotifierProvider(
      libraryId,
      initialSort: initialSort,
      initialDesc: initialDesc,
      initialFilter: initialFilter,
      initialCollapseSeries: initialCollapseSeries,
      initialInclude: initialInclude,
    );
  }

  @override
  LibraryItemsNotifierProvider getProviderOverride(
    covariant LibraryItemsNotifierProvider provider,
  ) {
    return call(
      provider.libraryId,
      initialSort: provider.initialSort,
      initialDesc: provider.initialDesc,
      initialFilter: provider.initialFilter,
      initialCollapseSeries: provider.initialCollapseSeries,
      initialInclude: provider.initialInclude,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'libraryItemsNotifierProvider';
}

/// See also [LibraryItemsNotifier].
class LibraryItemsNotifierProvider
    extends AsyncNotifierProviderImpl<LibraryItemsNotifier, LibraryItemState> {
  /// See also [LibraryItemsNotifier].
  LibraryItemsNotifierProvider(
    String libraryId, {
    String? initialSort,
    int? initialDesc,
    String? initialFilter,
    int? initialCollapseSeries,
    String? initialInclude,
  }) : this._internal(
         () =>
             LibraryItemsNotifier()
               ..libraryId = libraryId
               ..initialSort = initialSort
               ..initialDesc = initialDesc
               ..initialFilter = initialFilter
               ..initialCollapseSeries = initialCollapseSeries
               ..initialInclude = initialInclude,
         from: libraryItemsNotifierProvider,
         name: r'libraryItemsNotifierProvider',
         debugGetCreateSourceHash:
             const bool.fromEnvironment('dart.vm.product')
                 ? null
                 : _$libraryItemsNotifierHash,
         dependencies: LibraryItemsNotifierFamily._dependencies,
         allTransitiveDependencies:
             LibraryItemsNotifierFamily._allTransitiveDependencies,
         libraryId: libraryId,
         initialSort: initialSort,
         initialDesc: initialDesc,
         initialFilter: initialFilter,
         initialCollapseSeries: initialCollapseSeries,
         initialInclude: initialInclude,
       );

  LibraryItemsNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.libraryId,
    required this.initialSort,
    required this.initialDesc,
    required this.initialFilter,
    required this.initialCollapseSeries,
    required this.initialInclude,
  }) : super.internal();

  final String libraryId;
  final String? initialSort;
  final int? initialDesc;
  final String? initialFilter;
  final int? initialCollapseSeries;
  final String? initialInclude;

  @override
  FutureOr<LibraryItemState> runNotifierBuild(
    covariant LibraryItemsNotifier notifier,
  ) {
    return notifier.build(
      libraryId,
      initialSort: initialSort,
      initialDesc: initialDesc,
      initialFilter: initialFilter,
      initialCollapseSeries: initialCollapseSeries,
      initialInclude: initialInclude,
    );
  }

  @override
  Override overrideWith(LibraryItemsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: LibraryItemsNotifierProvider._internal(
        () =>
            create()
              ..libraryId = libraryId
              ..initialSort = initialSort
              ..initialDesc = initialDesc
              ..initialFilter = initialFilter
              ..initialCollapseSeries = initialCollapseSeries
              ..initialInclude = initialInclude,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        libraryId: libraryId,
        initialSort: initialSort,
        initialDesc: initialDesc,
        initialFilter: initialFilter,
        initialCollapseSeries: initialCollapseSeries,
        initialInclude: initialInclude,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<LibraryItemsNotifier, LibraryItemState>
  createElement() {
    return _LibraryItemsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryItemsNotifierProvider &&
        other.libraryId == libraryId &&
        other.initialSort == initialSort &&
        other.initialDesc == initialDesc &&
        other.initialFilter == initialFilter &&
        other.initialCollapseSeries == initialCollapseSeries &&
        other.initialInclude == initialInclude;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, libraryId.hashCode);
    hash = _SystemHash.combine(hash, initialSort.hashCode);
    hash = _SystemHash.combine(hash, initialDesc.hashCode);
    hash = _SystemHash.combine(hash, initialFilter.hashCode);
    hash = _SystemHash.combine(hash, initialCollapseSeries.hashCode);
    hash = _SystemHash.combine(hash, initialInclude.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LibraryItemsNotifierRef on AsyncNotifierProviderRef<LibraryItemState> {
  /// The parameter `libraryId` of this provider.
  String get libraryId;

  /// The parameter `initialSort` of this provider.
  String? get initialSort;

  /// The parameter `initialDesc` of this provider.
  int? get initialDesc;

  /// The parameter `initialFilter` of this provider.
  String? get initialFilter;

  /// The parameter `initialCollapseSeries` of this provider.
  int? get initialCollapseSeries;

  /// The parameter `initialInclude` of this provider.
  String? get initialInclude;
}

class _LibraryItemsNotifierProviderElement
    extends AsyncNotifierProviderElement<LibraryItemsNotifier, LibraryItemState>
    with LibraryItemsNotifierRef {
  _LibraryItemsNotifierProviderElement(super.provider);

  @override
  String get libraryId => (origin as LibraryItemsNotifierProvider).libraryId;
  @override
  String? get initialSort =>
      (origin as LibraryItemsNotifierProvider).initialSort;
  @override
  int? get initialDesc => (origin as LibraryItemsNotifierProvider).initialDesc;
  @override
  String? get initialFilter =>
      (origin as LibraryItemsNotifierProvider).initialFilter;
  @override
  int? get initialCollapseSeries =>
      (origin as LibraryItemsNotifierProvider).initialCollapseSeries;
  @override
  String? get initialInclude =>
      (origin as LibraryItemsNotifierProvider).initialInclude;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
