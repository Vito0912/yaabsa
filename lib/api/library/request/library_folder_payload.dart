import 'package:freezed_annotation/freezed_annotation.dart';

part 'library_folder_payload.freezed.dart';
part 'library_folder_payload.g.dart';

@freezed
abstract class LibraryFolderPayload with _$LibraryFolderPayload {
  @JsonSerializable(includeIfNull: false)
  const factory LibraryFolderPayload({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'fullPath') String? fullPath,
    @JsonKey(name: 'path') String? path,
    @JsonKey(name: 'libraryId') String? libraryId,
    @JsonKey(name: 'addedAt') int? addedAt,
  }) = _LibraryFolderPayload;

  factory LibraryFolderPayload.fromJson(Map<String, dynamic> json) => _$LibraryFolderPayloadFromJson(json);
}
