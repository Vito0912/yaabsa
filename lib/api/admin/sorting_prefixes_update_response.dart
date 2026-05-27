import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/me/server_settings.dart';

part 'sorting_prefixes_update_response.freezed.dart';
part 'sorting_prefixes_update_response.g.dart';

@freezed
abstract class SortingPrefixesUpdateResponse with _$SortingPrefixesUpdateResponse {
  const factory SortingPrefixesUpdateResponse({
    @JsonKey(name: 'rowsUpdated') required int rowsUpdated,
    @JsonKey(name: 'serverSettings') required ServerSettings serverSettings,
  }) = _SortingPrefixesUpdateResponse;

  factory SortingPrefixesUpdateResponse.fromJson(Map<String, dynamic> json) =>
      _$SortingPrefixesUpdateResponseFromJson(json);
}
