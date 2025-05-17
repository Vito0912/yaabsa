import 'package:buchshelfly/api/library_items/library_item.dart';
import 'package:buchshelfly/api/library_items/playback_session.dart';
import 'package:buchshelfly/api/library_items/request/library_item_request.dart';
import 'package:buchshelfly/api/library_items/request/play_library_item_request.dart';
import 'package:buchshelfly/api/routes/abs_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LibraryItemApi {
  final Dio _dio;

  LibraryItemApi(this._dio);

  Future<Response<LibraryItem>> getLibraryItem({
    required LibraryItemRequest libraryItemRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/items/{id}',
      fromJson: (data) => LibraryItem.fromJson(data),
      queryParams: libraryItemRequest.toJson(),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }

  Future<Response<PlaybackSession>> playLibraryItem(
    String id, {
    String? episodeId,
    required PlayLibraryItemRequest libraryItemRequest,
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
      bodyData: libraryItemRequest.toJson(),
    );
  }

  Widget getLibraryItemCover(
    String id, {
    LibraryItem? item,
    double? width,
    double? height,
  }) {
    if (item != null &&
        item.media != null &&
        ((item.media!.bookMedia != null &&
                item.media!.bookMedia!.coverPath == null) ||
            (item.media!.podcastMedia != null &&
                item.media!.podcastMedia!.coverPath == null))) {
      return Icon(Icons.image_sharp);
    }
    return CachedNetworkImage(
      imageUrl: '${_dio.options.baseUrl}/api/items/$id/cover',
      httpHeaders: Map<String, String>.from(_dio.options.headers),
      errorListener: (e) {
        print('Error loading image: $e');
      },
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) {
        if (error.toString().contains('404')) {
          // TODO: 404 image placeholder
          return const Icon(Icons.image_sharp);
        }
        return const Icon(Icons.error);
      },
    );
  }
}
