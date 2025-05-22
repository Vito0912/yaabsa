// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personalized_library_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$personalizedLibraryNotifierHash() =>
    r'2da59666810275c78aa411d8fda3658214053aa8';

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

abstract class _$PersonalizedLibraryNotifier
    extends BuildlessAsyncNotifier<PersonalizedLibrary?> {
  late final String libraryId;

  FutureOr<PersonalizedLibrary?> build(String libraryId);
}

/// See also [PersonalizedLibraryNotifier].
@ProviderFor(PersonalizedLibraryNotifier)
const personalizedLibraryNotifierProvider = PersonalizedLibraryNotifierFamily();

/// See also [PersonalizedLibraryNotifier].
class PersonalizedLibraryNotifierFamily
    extends Family<AsyncValue<PersonalizedLibrary?>> {
  /// See also [PersonalizedLibraryNotifier].
  const PersonalizedLibraryNotifierFamily();

  /// See also [PersonalizedLibraryNotifier].
  PersonalizedLibraryNotifierProvider call(String libraryId) {
    return PersonalizedLibraryNotifierProvider(libraryId);
  }

  @override
  PersonalizedLibraryNotifierProvider getProviderOverride(
    covariant PersonalizedLibraryNotifierProvider provider,
  ) {
    return call(provider.libraryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'personalizedLibraryNotifierProvider';
}

/// See also [PersonalizedLibraryNotifier].
class PersonalizedLibraryNotifierProvider
    extends
        AsyncNotifierProviderImpl<
          PersonalizedLibraryNotifier,
          PersonalizedLibrary?
        > {
  /// See also [PersonalizedLibraryNotifier].
  PersonalizedLibraryNotifierProvider(String libraryId)
    : this._internal(
        () => PersonalizedLibraryNotifier()..libraryId = libraryId,
        from: personalizedLibraryNotifierProvider,
        name: r'personalizedLibraryNotifierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$personalizedLibraryNotifierHash,
        dependencies: PersonalizedLibraryNotifierFamily._dependencies,
        allTransitiveDependencies:
            PersonalizedLibraryNotifierFamily._allTransitiveDependencies,
        libraryId: libraryId,
      );

  PersonalizedLibraryNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.libraryId,
  }) : super.internal();

  final String libraryId;

  @override
  FutureOr<PersonalizedLibrary?> runNotifierBuild(
    covariant PersonalizedLibraryNotifier notifier,
  ) {
    return notifier.build(libraryId);
  }

  @override
  Override overrideWith(PersonalizedLibraryNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: PersonalizedLibraryNotifierProvider._internal(
        () => create()..libraryId = libraryId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        libraryId: libraryId,
      ),
    );
  }

  @override
  AsyncNotifierProviderElement<
    PersonalizedLibraryNotifier,
    PersonalizedLibrary?
  >
  createElement() {
    return _PersonalizedLibraryNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PersonalizedLibraryNotifierProvider &&
        other.libraryId == libraryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, libraryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PersonalizedLibraryNotifierRef
    on AsyncNotifierProviderRef<PersonalizedLibrary?> {
  /// The parameter `libraryId` of this provider.
  String get libraryId;
}

class _PersonalizedLibraryNotifierProviderElement
    extends
        AsyncNotifierProviderElement<
          PersonalizedLibraryNotifier,
          PersonalizedLibrary?
        >
    with PersonalizedLibraryNotifierRef {
  _PersonalizedLibraryNotifierProviderElement(super.provider);

  @override
  String get libraryId =>
      (origin as PersonalizedLibraryNotifierProvider).libraryId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
