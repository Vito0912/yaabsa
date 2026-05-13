// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(uploadMetadataProviders)
final uploadMetadataProvidersProvider = UploadMetadataProvidersFamily._();

final class UploadMetadataProvidersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SearchProviderOption>>,
          List<SearchProviderOption>,
          FutureOr<List<SearchProviderOption>>
        >
    with $FutureModifier<List<SearchProviderOption>>, $FutureProvider<List<SearchProviderOption>> {
  UploadMetadataProvidersProvider._({required UploadMetadataProvidersFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'uploadMetadataProvidersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$uploadMetadataProvidersHash();

  @override
  String toString() {
    return r'uploadMetadataProvidersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<SearchProviderOption>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<SearchProviderOption>> create(Ref ref) {
    final argument = this.argument as String;
    return uploadMetadataProviders(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UploadMetadataProvidersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$uploadMetadataProvidersHash() => r'7403c6b61a4d97fd3023156f933b69e697a559c7';

final class UploadMetadataProvidersFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<SearchProviderOption>>, String> {
  UploadMetadataProvidersFamily._()
    : super(
        retry: null,
        name: r'uploadMetadataProvidersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  UploadMetadataProvidersProvider call(String mediaType) =>
      UploadMetadataProvidersProvider._(argument: mediaType, from: this);

  @override
  String toString() => r'uploadMetadataProvidersProvider';
}
