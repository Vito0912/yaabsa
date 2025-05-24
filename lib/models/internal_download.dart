import 'package:buchshelfly/api/library_items/episode.dart';
import 'package:buchshelfly/api/library_items/library_item.dart';
import 'package:buchshelfly/models/internal_media.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'internal_download.freezed.dart';
part 'internal_download.g.dart';

@freezed
abstract class InternalDownload with _$InternalDownload {
  InternalDownload._();

  factory InternalDownload({
    @JsonKey(name: "item") required LibraryItem? item,
    @JsonKey(name: "episode") required Episode? episode,
    @JsonKey(name: "tracks") required InternalTrack? tracks,
    @JsonKey(name: "saf", defaultValue: false) required bool saf,
  }) = _InternalDownload;

  factory InternalDownload.fromJson(Map<String, dynamic> json) => _$InternalDownloadFromJson(json);
}
