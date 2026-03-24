// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsCache)
final settingsCacheProvider = SettingsCacheProvider._();

final class SettingsCacheProvider
    extends $FunctionalProvider<SettingsCache, SettingsCache, SettingsCache>
    with $Provider<SettingsCache> {
  SettingsCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsCacheProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsCacheHash();

  @$internal
  @override
  $ProviderElement<SettingsCache> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SettingsCache create(Ref ref) {
    return settingsCache(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsCache value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsCache>(value),
    );
  }
}

String _$settingsCacheHash() => r'05175d029a69a1e15af750304907dd17f8c82874';

@ProviderFor(SettingsManager)
final settingsManagerProvider = SettingsManagerProvider._();

final class SettingsManagerProvider
    extends $StreamNotifierProvider<SettingsManager, bool> {
  SettingsManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsManagerHash();

  @$internal
  @override
  SettingsManager create() => SettingsManager();
}

String _$settingsManagerHash() => r'd231d2f8e9d6f0f27ea8b82facc001ba66f1f837';

abstract class _$SettingsManager extends $StreamNotifier<bool> {
  Stream<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(UserSettingsWatcher)
final userSettingsWatcherProvider = UserSettingsWatcherProvider._();

final class UserSettingsWatcherProvider
    extends $StreamNotifierProvider<UserSettingsWatcher, bool> {
  UserSettingsWatcherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userSettingsWatcherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userSettingsWatcherHash();

  @$internal
  @override
  UserSettingsWatcher create() => UserSettingsWatcher();
}

String _$userSettingsWatcherHash() =>
    r'e60d8bb7e7c33e35fca51da72e763866fdab04d5';

abstract class _$UserSettingsWatcher extends $StreamNotifier<bool> {
  Stream<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(globalSettingByKey)
final globalSettingByKeyProvider = GlobalSettingByKeyFamily._();

final class GlobalSettingByKeyProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, Stream<String?>>
    with $FutureModifier<String?>, $StreamProvider<String?> {
  GlobalSettingByKeyProvider._({
    required GlobalSettingByKeyFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'globalSettingByKeyProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$globalSettingByKeyHash();

  @override
  String toString() {
    return r'globalSettingByKeyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<String?> create(Ref ref) {
    final argument = this.argument as String;
    return globalSettingByKey(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GlobalSettingByKeyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$globalSettingByKeyHash() =>
    r'a0ef71373adf342a19f14e7d04b19503583007fa';

final class GlobalSettingByKeyFamily extends $Family
    with $FunctionalFamilyOverride<Stream<String?>, String> {
  GlobalSettingByKeyFamily._()
    : super(
        retry: null,
        name: r'globalSettingByKeyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  GlobalSettingByKeyProvider call(String key) =>
      GlobalSettingByKeyProvider._(argument: key, from: this);

  @override
  String toString() => r'globalSettingByKeyProvider';
}

@ProviderFor(settingsInitializer)
final settingsInitializerProvider = SettingsInitializerProvider._();

final class SettingsInitializerProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  SettingsInitializerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsInitializerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsInitializerHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return settingsInitializer(ref);
  }
}

String _$settingsInitializerHash() =>
    r'ff5cd3b2194aa7f43f31603d116e4a57844f768c';
