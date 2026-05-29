import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/library/request/library_folder_payload.dart';
import 'package:yaabsa/api/library/request/update_library_settings_request.dart';

part 'update_library_request.freezed.dart';
part 'update_library_request.g.dart';

@freezed
abstract class UpdateLibraryRequest with _$UpdateLibraryRequest {
  @JsonSerializable(includeIfNull: false)
  const factory UpdateLibraryRequest({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'displayOrder') int? displayOrder,
    @JsonKey(name: 'icon') String? icon,
    @JsonKey(name: 'mediaType') String? mediaType,
    @JsonKey(name: 'provider') String? provider,
    @JsonKey(name: 'settings') UpdateLibrarySettingsRequest? settings,
    @JsonKey(name: 'folders') List<LibraryFolderPayload>? folders,
  }) = _UpdateLibraryRequest;

  factory UpdateLibraryRequest.fromJson(Map<String, dynamic> json) => _$UpdateLibraryRequestFromJson(json);
}
