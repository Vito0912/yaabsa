import 'package:freezed_annotation/freezed_annotation.dart';

part 'reorder_library_entry_request.freezed.dart';
part 'reorder_library_entry_request.g.dart';

@freezed
abstract class ReorderLibraryEntryRequest with _$ReorderLibraryEntryRequest {
  const factory ReorderLibraryEntryRequest({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'newOrder') required int newOrder,
  }) = _ReorderLibraryEntryRequest;

  factory ReorderLibraryEntryRequest.fromJson(Map<String, dynamic> json) => _$ReorderLibraryEntryRequestFromJson(json);
}
