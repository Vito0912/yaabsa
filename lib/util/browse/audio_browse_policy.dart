import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/library_items/library_item.dart';

bool isPodcastItem(LibraryItem item) {
  return item.mediaType == 'podcast' || item.media?.podcastMedia != null;
}

bool isSupportedAudioItem(LibraryItem item) {
  if (isPodcastItem(item)) {
    return item.media != null;
  }
  return item.media?.hasAudio ?? false;
}

bool isAudioLibrary(Library library) {
  return library.mediaType == 'book' || library.mediaType == 'podcast';
}
