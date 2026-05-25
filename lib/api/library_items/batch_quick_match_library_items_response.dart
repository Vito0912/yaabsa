import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';

part 'batch_quick_match_library_items_response.freezed.dart';
part 'batch_quick_match_library_items_response.g.dart';

@freezed
abstract class BatchQuickMatchLibraryItemsResponse with _$BatchQuickMatchLibraryItemsResponse {
  const factory BatchQuickMatchLibraryItemsResponse({
    @JsonKey(name: 'success') @Default(false) bool success,
    @JsonKey(name: 'updates') @JsonKey(fromJson: jsonIntFromDynamic) @Default(0) int updates,
    @JsonKey(name: 'unmatched') @JsonKey(fromJson: jsonIntFromDynamic) @Default(0) int unmatched,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'error') String? error,
  }) = _BatchQuickMatchLibraryItemsResponse;

  factory BatchQuickMatchLibraryItemsResponse.fromJson(Map<String, dynamic> json) =>
      _$BatchQuickMatchLibraryItemsResponseFromJson(json);
}
