import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/library_items/author.dart';
import 'package:yaabsa/api/library_items/series.dart';

part 'update_library_item_media_request.freezed.dart';
part 'update_library_item_media_request.g.dart';

@freezed
abstract class UpdateLibraryItemMediaRequest with _$UpdateLibraryItemMediaRequest {
  @JsonSerializable(includeIfNull: false)
  const factory UpdateLibraryItemMediaRequest({
    @JsonKey(name: 'metadata') UpdateLibraryItemMediaMetadataPatch? metadata,
    @JsonKey(name: 'tags') List<String>? tags,
    @JsonKey(name: 'url') String? url,
  }) = _UpdateLibraryItemMediaRequest;

  factory UpdateLibraryItemMediaRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateLibraryItemMediaRequestFromJson(json);
}

@freezed
abstract class UpdateLibraryItemMediaMetadataPatch with _$UpdateLibraryItemMediaMetadataPatch {
  @JsonSerializable(includeIfNull: false)
  const factory UpdateLibraryItemMediaMetadataPatch({
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'subtitle') String? subtitle,
    @JsonKey(name: 'author') String? author,
    @JsonKey(name: 'authors') List<Author>? authors,
    @JsonKey(name: 'narrators') List<String>? narrators,
    @JsonKey(name: 'series') List<Series>? series,
    @JsonKey(name: 'genres') List<String>? genres,
    @JsonKey(name: 'publisher') String? publisher,
    @JsonKey(name: 'publishedYear') String? publishedYear,
    @JsonKey(name: 'publishedDate') String? publishedDate,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'language') String? language,
    @JsonKey(name: 'explicit') bool? explicit,
    @JsonKey(name: 'abridged') bool? abridged,
    @JsonKey(name: 'isbn') String? isbn,
    @JsonKey(name: 'asin') String? asin,
    @JsonKey(name: 'feedUrl') String? feedUrl,
    @JsonKey(name: 'itunesPageUrl') String? itunesPageUrl,
    @JsonKey(name: 'itunesId') String? itunesId,
    @JsonKey(name: 'releaseDate') String? releaseDate,
    @JsonKey(name: 'type') String? type,
  }) = _UpdateLibraryItemMediaMetadataPatch;

  factory UpdateLibraryItemMediaMetadataPatch.fromJson(Map<String, dynamic> json) =>
      _$UpdateLibraryItemMediaMetadataPatchFromJson(json);
}
