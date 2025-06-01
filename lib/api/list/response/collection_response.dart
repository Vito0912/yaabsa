import 'package:yaabsa/api/list/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'collection_response.freezed.dart';
part 'collection_response.g.dart';

@freezed
abstract class CollectionResponse with _$CollectionResponse {
  const factory CollectionResponse({@JsonKey(name: "collections") required List<Collection> items}) =
      _CollectionResponse;

  factory CollectionResponse.fromJson(Map<String, dynamic> json) => _$CollectionResponseFromJson(json);
}
