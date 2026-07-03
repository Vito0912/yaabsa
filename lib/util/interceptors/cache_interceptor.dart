import 'dart:convert';

import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/network/dio_factory.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';

const List<CacheRouteDefinition> cacheRouteDefinitions = [
  CacheRouteDefinition(
    settingKey: SettingKeys.cacheRouteLibraries,
    label: 'Libraries list',
    pathPattern: '/api/libraries',
    cacheDuration: Duration(days: 7),
  ),
  CacheRouteDefinition(
    settingKey: SettingKeys.cacheRouteLibraryById,
    label: 'Library details',
    pathPattern: '/api/libraries/{uuidv4}',
    cacheDuration: Duration(days: 7),
  ),
  CacheRouteDefinition(
    settingKey: SettingKeys.cacheRouteLibraryItems,
    label: 'Library items',
    pathPattern: '/api/libraries/{uuidv4}/items',
    cacheDuration: Duration(days: 7),
  ),
  CacheRouteDefinition(
    settingKey: SettingKeys.cacheRouteItemById,
    label: 'Item details',
    pathPattern: '/api/items/{uuidv4}',
    cacheDuration: Duration(days: 7),
  ),
  CacheRouteDefinition(
    settingKey: SettingKeys.cacheRouteItemChild,
    label: 'Item nested resource',
    pathPattern: '/api/items/{uuidv4}/{uuidv4}',
    cacheDuration: Duration(days: 7),
  ),
  CacheRouteDefinition(
    settingKey: SettingKeys.cacheRouteLibraryFilterData,
    label: 'Library filter data',
    pathPattern: '/api/libraries/{uuidv4}/filterdata',
    cacheDuration: Duration(days: 7),
  ),
  CacheRouteDefinition(
    settingKey: SettingKeys.cacheRouteLibrarySeries,
    label: 'Library series',
    pathPattern: '/api/libraries/{uuidv4}/series',
    cacheDuration: Duration(days: 7),
  ),
  CacheRouteDefinition(
    settingKey: SettingKeys.cacheRoutePlaylists,
    label: 'Playlists',
    pathPattern: '/api/playlists',
    cacheDuration: Duration(days: 7),
  ),
  CacheRouteDefinition(
    settingKey: SettingKeys.cacheRouteCollections,
    label: 'Collections',
    pathPattern: '/api/collections',
    cacheDuration: Duration(days: 7),
  ),
  CacheRouteDefinition(
    settingKey: SettingKeys.cacheRouteMe,
    label: 'Current user profile',
    pathPattern: '/api/me',
    cacheDuration: Duration(days: 1),
    aggressiveCache: true,
  ),
];

final StoreRef<String, dynamic> _cacheStore = StoreRef.main();

Future<void> invalidateCachedLibraryItemEntries({
  required ProviderContainer container,
  required String itemId,
  String? libraryId,
}) async {
  final userId = container.read(currentUserProvider).value?.id ?? container.read(absApiProvider)?.user?.id;
  if (userId == null || userId.isEmpty) {
    return;
  }

  final routeFragments = <String>{
    '/api/items/$itemId',
    '/api/playlists',
    '/api/collections',
    '/api/series/',
    '/api/authors/',
  };
  if (libraryId != null && libraryId.isNotEmpty) {
    routeFragments.addAll(<String>{
      '/api/libraries/$libraryId',
      '/api/libraries/$libraryId/items',
      '/api/libraries/$libraryId/personalized',
      '/api/libraries/$libraryId/search',
      '/api/libraries/$libraryId/series',
      '/api/libraries/$libraryId/authors',
    });
  }

  final records = await _cacheStore.find(cacheDb);
  final keysToDelete = <String>[];
  for (final record in records) {
    final key = record.key;
    if (!key.startsWith(userId)) {
      continue;
    }

    final matchesUpdatedItem = routeFragments.any(key.contains);
    if (!matchesUpdatedItem) {
      continue;
    }

    keysToDelete.add(key);
  }

  for (final key in keysToDelete) {
    await _cacheStore.record(key).delete(cacheDb);
  }

  if (keysToDelete.isNotEmpty) {
    logger(
      'Invalidated ${keysToDelete.length} cache entries for item $itemId',
      tag: 'CacheInterceptor',
      level: InfoLevel.debug,
    );
  }
}

// TODO: Replace by Drift cache
class CacheInterceptor extends Interceptor {
  final ProviderContainer container;
  final bool cachingEnabled;
  final bool boostLoading;
  final Map<String, bool> routeEnabledBySettingKey;

