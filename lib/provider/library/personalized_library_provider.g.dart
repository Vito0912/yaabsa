// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personalized_library_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PersonalizedLibraryNotifier)
final personalizedLibraryProvider = PersonalizedLibraryNotifierFamily._();

final class PersonalizedLibraryNotifierProvider
    extends $AsyncNotifierProvider<PersonalizedLibraryNotifier, PersonalizedLibrary?> {
  PersonalizedLibraryNotifierProvider._({
    required PersonalizedLibraryNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'personalizedLibraryProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$personalizedLibraryNotifierHash();

  @override
  String toString() {
    return r'personalizedLibraryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PersonalizedLibraryNotifier create() => PersonalizedLibraryNotifier();

  @override
  bool operator ==(Object other) {
    return other is PersonalizedLibraryNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$personalizedLibraryNotifierHash() => r'8e44624c05e513b2a8b845bef70fe4538891d55a';

final class PersonalizedLibraryNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          PersonalizedLibraryNotifier,
          AsyncValue<PersonalizedLibrary?>,
          PersonalizedLibrary?,
          FutureOr<PersonalizedLibrary?>,
          String
        > {
  PersonalizedLibraryNotifierFamily._()
    : super(
        retry: null,
        name: r'personalizedLibraryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  PersonalizedLibraryNotifierProvider call(String libraryId) =>
      PersonalizedLibraryNotifierProvider._(argument: libraryId, from: this);

  @override
  String toString() => r'personalizedLibraryProvider';
}

abstract class _$PersonalizedLibraryNotifier extends $AsyncNotifier<PersonalizedLibrary?> {
  late final _$args = ref.$arg as String;
  String get libraryId => _$args;

  FutureOr<PersonalizedLibrary?> build(String libraryId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PersonalizedLibrary?>, PersonalizedLibrary?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PersonalizedLibrary?>, PersonalizedLibrary?>,
              AsyncValue<PersonalizedLibrary?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(libraryDownloads)
final libraryDownloadsProvider = LibraryDownloadsFamily._();

final class LibraryDownloadsProvider
    extends
        $FunctionalProvider<AsyncValue<List<InternalDownload>>, List<InternalDownload>, Stream<List<InternalDownload>>>
    with $FutureModifier<List<InternalDownload>>, $StreamProvider<List<InternalDownload>> {
  LibraryDownloadsProvider._({required LibraryDownloadsFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'libraryDownloadsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryDownloadsHash();

  @override
  String toString() {
    return r'libraryDownloadsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<InternalDownload>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<InternalDownload>> create(Ref ref) {
    final argument = this.argument as String;
    return libraryDownloads(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryDownloadsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryDownloadsHash() => r'7bb9d49ba377027c582d9803b85d659647a0f9bb';

final class LibraryDownloadsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<InternalDownload>>, String> {
  LibraryDownloadsFamily._()
    : super(
        retry: null,
        name: r'libraryDownloadsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibraryDownloadsProvider call(String libraryId) => LibraryDownloadsProvider._(argument: libraryId, from: this);

  @override
  String toString() => r'libraryDownloadsProvider';
}
