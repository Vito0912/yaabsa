// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_feed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PodcastFeedResponse _$PodcastFeedResponseFromJson(Map<String, dynamic> json) =>
    _PodcastFeedResponse(podcast: PodcastFeed.fromJson(json['podcast'] as Map<String, dynamic>));

Map<String, dynamic> _$PodcastFeedResponseToJson(_PodcastFeedResponse instance) => <String, dynamic>{
  'podcast': instance.podcast,
};

_PodcastFeed _$PodcastFeedFromJson(Map<String, dynamic> json) => _PodcastFeed(
  metadata: PodcastFeedMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
  episodes:
      (json['episodes'] as List<dynamic>?)
          ?.map((e) => PodcastFeedEpisode.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PodcastFeedEpisode>[],
  numEpisodes: jsonIntFromDynamic(json['numEpisodes']),
);

Map<String, dynamic> _$PodcastFeedToJson(_PodcastFeed instance) => <String, dynamic>{
  'metadata': instance.metadata,
  'episodes': instance.episodes,
  'numEpisodes': instance.numEpisodes,
};

_PodcastFeedMetadata _$PodcastFeedMetadataFromJson(Map<String, dynamic> json) => _PodcastFeedMetadata(
  title: json['title'] as String?,
  language: json['language'] as String?,
  explicit: json['explicit'] as String?,
  author: json['author'] as String?,
  pubDate: json['pubDate'] as String?,
  link: json['link'] as String?,
  image: json['image'] as String?,
  categories: (json['categories'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  feedUrl: json['feedUrl'] as String?,
  description: json['description'] as String?,
  descriptionPlain: json['descriptionPlain'] as String?,
  type: json['type'] as String?,
);

Map<String, dynamic> _$PodcastFeedMetadataToJson(_PodcastFeedMetadata instance) => <String, dynamic>{
  'title': instance.title,
  'language': instance.language,
  'explicit': instance.explicit,
  'author': instance.author,
  'pubDate': instance.pubDate,
  'link': instance.link,
  'image': instance.image,
  'categories': instance.categories,
  'feedUrl': instance.feedUrl,
  'description': instance.description,
  'descriptionPlain': instance.descriptionPlain,
  'type': instance.type,
};

_PodcastFeedEpisode _$PodcastFeedEpisodeFromJson(Map<String, dynamic> json) => _PodcastFeedEpisode(
  title: json['title'] as String?,
  subtitle: json['subtitle'] as String?,
  description: json['description'] as String?,
  descriptionPlain: json['descriptionPlain'] as String?,
  pubDate: json['pubDate'] as String?,
  episodeType: json['episodeType'] as String?,
  season: json['season'] as String?,
  episode: json['episode'] as String?,
  author: json['author'] as String?,
  duration: json['duration'] as String?,
  durationSeconds: jsonIntFromDynamic(json['durationSeconds']),
  explicit: json['explicit'] as String?,
  publishedAt: jsonIntFromDynamic(json['publishedAt']),
  enclosure: json['enclosure'] == null
      ? null
      : PodcastFeedEpisodeEnclosure.fromJson(json['enclosure'] as Map<String, dynamic>),
  guid: json['guid'] as String?,
  chaptersUrl: json['chaptersUrl'] as String?,
  chaptersType: json['chaptersType'] as String?,
  chapters:
      (json['chapters'] as List<dynamic>?)
          ?.map((e) => PodcastFeedEpisodeChapter.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PodcastFeedEpisodeChapter>[],
);

Map<String, dynamic> _$PodcastFeedEpisodeToJson(_PodcastFeedEpisode instance) => <String, dynamic>{
  'title': instance.title,
  'subtitle': instance.subtitle,
  'description': instance.description,
  'descriptionPlain': instance.descriptionPlain,
  'pubDate': instance.pubDate,
  'episodeType': instance.episodeType,
  'season': instance.season,
  'episode': instance.episode,
  'author': instance.author,
  'duration': instance.duration,
  'durationSeconds': instance.durationSeconds,
  'explicit': instance.explicit,
  'publishedAt': instance.publishedAt,
  'enclosure': instance.enclosure,
  'guid': instance.guid,
  'chaptersUrl': instance.chaptersUrl,
  'chaptersType': instance.chaptersType,
  'chapters': instance.chapters,
};

_PodcastFeedEpisodeEnclosure _$PodcastFeedEpisodeEnclosureFromJson(Map<String, dynamic> json) =>
    _PodcastFeedEpisodeEnclosure(
      url: json['url'] as String?,
      type: json['type'] as String?,
      length: jsonIntFromDynamic(json['length']),
    );

Map<String, dynamic> _$PodcastFeedEpisodeEnclosureToJson(_PodcastFeedEpisodeEnclosure instance) => <String, dynamic>{
  'url': instance.url,
  'type': instance.type,
  'length': instance.length,
};

_PodcastFeedEpisodeChapter _$PodcastFeedEpisodeChapterFromJson(Map<String, dynamic> json) =>
    _PodcastFeedEpisodeChapter(title: json['title'] as String?, start: jsonDoubleFromDynamic(json['start']));

Map<String, dynamic> _$PodcastFeedEpisodeChapterToJson(_PodcastFeedEpisodeChapter instance) => <String, dynamic>{
  'title': instance.title,
  'start': instance.start,
};
