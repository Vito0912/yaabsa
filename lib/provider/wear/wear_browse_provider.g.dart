// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wear_browse_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(wearBrowse)
final wearBrowseProvider = WearBrowseFamily._();

final class WearBrowseProvider
    extends $FunctionalProvider<AsyncValue<CompactBrowsePage>, CompactBrowsePage, FutureOr<CompactBrowsePage>>
    with $FutureModifier<CompactBrowsePage>, $FutureProvider<CompactBrowsePage> {
  WearBrowseProvider._({required WearBrowseFamily super.from, required CompactBrowseQuery super.argument})
    : super(
        retry: _noBrowseRetry,
        name: r'wearBrowseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wearBrowseHash();

  @override
  String toString() {
    return r'wearBrowseProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CompactBrowsePage> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<CompactBrowsePage> create(Ref ref) {
    final argument = this.argument as CompactBrowseQuery;
    return wearBrowse(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WearBrowseProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$wearBrowseHash() => r'42dbb77834672b99115837e7d0dcfe2cc320647f';

final class WearBrowseFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CompactBrowsePage>, CompactBrowseQuery> {
  WearBrowseFamily._()
    : super(
        retry: _noBrowseRetry,
        name: r'wearBrowseProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WearBrowseProvider call(CompactBrowseQuery query) => WearBrowseProvider._(argument: query, from: this);

  @override
  String toString() => r'wearBrowseProvider';
}
