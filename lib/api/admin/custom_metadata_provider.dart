import 'package:freezed_annotation/freezed_annotation.dart';

part 'custom_metadata_provider.freezed.dart';
part 'custom_metadata_provider.g.dart';

int _intFromDynamic(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}

@freezed
abstract class CustomMetadataProvider with _$CustomMetadataProvider {
  const factory CustomMetadataProvider({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'mediaType') required String mediaType,
    @JsonKey(name: 'url') required String url,
    @JsonKey(name: 'authHeaderValue') String? authHeaderValue,
    @JsonKey(name: 'createdAt', fromJson: _intFromDynamic) @Default(0) int createdAt,
    @JsonKey(name: 'updatedAt', fromJson: _intFromDynamic) @Default(0) int updatedAt,
  }) = _CustomMetadataProvider;

  factory CustomMetadataProvider.fromJson(Map<String, dynamic> json) => _$CustomMetadataProviderFromJson(json);
}
