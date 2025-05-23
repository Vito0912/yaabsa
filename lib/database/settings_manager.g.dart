// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_manager.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsCacheHash() => r'05175d029a69a1e15af750304907dd17f8c82874';

/// See also [settingsCache].
@ProviderFor(settingsCache)
final settingsCacheProvider = Provider<SettingsCache>.internal(
  settingsCache,
  name: r'settingsCacheProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$settingsCacheHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SettingsCacheRef = ProviderRef<SettingsCache>;
String _$globalSettingByKeyHash() =>
    r'a0ef71373adf342a19f14e7d04b19503583007fa';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [globalSettingByKey].
@ProviderFor(globalSettingByKey)
const globalSettingByKeyProvider = GlobalSettingByKeyFamily();

/// See also [globalSettingByKey].
class GlobalSettingByKeyFamily extends Family<AsyncValue<String?>> {
  /// See also [globalSettingByKey].
  const GlobalSettingByKeyFamily();

  /// See also [globalSettingByKey].
  GlobalSettingByKeyProvider call(String key) {
    return GlobalSettingByKeyProvider(key);
  }

  @override
  GlobalSettingByKeyProvider getProviderOverride(
    covariant GlobalSettingByKeyProvider provider,
  ) {
    return call(provider.key);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'globalSettingByKeyProvider';
}

/// See also [globalSettingByKey].
class GlobalSettingByKeyProvider extends StreamProvider<String?> {
  /// See also [globalSettingByKey].
  GlobalSettingByKeyProvider(String key)
    : this._internal(
        (ref) => globalSettingByKey(ref as GlobalSettingByKeyRef, key),
        from: globalSettingByKeyProvider,
        name: r'globalSettingByKeyProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$globalSettingByKeyHash,
        dependencies: GlobalSettingByKeyFamily._dependencies,
        allTransitiveDependencies:
            GlobalSettingByKeyFamily._allTransitiveDependencies,
        key: key,
      );

  GlobalSettingByKeyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.key,
  }) : super.internal();

  final String key;

  @override
  Override overrideWith(
    Stream<String?> Function(GlobalSettingByKeyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GlobalSettingByKeyProvider._internal(
        (ref) => create(ref as GlobalSettingByKeyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        key: key,
      ),
    );
  }

  @override
  StreamProviderElement<String?> createElement() {
    return _GlobalSettingByKeyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GlobalSettingByKeyProvider && other.key == key;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, key.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GlobalSettingByKeyRef on StreamProviderRef<String?> {
  /// The parameter `key` of this provider.
  String get key;
}

class _GlobalSettingByKeyProviderElement extends StreamProviderElement<String?>
    with GlobalSettingByKeyRef {
  _GlobalSettingByKeyProviderElement(super.provider);

  @override
  String get key => (origin as GlobalSettingByKeyProvider).key;
}

String _$settingsInitializerHash() =>
    r'ff5cd3b2194aa7f43f31603d116e4a57844f768c';

/// See also [settingsInitializer].
@ProviderFor(settingsInitializer)
final settingsInitializerProvider = FutureProvider<void>.internal(
  settingsInitializer,
  name: r'settingsInitializerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$settingsInitializerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SettingsInitializerRef = FutureProviderRef<void>;
String _$settingsManagerHash() => r'612cc7d4ce8aed0e2c0f969a4249c4935345c352';

/// See also [SettingsManager].
@ProviderFor(SettingsManager)
final settingsManagerProvider =
    StreamNotifierProvider<SettingsManager, bool>.internal(
      SettingsManager.new,
      name: r'settingsManagerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$settingsManagerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SettingsManager = StreamNotifier<bool>;
String _$userSettingsWatcherHash() =>
    r'e60d8bb7e7c33e35fca51da72e763866fdab04d5';

/// See also [UserSettingsWatcher].
@ProviderFor(UserSettingsWatcher)
final userSettingsWatcherProvider =
    StreamNotifierProvider<UserSettingsWatcher, bool>.internal(
      UserSettingsWatcher.new,
      name: r'userSettingsWatcherProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$userSettingsWatcherHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserSettingsWatcher = StreamNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
