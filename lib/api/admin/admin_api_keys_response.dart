import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/admin/admin_api_key.dart';

part 'admin_api_keys_response.freezed.dart';
part 'admin_api_keys_response.g.dart';

@freezed
abstract class AdminApiKeysResponse with _$AdminApiKeysResponse {
  const factory AdminApiKeysResponse({@JsonKey(name: 'apiKeys') @Default(<AdminApiKey>[]) List<AdminApiKey> apiKeys}) =
      _AdminApiKeysResponse;

  factory AdminApiKeysResponse.fromJson(Map<String, dynamic> json) => _$AdminApiKeysResponseFromJson(json);
}
