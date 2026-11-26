// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_search_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SettingsSearchQuery)
final settingsSearchQueryProvider = SettingsSearchQueryProvider._();

final class SettingsSearchQueryProvider extends $NotifierProvider<SettingsSearchQuery, String> {
  SettingsSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsSearchQueryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsSearchQueryHash();

  @$internal
  @override
  SettingsSearchQuery create() => SettingsSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<String>(value));
  }
}

String _$settingsSearchQueryHash() => r'744795a8a3dc2b5acea53e7917afb81828772692';

abstract class _$SettingsSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<String, String>, String, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(SettingsLeftPaneScrollOffset)
final settingsLeftPaneScrollOffsetProvider = SettingsLeftPaneScrollOffsetProvider._();

final class SettingsLeftPaneScrollOffsetProvider extends $NotifierProvider<SettingsLeftPaneScrollOffset, double> {
  SettingsLeftPaneScrollOffsetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsLeftPaneScrollOffsetProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsLeftPaneScrollOffsetHash();

  @$internal
  @override
  SettingsLeftPaneScrollOffset create() => SettingsLeftPaneScrollOffset();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<double>(value));
  }
}

String _$settingsLeftPaneScrollOffsetHash() => r'f18f521d21ce4f74ca6543e7733e915b0508fdd4';

abstract class _$SettingsLeftPaneScrollOffset extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<double, double>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<double, double>, double, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
