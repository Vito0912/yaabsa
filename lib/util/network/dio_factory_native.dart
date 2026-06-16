import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';
import 'package:yaabsa/util/logger.dart';

bool? _androidCronetSupported;

bool _supportsAndroidCronet() {
  final cached = _androidCronetSupported;
  if (cached != null) {
    return cached;
  }

  try {
    final engine = CronetEngine.build();
    engine.close();
    _androidCronetSupported = true;
  } catch (_) {
    logger('Cronet is not supported on this Android device', tag: 'DioFactory', level: InfoLevel.warning);
    _androidCronetSupported = false;
  }

  return _androidCronetSupported!;
}

Dio createNativeDio({BaseOptions? options}) {
  final dio = Dio(options);

  if (Platform.isAndroid && !_supportsAndroidCronet()) {
    return dio;
  }

  dio.httpClientAdapter = NativeAdapter();
  return dio;
}
