import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/api/library/personalized_library.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:dio/dio.dart';

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
}
