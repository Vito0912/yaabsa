import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/library_items/library_item.dart';

part 'create_podcast_response.freezed.dart';
part 'create_podcast_response.g.dart';

@freezed
abstract class CreatePodcastResponse with _$CreatePodcastResponse {
  const CreatePodcastResponse._();

  const factory CreatePodcastResponse({
    @JsonKey(name: 'libraryItem') LibraryItem? libraryItem,
    @JsonKey(name: 'item') LibraryItem? item,
  }) = _CreatePodcastResponse;

  factory CreatePodcastResponse.fromJson(Map<String, dynamic> json) => _$CreatePodcastResponseFromJson(json);

  LibraryItem? get createdItem => libraryItem ?? item;
}
