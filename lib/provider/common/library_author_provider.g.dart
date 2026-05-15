// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_author_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LibraryAuthorsNotifier)
final libraryAuthorsProvider = LibraryAuthorsNotifierFamily._();

final class LibraryAuthorsNotifierProvider extends $AsyncNotifierProvider<LibraryAuthorsNotifier, LibraryAuthorsState> {
  LibraryAuthorsNotifierProvider._({
    required LibraryAuthorsNotifierFamily super.from,
    required (String, {String initialSort, int initialDesc, String? initialInclude}) super.argument,
  }) : super(
         retry: null,
         name: r'libraryAuthorsProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryAuthorsNotifierHash();

  @override
  String toString() {
    return r'libraryAuthorsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  LibraryAuthorsNotifier create() => LibraryAuthorsNotifier();

  @override
  bool operator ==(Object other) {
    return other is LibraryAuthorsNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryAuthorsNotifierHash() => r'1602a832163ce414154deabd25d503e6b018f957';

final class LibraryAuthorsNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          LibraryAuthorsNotifier,
          AsyncValue<LibraryAuthorsState>,
          LibraryAuthorsState,
          FutureOr<LibraryAuthorsState>,
          (String, {String initialSort, int initialDesc, String? initialInclude})
        > {
  LibraryAuthorsNotifierFamily._()
    : super(
        retry: null,
        name: r'libraryAuthorsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  LibraryAuthorsNotifierProvider call(
    String libraryId, {
    String initialSort = defaultAuthorSortWireValue,
    int initialDesc = defaultAuthorSortDesc,
    String? initialInclude = defaultLibraryAuthorInclude,
  }) => LibraryAuthorsNotifierProvider._(
    argument: (libraryId, initialSort: initialSort, initialDesc: initialDesc, initialInclude: initialInclude),
    from: this,
  );

  @override
  String toString() => r'libraryAuthorsProvider';
}

abstract class _$LibraryAuthorsNotifier extends $AsyncNotifier<LibraryAuthorsState> {
  late final _$args = ref.$arg as (String, {String initialSort, int initialDesc, String? initialInclude});
  String get libraryId => _$args.$1;
  String get initialSort => _$args.initialSort;
  int get initialDesc => _$args.initialDesc;
  String? get initialInclude => _$args.initialInclude;

  FutureOr<LibraryAuthorsState> build(
    String libraryId, {
    String initialSort = defaultAuthorSortWireValue,
    int initialDesc = defaultAuthorSortDesc,
    String? initialInclude = defaultLibraryAuthorInclude,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<LibraryAuthorsState>, LibraryAuthorsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LibraryAuthorsState>, LibraryAuthorsState>,
              AsyncValue<LibraryAuthorsState>,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(
        _$args.$1,
        initialSort: _$args.initialSort,
        initialDesc: _$args.initialDesc,
        initialInclude: _$args.initialInclude,
      ),
    );
  }
}

@ProviderFor(libraryAuthor)
final libraryAuthorProvider = LibraryAuthorFamily._();

final class LibraryAuthorProvider
    extends $FunctionalProvider<AsyncValue<AuthorDetails>, AuthorDetails, FutureOr<AuthorDetails>>
    with $FutureModifier<AuthorDetails>, $FutureProvider<AuthorDetails> {
  LibraryAuthorProvider._({required LibraryAuthorFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'libraryAuthorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryAuthorHash();

  @override
  String toString() {
    return r'libraryAuthorProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<AuthorDetails> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<AuthorDetails> create(Ref ref) {
    final argument = this.argument as String;
    return libraryAuthor(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryAuthorProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryAuthorHash() => r'7aad07d66e663c93ab354d057f93d18a3efcf7d0';

final class LibraryAuthorFamily extends $Family with $FunctionalFamilyOverride<FutureOr<AuthorDetails>, String> {
  LibraryAuthorFamily._()
    : super(
        retry: null,
        name: r'libraryAuthorProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibraryAuthorProvider call(String authorId) => LibraryAuthorProvider._(argument: authorId, from: this);

  @override
  String toString() => r'libraryAuthorProvider';
}
