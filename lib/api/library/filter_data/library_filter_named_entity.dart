import 'package:freezed_annotation/freezed_annotation.dart';

part 'library_filter_named_entity.freezed.dart';
part 'library_filter_named_entity.g.dart';

@freezed
abstract class LibraryFilterNamedEntity with _$LibraryFilterNamedEntity {
  const factory LibraryFilterNamedEntity({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
  }) = _LibraryFilterNamedEntity;

  factory LibraryFilterNamedEntity.fromJson(Map<String, dynamic> json) => _$LibraryFilterNamedEntityFromJson(json);
}
