part of 'library_item_api.dart';

mixin LibraryItemApiCover {
  Dio get _dio;

  Widget getLibraryItemCover(
    String id, {
    LibraryItem? item,
    double? width,
    double? height,
    double? cacheWidth,
    double? cacheHeight,
  }) {
    if (item != null && !item.hasCover) {
      return const CoverPlaceholder();
    }

    final localCoverUri = _resolveLocalCoverUri(item);
    if (!kIsWeb && localCoverUri != null) {
      return LocalCoverImage(
        coverPath: localCoverUri.toString(),
        cacheKey: 'library-item:$id',
        placeholder: const CoverPlaceholder(),
        width: width,
        height: height,
        cacheWidth: cacheWidth?.round(),
        cacheHeight: cacheHeight?.round(),
        fit: BoxFit.cover,
      );
    }

    final uri = _buildCoverUri(id, item: item, width: cacheWidth ?? width, height: cacheHeight ?? height);

    return CachedNetworkImage(
      imageUrl: uri.toString(),
      httpHeaders: Map<String, String>.from(_dio.options.headers),
      width: width,
      height: height,
      memCacheWidth: cacheWidth?.round(),
      memCacheHeight: cacheHeight?.round(),
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 120),
      fadeOutDuration: const Duration(milliseconds: 70),
      placeholder: (context, url) => const CoverLoadingPlaceholder(),
      errorBuilder: (context, url, error) => const CoverPlaceholder(),
    );
  }

  Uri getCoverUri(String id, {LibraryItem? item, double? width, double? height, bool raw = false}) {
    return _buildCoverUri(id, item: item, width: width, height: height, raw: raw);
  }

  Uri _buildCoverUri(String id, {LibraryItem? item, double? width, double? height, bool raw = false}) {
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

    if (raw == true) {
      assert(width == null && height == null, 'Raw cover request should not include width or height');
      queryParams['raw'] = '1';
    }

    final updatedAt = item?.updatedAt;
    if (updatedAt != null) {
      queryParams['ts'] = updatedAt.toString();
    }

    final base = Uri.parse('${_dio.options.baseUrl}/api/items/$id/cover');
    return queryParams.isEmpty ? base : base.replace(queryParameters: queryParams);
  }

  Uri? _resolveLocalCoverUri(LibraryItem? item) {
    if (kIsWeb) {
      return null;
    }

    final rawCoverPath = item?.coverPath?.trim();
    if (rawCoverPath == null || rawCoverPath.isEmpty) {
      return null;
    }

    if (!kIsWeb && Platform.isWindows && RegExp(r'^[a-zA-Z]:[\\/]').hasMatch(rawCoverPath)) {
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
}
