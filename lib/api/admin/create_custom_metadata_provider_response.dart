import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/admin/custom_metadata_provider.dart';

part 'create_custom_metadata_provider_response.freezed.dart';
part 'create_custom_metadata_provider_response.g.dart';

CustomMetadataProvider? _providerFromJson(dynamic value) {
  if (value is Map<String, dynamic>) {
    return CustomMetadataProvider.fromJson(value);
  }
  if (value is Map) {
    return CustomMetadataProvider.fromJson(Map<String, dynamic>.from(value));
  }

  return null;
}

@freezed
abstract class CreateCustomMetadataProviderResponse with _$CreateCustomMetadataProviderResponse {
  const factory CreateCustomMetadataProviderResponse({
    @JsonKey(name: 'provider', fromJson: _providerFromJson) CustomMetadataProvider? provider,
  }) = _CreateCustomMetadataProviderResponse;

  factory CreateCustomMetadataProviderResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateCustomMetadataProviderResponseFromJson(json);
}
