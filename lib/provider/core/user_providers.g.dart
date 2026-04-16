// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activeUserId)
final activeUserIdProvider = ActiveUserIdProvider._();

final class ActiveUserIdProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, Stream<String?>>
    with $FutureModifier<String?>, $StreamProvider<String?> {
  ActiveUserIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeUserIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeUserIdHash();

  @$internal
  @override
  $StreamProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<String?> create(Ref ref) {
    return activeUserId(ref);
  }
}

String _$activeUserIdHash() => r'7cd6e0720d9e38814d28806fecf7a9bbc3e2b311';

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

final class CurrentUserProvider
    extends $FunctionalProvider<AsyncValue<User?>, User?, Stream<User?>>
    with $FutureModifier<User?>, $StreamProvider<User?> {
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $StreamProviderElement<User?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<User?> create(Ref ref) {
    return currentUser(ref);
  }
}

String _$currentUserHash() => r'7a64b7ce6e28aefe511bf45b1f73cf227d603a86';

/// Provider for the list of all stored users.

@ProviderFor(allStoredUsers)
final allStoredUsersProvider = AllStoredUsersProvider._();

/// Provider for the list of all stored users.

final class AllStoredUsersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<User>>,
          List<User>,
          Stream<List<User>>
        >
    with $FutureModifier<List<User>>, $StreamProvider<List<User>> {
  /// Provider for the list of all stored users.
  AllStoredUsersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allStoredUsersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allStoredUsersHash();

  @$internal
  @override
  $StreamProviderElement<List<User>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<User>> create(Ref ref) {
    return allStoredUsers(ref);
  }
}

String _$allStoredUsersHash() => r'7d0a676d47e1920e42b0638ceb25a5549d7482fb';

@ProviderFor(absApi)
final absApiProvider = AbsApiProvider._();

final class AbsApiProvider
    extends $FunctionalProvider<ABSApi?, ABSApi?, ABSApi?>
    with $Provider<ABSApi?> {
  AbsApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'absApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$absApiHash();

  @$internal
  @override
  $ProviderElement<ABSApi?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ABSApi? create(Ref ref) {
    return absApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ABSApi? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ABSApi?>(value),
    );
  }
}

String _$absApiHash() => r'01fc36cd30620d37dd4d54fa96a0053cad015066';
