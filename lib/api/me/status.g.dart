// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServerStatus _$ServerStatusFromJson(Map<String, dynamic> json) =>
    _ServerStatus(
      app: json['app'] as String,
      serverVersion: json['serverVersion'] as String,
      isInit: json['isInit'] as bool,
      language: json['language'] as String,
      authMethods:
          (json['authMethods'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      authFormData: json['authFormData'] == null
          ? null
          : AuthFormData.fromJson(json['authFormData'] as Map<String, dynamic>),
      configPath: json['ConfigPath'] as String?,
      metadataPath: json['MetadataPath'] as String?,
    );

Map<String, dynamic> _$ServerStatusToJson(_ServerStatus instance) =>
    <String, dynamic>{
      'app': instance.app,
      'serverVersion': instance.serverVersion,
      'isInit': instance.isInit,
      'language': instance.language,
      'authMethods': instance.authMethods,
      'authFormData': instance.authFormData,
      'ConfigPath': instance.configPath,
      'MetadataPath': instance.metadataPath,
    };

_AuthFormData _$AuthFormDataFromJson(Map<String, dynamic> json) =>
    _AuthFormData(
      authLoginCustomMessage: json['authLoginCustomMessage'] as String?,
      authOpenIDButtonText: json['authOpenIDButtonText'] as String?,
      authOpenIDAutoLaunch: json['authOpenIDAutoLaunch'] as bool?,
    );

Map<String, dynamic> _$AuthFormDataToJson(_AuthFormData instance) =>
    <String, dynamic>{
      'authLoginCustomMessage': instance.authLoginCustomMessage,
      'authOpenIDButtonText': instance.authOpenIDButtonText,
      'authOpenIDAutoLaunch': instance.authOpenIDAutoLaunch,
    };
