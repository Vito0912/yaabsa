// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(absSocketClient)
final absSocketClientProvider = AbsSocketClientProvider._();

final class AbsSocketClientProvider extends $FunctionalProvider<ABSSocketClient, ABSSocketClient, ABSSocketClient>
    with $Provider<ABSSocketClient> {
  AbsSocketClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'absSocketClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$absSocketClientHash();

  @$internal
  @override
  $ProviderElement<ABSSocketClient> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  ABSSocketClient create(Ref ref) {
    return absSocketClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ABSSocketClient value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<ABSSocketClient>(value));
  }
}

String _$absSocketClientHash() => r'40c847a49076c21fa17268ef3aa9b22f10f1ebbf';
