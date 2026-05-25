import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';

part 'custom_metadata_provider.freezed.dart';
part 'custom_metadata_provider.g.dart';

@freezed
abstract class CustomMetadataProvider with _$CustomMetadataProvider {
  const factory CustomMetadataProvider({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'mediaType') required String mediaType,
    @JsonKey(name: 'url') required String url,
    @JsonKey(name: 'authHeaderValue') String? authHeaderValue,
    @JsonKey(name: 'createdAt', fromJson: jsonIntRequiredFromDynamic) @Default(0) int createdAt,
    @JsonKey(name: 'updatedAt', fromJson: jsonIntRequiredFromDynamic) @Default(0) int updatedAt,
  }) = _CustomMetadataProvider;

  factory CustomMetadataProvider.fromJson(Map<String, dynamic> json) => _$CustomMetadataProviderFromJson(json);
}
