// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_lookup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(collectionMembershipEditingAllowed)
final collectionMembershipEditingAllowedProvider = CollectionMembershipEditingAllowedProvider._();

final class CollectionMembershipEditingAllowedProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  CollectionMembershipEditingAllowedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collectionMembershipEditingAllowedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionMembershipEditingAllowedHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return collectionMembershipEditingAllowed(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<bool>(value));
  }
}

String _$collectionMembershipEditingAllowedHash() => r'91e577af02083701826c5d45e27e4509c3a94bc2';

@ProviderFor(bookCollectionMemberships)
final bookCollectionMembershipsProvider = BookCollectionMembershipsFamily._();

final class BookCollectionMembershipsProvider
    extends
        $FunctionalProvider<
          AsyncValue<BookCollectionMemberships>,
          AsyncValue<BookCollectionMemberships>,
          AsyncValue<BookCollectionMemberships>
        >
    with $Provider<AsyncValue<BookCollectionMemberships>> {
  BookCollectionMembershipsProvider._({
    required BookCollectionMembershipsFamily super.from,
    required ({String bookId, String libraryId}) super.argument,
  }) : super(
         retry: null,
         name: r'bookCollectionMembershipsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookCollectionMembershipsHash();

  @override
  String toString() {
    return r'bookCollectionMembershipsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<BookCollectionMemberships>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AsyncValue<BookCollectionMemberships> create(Ref ref) {
    final argument = this.argument as ({String bookId, String libraryId});
    return bookCollectionMemberships(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<BookCollectionMemberships> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<BookCollectionMemberships>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BookCollectionMembershipsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookCollectionMembershipsHash() => r'1342c52fc1e61c7d268dc56e24f4e5ea7787e81b';

final class BookCollectionMembershipsFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<BookCollectionMemberships>, ({String bookId, String libraryId})> {
  BookCollectionMembershipsFamily._()
    : super(
        retry: null,
        name: r'bookCollectionMembershipsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BookCollectionMembershipsProvider call(({String bookId, String libraryId}) key) =>
      BookCollectionMembershipsProvider._(argument: key, from: this);

  @override
  String toString() => r'bookCollectionMembershipsProvider';
}

@ProviderFor(collectionById)
final collectionByIdProvider = CollectionByIdFamily._();

final class CollectionByIdProvider extends $FunctionalProvider<AsyncValue<Collection>, Collection, FutureOr<Collection>>
    with $FutureModifier<Collection>, $FutureProvider<Collection> {
  CollectionByIdProvider._({required CollectionByIdFamily super.from, required (String, String) super.argument})
    : super(
        retry: null,
        name: r'collectionByIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collectionByIdHash();

  @override
  String toString() {
    return r'collectionByIdProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Collection> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Collection> create(Ref ref) {
    final argument = this.argument as (String, String);
    return collectionById(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is CollectionByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$collectionByIdHash() => r'1ca0d3bc0030c39568a94ccc23dc610ffe1da160';

final class CollectionByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Collection>, (String, String)> {
  CollectionByIdFamily._()
    : super(
        retry: null,
        name: r'collectionByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CollectionByIdProvider call(String libraryId, String id) =>
      CollectionByIdProvider._(argument: (libraryId, id), from: this);

  @override
  String toString() => r'collectionByIdProvider';
}
