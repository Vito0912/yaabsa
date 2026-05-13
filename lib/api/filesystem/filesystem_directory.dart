import 'package:freezed_annotation/freezed_annotation.dart';

part 'filesystem_directory.freezed.dart';
part 'filesystem_directory.g.dart';

@freezed
abstract class FilesystemDirectory with _$FilesystemDirectory {
  const factory FilesystemDirectory({
    @JsonKey(name: 'path') required String path,
    @JsonKey(name: 'dirname') required String dirname,
    @JsonKey(name: 'level') @Default(0) int level,
  }) = _FilesystemDirectory;

  factory FilesystemDirectory.fromJson(Map<String, dynamic> json) => _$FilesystemDirectoryFromJson(json);
}
