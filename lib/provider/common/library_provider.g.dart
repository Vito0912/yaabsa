// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userLibrariesHash() => r'18a6a0093685762a25a721c143e321b44826ff0a';

/// Provider to fetch all libraries for the current user.
///
/// Copied from [userLibraries].
@ProviderFor(userLibraries)
final userLibrariesProvider = AutoDisposeFutureProvider<List<Library>>.internal(
  userLibraries,
  name: r'userLibrariesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userLibrariesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserLibrariesRef = AutoDisposeFutureProviderRef<List<Library>>;
String _$selectedLibraryHash() => r'8f7ff23c279c75a73098b0f33942708b9012d373';

/// See also [selectedLibrary].
@ProviderFor(selectedLibrary)
final selectedLibraryProvider = Provider<Library?>.internal(
  selectedLibrary,
  name: r'selectedLibraryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedLibraryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedLibraryRef = ProviderRef<Library?>;
String _$selectedLibraryIdHash() => r'd763c3af83b5ead4197f5155550fe59763ccc881';

/// See also [SelectedLibraryId].
@ProviderFor(SelectedLibraryId)
final selectedLibraryIdProvider =
    AutoDisposeStreamNotifierProvider<SelectedLibraryId, String?>.internal(
      SelectedLibraryId.new,
      name: r'selectedLibraryIdProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedLibraryIdHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedLibraryId = AutoDisposeStreamNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
