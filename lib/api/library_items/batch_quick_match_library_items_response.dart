import 'package:freezed_annotation/freezed_annotation.dart';

part 'batch_quick_match_library_items_response.freezed.dart';
part 'batch_quick_match_library_items_response.g.dart';

@freezed
abstract class BatchQuickMatchLibraryItemsResponse with _$BatchQuickMatchLibraryItemsResponse {
  const factory BatchQuickMatchLibraryItemsResponse({
    @JsonKey(name: 'success') @Default(false) bool success,
    @JsonKey(name: 'updates') @JsonKey(fromJson: _intFromDynamic) @Default(0) int updates,
    @JsonKey(name: 'unmatched') @JsonKey(fromJson: _intFromDynamic) @Default(0) int unmatched,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'error') String? error,
  }) = _BatchQuickMatchLibraryItemsResponse;

  factory BatchQuickMatchLibraryItemsResponse.fromJson(Map<String, dynamic> json) =>
      _$BatchQuickMatchLibraryItemsResponseFromJson(json);
}

int _intFromDynamic(Object? value) {
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
