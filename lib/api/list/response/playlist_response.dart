import 'package:buchshelfly/api/list/playlist.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'playlist_response.freezed.dart';
part 'playlist_response.g.dart';

@freezed
abstract class PlaylistResponse with _$PlaylistResponse {
  const factory PlaylistResponse({
    @JsonKey(name: "playlists") required List<Playlist> items,
  }) = _PlaylistResponse;

  factory PlaylistResponse.fromJson(Map<String, dynamic> json) =>
      _$PlaylistResponseFromJson(json);
}
