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

String _$libraryAuthorsNotifierHash() => r'96db0e92a0ba5a51c29344d4030fd38b20a1c89a';

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

@ProviderFor(LibraryAuthorDetails)
final libraryAuthorDetailsProvider = LibraryAuthorDetailsFamily._();

final class LibraryAuthorDetailsProvider extends $AsyncNotifierProvider<LibraryAuthorDetails, AuthorDetails> {
  LibraryAuthorDetailsProvider._({required LibraryAuthorDetailsFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'libraryAuthorDetailsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryAuthorDetailsHash();

  @override
  String toString() {
    return r'libraryAuthorDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LibraryAuthorDetails create() => LibraryAuthorDetails();

  @override
  bool operator ==(Object other) {
    return other is LibraryAuthorDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryAuthorDetailsHash() => r'bf99aafcbdee2505091750df3311a24d8d2319a1';

final class LibraryAuthorDetailsFamily extends $Family
    with
        $ClassFamilyOverride<
          LibraryAuthorDetails,
          AsyncValue<AuthorDetails>,
          AuthorDetails,
          FutureOr<AuthorDetails>,
          String
        > {
  LibraryAuthorDetailsFamily._()
    : super(
        retry: null,
        name: r'libraryAuthorDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibraryAuthorDetailsProvider call(String authorId) => LibraryAuthorDetailsProvider._(argument: authorId, from: this);

  @override
  String toString() => r'libraryAuthorDetailsProvider';
}

abstract class _$LibraryAuthorDetails extends $AsyncNotifier<AuthorDetails> {
  late final _$args = ref.$arg as String;
  String get authorId => _$args;

  FutureOr<AuthorDetails> build(String authorId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AuthorDetails>, AuthorDetails>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthorDetails>, AuthorDetails>,
              AsyncValue<AuthorDetails>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
