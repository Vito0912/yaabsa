// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_item_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$libraryItemNotifierHash() =>
    r'b485491efb1c970b5ae6900411528a9daaf39649';

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

abstract class _$LibraryItemNotifier
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

/// See also [LibraryItemNotifier].
@ProviderFor(LibraryItemNotifier)
const libraryItemNotifierProvider = LibraryItemNotifierFamily();

/// See also [LibraryItemNotifier].
class LibraryItemNotifierFamily extends Family<AsyncValue<LibraryItemState>> {
  /// See also [LibraryItemNotifier].
  const LibraryItemNotifierFamily();

  /// See also [LibraryItemNotifier].
  LibraryItemNotifierProvider call(
    String libraryId, {
    String? initialSort,
    int? initialDesc,
    String? initialFilter,
    int? initialCollapseSeries,
    String? initialInclude,
  }) {
    return LibraryItemNotifierProvider(
      libraryId,
      initialSort: initialSort,
      initialDesc: initialDesc,
      initialFilter: initialFilter,
      initialCollapseSeries: initialCollapseSeries,
      initialInclude: initialInclude,
    );
  }

  @override
  LibraryItemNotifierProvider getProviderOverride(
    covariant LibraryItemNotifierProvider provider,
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
  String? get name => r'libraryItemNotifierProvider';
}

/// See also [LibraryItemNotifier].
class LibraryItemNotifierProvider
    extends AsyncNotifierProviderImpl<LibraryItemNotifier, LibraryItemState> {
  /// See also [LibraryItemNotifier].
  LibraryItemNotifierProvider(
    String libraryId, {
    String? initialSort,
    int? initialDesc,
    String? initialFilter,
    int? initialCollapseSeries,
    String? initialInclude,
  }) : this._internal(
         () =>
             LibraryItemNotifier()
               ..libraryId = libraryId
               ..initialSort = initialSort
               ..initialDesc = initialDesc
               ..initialFilter = initialFilter
               ..initialCollapseSeries = initialCollapseSeries
               ..initialInclude = initialInclude,
         from: libraryItemNotifierProvider,
         name: r'libraryItemNotifierProvider',
         debugGetCreateSourceHash:
             const bool.fromEnvironment('dart.vm.product')
                 ? null
                 : _$libraryItemNotifierHash,
         dependencies: LibraryItemNotifierFamily._dependencies,
         allTransitiveDependencies:
             LibraryItemNotifierFamily._allTransitiveDependencies,
         libraryId: libraryId,
         initialSort: initialSort,
         initialDesc: initialDesc,
         initialFilter: initialFilter,
         initialCollapseSeries: initialCollapseSeries,
         initialInclude: initialInclude,
       );

  LibraryItemNotifierProvider._internal(
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
    covariant LibraryItemNotifier notifier,
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
  Override overrideWith(LibraryItemNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: LibraryItemNotifierProvider._internal(
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
  AsyncNotifierProviderElement<LibraryItemNotifier, LibraryItemState>
  createElement() {
    return _LibraryItemNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryItemNotifierProvider &&
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
mixin LibraryItemNotifierRef on AsyncNotifierProviderRef<LibraryItemState> {
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

class _LibraryItemNotifierProviderElement
    extends AsyncNotifierProviderElement<LibraryItemNotifier, LibraryItemState>
    with LibraryItemNotifierRef {
  _LibraryItemNotifierProviderElement(super.provider);

  @override
  String get libraryId => (origin as LibraryItemNotifierProvider).libraryId;
  @override
  String? get initialSort =>
      (origin as LibraryItemNotifierProvider).initialSort;
  @override
  int? get initialDesc => (origin as LibraryItemNotifierProvider).initialDesc;
  @override
  String? get initialFilter =>
      (origin as LibraryItemNotifierProvider).initialFilter;
  @override
  int? get initialCollapseSeries =>
      (origin as LibraryItemNotifierProvider).initialCollapseSeries;
  @override
  String? get initialInclude =>
      (origin as LibraryItemNotifierProvider).initialInclude;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
