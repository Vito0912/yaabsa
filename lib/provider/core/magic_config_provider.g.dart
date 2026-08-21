// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'magic_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MagicConfigImport)
final magicConfigImportProvider = MagicConfigImportProvider._();

final class MagicConfigImportProvider extends $NotifierProvider<MagicConfigImport, String?> {
  MagicConfigImportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'magicConfigImportProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$magicConfigImportHash();

  @$internal
  @override
  MagicConfigImport create() => MagicConfigImport();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<String?>(value));
  }
}

String _$magicConfigImportHash() => r'df0edb8c494a50b78bc2c6a3b54d11dcb32752b8';

abstract class _$MagicConfigImport extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<String?, String?>, String?, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
