// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_tasks_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ServerTasks)
final serverTasksProvider = ServerTasksProvider._();

final class ServerTasksProvider extends $NotifierProvider<ServerTasks, ServerTasksState> {
  ServerTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverTasksProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverTasksHash();

  @$internal
  @override
  ServerTasks create() => ServerTasks();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServerTasksState value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<ServerTasksState>(value));
  }
}

String _$serverTasksHash() => r'76ff3ca6a16ce9c6fdc4893d81ad350048b059e6';

abstract class _$ServerTasks extends $Notifier<ServerTasksState> {
  ServerTasksState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ServerTasksState, ServerTasksState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ServerTasksState, ServerTasksState>,
              ServerTasksState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
