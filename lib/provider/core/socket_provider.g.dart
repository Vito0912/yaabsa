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

String _$absSocketClientHash() => r'1f0379040821833e5cda41ff601bb6d5b4bcb40f';
