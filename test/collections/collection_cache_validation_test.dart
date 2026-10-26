import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/util/interceptors/cache_interceptor.dart';

class _OfflineAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    throw DioException(requestOptions: options, type: DioExceptionType.connectionError);
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test('fresh membership validation cannot fall back to the offline cache', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid'))
      ..httpClientAdapter = _OfflineAdapter()
      ..interceptors.add(CacheInterceptor(container));
    addTearDown(dio.close);
    final api = ABSApi(dio: dio, interceptors: []);
    // No cache database is initialized: a fallback attempt would fail here.
    await expectLater(
      api.getListApi().getAllLibraryCollections('library', forceServer: true, extra: {'skipCacheOnError': true}),
      throwsA(isA<DioException>()),
    );
    await expectLater(
      api.getListApi().getAllLibraryPlaylists('library', forceServer: true, extra: {'skipCacheOnError': true}),
      throwsA(isA<DioException>()),
    );
  });
}
