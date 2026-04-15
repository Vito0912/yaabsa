// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(serverStatus)
final serverStatusProvider = ServerStatusProvider._();

final class ServerStatusProvider extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  ServerStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverStatusProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverStatusHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return serverStatus(ref);
  }
}

String _$serverStatusHash() => r'4e07f328691749638b87443d4da3ef7701adfd2e';
