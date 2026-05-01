import 'package:yaabsa/provider/core/server_reachability_provider.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ABSInterceptor extends Interceptor {
  final ProviderContainer container;

  const ABSInterceptor(this.container);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_isConnectivityFailure(err)) {
      final wasReachable = container.read(serverReachabilityProvider);
      if (wasReachable) {
        logger(
          'Marking server unreachable from interceptor due to ${err.type}.',
          tag: 'ABSInterceptor',
          level: InfoLevel.debug,
        );
        container.read(serverReachabilityProvider.notifier).setUnreachable();
      }
    }
    return handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      if (!container.read(serverReachabilityProvider)) {
        logger(
          'Marking server reachable from interceptor due to ${response.requestOptions.uri}.',
          tag: 'ABSInterceptor',
          level: InfoLevel.debug,
        );
        container.read(serverReachabilityProvider.notifier).setReachable();
      }
    }
    return handler.next(response);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger('Request: ${options.uri.toString()}', tag: 'ABSInterceptor', level: InfoLevel.debug);
    return handler.next(options);
  }

  bool _isConnectivityFailure(DioException err) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      return true;
    }

    if (err.type == DioExceptionType.badResponse) {
      final statusCode = err.response?.statusCode;
      if (statusCode == 502 || statusCode == 503 || statusCode == 504) {
        return true;
      }
    }

    return false;
  }
}
