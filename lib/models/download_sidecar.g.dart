// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_sidecar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DownloadSidecar _$DownloadSidecarFromJson(Map<String, dynamic> json) => _DownloadSidecar(
  schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
  itemId: json['itemId'] as String,
  episodeId: json['episodeId'] as String?,
  libraryId: json['libraryId'] as String?,
  userId: json['userId'] as String,
  serverId: json['serverId'] as String?,
  serverUrl: json['serverUrl'] as String?,
  serverHost: json['serverHost'] as String?,
  serverPort: (json['serverPort'] as num?)?.toInt(),
  serverSsl: json['serverSsl'] as bool?,
  title: json['title'] as String?,
  fileInode: json['fileInode'] as String?,
  fileIndex: (json['fileIndex'] as num).toInt(),
  fileKind: json['fileKind'] as String,
  fileName: json['fileName'] as String?,
  fileMimeType: json['fileMimeType'] as String?,
  coverPath: json['coverPath'] as String?,
  createdAtEpochMs: (json['createdAt'] as num).toInt(),
);

Map<String, dynamic> _$DownloadSidecarToJson(_DownloadSidecar instance) => <String, dynamic>{
  'schemaVersion': instance.schemaVersion,
  'itemId': instance.itemId,
  'episodeId': instance.episodeId,
  'libraryId': instance.libraryId,
  'userId': instance.userId,
  'serverId': instance.serverId,
  'serverUrl': instance.serverUrl,
  'serverHost': instance.serverHost,
  'serverPort': instance.serverPort,
  'serverSsl': instance.serverSsl,
  'title': instance.title,
  'fileInode': instance.fileInode,
  'fileIndex': instance.fileIndex,
  'fileKind': instance.fileKind,
  'fileName': instance.fileName,
  'fileMimeType': instance.fileMimeType,
  'coverPath': instance.coverPath,
  'createdAt': instance.createdAtEpochMs,
};
