import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/subtitles/subtitle_parser.dart';
import 'package:yaabsa/util/subtitles/subtitle_segment_spans.dart';

class PlayerSubtitleCuePresentation extends StatelessWidget {
  const PlayerSubtitleCuePresentation({
    super.key,
    required this.document,
    required this.cueIndex,
    required this.currentPosition,
    required this.readAlongEnabled,
    this.compact = false,
    this.accentColor,
  });

  final ParsedSubtitleDocument document;
  final int cueIndex;
  final Duration currentPosition;
  final bool readAlongEnabled;
  final bool compact;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final cue = document.cues[cueIndex];
    final colorScheme = Theme.of(context).colorScheme;
    final highlightColor = accentColor ?? colorScheme.primary;
    final currentCueStyle = (compact ? Theme.of(context).textTheme.bodyMedium : Theme.of(context).textTheme.bodyLarge)
        ?.copyWith(height: 1.35);
    final baseStyle = currentCueStyle ?? const TextStyle(fontSize: 16, height: 1.35);
    final activeStyle = baseStyle.copyWith(
      color: highlightColor,
      backgroundColor: highlightColor.withValues(alpha: 0.18),
    );

    Widget content;
    if (readAlongEnabled && cue.segments.isNotEmpty) {
      final spans = <TextSpan>[];
      for (final segment in cue.segments) {
        final isActive = currentPosition >= segment.start && currentPosition < segment.end;
        spans.addAll(
          buildSubtitleSegmentSpans(
            text: segment.text,
            isActive: isActive,
            inactiveStyle: baseStyle,
            activeStyle: activeStyle,
          ).whereType<TextSpan>(),
        );
      }

      content = RichText(
        textAlign: TextAlign.center,
        text: TextSpan(style: baseStyle, children: spans),
      );
    } else {
      content = Text(cue.text, textAlign: TextAlign.center, style: baseStyle);
    }

    return _PlayerSubtitleFrame(
      compact: compact,
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [content]),
      ),
    );
  }
}

class PlayerSubtitleEmptyPresentation extends StatelessWidget {
  const PlayerSubtitleEmptyPresentation({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return _PlayerSubtitleFrame(
      compact: compact,
      child: Center(
        child: SizedBox(height: compact ? 18 : 22, width: double.infinity),
      ),
    );
  }
}

class _PlayerSubtitleFrame extends StatelessWidget {
  const _PlayerSubtitleFrame({required this.child, required this.compact});

  final Widget child;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(top: compact ? 4 : 6),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.65)),
        ),
        child: child,
      ),
    );
  }
}
