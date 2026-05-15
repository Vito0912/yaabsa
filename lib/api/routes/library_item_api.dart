import 'package:yaabsa/api/library_items/batch_quick_match_library_items_response.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/api/library_items/quick_match_library_item_response.dart';
import 'package:yaabsa/api/library_items/batch_update_library_items_response.dart';
import 'package:yaabsa/api/library_items/request/batch_quick_match_library_items_request.dart';
import 'package:yaabsa/api/library_items/request/batch_update_library_item_request.dart';
import 'package:yaabsa/api/library_items/request/play_library_item_request.dart';
import 'package:yaabsa/api/library_items/request/quick_match_library_item_options.dart';
import 'package:yaabsa/api/library_items/request/update_library_item_media_request.dart';
import 'package:yaabsa/api/library_items/update_library_item_media_response.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/common/cover_loading_placeholder.dart';
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

  Future<bool> deleteLibraryItem(
    String itemId, {
    bool hardDelete = false,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiDeleteRequest(
      route: '/api/items/$itemId?hard=${hardDelete ? 1 : 0}',
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }

  Future<bool> deleteLibraryItems(
    List<String> libraryItemIds, {
    bool hardDelete = false,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    if (libraryItemIds.isEmpty) {
      return true;
    }

    final response = await ABSApi.makeApiPostRequest<bool>(
      route: '/api/items/batch/delete?hard=${hardDelete ? 1 : 0}',
      fromJson: null,
      bodyData: <String, dynamic>{'libraryItemIds': libraryItemIds},
      returnData: true,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );

    final statusCode = response.statusCode;
    return statusCode != null && statusCode >= 200 && statusCode < 300;
  }

  Future<BatchUpdateLibraryItemsResponse> batchUpdateLibraryItems(
    List<BatchUpdateLibraryItemRequest> updatePayloads, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    if (updatePayloads.isEmpty) {
      return const BatchUpdateLibraryItemsResponse(success: true, updates: 0);
    }

    final requestBody = updatePayloads.map((payload) => payload.toJson()).toList(growable: false);

    final options = Options(
      method: 'POST',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {'type': 'http', 'scheme': 'bearer', 'name': 'BearerAuth'},
        ],
        ...?extra,
      },
      contentType: 'application/json',
    );

    final response = await _dio.request<Object>(
      '/api/items/batch/update',
      data: requestBody,
      options: options,
      cancelToken: cancelToken,
    );

    final rawData = response.data;
    final parsedData = rawData is Map<String, dynamic>
        ? rawData
        : rawData is Map
        ? Map<String, dynamic>.from(rawData)
        : <String, dynamic>{
            'success': response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300,
            'updates': 0,
          };

    return BatchUpdateLibraryItemsResponse.fromJson(parsedData);
  }

  Future<BatchQuickMatchLibraryItemsResponse> batchQuickMatchLibraryItems({
    required BatchQuickMatchLibraryItemsRequest request,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    if (request.libraryItemIds.isEmpty) {
      return const BatchQuickMatchLibraryItemsResponse(success: true, updates: 0, unmatched: 0);
    }

    final dioOptions = Options(
      method: 'POST',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {'type': 'http', 'scheme': 'bearer', 'name': 'BearerAuth'},
        ],
        ...?extra,
      },
      contentType: 'application/json',
    );

    final response = await _dio.request<Object>(
      '/api/items/batch/quickmatch',
      data: request.toJson(),
      options: dioOptions,
      cancelToken: cancelToken,
    );

    final rawData = response.data;
    final parsedData = rawData is Map<String, dynamic>
        ? rawData
        : rawData is Map
        ? Map<String, dynamic>.from(rawData)
        : <String, dynamic>{
            'success': response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300,
            'updates': 0,
            'unmatched': request.libraryItemIds.length,
          };

    final normalizedData = Map<String, dynamic>.from(parsedData);
    normalizedData.putIfAbsent(
      'success',
      () => response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300,
    );
    normalizedData.putIfAbsent('updates', () {
      return parsedData['updated'] ??
          parsedData['matched'] ??
          parsedData['numUpdated'] ??
          parsedData['numMatched'] ??
          0;
    });
    normalizedData.putIfAbsent('unmatched', () {
      return parsedData['notMatched'] ??
          parsedData['numUnmatched'] ??
          parsedData['unmatchedCount'] ??
          parsedData['numNotMatched'] ??
          0;
    });

    return BatchQuickMatchLibraryItemsResponse.fromJson(normalizedData);
  }

  Future<QuickMatchLibraryItemResponse> quickMatchLibraryItem(
    String itemId, {
    required QuickMatchLibraryItemOptions request,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final dioOptions = Options(
      method: 'POST',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {'type': 'http', 'scheme': 'bearer', 'name': 'BearerAuth'},
        ],
        ...?extra,
      },
      contentType: 'application/json',
    );

    final response = await _dio.request<Object>(
      '/api/items/$itemId/match',
      data: request.toJson(),
      options: dioOptions,
      cancelToken: cancelToken,
    );

    final rawData = response.data;
    final parsedData = rawData is Map<String, dynamic>
        ? rawData
        : rawData is Map
        ? Map<String, dynamic>.from(rawData)
        : <String, dynamic>{
            'updated': response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300,
          };

    return QuickMatchLibraryItemResponse.fromJson(parsedData);
  }

  Future<Response<UpdateLibraryItemMediaResponse>> updateLibraryItemMedia(
    String itemId, {
    required UpdateLibraryItemMediaRequest request,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPatchRequest(
      route: '/api/items/$itemId/media',
      fromJson: (data) => UpdateLibraryItemMediaResponse.fromJson(data),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      bodyData: request.toJson(),
    );
  }

  Future<Response<Map<String, dynamic>>> getLibraryItemMetadataObject(
    String itemId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/items/$itemId/metadata-object',
      fromJson: (data) {
        if (data is Map<String, dynamic>) {
          return data;
        }
        if (data is Map) {
          return Map<String, dynamic>.from(data);
        }
        return <String, dynamic>{};
      },
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: {},
    );
  }

  Future<bool> startEmbedMetadata(
    String itemId, {
    bool backup = false,
    bool forceEmbedChapters = false,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final route = Uri(
      path: '/api/tools/item/$itemId/embed-metadata',
      queryParameters: <String, String>{
        'backup': backup ? '1' : '0',
        if (forceEmbedChapters) 'forceEmbedChapters': '1',
      },
    ).toString();

    final response = await _dio.request<Object>(
      route,
      options: Options(
        method: 'POST',
        headers: <String, dynamic>{...?headers},
        extra: <String, dynamic>{
          'secure': <Map<String, String>>[
            {'type': 'http', 'scheme': 'bearer', 'name': 'BearerAuth'},
          ],
          ...?extra,
        },
        contentType: 'application/json',
      ),
      cancelToken: cancelToken,
    );

    final statusCode = response.statusCode;
    return statusCode != null && statusCode >= 200 && statusCode < 300;
  }

  Future<bool> startEncodeM4b(
    String itemId, {
    required String codec,
    required String bitrate,
    required int channels,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final route = Uri(
      path: '/api/tools/item/$itemId/encode-m4b',
      queryParameters: <String, String>{
        if (codec.trim().isNotEmpty) 'codec': codec.trim(),
        if (bitrate.trim().isNotEmpty) 'bitrate': bitrate.trim(),
        'channels': channels.toString(),
      },
    ).toString();

    final response = await _dio.request<Object>(
      route,
      options: Options(
        method: 'POST',
        headers: <String, dynamic>{...?headers},
        extra: <String, dynamic>{
          'secure': <Map<String, String>>[
            {'type': 'http', 'scheme': 'bearer', 'name': 'BearerAuth'},
          ],
          ...?extra,
        },
        contentType: 'application/json',
      ),
      cancelToken: cancelToken,
    );

    final statusCode = response.statusCode;
    return statusCode != null && statusCode >= 200 && statusCode < 300;
  }

  Future<bool> cancelEncodeM4b(
    String itemId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiDeleteRequest(
      route: '/api/tools/item/$itemId/encode-m4b',
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }

  Widget getLibraryItemCover(String id, {LibraryItem? item, double? width, double? height}) {
    if (item != null && !item.hasCover) {
      return const CoverPlaceholder();
    }

    final uri = _buildCoverUri(id, item: item, width: width, height: height);

    return CachedNetworkImage(
      imageUrl: uri.toString(),
      httpHeaders: Map<String, String>.from(_dio.options.headers),
      width: width,
      height: height,
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 120),
      fadeOutDuration: const Duration(milliseconds: 70),
      placeholder: (context, url) => const CoverLoadingPlaceholder(),
      errorWidget: (context, url, error) => const CoverPlaceholder(),
    );
  }

  Uri getCoverUri(String id, {LibraryItem? item, double? width, double? height}) {
    return _buildCoverUri(id, item: item, width: width, height: height);
  }

  Uri _buildCoverUri(String id, {LibraryItem? item, double? width, double? height}) {
    final queryParams = <String, String>{};

    final widthPx = width?.round();
    if (widthPx != null && widthPx > 0) {
      queryParams['width'] = widthPx.toString();
    }

    final heightPx = height?.round();
    if (heightPx != null && heightPx > 0) {
      queryParams['height'] = heightPx.toString();
    }

    final updatedAt = item?.updatedAt;
    if (updatedAt != null) {
      queryParams['ts'] = updatedAt.toString();
    }

    final base = Uri.parse('${_dio.options.baseUrl}/api/items/$id/cover');
    return queryParams.isEmpty ? base : base.replace(queryParameters: queryParams);
  }
}
