// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(librarySearch)
final librarySearchProvider = LibrarySearchFamily._();

final class LibrarySearchProvider
    extends $FunctionalProvider<AsyncValue<SearchLibrary?>, SearchLibrary?, FutureOr<SearchLibrary?>>
    with $FutureModifier<SearchLibrary?>, $FutureProvider<SearchLibrary?> {
  LibrarySearchProvider._({required LibrarySearchFamily super.from, required LibrarySearchProviderArgs super.argument})
    : super(
        retry: null,
        name: r'librarySearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$librarySearchHash();

  @override
  String toString() {
    return r'librarySearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<SearchLibrary?> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<SearchLibrary?> create(Ref ref) {
    final argument = this.argument as LibrarySearchProviderArgs;
    return librarySearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LibrarySearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$librarySearchHash() => r'13045b249e0ce4ba55aa679e0c4904d70224b6a7';

final class LibrarySearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<SearchLibrary?>, LibrarySearchProviderArgs> {
  LibrarySearchFamily._()
    : super(
        retry: null,
        name: r'librarySearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibrarySearchProvider call(LibrarySearchProviderArgs args) => LibrarySearchProvider._(argument: args, from: this);

  @override
  String toString() => r'librarySearchProvider';
}
