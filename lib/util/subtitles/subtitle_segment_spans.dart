import 'package:flutter/widgets.dart';

List<InlineSpan> buildSubtitleSegmentSpans({
  required String text,
  required bool isActive,
  required TextStyle inactiveStyle,
  required TextStyle activeStyle,
}) {
  final normalizedText = text.replaceAll('\n', ' ');
  if (normalizedText.isEmpty) {
    return const <InlineSpan>[];
  }

  if (!isActive) {
    return <InlineSpan>[TextSpan(text: normalizedText, style: inactiveStyle)];
  }

  final spans = <InlineSpan>[];
  var cursor = 0;
  for (final match in RegExp(r'\S+').allMatches(normalizedText)) {
    if (match.start > cursor) {
      spans.add(TextSpan(text: normalizedText.substring(cursor, match.start), style: inactiveStyle));
    }

    spans.add(TextSpan(text: match.group(0), style: activeStyle));
    cursor = match.end;
  }

  if (cursor < normalizedText.length) {
    spans.add(TextSpan(text: normalizedText.substring(cursor), style: inactiveStyle));
  }

  return spans;
}
