import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

class AudioBrowseIcon extends StatelessWidget {
  const AudioBrowseIcon({required this.name, super.key});

  factory AudioBrowseIcon.library(String name) {
    final normalized = name.trim().toLowerCase();
    final supported = _libraryNames.contains(normalized);
    final libraryName = supported ? normalized : 'audiobookshelf';

    return AudioBrowseIcon(name: 'abs_library_${libraryName.replaceAll('-', '_')}');
  }

  static const _libraryNames = {
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

  final String name;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final themeColor = iconTheme.color ?? Theme.of(context).colorScheme.onSurface;
    final color = themeColor.withValues(alpha: themeColor.a * (iconTheme.opacity ?? 1.0));

    return SvgPicture.asset(
      'assets/browse_icons/$name.svg',
      width: 28,
      height: 28,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      excludeFromSemantics: true,
    );
  }
}
