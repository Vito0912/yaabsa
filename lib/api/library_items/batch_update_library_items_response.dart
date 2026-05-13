import 'package:freezed_annotation/freezed_annotation.dart';

part 'batch_update_library_items_response.freezed.dart';
part 'batch_update_library_items_response.g.dart';

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
abstract class BatchUpdateLibraryItemsResponse with _$BatchUpdateLibraryItemsResponse {
  const factory BatchUpdateLibraryItemsResponse({
    @JsonKey(name: 'success') @Default(false) bool success,
    @JsonKey(name: 'updates', fromJson: _intFromDynamic) @Default(0) int updates,
  }) = _BatchUpdateLibraryItemsResponse;

  factory BatchUpdateLibraryItemsResponse.fromJson(Map<String, dynamic> json) =>
      _$BatchUpdateLibraryItemsResponseFromJson(json);
}
