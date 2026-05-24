// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'synced_playback_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SyncedPlaybackNotifier)
final syncedPlaybackProvider = SyncedPlaybackNotifierProvider._();

final class SyncedPlaybackNotifierProvider extends $NotifierProvider<SyncedPlaybackNotifier, SyncedPlaybackState> {
  SyncedPlaybackNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncedPlaybackProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncedPlaybackNotifierHash();

  @$internal
  @override
  SyncedPlaybackNotifier create() => SyncedPlaybackNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncedPlaybackState value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<SyncedPlaybackState>(value));
  }
}

String _$syncedPlaybackNotifierHash() => r'5df0150b3369948f3b6978cee05619542d69d6ff';

abstract class _$SyncedPlaybackNotifier extends $Notifier<SyncedPlaybackState> {
  SyncedPlaybackState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SyncedPlaybackState, SyncedPlaybackState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncedPlaybackState, SyncedPlaybackState>,
              SyncedPlaybackState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
