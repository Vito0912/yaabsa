import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_data.dart';
import 'package:yaabsa/api/library/library.dart';

part 'library_details_response.freezed.dart';
part 'library_details_response.g.dart';

@freezed
abstract class LibraryDetailsResponse with _$LibraryDetailsResponse {
  const factory LibraryDetailsResponse({
    @JsonKey(name: 'filterdata') LibraryFilterData? filterData,
    @JsonKey(name: 'issues') @Default(0) int issues,
    @JsonKey(name: 'numUserPlaylists') @Default(0) int numUserPlaylists,
    @JsonKey(name: 'library') Library? library,
  }) = _LibraryDetailsResponse;

  factory LibraryDetailsResponse.fromJson(Map<String, dynamic> json) => _$LibraryDetailsResponseFromJson(json);
}
