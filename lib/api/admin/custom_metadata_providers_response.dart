import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/admin/custom_metadata_provider.dart';

part 'custom_metadata_providers_response.freezed.dart';
part 'custom_metadata_providers_response.g.dart';

List<CustomMetadataProvider> _providersFromJson(dynamic value) {
  if (value is! List) {
    return const <CustomMetadataProvider>[];
  }

  return value
      .map((entry) {
        if (entry is Map<String, dynamic>) {
          return CustomMetadataProvider.fromJson(entry);
        }
        if (entry is Map) {
          return CustomMetadataProvider.fromJson(Map<String, dynamic>.from(entry));
        }
        return null;
      })
      .whereType<CustomMetadataProvider>()
      .toList(growable: false);
}

@freezed
abstract class CustomMetadataProvidersResponse with _$CustomMetadataProvidersResponse {
  const factory CustomMetadataProvidersResponse({
    @JsonKey(name: 'providers', fromJson: _providersFromJson)
    @Default(<CustomMetadataProvider>[])
    List<CustomMetadataProvider> providers,
  }) = _CustomMetadataProvidersResponse;

  factory CustomMetadataProvidersResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomMetadataProvidersResponseFromJson(json);
}
