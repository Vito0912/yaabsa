// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Login _$LoginFromJson(Map<String, dynamic> json) => _Login(
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  userDefaultLibraryId: json['userDefaultLibraryId'] as String,
  serverSettings: ServerSettings.fromJson(
    json['serverSettings'] as Map<String, dynamic>,
  ),
  source: json['Source'] as String,
);

Map<String, dynamic> _$LoginToJson(_Login instance) => <String, dynamic>{
  'user': instance.user,
  'userDefaultLibraryId': instance.userDefaultLibraryId,
  'serverSettings': instance.serverSettings,
  'Source': instance.source,
};
