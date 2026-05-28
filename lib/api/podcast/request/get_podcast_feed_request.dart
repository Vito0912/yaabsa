import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_podcast_feed_request.freezed.dart';
part 'get_podcast_feed_request.g.dart';

@freezed
abstract class GetPodcastFeedRequest with _$GetPodcastFeedRequest {
  const factory GetPodcastFeedRequest({@JsonKey(name: 'rssFeed') required String rssFeed}) = _GetPodcastFeedRequest;

  factory GetPodcastFeedRequest.fromJson(Map<String, dynamic> json) => _$GetPodcastFeedRequestFromJson(json);
}
