import 'package:dio/dio.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';

Dio createNativeDio({BaseOptions? options}) {
  final dio = Dio(options);
  dio.httpClientAdapter = NativeAdapter();
  return dio;
}
