import 'dart:io';

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

  Future<bool> _postStatusOnly({
    required String route,
    required Object? bodyData,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final response = await ABSApi.makeApiPostRequest<bool>(
      route: route,
      fromJson: null,
      bodyData: bodyData,
      returnData: true,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );

    final statusCode = response.statusCode;
    return statusCode != null && statusCode >= 200 && statusCode < 300;
  }

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

    return _postStatusOnly(
      route: '/api/items/batch/delete?hard=${hardDelete ? 1 : 0}',
      bodyData: <String, dynamic>{'libraryItemIds': libraryItemIds},
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
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

    final response = await ABSApi.makeApiPostRequest<BatchUpdateLibraryItemsResponse>(
      route: '/api/items/batch/update',
      fromJson: (data) => BatchUpdateLibraryItemsResponse.fromJson(data as Map<String, dynamic>),
      bodyData: requestBody,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );

    return response.data ?? const BatchUpdateLibraryItemsResponse(success: false, updates: 0);
  }

  Future<bool> batchQuickMatchLibraryItems({
    required BatchQuickMatchLibraryItemsRequest request,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    if (request.libraryItemIds.isEmpty) {
      return true;
    }

    return _postStatusOnly(
      route: '/api/items/batch/quickmatch',
      bodyData: request.toJson(),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<QuickMatchLibraryItemResponse> quickMatchLibraryItem(
    String itemId, {
    required QuickMatchLibraryItemOptions request,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final response = await ABSApi.makeApiPostRequest<QuickMatchLibraryItemResponse>(
      route: '/api/items/$itemId/match',
      fromJson: (data) => QuickMatchLibraryItemResponse.fromJson(data as Map<String, dynamic>),
      bodyData: request.toJson(),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );

    return response.data ?? const QuickMatchLibraryItemResponse();
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
      fromJson: (data) => data as Map<String, dynamic>,
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

    return _postStatusOnly(
      route: route,
      bodyData: const <String, dynamic>{},
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
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

    return _postStatusOnly(
      route: route,
      bodyData: const <String, dynamic>{},
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
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

    final localCoverUri = _resolveLocalCoverUri(item);
    final localCoverPath = localCoverUri == null ? null : _toLocalFilePath(localCoverUri);
    if (localCoverPath != null) {
      return Image.file(
        File(localCoverPath),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const CoverPlaceholder(),
      );
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
    final localCoverUri = _resolveLocalCoverUri(item);
    if (localCoverUri != null) {
      return localCoverUri;
    }

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

  Uri? _resolveLocalCoverUri(LibraryItem? item) {
    final rawCoverPath = item?.coverPath?.trim();
    if (rawCoverPath == null || rawCoverPath.isEmpty) {
      return null;
    }

    if (Platform.isWindows && RegExp(r'^[a-zA-Z]:[\\/]').hasMatch(rawCoverPath)) {
      final file = File(rawCoverPath);
      if (file.existsSync()) {
        return file.uri;
      }
      return null;
    }

    final parsed = Uri.tryParse(rawCoverPath);
    if (parsed == null) {
      return null;
    }

    if (parsed.scheme.isEmpty) {
      final file = File(rawCoverPath);
      if (file.existsSync()) {
        return file.uri;
      }
      return null;
    }

    if (parsed.scheme == 'file' || parsed.scheme == 'content' || parsed.scheme == 'urlbookmark') {
      return parsed;
    }

    return null;
  }

  String? _toLocalFilePath(Uri uri) {
    if (uri.scheme == 'file') {
      try {
        return uri.toFilePath(windows: Platform.isWindows);
      } catch (_) {
        return null;
      }
    }

    if (uri.scheme.isEmpty) {
      final path = uri.toString();
      return path.isEmpty ? null : path;
    }

    return null;
  }
}
