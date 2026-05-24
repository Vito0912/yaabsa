// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_message_consents_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserMessageConsentsNotifier)
final userMessageConsentsProvider = UserMessageConsentsNotifierProvider._();

final class UserMessageConsentsNotifierProvider
    extends $AsyncNotifierProvider<UserMessageConsentsNotifier, SocialConnectionState> {
  UserMessageConsentsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userMessageConsentsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userMessageConsentsNotifierHash();

  @$internal
  @override
  UserMessageConsentsNotifier create() => UserMessageConsentsNotifier();
}

String _$userMessageConsentsNotifierHash() => r'5236f32c7d9a6c28828ca7e81f5f9167f566843a';

abstract class _$UserMessageConsentsNotifier extends $AsyncNotifier<SocialConnectionState> {
  FutureOr<SocialConnectionState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SocialConnectionState>, SocialConnectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SocialConnectionState>, SocialConnectionState>,
              AsyncValue<SocialConnectionState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
