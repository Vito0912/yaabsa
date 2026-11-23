// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wear_preferences_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(wearPreferences)
final wearPreferencesProvider = WearPreferencesProvider._();

final class WearPreferencesProvider extends $FunctionalProvider<WearPreferences, WearPreferences, WearPreferences>
    with $Provider<WearPreferences> {
  WearPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wearPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wearPreferencesHash();

  @$internal
  @override
  $ProviderElement<WearPreferences> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  WearPreferences create(Ref ref) {
    return wearPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WearPreferences value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<WearPreferences>(value));
  }
}

String _$wearPreferencesHash() => r'089e796d40b1034576b762e93df7114e51dcbbac';
