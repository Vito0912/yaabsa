// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(locale)
final localeProvider = LocaleProvider._();

final class LocaleProvider extends $FunctionalProvider<Locale?, Locale?, Locale?> with $Provider<Locale?> {
  LocaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeHash();

  @$internal
  @override
  $ProviderElement<Locale?> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Locale? create(Ref ref) {
    return locale(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Locale?>(value));
  }
}

String _$localeHash() => r'573fbea5ae8d29f4be92f668ec7e278e24fa64a1';

@ProviderFor(resolvedLocale)
final resolvedLocaleProvider = ResolvedLocaleProvider._();

final class ResolvedLocaleProvider extends $FunctionalProvider<Locale, Locale, Locale> with $Provider<Locale> {
  ResolvedLocaleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resolvedLocaleProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resolvedLocaleHash();

  @$internal
  @override
  $ProviderElement<Locale> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Locale create(Ref ref) {
    return resolvedLocale(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Locale>(value));
  }
}

String _$resolvedLocaleHash() => r'cf1ebdf2aa2119b8d069d6f6e7150d6189e70f1b';

@ProviderFor(LocaleEffects)
final localeEffectsProvider = LocaleEffectsProvider._();

final class LocaleEffectsProvider extends $NotifierProvider<LocaleEffects, void> {
  LocaleEffectsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeEffectsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeEffectsHash();

  @$internal
  @override
  LocaleEffects create() => LocaleEffects();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<void>(value));
  }
}

String _$localeEffectsHash() => r'd5bfa28b06f00ea0dcc54bd57236e36196f36624';

abstract class _$LocaleEffects extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<void, void>, void, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
