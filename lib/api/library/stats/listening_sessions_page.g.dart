// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listening_sessions_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ListeningSessionsPage _$ListeningSessionsPageFromJson(Map<String, dynamic> json) => _ListeningSessionsPage(
  total: (json['total'] as num?)?.toInt(),
  numPages: (json['numPages'] as num?)?.toInt(),
  page: (json['page'] as num?)?.toInt(),
  itemsPerPage: (json['itemsPerPage'] as num?)?.toInt(),
  sessions:
      (json['sessions'] as List<dynamic>?)?.map((e) => PlaybackSession.fromJson(e as Map<String, dynamic>)).toList() ??
      const <PlaybackSession>[],
);

Map<String, dynamic> _$ListeningSessionsPageToJson(_ListeningSessionsPage instance) => <String, dynamic>{
  'total': instance.total,
  'numPages': instance.numPages,
  'page': instance.page,
  'itemsPerPage': instance.itemsPerPage,
  'sessions': instance.sessions,
};
