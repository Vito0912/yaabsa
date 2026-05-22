import 'package:dio/dio.dart';
import 'package:yaabsa/api/podcast/podcast_feed.dart';
import 'package:yaabsa/api/podcast/request/get_podcast_feed_request.dart';

class PodcastApi {
  PodcastApi(Dio dio) : _dio = dio;

  final Dio _dio;

  static const _secureExtra = [
    {'type': 'http', 'scheme': 'bearer', 'name': 'BearerAuth'},
  ];

  Future<PodcastFeed?> getPodcastFeed({
    required String rssFeed,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    CancelToken? cancelToken,
  }) async {
    final request = GetPodcastFeedRequest(rssFeed: rssFeed);

    final response = await _dio.post<Object>(
      '/api/podcasts/feed',
      data: request.toJson(),
      cancelToken: cancelToken,
      options: Options(headers: headers, extra: {'secure': _secureExtra, ...?extra}),
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      return null;
    }

    return PodcastFeedResponse.fromJson(data).podcast;
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
    final response = await _dio.post<Object>(
      '/api/podcasts/$libraryItemId/download-episodes',
      data: payload,
      cancelToken: cancelToken,
      options: Options(headers: headers, extra: {'secure': _secureExtra, ...?extra}),
    );

    final statusCode = response.statusCode;
    return statusCode != null && statusCode >= 200 && statusCode < 300;
  }
}
