import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/admin/admin_api_key.dart';

part 'admin_api_key_response.freezed.dart';
part 'admin_api_key_response.g.dart';

@freezed
abstract class AdminApiKeyResponse with _$AdminApiKeyResponse {
  const factory AdminApiKeyResponse({@JsonKey(name: 'apiKey') required AdminApiKey apiKey}) = _AdminApiKeyResponse;

  factory AdminApiKeyResponse.fromJson(Map<String, dynamic> json) => _$AdminApiKeyResponseFromJson(json);
}
