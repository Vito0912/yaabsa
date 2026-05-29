import 'package:dio/dio.dart';
import 'package:yaabsa/api/podcast/podcast_feed.dart';
import 'package:yaabsa/api/podcast/request/get_podcast_feed_request.dart';
import 'package:yaabsa/api/routes/abs_api.dart';

class PodcastApi {
  PodcastApi(Dio dio) : _dio = dio;

  final Dio _dio;

  Future<bool> _postStatusOnly({
    required String route,
    required Object? bodyData,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    CancelToken? cancelToken,
  }) async {
    final response = await ABSApi.makeApiPostRequest<bool>(
      route: route,
      fromJson: null,
      bodyData: bodyData,
      returnData: true,
      dio: _dio,
      headers: headers,
      extra: extra,
      cancelToken: cancelToken,
    );

    final statusCode = response.statusCode;
    return statusCode != null && statusCode >= 200 && statusCode < 300;
  }

  Future<Response<PodcastFeedResponse>> getPodcastFeed({
    required String rssFeed,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    CancelToken? cancelToken,
  }) async {
    final request = GetPodcastFeedRequest(rssFeed: rssFeed);

    return ABSApi.makeApiPostRequest(
      route: '/api/podcasts/feed',
      fromJson: (data) => PodcastFeedResponse.fromJson(data as Map<String, dynamic>),
      bodyData: request.toJson(),
      dio: _dio,
      headers: headers,
      extra: extra,
      cancelToken: cancelToken,
    );
  }

  Future<bool> downloadPodcastEpisodes({
    required String libraryItemId,
    required List<PodcastFeedEpisode> episodes,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    CancelToken? cancelToken,
  }) async {
    if (episodes.isEmpty) {
      return true;
    }

    final payload = episodes.map((episode) => episode.toJson()).toList(growable: false);
    return _postStatusOnly(
      route: '/api/podcasts/$libraryItemId/download-episodes',
      bodyData: payload,
      headers: headers,
      extra: extra,
      cancelToken: cancelToken,
    );
  }
}
