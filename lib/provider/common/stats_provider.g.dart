// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(listeningStats)
final listeningStatsProvider = ListeningStatsProvider._();

final class ListeningStatsProvider
    extends $FunctionalProvider<AsyncValue<UserListeningStats>, UserListeningStats, FutureOr<UserListeningStats>>
    with $FutureModifier<UserListeningStats>, $FutureProvider<UserListeningStats> {
  ListeningStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listeningStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$listeningStatsHash();

  @$internal
  @override
  $FutureProviderElement<UserListeningStats> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserListeningStats> create(Ref ref) {
    return listeningStats(ref);
  }
}

String _$listeningStatsHash() => r'5361356c247ff4b678138d662ad55264ba67185d';

@ProviderFor(yearInReviewStats)
final yearInReviewStatsProvider = YearInReviewStatsFamily._();

final class YearInReviewStatsProvider
    extends $FunctionalProvider<AsyncValue<YearInReviewStats?>, YearInReviewStats?, FutureOr<YearInReviewStats?>>
    with $FutureModifier<YearInReviewStats?>, $FutureProvider<YearInReviewStats?> {
  YearInReviewStatsProvider._({required YearInReviewStatsFamily super.from, required int super.argument})
    : super(
        retry: null,
        name: r'yearInReviewStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$yearInReviewStatsHash();

  @override
  String toString() {
    return r'yearInReviewStatsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<YearInReviewStats?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<YearInReviewStats?> create(Ref ref) {
    final argument = this.argument as int;
    return yearInReviewStats(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is YearInReviewStatsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$yearInReviewStatsHash() => r'2a75cbb2e3621010da5f506518d8b379dd64ae1d';

final class YearInReviewStatsFamily extends $Family with $FunctionalFamilyOverride<FutureOr<YearInReviewStats?>, int> {
  YearInReviewStatsFamily._()
    : super(
        retry: null,
        name: r'yearInReviewStatsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  YearInReviewStatsProvider call(int year) => YearInReviewStatsProvider._(argument: year, from: this);

  @override
  String toString() => r'yearInReviewStatsProvider';
}

@ProviderFor(listeningActivityStats)
final listeningActivityStatsProvider = ListeningActivityStatsProvider._();

final class ListeningActivityStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ListeningActivityStats>,
          ListeningActivityStats,
          FutureOr<ListeningActivityStats>
        >
    with $FutureModifier<ListeningActivityStats>, $FutureProvider<ListeningActivityStats> {
  ListeningActivityStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listeningActivityStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$listeningActivityStatsHash();

  @$internal
  @override
  $FutureProviderElement<ListeningActivityStats> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ListeningActivityStats> create(Ref ref) {
    return listeningActivityStats(ref);
  }
}

String _$listeningActivityStatsHash() => r'114f17e1bcc92cae08f75f75eebaaacf4b637122';

@ProviderFor(AdvancedListeningAnalytics)
final advancedListeningAnalyticsProvider = AdvancedListeningAnalyticsProvider._();

final class AdvancedListeningAnalyticsProvider
    extends $NotifierProvider<AdvancedListeningAnalytics, AdvancedListeningAnalyticsState> {
  AdvancedListeningAnalyticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'advancedListeningAnalyticsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$advancedListeningAnalyticsHash();

  @$internal
  @override
  AdvancedListeningAnalytics create() => AdvancedListeningAnalytics();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdvancedListeningAnalyticsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdvancedListeningAnalyticsState>(value),
    );
  }
}

String _$advancedListeningAnalyticsHash() => r'5098f9ca1d92b2551a0c555b72a7f771dec5b55e';

abstract class _$AdvancedListeningAnalytics extends $Notifier<AdvancedListeningAnalyticsState> {
  AdvancedListeningAnalyticsState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AdvancedListeningAnalyticsState, AdvancedListeningAnalyticsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AdvancedListeningAnalyticsState, AdvancedListeningAnalyticsState>,
              AdvancedListeningAnalyticsState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
