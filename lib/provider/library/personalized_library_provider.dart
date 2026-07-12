import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/api/library/personalized_library.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/provider/common/library_item_events.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:dio/dio.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/models/internal_download.dart';

part 'personalized_library_provider.g.dart';

final Map<String, PersonalizedLibrary> _personalizedLibraryCacheByUserLibraryKey = {};

String _personalizedCacheKey({required String libraryId, required String? userId}) {
  return '${userId ?? ''}:$libraryId';
}

@Riverpod(keepAlive: true)
class PersonalizedLibraryNotifier extends _$PersonalizedLibraryNotifier {
  CancelToken? _activeRequestToken;

  Future<PersonalizedLibrary?> _fetchPersonalizedLibrary(
    String libraryId, {
    required String? userId,
    bool bypassCache = false,
  }) async {
    final api = ref.read(absApiProvider);
    final cacheKey = _personalizedCacheKey(libraryId: libraryId, userId: userId);
    final cachedLibrary = _personalizedLibraryCacheByUserLibraryKey[cacheKey];

    if (api == null) {
      if (cachedLibrary != null) {
        logger(
          'PersonalizedLibraryNotifier: ABSApi is null, using cached personalized data for $libraryId.',
          tag: 'PersonalizedLibraryNotifier',
          level: InfoLevel.warning,
        );
        return cachedLibrary;
      }
      throw StateError('No server connection available.');
    }

    _activeRequestToken?.cancel('Superseded by a newer personalized request');
    final cancelToken = CancelToken();
    _activeRequestToken = cancelToken;

    try {
      final response = await api.getLibraryApi().getPersonalized(
        libraryId,
        cancelToken: cancelToken,
        extra: bypassCache ? const <String, dynamic>{'noCache': true} : null,
      );
      final data = response.data;
      if (data != null) {
        _personalizedLibraryCacheByUserLibraryKey[cacheKey] = data;
      }
      return data;
    } on DioException catch (e, s) {
      if (CancelToken.isCancel(e)) {
        rethrow;
      }

      if (cachedLibrary != null) {
        logger(
          'Error fetching personalized library, serving cached data for $libraryId: $e',
          tag: 'PersonalizedLibraryNotifier',
          level: InfoLevel.warning,
        );
        return cachedLibrary;
      }

      logger('Error fetching personalized library: $e\n$s', tag: 'PersonalizedLibraryNotifier', level: InfoLevel.error);
      rethrow;
    } catch (e, s) {
      if (cachedLibrary != null) {
        logger(
          'Unexpected error fetching personalized library, serving cached data for $libraryId: $e',
          tag: 'PersonalizedLibraryNotifier',
          level: InfoLevel.warning,
        );
        return cachedLibrary;
      }

      logger('Error fetching personalized library: $e\n$s', tag: 'PersonalizedLibraryNotifier', level: InfoLevel.error);
      rethrow;
    } finally {
      if (identical(_activeRequestToken, cancelToken)) {
        _activeRequestToken = null;
      }
    }
  }

  @override
  Future<PersonalizedLibrary?> build(String libraryId) async {
    ref.listen<LibraryItemMutation?>(libraryItemMutationProvider, (previous, next) {
      if (next == null) {
        return;
      }

      _applyLibraryItemMutation(next, libraryId: libraryId);
    });

    final activeUserId = ref.read(currentUserProvider).value?.id;

    ref.onDispose(() {
      _activeRequestToken?.cancel('Personalized provider disposed');
      _activeRequestToken = null;
    });

    return _fetchPersonalizedLibrary(libraryId, userId: activeUserId);
  }

  Future<void> refresh(String libraryId, {bool withLoading = false, bool bypassCache = false}) async {
    final activeUserId = ref.read(currentUserProvider).value?.id;
    final cacheKey = _personalizedCacheKey(libraryId: libraryId, userId: activeUserId);

    if (withLoading) {
      state = const AsyncValue.loading();
    }

    final fallbackData = state.value ?? _personalizedLibraryCacheByUserLibraryKey[cacheKey];
    final nextState = await AsyncValue.guard(
      () => _fetchPersonalizedLibrary(libraryId, userId: activeUserId, bypassCache: bypassCache),
    );

    if (!ref.mounted) {
      return;
    }

    if (nextState.hasError && fallbackData != null) {
      state = AsyncValue.data(fallbackData);
      return;
    }

    state = nextState;
  }

  void _applyLibraryItemMutation(LibraryItemMutation mutation, {required String libraryId}) {
    final currentLibrary = state.asData?.value;
    if (currentLibrary == null) {
      return;
    }

    final mutationLibraryId = mutation.libraryId?.trim();
    final hasLibraryMismatch =
        mutationLibraryId != null && mutationLibraryId.isNotEmpty && mutationLibraryId != libraryId;
    final itemExistsInShelves = _containsLibraryItem(currentLibrary, mutation.itemId);

    if (hasLibraryMismatch && !itemExistsInShelves) {
      return;
    }

    final nextLibrary = _mutatePersonalizedLibrary(
      currentLibrary,
      mutation: mutation,
      itemExistsInShelves: itemExistsInShelves,
    );
    if (identical(nextLibrary, currentLibrary)) {
      return;
    }

    state = AsyncValue.data(nextLibrary);

    final activeUserId = ref.read(currentUserProvider).value?.id;
    final cacheKey = _personalizedCacheKey(libraryId: libraryId, userId: activeUserId);
    _personalizedLibraryCacheByUserLibraryKey[cacheKey] = nextLibrary;
  }
}

