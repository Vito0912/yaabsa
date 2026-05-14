import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/library_items/library_item.dart';

part 'quick_match_library_item_response.freezed.dart';
part 'quick_match_library_item_response.g.dart';

@freezed
abstract class QuickMatchLibraryItemResponse with _$QuickMatchLibraryItemResponse {
  const factory QuickMatchLibraryItemResponse({
    @JsonKey(name: 'updated') @Default(false) bool updated,
    @JsonKey(name: 'libraryItem') LibraryItem? libraryItem,
    @JsonKey(name: 'message') String? message,
    @JsonKey(name: 'error') String? error,
  }) = _QuickMatchLibraryItemResponse;

  factory QuickMatchLibraryItemResponse.fromJson(Map<String, dynamic> json) =>
      _$QuickMatchLibraryItemResponseFromJson(json);
}
