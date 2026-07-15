import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/models/internal_media.dart';

part 'download_task_metadata.freezed.dart';
part 'download_task_metadata.g.dart';

@freezed
abstract class DownloadTaskMetadata with _$DownloadTaskMetadata {
  const factory DownloadTaskMetadata({
    required String itemId,
    required String userId,
    String? episodeId,
    InternalTrack? track,
    @Default(1) int expectedFileCount,
    @Default('') String fileInode,
    @Default(0) int fileIndex,
    @Default('file') String fileKind,
    String? fileName,
    String? fileMimeType,
    @Default(false) bool saf,
    String? downloadBasePath,
    String? libraryId,
    String? serverUrl,
    String? serverHost,
    int? serverPort,
    bool? serverSsl,
    String? title,
    @Default('both') String downloadType,
  }) = _DownloadTaskMetadata;

  factory DownloadTaskMetadata.fromJson(Map<String, dynamic> json) => _$DownloadTaskMetadataFromJson(json);
}
