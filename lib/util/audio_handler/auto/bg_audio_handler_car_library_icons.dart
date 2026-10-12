part of '../bg_audio_handler.dart';

const _androidAutoLibraryIconNames = <String>{
  'audiobookshelf',
  'book-1',
  'books-1',
  'books-2',
  'database',
  'database-1',
  'file-picture',
  'headphones',
  'heart',
  'microphone-1',
  'microphone-2',
  'microphone-3',
  'music',
  'podcast',
  'power',
  'radio',
  'rocket',
  'rss',
  'star',
  'video',
};

extension _BGAudioHandlerCarLibraryIcons on BGAudioHandler {
  Uri? _androidAutoLibraryIconUri(Library library) {
    if (kIsWeb || !Platform.isAndroid) {
      return null;
    }

    final requestedIcon = library.icon.trim().toLowerCase();
    final icon = _androidAutoLibraryIconNames.contains(requestedIcon) ? requestedIcon : 'audiobookshelf';
    final drawable = 'abs_library_${icon.replaceAll('-', '_')}';

    return _androidAutoDrawableIconUri(drawable);
  }
}
