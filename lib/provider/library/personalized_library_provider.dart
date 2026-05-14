import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/api/library/personalized_library.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:dio/dio.dart';

part 'personalized_library_provider.g.dart';

final Map<String, PersonalizedLibrary> _personalizedLibraryCacheByLibraryId = {};

ShelfEntry<LibraryItem>? _replaceLibraryItemInShelf(ShelfEntry<LibraryItem>? shelf, LibraryItem updatedItem) {
  if (shelf == null) {
    return null;
  }

  var changed = false;
  final updatedEntities = List<LibraryItem>.from(shelf.entities);
  for (var i = 0; i < updatedEntities.length; i++) {
    if (updatedEntities[i].id != updatedItem.id) {
      continue;
    }

    updatedEntities[i] = updatedItem;
    changed = true;
  }

  if (!changed) {
    return shelf;
  }

  return shelf.copyWith(entities: updatedEntities);
}

List<ShelfEntry<LibraryItem>> _replaceLibraryItemInShelfList(
  List<ShelfEntry<LibraryItem>> shelves,
  LibraryItem updatedItem,
) {
  var changed = false;
  final updatedShelves = <ShelfEntry<LibraryItem>>[];

  for (final shelf in shelves) {
    final updatedShelf = _replaceLibraryItemInShelf(shelf, updatedItem);
    if (!identical(updatedShelf, shelf)) {
      changed = true;
    }
    updatedShelves.add(updatedShelf!);
  }

  if (!changed) {
    return shelves;
  }

  return updatedShelves;
}

PersonalizedLibrary _replaceLibraryItemInPersonalizedLibrary(PersonalizedLibrary library, LibraryItem updatedItem) {
  final updatedContinueListening = _replaceLibraryItemInShelf(library.continueListening, updatedItem);
  final updatedRecentlyAdded = _replaceLibraryItemInShelf(library.recentlyAdded, updatedItem);
  final updatedDiscover = _replaceLibraryItemInShelf(library.discover, updatedItem);
  final updatedListenAgain = _replaceLibraryItemInShelf(library.listenAgain, updatedItem);
  final updatedContinueSeries = _replaceLibraryItemInShelf(library.continueSeries, updatedItem);
  final updatedExtraLibraryShelves = _replaceLibraryItemInShelfList(library.extraLibraryShelves, updatedItem);

  final hasChanges =
      !identical(updatedContinueListening, library.continueListening) ||
      !identical(updatedRecentlyAdded, library.recentlyAdded) ||
      !identical(updatedDiscover, library.discover) ||
      !identical(updatedListenAgain, library.listenAgain) ||
      !identical(updatedContinueSeries, library.continueSeries) ||
      !identical(updatedExtraLibraryShelves, library.extraLibraryShelves);

  if (!hasChanges) {
    return library;
  }

  return library.copyWith(
    continueListening: updatedContinueListening,
    recentlyAdded: updatedRecentlyAdded,
    discover: updatedDiscover,
    listenAgain: updatedListenAgain,
    continueSeries: updatedContinueSeries,
    extraLibraryShelves: updatedExtraLibraryShelves,
  );
}

@Riverpod(keepAlive: true)
class PersonalizedLibraryNotifier extends _$PersonalizedLibraryNotifier {
  static final Set<PersonalizedLibraryNotifier> _activeNotifiers = <PersonalizedLibraryNotifier>{};

  CancelToken? _activeRequestToken;

  static void applyLocalItemUpdateToAllActive(LibraryItem updatedItem) {
    final activeSnapshot = List<PersonalizedLibraryNotifier>.from(_activeNotifiers);
    for (final notifier in activeSnapshot) {
      notifier.applyLocalItemUpdate(updatedItem);
    }
  }

  Future<PersonalizedLibrary?> _fetchPersonalizedLibrary(String libraryId) async {
    final api = ref.read(absApiProvider);
    final cachedLibrary = _personalizedLibraryCacheByLibraryId[libraryId];

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
      final response = await api.getLibraryApi().getPersonalized(libraryId, cancelToken: cancelToken);
      final data = response.data;
      if (data != null) {
        _personalizedLibraryCacheByLibraryId[libraryId] = data;
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
    _activeNotifiers.add(this);
    ref.onDispose(() {
      _activeNotifiers.remove(this);
      _activeRequestToken?.cancel('Personalized provider disposed');
      _activeRequestToken = null;
    });
    return _fetchPersonalizedLibrary(libraryId);
  }

  void applyLocalItemUpdate(LibraryItem updatedItem) {
    final currentLibrary = state.asData?.value;
    if (currentLibrary == null) {
      return;
    }

    final updatedLibrary = _replaceLibraryItemInPersonalizedLibrary(currentLibrary, updatedItem);
    if (identical(updatedLibrary, currentLibrary)) {
      return;
    }

    _personalizedLibraryCacheByLibraryId[libraryId] = updatedLibrary;
    state = AsyncValue.data(updatedLibrary);
  }

  Future<void> refresh(String libraryId, {bool withLoading = false}) async {
    if (withLoading) {
      state = const AsyncValue.loading();
    }

    final fallbackData = state.value ?? _personalizedLibraryCacheByLibraryId[libraryId];
    final nextState = await AsyncValue.guard(() => _fetchPersonalizedLibrary(libraryId));

    if (!ref.mounted) {
      return;
    }

    if (nextState.hasError && fallbackData != null) {
      state = AsyncValue.data(fallbackData);
      return;
    }

    state = nextState;
  }
}
