import 'package:dio/dio.dart';
import 'package:yaabsa/api/podcast/library_podcast_title.dart';
import 'package:yaabsa/api/podcast/podcast_feed.dart';
import 'package:yaabsa/api/podcast/podcast_search_result.dart';
import 'package:yaabsa/api/podcast/request/create_podcast_request.dart';
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

    final response = await _dio.post<Map<String, dynamic>>(
      '/api/podcasts/feed',
      data: request.toJson(),
      cancelToken: cancelToken,
      options: Options(headers: headers, extra: {'secure': _secureExtra, ...?extra}),
    );

    final data = response.data;
    if (data == null) {
      return null;
    }

    return PodcastFeedResponse.fromJson(data).podcast;
  }

  Future<List<PodcastSearchResult>> searchPodcasts({
    required String term,
    String? country,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    CancelToken? cancelToken,
  }) async {
    final normalizedTerm = term.trim();
    if (normalizedTerm.isEmpty) {
      return const <PodcastSearchResult>[];
    }

    final query = <String, dynamic>{
      'term': normalizedTerm,
      if (country != null && country.trim().isNotEmpty) 'country': country.trim(),
    };

    final response = await _dio.get<List<dynamic>>(
      '/api/search/podcast',
      queryParameters: query,
      cancelToken: cancelToken,
      options: Options(headers: headers, extra: {'secure': _secureExtra, ...?extra}),
    );

    final data = response.data ?? const <dynamic>[];
    return data
        .whereType<Map>()
        .map((entry) => PodcastSearchResult.fromJson(Map<String, dynamic>.from(entry)))
        .toList(growable: false);
  }

  Future<List<LibraryPodcastTitle>> getLibraryPodcastTitles({
    required String libraryId,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get<List<dynamic>>(
      '/api/libraries/$libraryId/podcast-titles',
      cancelToken: cancelToken,
      options: Options(headers: headers, extra: {'secure': _secureExtra, ...?extra}),
    );

    final data = response.data ?? const <dynamic>[];
    return data
        .whereType<Map>()
        .map((entry) => LibraryPodcastTitle.fromJson(Map<String, dynamic>.from(entry)))
        .toList(growable: false);
  }

  Future<void> createPodcast({
    required CreatePodcastRequest request,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    CancelToken? cancelToken,
  }) async {
    await _dio.post<Object>(
      '/api/podcasts',
      data: request.toJson(),
      cancelToken: cancelToken,
      options: Options(headers: headers, extra: {'secure': _secureExtra, ...?extra}),
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
