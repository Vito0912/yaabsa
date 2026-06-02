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

String _$serverUpdateStateHash() => r'cee89ca326dedd352f8cc27737491efb96f86903';

abstract class _$ServerUpdateState extends $AsyncNotifier<ServerUpdateInfo?> {
  FutureOr<ServerUpdateInfo?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ServerUpdateInfo?>, ServerUpdateInfo?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ServerUpdateInfo?>, ServerUpdateInfo?>,
              AsyncValue<ServerUpdateInfo?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
