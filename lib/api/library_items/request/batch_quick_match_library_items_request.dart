import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/library_items/request/quick_match_library_item_options.dart';

part 'batch_quick_match_library_items_request.freezed.dart';
part 'batch_quick_match_library_items_request.g.dart';

@freezed
abstract class BatchQuickMatchLibraryItemsRequest with _$BatchQuickMatchLibraryItemsRequest {
  @JsonSerializable(explicitToJson: true, includeIfNull: false)
  const factory BatchQuickMatchLibraryItemsRequest({
    @JsonKey(name: 'libraryItemIds') required List<String> libraryItemIds,
    @JsonKey(name: 'options') required QuickMatchLibraryItemOptions options,
  }) = _BatchQuickMatchLibraryItemsRequest;

  factory BatchQuickMatchLibraryItemsRequest.fromJson(Map<String, dynamic> json) =>
      _$BatchQuickMatchLibraryItemsRequestFromJson(json);
}
