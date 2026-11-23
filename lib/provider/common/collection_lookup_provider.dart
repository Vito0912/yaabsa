import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/api/list/collection.dart';
import 'package:yaabsa/api/list/response/library_list_page.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/common/collection_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/collection_membership.dart';
import 'package:yaabsa/util/setting_key.dart';

part 'collection_lookup_provider.g.dart';

@riverpod
bool collectionMembershipEditingAllowed(Ref ref) {
  final user = ref.watch(currentUserProvider).value;
  ref.watch(userSettingsWatcherProvider);
  return user != null &&
      user.permissions.update &&
      ref
          .read(settingsManagerProvider.notifier)
          .getUserSetting<bool>(user.id, SettingKeys.serverManagementCollections, defaultValue: true);
}

@riverpod
AsyncValue<BookCollectionMemberships> bookCollectionMemberships(Ref ref, ({String libraryId, String bookId}) key) {
  return ref
      .watch(collectionsProvider(key.libraryId))
      .whenData(
        (state) => BookCollectionMemberships(
          collections: state.items,
          libraryId: key.libraryId,
          bookId: key.bookId,
          error: state.error ?? state.nextPageError,
          hasMore: state.hasNextPage,
          isLoadingMore: state.isLoadingNextPage,
        ),
      );
}

@riverpod
Future<Collection> collectionById(Ref ref, String libraryId, String id) async {
  final api = ref.watch(absApiProvider);
  if (api == null) {
    throw Exception('API not available.');
  }

  final index = collectionsProvider(libraryId);
  final hasKnown = ref.read(index.exists);
  final known = hasKnown ? ref.read(index).value : null;
  Collection? cached;
  final candidates = (known?.items ?? const <Collection>[]).followedBy(
    known?.pagination.bufferedItems ?? const <Collection>[],
  );
  for (final item in candidates) {
    if (item.id == id) {
      cached = item;
      break;
    }
  }

  try {
    final item = (await api.getListApi().getCollection(
      id,
      extra: const {'noCache': true, 'cacheFallbackOnNetworkErrorOnly': true},
    )).data;
    if (item == null || item.libraryId != libraryId) {
      throw Exception('No collection data received for this library.');
    }

    return item;
  } on DioException catch (error) {
    final status = error.response?.statusCode;
    if (cached != null && (status == null || status >= 500)) {
      return cached;
    }

    rethrow;
  }
}

Future<LibraryListPage<Collection>> fetchCollectionListPage(
  Ref ref,
  String libraryId,
  int page, {
  bool forceServer = false,
  bool requireServer = false,
}) async {
  final api = ref.read(absApiProvider);
  if (api == null) {
    throw Exception('API not available.');
  }

  final data = (await api.getListApi().getLibraryCollections(
    libraryId,
    page: page,
    forceServer: forceServer || requireServer,
    extra: requireServer ? const {'skipCacheOnError': true} : null,
  )).data;
  if (data == null) {
    throw const FormatException('Incomplete library list response.');
  }

  return data;
}
