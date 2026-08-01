// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_episodes_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecentEpisodesResponse _$RecentEpisodesResponseFromJson(Map<String, dynamic> json) => _RecentEpisodesResponse(
  episodes:
      (json['episodes'] as List<dynamic>?)?.map((e) => Episode.fromJson(e as Map<String, dynamic>)).toList() ??
      const <Episode>[],
  limit: json['limit'] == null ? 0 : jsonIntRequiredFromDynamic(json['limit']),
  page: json['page'] == null ? 0 : jsonIntRequiredFromDynamic(json['page']),
);

Map<String, dynamic> _$RecentEpisodesResponseToJson(_RecentEpisodesResponse instance) => <String, dynamic>{
  'episodes': instance.episodes,
  'limit': instance.limit,
  'page': instance.page,
};
