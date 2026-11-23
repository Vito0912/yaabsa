// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_work_policy.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SocketPolicy)
final socketPolicyProvider = SocketPolicyProvider._();

final class SocketPolicyProvider extends $NotifierProvider<SocketPolicy, SocketWorkPolicy> {
  SocketPolicyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socketPolicyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socketPolicyHash();

  @$internal
  @override
  SocketPolicy create() => SocketPolicy();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SocketWorkPolicy value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<SocketWorkPolicy>(value));
  }
}

String _$socketPolicyHash() => r'08531ef632173cb46f0df8d02812d101b58e8bf2';

abstract class _$SocketPolicy extends $Notifier<SocketWorkPolicy> {
  SocketWorkPolicy build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SocketWorkPolicy, SocketWorkPolicy>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SocketWorkPolicy, SocketWorkPolicy>,
              SocketWorkPolicy,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(SocketInteractionActive)
final socketInteractionActiveProvider = SocketInteractionActiveProvider._();

final class SocketInteractionActiveProvider extends $NotifierProvider<SocketInteractionActive, bool> {
  SocketInteractionActiveProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'socketInteractionActiveProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$socketInteractionActiveHash();

  @$internal
  @override
  SocketInteractionActive create() => SocketInteractionActive();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<bool>(value));
  }
}

String _$socketInteractionActiveHash() => r'0b76e57f4868c20897390d268fe0809d13a91847';

abstract class _$SocketInteractionActive extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<bool, bool>, bool, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
