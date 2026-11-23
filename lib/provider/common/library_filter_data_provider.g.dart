// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_filter_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(libraryFilterData)
final libraryFilterDataProvider = LibraryFilterDataFamily._();

final class LibraryFilterDataProvider
    extends $FunctionalProvider<AsyncValue<LibraryFilterData?>, LibraryFilterData?, FutureOr<LibraryFilterData?>>
    with $FutureModifier<LibraryFilterData?>, $FutureProvider<LibraryFilterData?> {
  LibraryFilterDataProvider._({required LibraryFilterDataFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'libraryFilterDataProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$libraryFilterDataHash();

  @override
  String toString() {
    return r'libraryFilterDataProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<LibraryFilterData?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<LibraryFilterData?> create(Ref ref) {
    final argument = this.argument as String;
    return libraryFilterData(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryFilterDataProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryFilterDataHash() => r'58c73ce05b2275aa63a8486bd22301ddf5096a1f';

final class LibraryFilterDataFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<LibraryFilterData?>, String> {
  LibraryFilterDataFamily._()
    : super(
        retry: null,
        name: r'libraryFilterDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  LibraryFilterDataProvider call(String libraryId) => LibraryFilterDataProvider._(argument: libraryId, from: this);

  @override
  String toString() => r'libraryFilterDataProvider';
}
