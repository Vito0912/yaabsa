import 'package:dio/dio.dart';
import 'package:yaabsa/api/podcast/library_podcast_title.dart';
import 'package:yaabsa/api/podcast/podcast_feed.dart';
import 'package:yaabsa/api/podcast/podcast_search_result.dart';
import 'package:yaabsa/api/podcast/request/create_podcast_request.dart';
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

    final response = await ABSApi.makeApiGetRequest<List<PodcastSearchResult>>(
      route: '/api/search/podcast',
      fromJson: (data) {
        final list = data is List ? data : const <dynamic>[];
        return list
            .whereType<Map>()
            .map((entry) => PodcastSearchResult.fromJson(Map<String, dynamic>.from(entry)))
            .toList(growable: false);
      },
      queryParams: query,
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );

    return response.data ?? const <PodcastSearchResult>[];
  }

  Future<List<LibraryPodcastTitle>> getLibraryPodcastTitles({
    required String libraryId,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    CancelToken? cancelToken,
  }) async {
    final response = await ABSApi.makeApiGetRequest<List<LibraryPodcastTitle>>(
      route: '/api/libraries/$libraryId/podcast-titles',
      fromJson: (data) {
        final list = data is List ? data : const <dynamic>[];
        return list
            .whereType<Map>()
            .map((entry) => LibraryPodcastTitle.fromJson(Map<String, dynamic>.from(entry)))
            .toList(growable: false);
      },
      queryParams: <String, dynamic>{},
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
    return response.data ?? const <LibraryPodcastTitle>[];
  }

  Future<void> createPodcast({
    required CreatePodcastRequest request,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    CancelToken? cancelToken,
  }) async {
    await ABSApi.makeApiPostRequest<void>(
      route: '/api/podcasts',
      fromJson: null,
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
