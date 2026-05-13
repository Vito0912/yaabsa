import 'package:dio/dio.dart';
import 'package:yaabsa/api/admin/logger_data.dart';
import 'package:yaabsa/api/me/server_settings.dart';
import 'package:yaabsa/api/routes/abs_api.dart';

class AdminApi {
  AdminApi(this._dio);

  final Dio _dio;

  Future<Response<LoggerData>> getLoggerData({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/logger-data',
      fromJson: (data) => LoggerData.fromJson(data as Map<String, dynamic>),
      queryParams: {},
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<ServerSettings?>> updateServerSettings({
    required ServerSettings settingsUpdate,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPatchRequest(
      route: '/api/settings',
      fromJson: (data) {
        final rawSettings = data['serverSettings'];
        if (rawSettings is Map<String, dynamic>) {
          return ServerSettings.fromJson(rawSettings);
        }
        if (rawSettings is Map) {
          return ServerSettings.fromJson(Map<String, dynamic>.from(rawSettings));
        }
        return null;
      },
      bodyData: Map<String, dynamic>.from(settingsUpdate.toJson())
        ..removeWhere((key, value) => value == null || key == 'id'),
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }
}
