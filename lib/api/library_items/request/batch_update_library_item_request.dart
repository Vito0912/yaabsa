import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/library_items/request/update_library_item_media_request.dart';

part 'batch_update_library_item_request.freezed.dart';
part 'batch_update_library_item_request.g.dart';

@freezed
abstract class BatchUpdateLibraryItemRequest with _$BatchUpdateLibraryItemRequest {
  @JsonSerializable(includeIfNull: false, explicitToJson: true)
  const factory BatchUpdateLibraryItemRequest({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'mediaPayload') required UpdateLibraryItemMediaRequest mediaPayload,
  }) = _BatchUpdateLibraryItemRequest;

  factory BatchUpdateLibraryItemRequest.fromJson(Map<String, dynamic> json) =>
      _$BatchUpdateLibraryItemRequestFromJson(json);
}
