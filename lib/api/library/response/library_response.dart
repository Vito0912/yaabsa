import 'package:yaabsa/api/library/library.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'library_response.freezed.dart';
part 'library_response.g.dart';

@freezed
abstract class LibraryResponse with _$LibraryResponse {
  const factory LibraryResponse({@JsonKey(name: "libraries") required List<Library> libraries}) = _LibraryResponse;

  factory LibraryResponse.fromJson(Map<String, dynamic> json) => _$LibraryResponseFromJson(json);
}
