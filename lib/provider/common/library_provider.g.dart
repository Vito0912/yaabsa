// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider to fetch all libraries for the current user.

@ProviderFor(userLibraries)
final userLibrariesProvider = UserLibrariesProvider._();

/// Provider to fetch all libraries for the current user.

final class UserLibrariesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Library>>,
          List<Library>,
          FutureOr<List<Library>>
        >
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
  $FutureProviderElement<List<Library>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Library>> create(Ref ref) {
    return userLibraries(ref);
  }
}

String _$userLibrariesHash() => r'18a6a0093685762a25a721c143e321b44826ff0a';

@ProviderFor(SelectedLibraryId)
final selectedLibraryIdProvider = SelectedLibraryIdProvider._();

final class SelectedLibraryIdProvider
    extends $StreamNotifierProvider<SelectedLibraryId, String?> {
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

String _$selectedLibraryIdHash() => r'd763c3af83b5ead4197f5155550fe59763ccc881';

abstract class _$SelectedLibraryId extends $StreamNotifier<String?> {
  Stream<String?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String?>, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, String?>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(selectedLibrary)
final selectedLibraryProvider = SelectedLibraryProvider._();

final class SelectedLibraryProvider
    extends $FunctionalProvider<Library?, Library?, Library?>
    with $Provider<Library?> {
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
  $ProviderElement<Library?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Library? create(Ref ref) {
    return selectedLibrary(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Library? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Library?>(value),
    );
  }
}

String _$selectedLibraryHash() => r'8f7ff23c279c75a73098b0f33942708b9012d373';
