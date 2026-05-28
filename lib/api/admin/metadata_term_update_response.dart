import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';

part 'metadata_term_update_response.freezed.dart';
part 'metadata_term_update_response.g.dart';

@freezed
abstract class MetadataTermUpdateResponse with _$MetadataTermUpdateResponse {
  const factory MetadataTermUpdateResponse({
    @JsonKey(name: 'numItemsUpdated', fromJson: jsonIntRequiredFromDynamic) @Default(0) int numItemsUpdated,
    @JsonKey(name: 'tagMerged') bool? tagMerged,
    @JsonKey(name: 'genreMerged') bool? genreMerged,
  }) = _MetadataTermUpdateResponse;

  factory MetadataTermUpdateResponse.fromJson(Map<String, dynamic> json) => _$MetadataTermUpdateResponseFromJson(json);
}
