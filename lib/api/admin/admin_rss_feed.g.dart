// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_rss_feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminRssFeedsResponse _$AdminRssFeedsResponseFromJson(Map<String, dynamic> json) => _AdminRssFeedsResponse(
  feeds:
      (json['feeds'] as List<dynamic>?)?.map((e) => AdminRssFeed.fromJson(e as Map<String, dynamic>)).toList() ??
      const <AdminRssFeed>[],
  minified:
      (json['minified'] as List<dynamic>?)
          ?.map((e) => AdminRssFeedMinified.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AdminRssFeedMinified>[],
);

Map<String, dynamic> _$AdminRssFeedsResponseToJson(_AdminRssFeedsResponse instance) => <String, dynamic>{
  'feeds': instance.feeds,
  'minified': instance.minified,
};

_AdminRssFeed _$AdminRssFeedFromJson(Map<String, dynamic> json) => _AdminRssFeed(
  id: json['id'] as String,
  slug: json['slug'] as String?,
  userId: json['userId'] as String?,
  entityType: json['entityType'] as String?,
  entityId: json['entityId'] as String?,
  entityUpdatedAt: (json['entityUpdatedAt'] as num?)?.toInt(),
  coverPath: json['coverPath'] as String?,
  meta: json['meta'] == null ? null : AdminRssFeedMeta.fromJson(json['meta'] as Map<String, dynamic>),
  serverAddress: json['serverAddress'] as String?,
  feedUrl: json['feedUrl'] as String?,
  episodes:
      (json['episodes'] as List<dynamic>?)
          ?.map((e) => AdminRssFeedEpisode.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AdminRssFeedEpisode>[],
  createdAt: (json['createdAt'] as num?)?.toInt(),
  updatedAt: (json['updatedAt'] as num?)?.toInt(),
);

Map<String, dynamic> _$AdminRssFeedToJson(_AdminRssFeed instance) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'userId': instance.userId,
  'entityType': instance.entityType,
  'entityId': instance.entityId,
  'entityUpdatedAt': instance.entityUpdatedAt,
  'coverPath': instance.coverPath,
  'meta': instance.meta,
  'serverAddress': instance.serverAddress,
  'feedUrl': instance.feedUrl,
  'episodes': instance.episodes,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

_AdminRssFeedMinified _$AdminRssFeedMinifiedFromJson(Map<String, dynamic> json) => _AdminRssFeedMinified(
  id: json['id'] as String,
  entityType: json['entityType'] as String?,
  entityId: json['entityId'] as String?,
  feedUrl: json['feedUrl'] as String?,
  meta: json['meta'] == null ? null : AdminRssFeedMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AdminRssFeedMinifiedToJson(_AdminRssFeedMinified instance) => <String, dynamic>{
  'id': instance.id,
  'entityType': instance.entityType,
  'entityId': instance.entityId,
  'feedUrl': instance.feedUrl,
  'meta': instance.meta,
};

_AdminRssFeedMeta _$AdminRssFeedMetaFromJson(Map<String, dynamic> json) => _AdminRssFeedMeta(
  title: json['title'] as String?,
  description: json['description'] as String?,
  author: json['author'] as String?,
  imageUrl: json['imageUrl'] as String?,
  feedUrl: json['feedUrl'] as String?,
  link: json['link'] as String?,
  explicit: json['explicit'] as bool?,
  type: json['type'] as String?,
  language: json['language'] as String?,
  preventIndexing: json['preventIndexing'] as bool?,
  ownerName: json['ownerName'] as String?,
  ownerEmail: json['ownerEmail'] as String?,
);

Map<String, dynamic> _$AdminRssFeedMetaToJson(_AdminRssFeedMeta instance) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'author': instance.author,
  'imageUrl': instance.imageUrl,
  'feedUrl': instance.feedUrl,
  'link': instance.link,
  'explicit': instance.explicit,
  'type': instance.type,
  'language': instance.language,
  'preventIndexing': instance.preventIndexing,
  'ownerName': instance.ownerName,
  'ownerEmail': instance.ownerEmail,
};

_AdminRssFeedEpisode _$AdminRssFeedEpisodeFromJson(Map<String, dynamic> json) => _AdminRssFeedEpisode(
  id: json['id'] as String,
  title: json['title'] as String?,
  description: json['description'] as String?,
  enclosure: json['enclosure'] == null
      ? null
      : AdminRssFeedEpisodeEnclosure.fromJson(json['enclosure'] as Map<String, dynamic>),
  pubDate: json['pubDate'] as String?,
  link: json['link'] as String?,
  author: json['author'] as String?,
  explicit: json['explicit'] as bool?,
  duration: (json['duration'] as num?)?.toDouble(),
  season: json['season'] as String?,
  episode: json['episode'] as String?,
  episodeType: json['episodeType'] as String?,
  fullPath: json['fullPath'] as String?,
);

Map<String, dynamic> _$AdminRssFeedEpisodeToJson(_AdminRssFeedEpisode instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'enclosure': instance.enclosure,
  'pubDate': instance.pubDate,
  'link': instance.link,
  'author': instance.author,
  'explicit': instance.explicit,
  'duration': instance.duration,
  'season': instance.season,
  'episode': instance.episode,
  'episodeType': instance.episodeType,
  'fullPath': instance.fullPath,
};

_AdminRssFeedEpisodeEnclosure _$AdminRssFeedEpisodeEnclosureFromJson(Map<String, dynamic> json) =>
    _AdminRssFeedEpisodeEnclosure(
      url: json['url'] as String?,
      size: jsonIntFromDynamic(json['size']),
      type: json['type'] as String?,
    );

Map<String, dynamic> _$AdminRssFeedEpisodeEnclosureToJson(_AdminRssFeedEpisodeEnclosure instance) => <String, dynamic>{
  'url': instance.url,
  'size': instance.size,
  'type': instance.type,
};
