// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wear_sign_in_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WearSignIn)
final wearSignInProvider = WearSignInProvider._();

final class WearSignInProvider extends $AsyncNotifierProvider<WearSignIn, void> {
  WearSignInProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wearSignInProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wearSignInHash();

  @$internal
  @override
  WearSignIn create() => WearSignIn();
}

String _$wearSignInHash() => r'12838066cdafd8b2fc6946ee10882286f5d719af';

abstract class _$WearSignIn extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element as $ClassProviderElement<AnyNotifier<AsyncValue<void>, void>, AsyncValue<void>, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
