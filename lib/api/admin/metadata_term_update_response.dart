import 'package:freezed_annotation/freezed_annotation.dart';

part 'metadata_term_update_response.freezed.dart';
part 'metadata_term_update_response.g.dart';

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
abstract class MetadataTermUpdateResponse with _$MetadataTermUpdateResponse {
  const factory MetadataTermUpdateResponse({
    @JsonKey(name: 'numItemsUpdated', fromJson: _intFromDynamic) @Default(0) int numItemsUpdated,
    @JsonKey(name: 'tagMerged') bool? tagMerged,
    @JsonKey(name: 'genreMerged') bool? genreMerged,
  }) = _MetadataTermUpdateResponse;

  factory MetadataTermUpdateResponse.fromJson(Map<String, dynamic> json) => _$MetadataTermUpdateResponseFromJson(json);
}
