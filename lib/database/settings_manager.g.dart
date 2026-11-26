// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsCache)
final settingsCacheProvider = SettingsCacheProvider._();

final class SettingsCacheProvider extends $FunctionalProvider<SettingsCache, SettingsCache, SettingsCache>
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
  $ProviderElement<SettingsCache> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  SettingsCache create(Ref ref) {
    return settingsCache(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsCache value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<SettingsCache>(value));
  }
}

String _$settingsCacheHash() => r'05175d029a69a1e15af750304907dd17f8c82874';

@ProviderFor(SettingsManager)
final settingsManagerProvider = SettingsManagerProvider._();

final class SettingsManagerProvider extends $StreamNotifierProvider<SettingsManager, int> {
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

String _$settingsManagerHash() => r'64565248c34f346f1aa8809332a8fe60189f415a';

abstract class _$SettingsManager extends $StreamNotifier<int> {
  Stream<int> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element as $ClassProviderElement<AnyNotifier<AsyncValue<int>, int>, AsyncValue<int>, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(UserSettingsWatcher)
final userSettingsWatcherProvider = UserSettingsWatcherProvider._();

final class UserSettingsWatcherProvider extends $StreamNotifierProvider<UserSettingsWatcher, int> {
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

String _$userSettingsWatcherHash() => r'2f071f518f8a052f7bd4989dcdbce52bb7eb7497';

abstract class _$UserSettingsWatcher extends $StreamNotifier<int> {
  Stream<int> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element as $ClassProviderElement<AnyNotifier<AsyncValue<int>, int>, AsyncValue<int>, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(globalSettingByKey)
final globalSettingByKeyProvider = GlobalSettingByKeyFamily._();

final class GlobalSettingByKeyProvider extends $FunctionalProvider<AsyncValue<String?>, String?, Stream<String?>>
    with $FutureModifier<String?>, $StreamProvider<String?> {
  GlobalSettingByKeyProvider._({required GlobalSettingByKeyFamily super.from, required String super.argument})
    : super(
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
  $StreamProviderElement<String?> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

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

String _$globalSettingByKeyHash() => r'a0ef71373adf342a19f14e7d04b19503583007fa';

final class GlobalSettingByKeyFamily extends $Family with $FunctionalFamilyOverride<Stream<String?>, String> {
  GlobalSettingByKeyFamily._()
    : super(
        retry: null,
        name: r'globalSettingByKeyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  GlobalSettingByKeyProvider call(String key) => GlobalSettingByKeyProvider._(argument: key, from: this);

  @override
  String toString() => r'globalSettingByKeyProvider';
}

@ProviderFor(settingsInitializer)
final settingsInitializerProvider = SettingsInitializerProvider._();

final class SettingsInitializerProvider extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
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
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return settingsInitializer(ref);
  }
}

String _$settingsInitializerHash() => r'54e713ec5361c903812a614e5b6c15cffc508e5d';

@ProviderFor(globalSettingValue)
final globalSettingValueProvider = GlobalSettingValueFamily._();

final class GlobalSettingValueProvider extends $FunctionalProvider<String?, String?, String?> with $Provider<String?> {
  GlobalSettingValueProvider._({required GlobalSettingValueFamily super.from, required String super.argument})
    : super(
        retry: null,
        name: r'globalSettingValueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$globalSettingValueHash();

  @override
  String toString() {
    return r'globalSettingValueProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    final argument = this.argument as String;
    return globalSettingValue(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<String?>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is GlobalSettingValueProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$globalSettingValueHash() => r'52c02bed778ba2058e06085139646880ca75de5b';

final class GlobalSettingValueFamily extends $Family with $FunctionalFamilyOverride<String?, String> {
  GlobalSettingValueFamily._()
    : super(
        retry: null,
        name: r'globalSettingValueProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GlobalSettingValueProvider call(String key) => GlobalSettingValueProvider._(argument: key, from: this);

  @override
  String toString() => r'globalSettingValueProvider';
}

@ProviderFor(userSettingValue)
final userSettingValueProvider = UserSettingValueFamily._();

final class UserSettingValueProvider extends $FunctionalProvider<String?, String?, String?> with $Provider<String?> {
  UserSettingValueProvider._({required UserSettingValueFamily super.from, required (String?, String) super.argument})
    : super(
        retry: null,
        name: r'userSettingValueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userSettingValueHash();

  @override
  String toString() {
    return r'userSettingValueProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    final argument = this.argument as (String?, String);
    return userSettingValue(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<String?>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is UserSettingValueProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userSettingValueHash() => r'e41b6073240e9d6e3d662af98c5e0c56301cef0c';

final class UserSettingValueFamily extends $Family with $FunctionalFamilyOverride<String?, (String?, String)> {
  UserSettingValueFamily._()
    : super(
        retry: null,
        name: r'userSettingValueProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserSettingValueProvider call(String? userId, String key) =>
      UserSettingValueProvider._(argument: (userId, key), from: this);

  @override
  String toString() => r'userSettingValueProvider';
}
