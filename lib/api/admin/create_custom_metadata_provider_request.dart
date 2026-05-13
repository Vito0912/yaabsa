import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_custom_metadata_provider_request.freezed.dart';
part 'create_custom_metadata_provider_request.g.dart';

@freezed
abstract class CreateCustomMetadataProviderRequest with _$CreateCustomMetadataProviderRequest {
  const factory CreateCustomMetadataProviderRequest({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'url') required String url,
    @JsonKey(name: 'mediaType') required String mediaType,
    @JsonKey(name: 'authHeaderValue') String? authHeaderValue,
  }) = _CreateCustomMetadataProviderRequest;

  factory CreateCustomMetadataProviderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCustomMetadataProviderRequestFromJson(json);
}
