// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_update_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ServerUpdateState)
final serverUpdateStateProvider = ServerUpdateStateProvider._();

final class ServerUpdateStateProvider extends $AsyncNotifierProvider<ServerUpdateState, ServerUpdateInfo?> {
  ServerUpdateStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverUpdateStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverUpdateStateHash();

  @$internal
  @override
  ServerUpdateState create() => ServerUpdateState();
}

String _$serverUpdateStateHash() => r'37d924c1cfc7f633c3f7d59b7dd5d6be438c99c8';

abstract class _$ServerUpdateState extends $AsyncNotifier<ServerUpdateInfo?> {
  FutureOr<ServerUpdateInfo?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ServerUpdateInfo?>, ServerUpdateInfo?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ServerUpdateInfo?>, ServerUpdateInfo?>,
              AsyncValue<ServerUpdateInfo?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
