import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/library_view_subtitles.dart';

class AdditionalInformationText extends StatelessWidget {
  const AdditionalInformationText({required this.subtitle, required this.style, super.key});

  final LibraryViewSubtitle subtitle;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    if (subtitle.isEmpty) {
      return const SizedBox.shrink();
    }

    final children = <Widget>[];
    final inlineParts = <String>[];

    void flushInlineParts() {
      if (inlineParts.isEmpty) {
        return;
      }

      children.add(Text(inlineParts.join(' • '), softWrap: true, style: style));
      inlineParts.clear();
    }

    for (final part in subtitle.parts) {
      if (part.isStandalone) {
        flushInlineParts();
        children.add(
          Text(part.displayText, maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false, style: style),
        );
      } else {
        inlineParts.add(part.displayText);
      }
    }
    flushInlineParts();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }
}
