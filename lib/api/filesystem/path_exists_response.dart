import 'package:freezed_annotation/freezed_annotation.dart';

part 'path_exists_response.freezed.dart';
part 'path_exists_response.g.dart';

@freezed
abstract class PathExistsResponse with _$PathExistsResponse {
  const factory PathExistsResponse({
    @JsonKey(name: 'exists') required bool exists,
    @JsonKey(name: 'libraryItemTitle') String? libraryItemTitle,
    @JsonKey(name: 'error') String? error,
  }) = _PathExistsResponse;

  factory PathExistsResponse.fromJson(Map<String, dynamic> json) => _$PathExistsResponseFromJson(json);
}
