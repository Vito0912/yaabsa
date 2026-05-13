import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/filesystem/filesystem_directory.dart';

part 'filesystem_paths_response.freezed.dart';
part 'filesystem_paths_response.g.dart';

@freezed
abstract class FilesystemPathsResponse with _$FilesystemPathsResponse {
  const factory FilesystemPathsResponse({
    @JsonKey(name: 'posix') required bool posix,
    @JsonKey(name: 'directories') @Default(<FilesystemDirectory>[]) List<FilesystemDirectory> directories,
  }) = _FilesystemPathsResponse;

  factory FilesystemPathsResponse.fromJson(Map<String, dynamic> json) => _$FilesystemPathsResponseFromJson(json);
}
