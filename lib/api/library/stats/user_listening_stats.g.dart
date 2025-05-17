// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_listening_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserListeningStats _$UserListeningStatsFromJson(Map<String, dynamic> json) =>
    _UserListeningStats(
      totalTime: (json['totalTime'] as num?)?.toDouble(),
      items: (json['items'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, ItemsListenedTo.fromJson(e as Map<String, dynamic>)),
      ),
      days: (json['days'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      dayOfWeek:
          json['dayOfWeek'] == null
              ? null
              : DaysOfWeek.fromJson(json['dayOfWeek'] as Map<String, dynamic>),
      today: (json['today'] as num?)?.toDouble(),
      recentSessions:
          (json['recentSessions'] as List<dynamic>?)
              ?.map((e) => PlaybackSession.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$UserListeningStatsToJson(_UserListeningStats instance) =>
    <String, dynamic>{
      'totalTime': instance.totalTime,
      'items': instance.items,
      'days': instance.days,
      'dayOfWeek': instance.dayOfWeek,
      'today': instance.today,
      'recentSessions': instance.recentSessions,
    };