PersonalizedLibrary _mutatePersonalizedLibrary(
  PersonalizedLibrary current, {
  required LibraryItemMutation mutation,
  required bool itemExistsInShelves,
}) {
  ShelfEntry<LibraryItem>? mutateShelf(ShelfEntry<LibraryItem>? shelf) {
    return switch (mutation.type) {
      LibraryItemMutationType.added =>
        itemExistsInShelves
            ? _replaceLibraryItemInShelf(shelf, mutation.item)
            : _prependLibraryItemToShelf(shelf, mutation.item),
      LibraryItemMutationType.updated => _replaceLibraryItemInShelf(shelf, mutation.item),
      LibraryItemMutationType.removed => _removeLibraryItemFromShelf(shelf, mutation.itemId),
    };
  }

  final nextContinueListening = mutateShelf(current.continueListening);
  final nextRecentlyAdded = mutateShelf(current.recentlyAdded);
  final nextDiscover = mutateShelf(current.discover);
  final nextListenAgain = mutateShelf(current.listenAgain);
  final nextContinueSeries = mutateShelf(current.continueSeries);

  var extraShelvesChanged = false;
  final nextExtraLibraryShelves = <ShelfEntry<LibraryItem>>[];
  for (final shelf in current.extraLibraryShelves) {
    final nextShelf = mutateShelf(shelf);
    if (!identical(nextShelf, shelf)) {
      extraShelvesChanged = true;
    }
    nextExtraLibraryShelves.add(nextShelf ?? shelf);
  }

  final changed =
      !identical(nextContinueListening, current.continueListening) ||
      !identical(nextRecentlyAdded, current.recentlyAdded) ||
      !identical(nextDiscover, current.discover) ||
      !identical(nextListenAgain, current.listenAgain) ||
      !identical(nextContinueSeries, current.continueSeries) ||
      extraShelvesChanged;

  if (!changed) {
    return current;
  }

  return current.copyWith(
    continueListening: nextContinueListening,
    recentlyAdded: nextRecentlyAdded,
    discover: nextDiscover,
    listenAgain: nextListenAgain,
    continueSeries: nextContinueSeries,
    extraLibraryShelves: extraShelvesChanged ? nextExtraLibraryShelves : current.extraLibraryShelves,
  );
}

bool _containsLibraryItem(PersonalizedLibrary library, String itemId) {
  bool containsInShelf(ShelfEntry<LibraryItem>? shelf) {
    if (shelf == null) {
      return false;
    }

    return shelf.entities.any((item) => item.id == itemId);
  }

  if (containsInShelf(library.continueListening) ||
      containsInShelf(library.recentlyAdded) ||
      containsInShelf(library.discover) ||
      containsInShelf(library.listenAgain) ||
      containsInShelf(library.continueSeries)) {
    return true;
  }

  for (final shelf in library.extraLibraryShelves) {
    if (containsInShelf(shelf)) {
      return true;
    }
  }

  return false;
}

ShelfEntry<LibraryItem>? _replaceLibraryItemInShelf(ShelfEntry<LibraryItem>? shelf, LibraryItem? item) {
  if (shelf == null || item == null) {
    return shelf;
  }

  final index = shelf.entities.indexWhere((entity) => entity.id == item.id);
  if (index == -1) {
    return shelf;
  }

  final nextEntities = List<LibraryItem>.from(shelf.entities);
  nextEntities[index] = item;
  return shelf.copyWith(entities: nextEntities);
}

ShelfEntry<LibraryItem>? _prependLibraryItemToShelf(ShelfEntry<LibraryItem>? shelf, LibraryItem? item) {
  if (shelf == null || item == null) {
    return shelf;
  }

  if (shelf.id != 'recently-added') {
    return shelf;
  }

  final existingIndex = shelf.entities.indexWhere((entity) => entity.id == item.id);
  final nextEntities = List<LibraryItem>.from(shelf.entities);
  if (existingIndex >= 0) {
    nextEntities[existingIndex] = item;
    return shelf.copyWith(entities: nextEntities);
  }

  nextEntities.insert(0, item);
  return shelf.copyWith(entities: nextEntities, total: shelf.total + 1);
}

ShelfEntry<LibraryItem>? _removeLibraryItemFromShelf(ShelfEntry<LibraryItem>? shelf, String itemId) {
  if (shelf == null) {
    return shelf;
  }

  final existingIndex = shelf.entities.indexWhere((entity) => entity.id == itemId);
  if (existingIndex == -1) {
    return shelf;
  }

  final nextEntities = List<LibraryItem>.from(shelf.entities)..removeAt(existingIndex);
  final nextTotal = shelf.total > 0 ? shelf.total - 1 : nextEntities.length;
  return shelf.copyWith(entities: nextEntities, total: nextTotal);
}

@riverpod
Stream<List<InternalDownload>> libraryDownloads(Ref ref, String libraryId) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) {
    return Stream.value(const <InternalDownload>[]);
  }
  final db = ref.watch(appDatabaseProvider);
  return db.watchStoredDownloadsByUser(user.id).map((downloads) {
    return downloads.where((d) => d.item?.libraryId == libraryId).toList();
  });
}
