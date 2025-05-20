// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'internal_media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InternalMedia _$InternalMediaFromJson(Map<String, dynamic> json) => _InternalMedia(
  libraryId: json['libraryId'] as String,
  itemId: json['itemId'] as String,
  episodeId: json['episodeId'] as String?,
  sessionId: json['sessionId'] as String,
  title: json['title'] as String,
  author: json['author'] as String?,
  series: json['series'] as String?,
  seriesPosition: json['seriesPosition'] as String?,
  cover: json['cover'] == null ? null : Uri.parse(json['cover'] as String),
  tracks: (json['tracks'] as List<dynamic>).map((e) => InternalTrack.fromJson(e as Map<String, dynamic>)).toList(),
  chapters:
      (json['chapters'] as List<dynamic>?)?.map((e) => InternalChapter.fromJson(e as Map<String, dynamic>)).toList(),
  duration: (json['duration'] as num?)?.toDouble(),
  local: json['local'] as bool? ?? false,
  saf: json['saf'] as bool,
);

Map<String, dynamic> _$InternalMediaToJson(_InternalMedia instance) => <String, dynamic>{
  'libraryId': instance.libraryId,
  'itemId': instance.itemId,
  'episodeId': instance.episodeId,
  'sessionId': instance.sessionId,
  'title': instance.title,
  'author': instance.author,
  'series': instance.series,
  'seriesPosition': instance.seriesPosition,
  'cover': instance.cover?.toString(),
  'tracks': instance.tracks,
  'chapters': instance.chapters,
  'duration': instance.duration,
  'local': instance.local,
  'saf': instance.saf,
};

_InternalTrack _$InternalTrackFromJson(Map<String, dynamic> json) => _InternalTrack(
  index: (json['index'] as num).toInt(),
  duration: (json['duration'] as num).toDouble(),
  url: json['url'] as String,
  mimeType: json['mimeType'] as String,
  start: (json['start'] as num?)?.toDouble(),
  end: (json['end'] as num?)?.toDouble(),
);

Map<String, dynamic> _$InternalTrackToJson(_InternalTrack instance) => <String, dynamic>{
  'index': instance.index,
  'duration': instance.duration,
  'url': instance.url,
  'mimeType': instance.mimeType,
  'start': instance.start,
  'end': instance.end,
};

_InternalChapter _$InternalChapterFromJson(Map<String, dynamic> json) => _InternalChapter(
  start: (json['start'] as num).toDouble(),
  end: (json['end'] as num).toDouble(),
  title: json['title'] as String,
);

Map<String, dynamic> _$InternalChapterToJson(_InternalChapter instance) => <String, dynamic>{
  'start': instance.start,
  'end': instance.end,
  'title': instance.title,
};

_QueueItem _$QueueItemFromJson(Map<String, dynamic> json) =>
    _QueueItem(itemId: json['itemId'] as String, episodeId: json['episodeId'] as String?);

Map<String, dynamic> _$QueueItemToJson(_QueueItem instance) => <String, dynamic>{
  'itemId': instance.itemId,
  'episodeId': instance.episodeId,
};
