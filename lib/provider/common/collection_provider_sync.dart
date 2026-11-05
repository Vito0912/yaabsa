part of 'collection_provider.dart';

mixin _CollectionServerSync on _$CollectionsNotifier {
  Map<String, int> get itemRevisions;

  void invalidateListRequests();
  void applyServerUpdate(Collection item);
  void applyServerRemoval(String id);

  Future<void> synchronizeCollection(String id) async {
    final revision = itemRevisions.update(id, (value) => value + 1, ifAbsent: () => 1);
    invalidateListRequests();

    try {
      final api = ref.read(absApiProvider);
      if (api == null) {
        throw Exception('API not available.');
      }

      final item = (await api.getListApi().getCollection(
        id,
        extra: const {'noCache': true, 'skipCacheOnError': true},
      )).data;
      if (!ref.mounted || itemRevisions[id] != revision) {
        return;
      }
      if (item == null) {
        applyServerRemoval(id);
        return;
      }
      if (item.id != id || item.libraryId != libraryId) {
        throw const FormatException('Invalid collection response.');
      }

      applyServerUpdate(item);
    } catch (error, stackTrace) {
      if (!ref.mounted || itemRevisions[id] != revision) {
        return;
      }

      final status = error is DioException ? error.response?.statusCode : null;
      if (status == 403 || status == 404) {
        applyServerRemoval(id);
        return;
      }

      final current = state.value;
      if (current != null) {
        state = AsyncData(current.copyWith(error: error, stackTrace: stackTrace, isLoadingNextPage: false));
      }
    }
  }
}
