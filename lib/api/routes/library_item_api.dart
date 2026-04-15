import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/api/library_items/request/play_library_item_request.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/common/cover_placeholder.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LibraryItemApi {
  final Dio _dio;

  LibraryItemApi(this._dio);

  Future<Response<LibraryItem>> getLibraryItem({
    required String itemId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/items/$itemId',
      fromJson: (data) => LibraryItem.fromJson(data),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: {},
    );
  }

  Future<Response<PlaybackSession>> playLibraryItem(
    String id, {
    String? episodeId,
    required PlayLibraryItemRequest playRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    String route;
    if (episodeId != null) {
      route = '/api/items/$id/play/$episodeId';
    } else {
      route = '/api/items/$id/play';
    }

    return ABSApi.makeApiPostRequest(
      route: route,
      fromJson: (data) => PlaybackSession.fromJson(data),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      bodyData: playRequest.toJson(),
    );
  }

  Widget getLibraryItemCover(String id, {LibraryItem? item, double? width, double? height}) {
    if (item != null && !item.hasCover) {
      return const CoverPlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: '${_dio.options.baseUrl}/api/items/$id/cover',
      httpHeaders: Map<String, String>.from(_dio.options.headers),
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (context, url) => const CoverPlaceholder(),
      errorWidget: (context, url, error) => const CoverPlaceholder(),
    );
  }

  Uri getCoverUri(String id) {
    return Uri.parse('${_dio.options.baseUrl}/api/items/$id/cover');
  }
}
