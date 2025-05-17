import 'package:freezed_annotation/freezed_annotation.dart';

part 'library_folder.freezed.dart';
part 'library_folder.g.dart';

@freezed
abstract class LibraryFolder with _$LibraryFolder {
  const factory LibraryFolder({
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "fullPath") required String fullPath,
    @JsonKey(name: "libraryId") required String libraryId,
    @JsonKey(name: "addedAt") int? addedAt,
  }) = _LibraryFolder;

  factory LibraryFolder.fromJson(Map<String, dynamic> json) =>
      _$LibraryFolderFromJson(json);
}
