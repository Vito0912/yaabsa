// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_progress_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MediaProgressNotifier)
final mediaProgressProvider = MediaProgressNotifierProvider._();

final class MediaProgressNotifierProvider
    extends $AsyncNotifierProvider<MediaProgressNotifier, Map<String, MediaProgress>> {
  MediaProgressNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaProgressProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaProgressNotifierHash();

  @$internal
  @override
  MediaProgressNotifier create() => MediaProgressNotifier();
}

String _$mediaProgressNotifierHash() => r'dfce16b1d429900ae3799adc60ad73c895465311';

abstract class _$MediaProgressNotifier extends $AsyncNotifier<Map<String, MediaProgress>> {
  FutureOr<Map<String, MediaProgress>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Map<String, MediaProgress>>, Map<String, MediaProgress>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Map<String, MediaProgress>>, Map<String, MediaProgress>>,
              AsyncValue<Map<String, MediaProgress>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
