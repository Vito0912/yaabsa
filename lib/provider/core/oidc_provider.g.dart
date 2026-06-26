// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oidc_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OidcState)
final oidcStateProvider = OidcStateProvider._();

final class OidcStateProvider extends $NotifierProvider<OidcState, AsyncValue<void>> {
  OidcStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'oidcStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$oidcStateHash();

  @$internal
  @override
  OidcState create() => OidcState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<AsyncValue<void>>(value));
  }
}

String _$oidcStateHash() => r'12c77cf92057a1ebb09772e498505030e69c05ae';

abstract class _$OidcState extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
