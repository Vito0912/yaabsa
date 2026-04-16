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

String _$personalizedLibraryNotifierHash() => r'2da59666810275c78aa411d8fda3658214053aa8';

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
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PersonalizedLibrary?>, PersonalizedLibrary?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PersonalizedLibrary?>, PersonalizedLibrary?>,
              AsyncValue<PersonalizedLibrary?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
