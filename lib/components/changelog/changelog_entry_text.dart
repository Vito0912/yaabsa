import 'package:material_ui/material_ui.dart';

class ChangelogEntryText extends StatelessWidget {
  const ChangelogEntryText({super.key, required this.entry});

  final String entry;

  static const _platformIcons = <String, IconData>{
    'Android': Icons.android,
    'Android Automotive OS': Icons.directions_car_outlined,
    'Android Automtoive OS': Icons.directions_car_outlined,
    'AAOS': Icons.directions_car_outlined,
    'Windows': Icons.window_rounded,
    'Linux': Icons.terminal_rounded,
    'iOS': Icons.apple,
    'macOS': Icons.apple,
  };

  static final _platformTag = RegExp(r'\(([^)]+)\)');
  static final _separator = RegExp(r'([,/])');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium?.copyWith(height: 1.5);
    final spans = <InlineSpan>[];
    var offset = 0;

    for (final match in _platformTag.allMatches(entry)) {
      spans.add(TextSpan(text: entry.substring(offset, match.start)));

      final label = match.group(1)!;
      final parts = label.split(_separator);
      final hasMappedPlatform = parts.any((part) => _platformIcons.containsKey(part.trim()));
      if (!hasMappedPlatform) {
        spans.add(TextSpan(text: match.group(0)));
        offset = match.end;
        continue;
      }

      var partOffset = 0;
      for (final separator in _separator.allMatches(label)) {
        _addPlatform(spans, label.substring(partOffset, separator.start).trim(), style);
        spans.add(TextSpan(text: ' ${separator.group(0)} '));
        partOffset = separator.end;
      }
      _addPlatform(spans, label.substring(partOffset).trim(), style);
      offset = match.end;
    }

    spans.add(TextSpan(text: entry.substring(offset)));

    return Text.rich(TextSpan(children: spans), style: style);
  }

  void _addPlatform(List<InlineSpan> spans, String platform, TextStyle? style) {
    final icon = _platformIcons[platform];
    if (icon == null) {
      spans.add(TextSpan(text: platform));
      return;
    }

    spans.add(
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Tooltip(
          message: platform,
          child: Icon(icon, size: style?.fontSize ?? 14, semanticLabel: platform),
        ),
      ),
    );
  }
}
