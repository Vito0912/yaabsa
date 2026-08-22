// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_download_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SmartDownloadManager)
final smartDownloadManagerProvider = SmartDownloadManagerProvider._();

final class SmartDownloadManagerProvider extends $NotifierProvider<SmartDownloadManager, SmartDownloadState> {
  SmartDownloadManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'smartDownloadManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$smartDownloadManagerHash();

  @$internal
  @override
  SmartDownloadManager create() => SmartDownloadManager();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SmartDownloadState value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<SmartDownloadState>(value));
  }
}

String _$smartDownloadManagerHash() => r'e2703105e69f13cf2b87865e0f107b2708606d59';

abstract class _$SmartDownloadManager extends $Notifier<SmartDownloadState> {
  SmartDownloadState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SmartDownloadState, SmartDownloadState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SmartDownloadState, SmartDownloadState>,
              SmartDownloadState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
