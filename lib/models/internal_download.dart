import 'package:yaabsa/api/library_items/episode.dart';
import 'package:yaabsa/api/library_items/library_file.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/util/file_formats.dart';
import 'package:yaabsa/util/download_destination.dart';

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
    @JsonKey(name: "downloadType") @Default('both') String downloadType,
    @JsonKey(name: 'downloadBasePath') String? downloadBasePath,
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
    final resolvedItem = item;
    if (resolvedItem == null) {
      final expected = expectedFileCount;
      if (expected != null && expected > 0) {
        return expected;
      }
      return numberOfTracks;
    }

    if (isPodcast) {
      return 1;
    }

    final hasAudio = downloadType == 'audiobook' || downloadType == 'both';
    final hasEbook = downloadType == 'ebook' || downloadType == 'both';

    int count = 0;
    if (hasAudio) {
      count += resolvedItem.media?.bookMedia?.audioFiles?.length ?? 0;
    }
    if (hasEbook) {
      if (resolvedItem.media?.bookMedia?.ebookFile != null) {
        count += 1;
      }
      final libraryFiles = resolvedItem.libraryFiles ?? const <LibraryFile>[];
      for (final libraryFile in libraryFiles) {
        if (FileFormats.isEbook(libraryFile.metadata.ext)) {
          count += 1;
        }
      }
    }
    return count > 0 ? count : numberOfTracks;
  }

  int get numberOfDownloadedFiles {
    final uniqueAuxiliaryFiles = auxiliaryFilePaths.where((path) => path.trim().isNotEmpty).toSet();
    return numberOfDownloadedTracks + uniqueAuxiliaryFiles.length;
  }

  bool get isComplete {
    if (downloadType == 'ebook') {
      final hasEbook = auxiliaryFilePaths.any(FileFormats.isEbook);
      return hasEbook;
    }

    if (downloadType == 'audiobook') {
      return numberOfDownloadedTracks == numberOfTracks && numberOfTracks > 0;
    }

    final hasEbook = auxiliaryFilePaths.any(FileFormats.isEbook);

    final ebookAvailable = item?.media?.bookMedia?.ebookFile != null;
    final audioAvailable = (item?.media?.bookMedia?.audioFiles?.isNotEmpty ?? false) || (episode != null);

    bool audioComplete = true;
    if (audioAvailable) {
      audioComplete = numberOfDownloadedTracks == numberOfTracks && numberOfTracks > 0;
    }

    bool ebookComplete = true;
    if (ebookAvailable) {
      ebookComplete = hasEbook;
    }

    return audioComplete && ebookComplete;
  }

  Future<InternalDownload> resolvePaths() async {
    final basePath = downloadBasePath;
    if (basePath == null || basePath.isEmpty) {
      return this;
    }

    final resolvedTracks = await Future.wait(
      tracks.map((track) async => track.copyWith(url: await resolveStoredDownloadPath(track.url, basePath))),
    );
    final resolvedAuxiliaryPaths = await Future.wait(
      auxiliaryFilePaths.map((path) => resolveStoredDownloadPath(path, basePath)),
    );
    final resolvedSidecarPaths = await Future.wait(
      sidecarPaths.map((path) => resolveStoredDownloadPath(path, basePath)),
    );

    return copyWith(
      tracks: resolvedTracks,
      auxiliaryFilePaths: resolvedAuxiliaryPaths.whereType<String>().toList(growable: false),
      sidecarPaths: resolvedSidecarPaths.whereType<String>().toList(growable: false),
      coverPath: await resolveStoredDownloadPath(coverPath, basePath),
    );
  }

  factory InternalDownload.fromJson(Map<String, dynamic> json) => _$InternalDownloadFromJson(json);
}
