import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_admin_api_key_request.freezed.dart';
part 'update_admin_api_key_request.g.dart';

@freezed
abstract class UpdateAdminApiKeyRequest with _$UpdateAdminApiKeyRequest {
  const factory UpdateAdminApiKeyRequest({
    @JsonKey(name: 'userId') String? userId,
    @JsonKey(name: 'isActive') bool? isActive,
  }) = _UpdateAdminApiKeyRequest;

  factory UpdateAdminApiKeyRequest.fromJson(Map<String, dynamic> json) => _$UpdateAdminApiKeyRequestFromJson(json);
}
