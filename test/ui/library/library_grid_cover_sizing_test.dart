import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/api/routes/library_item_api.dart';
import 'package:yaabsa/components/app/library/library_items_grid.dart';

void main() {
  test('library grid cover cache size follows tile width and device pixel ratio', () {
    expect(libraryGridCoverCacheSize(tileWidth: 176, devicePixelRatio: 1), 160);
    expect(libraryGridCoverCacheSize(tileWidth: 176, devicePixelRatio: 1.25), 200);
    expect(libraryGridCoverCacheSize(tileWidth: 176, devicePixelRatio: 2), 320);
    expect(libraryGridCoverCacheSize(tileWidth: 140, devicePixelRatio: 2), 248);
  });

  test('cover keeps its logical layout size while requesting a pixel-sized image', () {
    final api = LibraryItemApi(Dio(BaseOptions(baseUrl: 'https://audiobookshelf.example')));
    final cover = api.getLibraryItemCover('library-item', width: 160, height: 160, cacheWidth: 320, cacheHeight: 320);

    expect(cover, isA<CachedNetworkImage>());
    final image = cover as CachedNetworkImage;
    final requestUri = Uri.parse(image.imageUrl);

    expect(image.width, 160);
    expect(image.height, 160);
    expect(image.memCacheWidth, 320);
    expect(image.memCacheHeight, 320);
    expect(requestUri.queryParameters['width'], '320');
    expect(requestUri.queryParameters['height'], '320');
  });
}
