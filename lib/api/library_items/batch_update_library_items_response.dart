import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';

part 'batch_update_library_items_response.freezed.dart';
part 'batch_update_library_items_response.g.dart';

@freezed
abstract class BatchUpdateLibraryItemsResponse with _$BatchUpdateLibraryItemsResponse {
  const factory BatchUpdateLibraryItemsResponse({
    @JsonKey(name: 'success') @Default(false) bool success,
    @JsonKey(name: 'updates', fromJson: jsonIntRequiredFromDynamic) @Default(0) int updates,
  }) = _BatchUpdateLibraryItemsResponse;

  factory BatchUpdateLibraryItemsResponse.fromJson(Map<String, dynamic> json) =>
      _$BatchUpdateLibraryItemsResponseFromJson(json);
}
