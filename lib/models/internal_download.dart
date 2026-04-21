import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'internal_download.freezed.dart';
part 'internal_download.g.dart';

@freezed
abstract class InternalDownload with _$InternalDownload {
  InternalDownload._();

  factory InternalDownload({
    @JsonKey(name: "item") required LibraryItem? item,
    @JsonKey(name: "episode") required Episode? episode,
    @JsonKey(name: "tracks") required List<InternalTrack> tracks,
    @JsonKey(name: "expectedFileCount") int? expectedFileCount,
    @JsonKey(name: "auxiliaryFilePaths") @Default(<String>[]) List<String> auxiliaryFilePaths,
    @JsonKey(name: "saf", defaultValue: false) required bool saf,
    @JsonKey(name: "coverPath") String? coverPath,
    @JsonKey(name: "sidecarPaths") @Default(<String>[]) List<String> sidecarPaths,
  }) = _InternalDownload;

  bool get isPodcast {
    assert(item != null || episode != null, 'Either item or episode must be provided');
    // This just means podcast. Maybe a better name, because I ran into my own confusion why item was nullable.
    return episode != null;
  }

  int get numberOfTracks {
    if (isPodcast) {
      return 1;
    } else {
      return item?.media?.bookMedia?.audioFiles?.length ?? 0;
    }
  }

  int get numberOfDownloadedTracks {
    return tracks.where((track) => track.url != null && track.url!.trim().isNotEmpty).length;
  }

  int get numberOfFiles {
    final expected = expectedFileCount;
    if (expected != null && expected > 0) {
      return expected;
    }
    return numberOfTracks;
  }

  int get numberOfDownloadedFiles {
    final uniqueAuxiliaryFiles = auxiliaryFilePaths.where((path) => path.trim().isNotEmpty).toSet();
    return numberOfDownloadedTracks + uniqueAuxiliaryFiles.length;
  }

  bool get isComplete {
    final target = numberOfFiles;
    if (target <= 0) {
      return numberOfDownloadedTracks == numberOfTracks;
    }
    return numberOfDownloadedFiles >= target;
  }

  factory InternalDownload.fromJson(Map<String, dynamic> json) => _$InternalDownloadFromJson(json);
}
