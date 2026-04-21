import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_sidecar.freezed.dart';
part 'download_sidecar.g.dart';

@freezed
abstract class DownloadSidecar with _$DownloadSidecar {
  const factory DownloadSidecar({
    @JsonKey(name: 'schemaVersion') @Default(1) int schemaVersion,
    @JsonKey(name: 'itemId') required String itemId,
    @JsonKey(name: 'episodeId') String? episodeId,
    @JsonKey(name: 'libraryId') String? libraryId,
    @JsonKey(name: 'userId') required String userId,
    @JsonKey(name: 'serverId') String? serverId,
    @JsonKey(name: 'serverUrl') String? serverUrl,
    @JsonKey(name: 'serverHost') String? serverHost,
    @JsonKey(name: 'serverPort') int? serverPort,
    @JsonKey(name: 'serverSsl') bool? serverSsl,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'fileInode') String? fileInode,
    @JsonKey(name: 'fileIndex') required int fileIndex,
    @JsonKey(name: 'fileKind') required String fileKind,
    @JsonKey(name: 'fileName') String? fileName,
    @JsonKey(name: 'fileMimeType') String? fileMimeType,
    @JsonKey(name: 'coverPath') String? coverPath,
    @JsonKey(name: 'createdAt') required int createdAtEpochMs,
  }) = _DownloadSidecar;

  factory DownloadSidecar.fromJson(Map<String, dynamic> json) => _$DownloadSidecarFromJson(json);
}
