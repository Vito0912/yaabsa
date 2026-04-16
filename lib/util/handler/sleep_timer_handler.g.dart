// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_timer_handler.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SleepTimerHandler)
final sleepTimerHandlerProvider = SleepTimerHandlerProvider._();

final class SleepTimerHandlerProvider
    extends $NotifierProvider<SleepTimerHandler, SleepTimerData> {
  SleepTimerHandlerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sleepTimerHandlerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sleepTimerHandlerHash();

  @$internal
  @override
  SleepTimerHandler create() => SleepTimerHandler();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SleepTimerData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SleepTimerData>(value),
    );
  }
}

String _$sleepTimerHandlerHash() => r'd293c237dcb5a86807c747bb28f079b9c215da5d';

abstract class _$SleepTimerHandler extends $Notifier<SleepTimerData> {
  SleepTimerData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SleepTimerData, SleepTimerData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SleepTimerData, SleepTimerData>,
              SleepTimerData,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(sleepTimerRemainingTime)
final sleepTimerRemainingTimeProvider = SleepTimerRemainingTimeProvider._();

final class SleepTimerRemainingTimeProvider
    extends $FunctionalProvider<Duration, Duration, Duration>
    with $Provider<Duration> {
  SleepTimerRemainingTimeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sleepTimerRemainingTimeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sleepTimerRemainingTimeHash();

  @$internal
  @override
  $ProviderElement<Duration> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Duration create(Ref ref) {
    return sleepTimerRemainingTime(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration>(value),
    );
  }
}

String _$sleepTimerRemainingTimeHash() =>
    r'5448067efe23d6862dc299b44304e3ead602db71';

@ProviderFor(sleepTimerState)
final sleepTimerStateProvider = SleepTimerStateProvider._();

final class SleepTimerStateProvider
    extends
        $FunctionalProvider<SleepTimerState, SleepTimerState, SleepTimerState>
    with $Provider<SleepTimerState> {
  SleepTimerStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sleepTimerStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sleepTimerStateHash();

  @$internal
  @override
  $ProviderElement<SleepTimerState> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SleepTimerState create(Ref ref) {
    return sleepTimerState(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SleepTimerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SleepTimerState>(value),
    );
  }
}

String _$sleepTimerStateHash() => r'b52764c84f46cd98809a1e33f167df245460dee8';

@ProviderFor(sleepTimerIsActive)
final sleepTimerIsActiveProvider = SleepTimerIsActiveProvider._();

final class SleepTimerIsActiveProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  SleepTimerIsActiveProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sleepTimerIsActiveProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sleepTimerIsActiveHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return sleepTimerIsActive(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$sleepTimerIsActiveHash() =>
    r'caa43a299e2d1f1bbb2d568cc1376f8880887d43';
