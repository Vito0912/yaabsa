import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_admin_api_key_request.freezed.dart';
part 'create_admin_api_key_request.g.dart';

@freezed
abstract class CreateAdminApiKeyRequest with _$CreateAdminApiKeyRequest {
  const factory CreateAdminApiKeyRequest({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'userId') required String userId,
    @JsonKey(name: 'expiresIn') int? expiresIn,
    @JsonKey(name: 'isActive') @Default(true) bool isActive,
  }) = _CreateAdminApiKeyRequest;

  factory CreateAdminApiKeyRequest.fromJson(Map<String, dynamic> json) => _$CreateAdminApiKeyRequestFromJson(json);
}
