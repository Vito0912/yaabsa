// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user_permissions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminUserPermissions _$AdminUserPermissionsFromJson(Map<String, dynamic> json) => _AdminUserPermissions(
  download: json['download'] as bool? ?? true,
  update: json['update'] as bool? ?? false,
  delete: json['delete'] as bool? ?? false,
  upload: json['upload'] as bool? ?? false,
  createEreader: json['createEreader'] as bool? ?? false,
  accessAllLibraries: json['accessAllLibraries'] as bool? ?? true,
  accessAllTags: json['accessAllTags'] as bool? ?? true,
  accessExplicitContent: json['accessExplicitContent'] as bool? ?? false,
  selectedTagsNotAccessible: json['selectedTagsNotAccessible'] as bool? ?? false,
  librariesAccessible:
      (json['librariesAccessible'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  itemTagsSelected: (json['itemTagsSelected'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
);

Map<String, dynamic> _$AdminUserPermissionsToJson(_AdminUserPermissions instance) => <String, dynamic>{
  'download': instance.download,
  'update': instance.update,
  'delete': instance.delete,
  'upload': instance.upload,
  'createEreader': instance.createEreader,
  'accessAllLibraries': instance.accessAllLibraries,
  'accessAllTags': instance.accessAllTags,
  'accessExplicitContent': instance.accessExplicitContent,
  'selectedTagsNotAccessible': instance.selectedTagsNotAccessible,
  'librariesAccessible': instance.librariesAccessible,
  'itemTagsSelected': instance.itemTagsSelected,
};
