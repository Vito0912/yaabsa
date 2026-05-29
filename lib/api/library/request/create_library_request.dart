import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/library/library_settings.dart';
import 'package:yaabsa/api/library/request/library_folder_payload.dart';

part 'create_library_request.freezed.dart';
part 'create_library_request.g.dart';

@freezed
abstract class CreateLibraryRequest with _$CreateLibraryRequest {
  const factory CreateLibraryRequest({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'folders') required List<LibraryFolderPayload> folders,
    @JsonKey(name: 'provider') String? provider,
    @JsonKey(name: 'icon') String? icon,
    @JsonKey(name: 'mediaType') String? mediaType,
    @JsonKey(name: 'settings') LibrarySettings? settings,
  }) = _CreateLibraryRequest;

  factory CreateLibraryRequest.fromJson(Map<String, dynamic> json) => _$CreateLibraryRequestFromJson(json);
}
