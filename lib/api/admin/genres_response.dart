import 'package:freezed_annotation/freezed_annotation.dart';

part 'genres_response.freezed.dart';
part 'genres_response.g.dart';

List<String> _stringListFromJson(dynamic value) {
  if (value is! List) {
    return const <String>[];
  }

  return value
      .whereType<Object>()
      .map((entry) => entry.toString().trim())
      .where((entry) => entry.isNotEmpty)
      .toList(growable: false);
}

@freezed
abstract class GenresResponse with _$GenresResponse {
  const factory GenresResponse({
    @JsonKey(name: 'genres', fromJson: _stringListFromJson) @Default(<String>[]) List<String> genres,
  }) = _GenresResponse;

  factory GenresResponse.fromJson(Map<String, dynamic> json) => _$GenresResponseFromJson(json);
}
