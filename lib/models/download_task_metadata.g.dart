// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_task_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DownloadTaskMetadata _$DownloadTaskMetadataFromJson(Map<String, dynamic> json) => _DownloadTaskMetadata(
  itemId: json['itemId'] as String,
  userId: json['userId'] as String,
  episodeId: json['episodeId'] as String?,
  track: json['track'] == null ? null : InternalTrack.fromJson(json['track'] as Map<String, dynamic>),
  expectedFileCount: (json['expectedFileCount'] as num?)?.toInt() ?? 1,
  fileInode: json['fileInode'] as String? ?? '',
  fileIndex: (json['fileIndex'] as num?)?.toInt() ?? 0,
  fileKind: json['fileKind'] as String? ?? 'file',
  fileName: json['fileName'] as String?,
  fileMimeType: json['fileMimeType'] as String?,
  saf: json['saf'] as bool? ?? false,
  downloadBasePath: json['downloadBasePath'] as String?,
  libraryId: json['libraryId'] as String?,
  serverUrl: json['serverUrl'] as String?,
  serverHost: json['serverHost'] as String?,
  serverPort: (json['serverPort'] as num?)?.toInt(),
  serverSsl: json['serverSsl'] as bool?,
  title: json['title'] as String?,
  downloadType: json['downloadType'] as String? ?? 'both',
);

Map<String, dynamic> _$DownloadTaskMetadataToJson(_DownloadTaskMetadata instance) => <String, dynamic>{
  'itemId': instance.itemId,
  'userId': instance.userId,
  'episodeId': instance.episodeId,
  'track': instance.track,
  'expectedFileCount': instance.expectedFileCount,
  'fileInode': instance.fileInode,
  'fileIndex': instance.fileIndex,
  'fileKind': instance.fileKind,
  'fileName': instance.fileName,
  'fileMimeType': instance.fileMimeType,
  'saf': instance.saf,
  'downloadBasePath': instance.downloadBasePath,
  'libraryId': instance.libraryId,
  'serverUrl': instance.serverUrl,
  'serverHost': instance.serverHost,
  'serverPort': instance.serverPort,
  'serverSsl': instance.serverSsl,
  'title': instance.title,
  'downloadType': instance.downloadType,
};
