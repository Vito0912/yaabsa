// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayableRef _$PlayableRefFromJson(Map<String, dynamic> json) =>
    _PlayableRef(itemId: json['itemId'] as String, episodeId: json['episodeId'] as String?);

Map<String, dynamic> _$PlayableRefToJson(_PlayableRef instance) => <String, dynamic>{
  'itemId': instance.itemId,
  'episodeId': instance.episodeId,
};

_MediaSourceDescriptor _$MediaSourceDescriptorFromJson(Map<String, dynamic> json) => _MediaSourceDescriptor(
  type: $enumDecode(_$MediaSourceTypeEnumMap, json['type']),
  sourceId: json['sourceId'] as String,
  libraryId: json['libraryId'] as String,
  displayName: json['displayName'] as String?,
  descending: json['descending'] as bool? ?? false,
  revision: (json['revision'] as num?)?.toInt(),
);

Map<String, dynamic> _$MediaSourceDescriptorToJson(_MediaSourceDescriptor instance) => <String, dynamic>{
  'type': _$MediaSourceTypeEnumMap[instance.type]!,
  'sourceId': instance.sourceId,
  'libraryId': instance.libraryId,
  'displayName': instance.displayName,
  'descending': instance.descending,
  'revision': instance.revision,
};

const _$MediaSourceTypeEnumMap = {
  MediaSourceType.podcast: 'podcast',
  MediaSourceType.series: 'series',
  MediaSourceType.playlist: 'playlist',
  MediaSourceType.collection: 'collection',
};

_QueueCandidate _$QueueCandidateFromJson(Map<String, dynamic> json) => _QueueCandidate(
  ref: PlayableRef.fromJson(json['ref'] as Map<String, dynamic>),
  title: json['title'] as String?,
  subtitle: json['subtitle'] as String?,
  author: json['author'] as String?,
  order: (json['order'] as num?)?.toInt(),
  addedAt: (json['addedAt'] as num?)?.toInt(),
  publishedAt: (json['publishedAt'] as num?)?.toInt(),
  estimatedBytes: (json['estimatedBytes'] as num?)?.toInt(),
  isFinished: json['isFinished'] as bool? ?? false,
);

Map<String, dynamic> _$QueueCandidateToJson(_QueueCandidate instance) => <String, dynamic>{
  'ref': instance.ref,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'author': instance.author,
  'order': instance.order,
  'addedAt': instance.addedAt,
  'publishedAt': instance.publishedAt,
  'estimatedBytes': instance.estimatedBytes,
  'isFinished': instance.isFinished,
};

_CandidatePage _$CandidatePageFromJson(Map<String, dynamic> json) => _CandidatePage(
  candidates:
      (json['candidates'] as List<dynamic>?)?.map((e) => QueueCandidate.fromJson(e as Map<String, dynamic>)).toList() ??
      const <QueueCandidate>[],
  total: (json['total'] as num?)?.toInt(),
  page: (json['page'] as num?)?.toInt(),
  pageSize: (json['pageSize'] as num?)?.toInt(),
  nextCursor: json['nextCursor'] as String?,
  revision: (json['revision'] as num?)?.toInt(),
);

Map<String, dynamic> _$CandidatePageToJson(_CandidatePage instance) => <String, dynamic>{
  'candidates': instance.candidates,
  'total': instance.total,
  'page': instance.page,
  'pageSize': instance.pageSize,
  'nextCursor': instance.nextCursor,
  'revision': instance.revision,
};

_QueueIntentEntry _$QueueIntentEntryFromJson(Map<String, dynamic> json) => _QueueIntentEntry(
  ref: PlayableRef.fromJson(json['ref'] as Map<String, dynamic>),
  title: json['title'] as String?,
  subtitle: json['subtitle'] as String?,
  author: json['author'] as String?,
);

Map<String, dynamic> _$QueueIntentEntryToJson(_QueueIntentEntry instance) => <String, dynamic>{
  'ref': instance.ref,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'author': instance.author,
};

_QueueIntentSnapshot _$QueueIntentSnapshotFromJson(Map<String, dynamic> json) => _QueueIntentSnapshot(
  version: (json['version'] as num?)?.toInt() ?? 1,
  manualEntries:
      (json['manualEntries'] as List<dynamic>?)
          ?.map((e) => QueueIntentEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <QueueIntentEntry>[],
  source: json['source'] == null ? null : MediaSourceDescriptor.fromJson(json['source'] as Map<String, dynamic>),
  anchor: json['anchor'] == null ? null : PlayableRef.fromJson(json['anchor'] as Map<String, dynamic>),
  suppressed:
      (json['suppressed'] as List<dynamic>?)?.map((e) => PlayableRef.fromJson(e as Map<String, dynamic>)).toList() ??
      const <PlayableRef>[],
  sourceRevision: (json['sourceRevision'] as num?)?.toInt(),
);

Map<String, dynamic> _$QueueIntentSnapshotToJson(_QueueIntentSnapshot instance) => <String, dynamic>{
  'version': instance.version,
  'manualEntries': instance.manualEntries,
  'source': instance.source,
  'anchor': instance.anchor,
  'suppressed': instance.suppressed,
  'sourceRevision': instance.sourceRevision,
};
