import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';

part 'admin_rss_feed.freezed.dart';
part 'admin_rss_feed.g.dart';

@freezed
abstract class AdminRssFeedsResponse with _$AdminRssFeedsResponse {
  const factory AdminRssFeedsResponse({
    @JsonKey(name: 'feeds') @Default(<AdminRssFeed>[]) List<AdminRssFeed> feeds,
    @JsonKey(name: 'minified') @Default(<AdminRssFeedMinified>[]) List<AdminRssFeedMinified> minified,
  }) = _AdminRssFeedsResponse;

  factory AdminRssFeedsResponse.fromJson(Map<String, dynamic> json) => _$AdminRssFeedsResponseFromJson(json);
}

@freezed
abstract class AdminRssFeed with _$AdminRssFeed {
  const AdminRssFeed._();

  const factory AdminRssFeed({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'slug') String? slug,
    @JsonKey(name: 'userId') String? userId,
    @JsonKey(name: 'entityType') String? entityType,
    @JsonKey(name: 'entityId') String? entityId,
    @JsonKey(name: 'entityUpdatedAt') int? entityUpdatedAt,
    @JsonKey(name: 'coverPath') String? coverPath,
    @JsonKey(name: 'meta') AdminRssFeedMeta? meta,
    @JsonKey(name: 'serverAddress') String? serverAddress,
    @JsonKey(name: 'feedUrl') String? feedUrl,
    @JsonKey(name: 'episodes') @Default(<AdminRssFeedEpisode>[]) List<AdminRssFeedEpisode> episodes,
    @JsonKey(name: 'createdAt') int? createdAt,
    @JsonKey(name: 'updatedAt') int? updatedAt,
  }) = _AdminRssFeed;

  factory AdminRssFeed.fromJson(Map<String, dynamic> json) => _$AdminRssFeedFromJson(json);

  DateTime? get updatedDateTime {
    final value = updatedAt;
    if (value == null || value <= 0) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  DateTime? get createdDateTime {
    final value = createdAt;
    if (value == null || value <= 0) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  String get resolvedTitle {
    final metadataTitle = meta?.title?.trim();
    if (metadataTitle != null && metadataTitle.isNotEmpty) {
      return metadataTitle;
    }

    final slugValue = slug?.trim();
    if (slugValue != null && slugValue.isNotEmpty) {
      return slugValue;
    }

    return id;
  }
}

@freezed
abstract class AdminRssFeedMinified with _$AdminRssFeedMinified {
  const factory AdminRssFeedMinified({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'entityType') String? entityType,
    @JsonKey(name: 'entityId') String? entityId,
    @JsonKey(name: 'feedUrl') String? feedUrl,
    @JsonKey(name: 'meta') AdminRssFeedMeta? meta,
  }) = _AdminRssFeedMinified;

  factory AdminRssFeedMinified.fromJson(Map<String, dynamic> json) => _$AdminRssFeedMinifiedFromJson(json);
}

@freezed
abstract class AdminRssFeedMeta with _$AdminRssFeedMeta {
  const factory AdminRssFeedMeta({
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'author') String? author,
    @JsonKey(name: 'imageUrl') String? imageUrl,
    @JsonKey(name: 'feedUrl') String? feedUrl,
    @JsonKey(name: 'link') String? link,
    @JsonKey(name: 'explicit') bool? explicit,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'language') String? language,
    @JsonKey(name: 'preventIndexing') bool? preventIndexing,
    @JsonKey(name: 'ownerName') String? ownerName,
    @JsonKey(name: 'ownerEmail') String? ownerEmail,
  }) = _AdminRssFeedMeta;

  factory AdminRssFeedMeta.fromJson(Map<String, dynamic> json) => _$AdminRssFeedMetaFromJson(json);
}

@freezed
abstract class AdminRssFeedEpisode with _$AdminRssFeedEpisode {
  const factory AdminRssFeedEpisode({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'enclosure') AdminRssFeedEpisodeEnclosure? enclosure,
    @JsonKey(name: 'pubDate') String? pubDate,
    @JsonKey(name: 'link') String? link,
    @JsonKey(name: 'author') String? author,
    @JsonKey(name: 'explicit') bool? explicit,
    @JsonKey(name: 'duration') double? duration,
    @JsonKey(name: 'season') String? season,
    @JsonKey(name: 'episode') String? episode,
    @JsonKey(name: 'episodeType') String? episodeType,
    @JsonKey(name: 'fullPath') String? fullPath,
  }) = _AdminRssFeedEpisode;

  factory AdminRssFeedEpisode.fromJson(Map<String, dynamic> json) => _$AdminRssFeedEpisodeFromJson(json);
}

@freezed
abstract class AdminRssFeedEpisodeEnclosure with _$AdminRssFeedEpisodeEnclosure {
  const factory AdminRssFeedEpisodeEnclosure({
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'size', fromJson: jsonIntFromDynamic) int? size,
    @JsonKey(name: 'type') String? type,
  }) = _AdminRssFeedEpisodeEnclosure;

  factory AdminRssFeedEpisodeEnclosure.fromJson(Map<String, dynamic> json) =>
      _$AdminRssFeedEpisodeEnclosureFromJson(json);
}
