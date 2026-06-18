// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userLibrariesOrder)
final userLibrariesOrderProvider = UserLibrariesOrderFamily._();

final class UserLibrariesOrderProvider extends $FunctionalProvider<AsyncValue<String?>, String?, Stream<String?>>
    with $FutureModifier<String?>, $StreamProvider<String?> {
  UserLibrariesOrderProvider._({required UserLibrariesOrderFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'userLibrariesOrderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userLibrariesOrderHash();

  @override
  String toString() {
    return r'userLibrariesOrderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<String?> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<String?> create(Ref ref) {
    final argument = this.argument as String;
    return userLibrariesOrder(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserLibrariesOrderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userLibrariesOrderHash() => r'ba6006cf2f08cb7368348291e1e78ad0d0316848';

final class UserLibrariesOrderFamily extends $Family with $FunctionalFamilyOverride<Stream<String?>, String> {
  UserLibrariesOrderFamily._()
    : super(
        retry: null,
        name: r'userLibrariesOrderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserLibrariesOrderProvider call(String userId) => UserLibrariesOrderProvider._(argument: userId, from: this);

  @override
  String toString() => r'userLibrariesOrderProvider';
}

/// Provider to fetch all libraries for the current user.

@ProviderFor(userLibraries)
final userLibrariesProvider = UserLibrariesProvider._();

/// Provider to fetch all libraries for the current user.

final class UserLibrariesProvider
    extends $FunctionalProvider<AsyncValue<List<Library>>, List<Library>, FutureOr<List<Library>>>
    with $FutureModifier<List<Library>>, $FutureProvider<List<Library>> {
  /// Provider to fetch all libraries for the current user.
  UserLibrariesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userLibrariesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userLibrariesHash();

  @$internal
  @override
  $FutureProviderElement<List<Library>> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Library>> create(Ref ref) {
    return userLibraries(ref);
  }
}

String _$userLibrariesHash() => r'e5aa67333a7f2e71126fb40bd7308963ae3482a7';

@ProviderFor(SelectedLibraryId)
final selectedLibraryIdProvider = SelectedLibraryIdProvider._();

final class SelectedLibraryIdProvider extends $StreamNotifierProvider<SelectedLibraryId, String?> {
  SelectedLibraryIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedLibraryIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedLibraryIdHash();

  @$internal
  @override
  SelectedLibraryId create() => SelectedLibraryId();
}

String _$selectedLibraryIdHash() => r'e31a05c13e49ac4370a1abe7a5426a9ece3caff0';

abstract class _$SelectedLibraryId extends $StreamNotifier<String?> {
  Stream<String?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String?>, String?>;
    final element =
        ref.element
            as $ClassProviderElement<AnyNotifier<AsyncValue<String?>, String?>, AsyncValue<String?>, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(selectedLibrary)
final selectedLibraryProvider = SelectedLibraryProvider._();

final class SelectedLibraryProvider extends $FunctionalProvider<Library?, Library?, Library?> with $Provider<Library?> {
  SelectedLibraryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedLibraryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedLibraryHash();

  @$internal
  @override
  $ProviderElement<Library?> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Library? create(Ref ref) {
    return selectedLibrary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Library? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Library?>(value));
  }
}

String _$selectedLibraryHash() => r'ee13e6737c00aa1fbf010c3bdfec7f19eb00a116';
