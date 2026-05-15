import 'package:freezed_annotation/freezed_annotation.dart';

part 'quick_match_library_item_options.freezed.dart';
part 'quick_match_library_item_options.g.dart';

@freezed
abstract class QuickMatchLibraryItemOptions with _$QuickMatchLibraryItemOptions {
  @JsonSerializable(includeIfNull: false)
  const factory QuickMatchLibraryItemOptions({
    @JsonKey(name: 'provider') String? provider,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'author') String? author,
    @JsonKey(name: 'isbn') String? isbn,
    @JsonKey(name: 'asin') String? asin,
    @JsonKey(name: 'overrideCover') @Default(true) bool overrideCover,
    @JsonKey(name: 'overrideDetails') @Default(true) bool overrideDetails,
  }) = _QuickMatchLibraryItemOptions;

  factory QuickMatchLibraryItemOptions.fromJson(Map<String, dynamic> json) =>
      _$QuickMatchLibraryItemOptionsFromJson(json);
}
