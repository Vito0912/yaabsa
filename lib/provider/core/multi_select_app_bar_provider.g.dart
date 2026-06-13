// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_select_app_bar_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MultiSelectAppBar)
final multiSelectAppBarProvider = MultiSelectAppBarProvider._();

final class MultiSelectAppBarProvider extends $NotifierProvider<MultiSelectAppBar, MultiSelectAppBarState?> {
  MultiSelectAppBarProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'multiSelectAppBarProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$multiSelectAppBarHash();

  @$internal
  @override
  MultiSelectAppBar create() => MultiSelectAppBar();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MultiSelectAppBarState? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<MultiSelectAppBarState?>(value));
  }
}

String _$multiSelectAppBarHash() => r'814f472c7b82048b5fa4804cd923eb734027f231';

abstract class _$MultiSelectAppBar extends $Notifier<MultiSelectAppBarState?> {
  MultiSelectAppBarState? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MultiSelectAppBarState?, MultiSelectAppBarState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MultiSelectAppBarState?, MultiSelectAppBarState?>,
              MultiSelectAppBarState?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
