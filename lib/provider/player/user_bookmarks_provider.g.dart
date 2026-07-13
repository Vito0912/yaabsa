// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_bookmarks_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserBookmarksNotifier)
final userBookmarksProvider = UserBookmarksNotifierProvider._();

final class UserBookmarksNotifierProvider extends $AsyncNotifierProvider<UserBookmarksNotifier, List<Bookmark>> {
  UserBookmarksNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userBookmarksProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userBookmarksNotifierHash();

  @$internal
  @override
  UserBookmarksNotifier create() => UserBookmarksNotifier();
}

String _$userBookmarksNotifierHash() => r'c3c3c1d70845ac5694b9236e0e3b8294fa6ed3f2';

abstract class _$UserBookmarksNotifier extends $AsyncNotifier<List<Bookmark>> {
  FutureOr<List<Bookmark>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Bookmark>>, List<Bookmark>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Bookmark>>, List<Bookmark>>,
              AsyncValue<List<Bookmark>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
