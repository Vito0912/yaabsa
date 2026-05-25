import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';
import 'package:yaabsa/api/library_items/library_item.dart';

part 'update_library_item_media_response.freezed.dart';
part 'update_library_item_media_response.g.dart';

@freezed
abstract class UpdateLibraryItemMediaResponse with _$UpdateLibraryItemMediaResponse {
  const factory UpdateLibraryItemMediaResponse({
    @JsonKey(name: 'updated') @Default(false) bool updated,
    @JsonKey(name: 'libraryItem') LibraryItem? libraryItem,
  }) = _UpdateLibraryItemMediaResponse;

  factory UpdateLibraryItemMediaResponse.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    normalized['updated'] = jsonBoolRequiredFromDynamic(json['updated']);
    return _$UpdateLibraryItemMediaResponseFromJson(normalized);
  }
}
