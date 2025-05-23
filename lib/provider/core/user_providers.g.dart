// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeUserIdHash() => r'7cd6e0720d9e38814d28806fecf7a9bbc3e2b311';

/// See also [activeUserId].
@ProviderFor(activeUserId)
final activeUserIdProvider = StreamProvider<String?>.internal(
  activeUserId,
  name: r'activeUserIdProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$activeUserIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveUserIdRef = StreamProviderRef<String?>;
String _$currentUserHash() => r'384cc5a7df05ea69dadba1fe9feb85989a889e52';

/// See also [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = StreamProvider<User?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRef = StreamProviderRef<User?>;
String _$allStoredUsersHash() => r'7d0a676d47e1920e42b0638ceb25a5549d7482fb';

/// Provider for the list of all stored users.
///
/// Copied from [allStoredUsers].
@ProviderFor(allStoredUsers)
final allStoredUsersProvider = StreamProvider<List<User>>.internal(
  allStoredUsers,
  name: r'allStoredUsersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$allStoredUsersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllStoredUsersRef = StreamProviderRef<List<User>>;
String _$absApiHash() => r'c148a14c764254e3f09d03f9bdcf7d332fb43035';

/// See also [absApi].
@ProviderFor(absApi)
final absApiProvider = Provider<ABSApi?>.internal(
  absApi,
  name: r'absApiProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$absApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AbsApiRef = ProviderRef<ABSApi?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