  CacheInterceptor(
    this.container, {
    this.cachingEnabled = true,
    this.boostLoading = false,
    this.routeEnabledBySettingKey = const {},
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.extra['noCache'] == true ||
        options.extra['doNotCache'] == true ||
        options.responseType == ResponseType.stream) {
      return handler.next(options);
    }

    final matchingRoute = _getMatchingRoute(options);

    if (matchingRoute != null) {
      final String cacheKey = _getCacheKey(options.uri);
      final cachedData = await _cacheStore.record(cacheKey).get(cacheDb);

      if (cachedData != null) {
        final DateTime cachedTime = DateTime.parse(cachedData['timestamp']);
        final DateTime now = DateTime.now();

        if (now.difference(cachedTime) < matchingRoute.cacheDuration) {
          final decodedHeaders = jsonDecode(cachedData['headers']) as Map<String, dynamic>;
          final headers = decodedHeaders.map<String, List<String>>((key, dynamic value) {
            if (value is List) {
              return MapEntry(key, value.cast<String>());
            } else {
              throw Exception("Expected a List<String> but got something else");
            }
          });

          logger('Cache hit: ${options.uri.toString()}', tag: 'CacheInterceptor', level: InfoLevel.debug);
          handler.resolve(
            Response(
              requestOptions: options,
              data: cachedData['data'],
              statusCode: cachedData['statusCode'],
              statusMessage: cachedData['statusMessage'],
              headers: Headers.fromMap(headers),
            ),
          );

          if (boostLoading) {
            final refreshedExtra = Map<String, dynamic>.from(options.extra)..['noCache'] = true;
            final refreshedOptions = options.copyWith(extra: refreshedExtra);

            final Dio dio = createNativeDio();
            dio.interceptors.add(this);

            // Serve stale data now, then refresh in the background for the next call.
            dio.fetch(refreshedOptions);
          }
          return;
        } else {
          logger('Cache expired: ${options.uri.toString()}', tag: 'CacheInterceptor', level: InfoLevel.debug);
        }
      }
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.requestOptions.extra['doNotCache'] == true ||
        response.requestOptions.responseType == ResponseType.stream) {
      return handler.next(response);
    }
    final matchingRoute = _getMatchingRoute(response.requestOptions);

    if (matchingRoute != null &&
        response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      final String cacheKey = _getCacheKey(response.requestOptions.uri);
      logger('Caching: ${response.requestOptions.uri.toString()}', tag: 'CacheInterceptor', level: InfoLevel.debug);
      await _cacheStore.record(cacheKey).put(cacheDb, {
        'data': response.data,
        'statusCode': response.statusCode,
        'statusMessage': response.statusMessage,
        'headers': jsonEncode(response.headers.map),
        'timestamp': DateTime.now().toIso8601String(),
      });
    }

    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.requestOptions.extra['doNotCache'] == true || err.requestOptions.responseType == ResponseType.stream) {
      return handler.next(err);
    }
    final matchingRoute = _getMatchingRoute(err.requestOptions);

    if (matchingRoute != null) {
      final String cacheKey = _getCacheKey(err.requestOptions.uri);
      _cacheStore.record(cacheKey).get(cacheDb).then((cachedData) {
        if (cachedData != null) {
          try {
            final decodedHeaders = jsonDecode(cachedData['headers']) as Map<String, dynamic>;
            final headers = decodedHeaders.map<String, List<String>>((key, dynamic value) {
              if (value is List) {
                return MapEntry(key, value.cast<String>());
              }
              throw Exception("Expected a List<String> but got something else");
            });

            return handler.resolve(
              Response(
                requestOptions: err.requestOptions,
                data: cachedData['data'],
                statusCode: cachedData['statusCode'],
                statusMessage: cachedData['statusMessage'],
                headers: Headers.fromMap(headers),
              ),
            );
          } catch (e) {
            logger('Error while serving from cache: $e', tag: 'CacheInterceptor', level: InfoLevel.debug);
            return handler.next(err);
          }
        } else {
          return handler.next(err);
        }
      });
    } else {
      return handler.next(err);
    }
  }

  CacheRouteDefinition? _getMatchingRoute(RequestOptions options) {
    if (!cachingEnabled) return null;
    if (options.method.toUpperCase() != 'GET') {
      return null;
    }

    for (var routePattern in cacheRouteDefinitions) {
      if (routePattern.matches(options.path)) {
        if (!_isRouteEnabled(routePattern.settingKey)) {
          continue;
        }

        return routePattern;
      }
    }
    return null;
  }

  bool _isRouteEnabled(String settingKey) {
    return routeEnabledBySettingKey[settingKey] ?? true;
  }

  String _getCacheKey(Uri uri) {
    final user = container.read(currentUserProvider).value;
    return '${user?.id}${uri.toString()}';
  }
}

class CacheRouteDefinition {
  final String settingKey;
  final String label;
  final String pathPattern;
  final Duration cacheDuration;
  final bool aggressiveCache;

  const CacheRouteDefinition({
    required this.settingKey,
    required this.label,
    required this.pathPattern,
    required this.cacheDuration,
    this.aggressiveCache = false,
  });

  bool matches(String path) {
    final patternSegments = pathPattern.split('/');
    final pathSegments = Uri.parse(path).path.split('/');

    if (patternSegments.length != pathSegments.length) {
      return false;
    }

    for (var i = 0; i < patternSegments.length; i++) {
      if (patternSegments[i].startsWith('{') && patternSegments[i].endsWith('}')) {
        continue;
      }
      if (patternSegments[i] != pathSegments[i]) {
        return false;
      }
    }

    return true;
  }
}
