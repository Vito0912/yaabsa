import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/list/collection.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

class CollectionsState {
  const CollectionsState({
    this.items = const <Collection>[],
    required this.libraryId,
    this.error,
    this.stackTrace,
    this.totalItems = 0,
  });

  final List<Collection> items;
  final String libraryId;
  final Object? error;
  final StackTrace? stackTrace;
  final int totalItems;

  CollectionsState copyWith({
    List<Collection>? items,
    String? libraryId,
    Object? error,
    StackTrace? stackTrace,
    int? totalItems,
  }) {
    return CollectionsState(
      items: items ?? this.items,
      libraryId: libraryId ?? this.libraryId,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

final collectionsProvider = AsyncNotifierProvider.family<CollectionsNotifier, CollectionsState, String>(
  CollectionsNotifier.new,
);

class CollectionsNotifier extends AsyncNotifier<CollectionsState> {
  CollectionsNotifier(this.libraryId);

  final String libraryId;

  Future<CollectionsState> _fetchCollections() async {
    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or API not available.');
    }

    final response = await absApi.getListApi().getCollections();
    final data = response.data;
    if (data == null) {
      throw Exception('No collections data received from API.');
    }

    final filteredCollections = data.items.where((item) => item.libraryId == libraryId).toList(growable: false)
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return CollectionsState(items: filteredCollections, libraryId: libraryId, totalItems: filteredCollections.length);
  }

  @override
  Future<CollectionsState> build() async {
    return _fetchCollections();
  }

  Future<void> refresh({bool withLoading = true}) async {
    if (withLoading) {
      state = const AsyncValue.loading();
    }

    try {
      final refreshed = await _fetchCollections();
      state = AsyncData(refreshed);
    } catch (e, s) {
      final currentState = state.value;
      if (currentState != null) {
        state = AsyncData(currentState.copyWith(error: e, stackTrace: s));
      } else {
        state = AsyncError(e, s);
      }
    }
  }
}
