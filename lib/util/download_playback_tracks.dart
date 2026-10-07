import 'package:yaabsa/api/library_items/audio_file.dart';
import 'package:yaabsa/models/internal_download.dart';
import 'package:yaabsa/models/internal_media.dart';

List<InternalTrack> downloadPlaybackTracks(InternalDownload download, String? serverUrl) {
  final audioFiles = download.item?.media?.bookMedia?.audioFiles;
  if (download.isComplete || download.isPodcast || audioFiles == null || audioFiles.isEmpty) return download.tracks;

  final localTracks = {for (final track in download.tracks) track.index: track};
  final ordered = audioFiles.toList()..sort((left, right) => (left.index ?? 0).compareTo(right.index ?? 0));
  final tracks = <InternalTrack>[];
  var start = 0.0;
  var fallbackIndex = 0;
  for (final AudioFile file in ordered) {
    final index = file.index ?? fallbackIndex;
    final duration = file.duration ?? 0;
    final localTrack = localTracks[index];
    final url = serverUrl == null
        ? null
        : '${serverUrl.replaceFirst(RegExp(r'/+$'), '')}/api/items/${download.item!.id}/file/${file.ino}/download';
    tracks.add(
      InternalTrack(
        index: index,
        duration: duration,
        url: localTrack?.url ?? url,
        mimeType: localTrack?.mimeType ?? file.mimeType ?? 'audio/mpeg',
        start: start,
        end: start + duration,
      ),
    );
    start += duration;
    fallbackIndex = index + 1;
  }
  return tracks;
}
