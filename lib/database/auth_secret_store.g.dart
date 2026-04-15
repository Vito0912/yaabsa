// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_secret_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authSecretStore)
final authSecretStoreProvider = AuthSecretStoreProvider._();

final class AuthSecretStoreProvider extends $FunctionalProvider<AuthSecretStore, AuthSecretStore, AuthSecretStore>
    with $Provider<AuthSecretStore> {
  AuthSecretStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authSecretStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authSecretStoreHash();

  @$internal
  @override
  $ProviderElement<AuthSecretStore> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  AuthSecretStore create(Ref ref) {
    return authSecretStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthSecretStore value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<AuthSecretStore>(value));
  }
}

String _$authSecretStoreHash() => r'd1293916539a7fac475d6ed6052a83221ed83289';
