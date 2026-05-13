import 'package:freezed_annotation/freezed_annotation.dart';

part 'tags_response.freezed.dart';
part 'tags_response.g.dart';

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
abstract class TagsResponse with _$TagsResponse {
  const factory TagsResponse({
    @JsonKey(name: 'tags', fromJson: _stringListFromJson) @Default(<String>[]) List<String> tags,
  }) = _TagsResponse;

  factory TagsResponse.fromJson(Map<String, dynamic> json) => _$TagsResponseFromJson(json);
}
