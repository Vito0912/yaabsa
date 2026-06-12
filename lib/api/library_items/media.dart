import 'package:yaabsa/api/library_items/book_media.dart';
import 'package:yaabsa/api/library_items/podcast_media.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media.freezed.dart';

@freezed
abstract class Media with _$Media {
  const Media._(); // Private constructor for custom methods.

  const factory Media({PodcastMedia? podcastMedia, BookMedia? bookMedia}) = _Media;

  /// Custom fromJson method to handle different structures.
  factory Media.fromJson(Map<String, dynamic> json) {
    // Check if the JSON contains an "episodes" key, indicating a PodcastMedia.
    if (json.containsKey('episodes') || json.containsKey('numEpisodes')) {
      return Media(podcastMedia: PodcastMedia.fromJson(json));
    }
    // Otherwise, default to BookMedia.
    else {
      return Media(bookMedia: BookMedia.fromJson(json));
    }
  }

  /// Custom toJson method to handle different structures.
  Map<String, dynamic> toJson() {
    // Check if the instance contains a PodcastMedia.
    if (podcastMedia != null) {
      return podcastMedia!.toJson();
    }
    // Otherwise, default to BookMedia.
    else {
      return bookMedia!.toJson();
    }
  }

  String? get title => podcastMedia?.metadata.title ?? bookMedia!.metadata.title;

  String? get subtitle => podcastMedia == null ? bookMedia!.metadata.subtitle : null;

  List<String>? get authors => podcastMedia != null
      ? podcastMedia!.metadata.author?.split(',')
      : bookMedia!.metadata.authors?.map((e) => e.name).toList();

  String? get seriesSequence => bookMedia?.metadata.series?.firstOrNull?.sequence;

  bool get hasAudio {
    bool simple =
        podcastMedia?.episodes?.isNotEmpty ??
        bookMedia?.audioFiles?.isNotEmpty ??
        ((bookMedia?.numAudioFiles ?? 0) > 0);

    return simple;
  }

  bool get hasBook => bookMedia?.ebookFile != null || bookMedia?.ebookFormat != null;

  double duration({String? episodeId}) {
    if (podcastMedia != null) {
      if (episodeId != null) {
        final episode = podcastMedia!.episodes?.where((e) => e.id == episodeId).firstOrNull;
        return episode?.audioFile?.duration ?? 0;
      }
      final episodes = podcastMedia!.episodes;
      if (episodes == null || episodes.isEmpty) {
        return 0;
      }

      return episodes.fold<double>(0, (total, episode) => total + (episode.audioFile?.duration ?? 0));
    } else {
      final audioFiles = bookMedia?.audioFiles;
      if (audioFiles == null || audioFiles.isEmpty) {
        return 0;
      }

      return audioFiles.fold<double>(0, (total, audioFile) => total + (audioFile.duration ?? 0));
    }
  }
}
