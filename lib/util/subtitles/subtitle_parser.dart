enum SubtitleDocumentFormat { srt, webvtt }

class ParsedSubtitleDocument {
  ParsedSubtitleDocument({required this.format, required List<ParsedSubtitleCue> cues})
    : cues = List<ParsedSubtitleCue>.unmodifiable(cues);

  final SubtitleDocumentFormat format;
  final List<ParsedSubtitleCue> cues;
  late final List<int> _startMicros = cues.map((cue) => cue.start.inMicroseconds).toList(growable: false);
  late final List<int> _endMicros = cues.map((cue) => cue.end.inMicroseconds).toList(growable: false);

  bool get supportsSpeakerHighlighting {
    return format == SubtitleDocumentFormat.webvtt && cues.any((cue) => cue.speaker?.isNotEmpty == true);
  }

  bool get supportsReadAlong {
    return format == SubtitleDocumentFormat.webvtt && cues.any((cue) => cue.segments.isNotEmpty);
  }

  int cueIndexAt(Duration position) {
    if (cues.isEmpty) {
      return -1;
    }

    final targetMicros = position.inMicroseconds;
    var left = 0;
    var right = cues.length - 1;

    while (left <= right) {
      final mid = (left + right) >> 1;
      if (targetMicros < _startMicros[mid]) {
        right = mid - 1;
        continue;
      }
      if (targetMicros >= _endMicros[mid]) {
        left = mid + 1;
        continue;
      }
      return mid;
    }

    return -1;
  }

  int nearestCueIndex(Duration position) {
    if (cues.isEmpty) {
      return -1;
    }

    final targetMicros = position.inMicroseconds;
    if (targetMicros <= _startMicros.first) {
      return 0;
    }
    if (targetMicros >= _endMicros.last) {
      return cues.length - 1;
    }

    var left = 0;
    var right = cues.length - 1;
    var candidate = 0;

    while (left <= right) {
      final mid = (left + right) >> 1;
      if (_startMicros[mid] <= targetMicros) {
        candidate = mid;
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }

    return candidate;
  }

  ParsedSubtitleCue? cueAt(Duration position) {
    final index = cueIndexAt(position);
    if (index < 0) {
      return null;
    }

    return cues[index];
  }
}

class ParsedSubtitleCue {
  const ParsedSubtitleCue({
    required this.start,
    required this.end,
    required this.text,
    this.speaker,
    this.segments = const <ParsedSubtitleSegment>[],
  });

  final Duration start;
  final Duration end;
  final String text;
  final String? speaker;
  final List<ParsedSubtitleSegment> segments;
}

class ParsedSubtitleSegment {
  const ParsedSubtitleSegment({required this.start, required this.end, required this.text});

  final Duration start;
  final Duration end;
  final String text;
}

class SubtitleParser {
  static final RegExp _blankBlockPattern = RegExp(r'\n{2,}');
  static final RegExp _vttTimestampTagPattern = RegExp(r'<((?:\d{2,}:)?\d{2}:\d{2}\.\d{3})>');
  static final RegExp _speakerTagPattern = RegExp(r'<v(?:\.[^ >]+)?(?:\s+([^>]+))?>', caseSensitive: false);

  static ParsedSubtitleDocument? parse({required String rawContent, required SubtitleDocumentFormat format}) {
    final normalizedContent = _normalizeContent(rawContent);
    if (normalizedContent.trim().isEmpty) {
      return null;
    }

    final cues = switch (format) {
      SubtitleDocumentFormat.srt => _parseSrt(normalizedContent),
      SubtitleDocumentFormat.webvtt => _parseWebVtt(normalizedContent),
    };

    if (cues.isEmpty) {
      return null;
    }

    cues.sort((left, right) => left.start.compareTo(right.start));
    return ParsedSubtitleDocument(format: format, cues: cues);
  }

  static String _normalizeContent(String input) {
    final normalizedLineBreaks = input.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    if (normalizedLineBreaks.startsWith('\uFEFF')) {
      return normalizedLineBreaks.substring(1);
    }
    return normalizedLineBreaks;
  }

  static List<ParsedSubtitleCue> _parseSrt(String content) {
    final cues = <ParsedSubtitleCue>[];
    final blocks = content.split(_blankBlockPattern);

    for (final rawBlock in blocks) {
      final block = rawBlock.trim();
      if (block.isEmpty) {
        continue;
      }

      final lines = block.split('\n');
      final timingIndex = lines.indexWhere((line) => line.contains('-->'));
      if (timingIndex < 0) {
        continue;
      }

      final timing = _parseTimingLine(lines[timingIndex], format: SubtitleDocumentFormat.srt);
      if (timing == null) {
        continue;
      }

      final payloadLines = lines.skip(timingIndex + 1).toList(growable: false);
      if (payloadLines.isEmpty) {
        continue;
      }

      final payload = payloadLines.join('\n');
      final decodedPayload = _decodeEntities(_stripTags(payload));
      final displayText = _normalizeCueText(decodedPayload);
      if (displayText.isEmpty) {
        continue;
      }

      cues.add(ParsedSubtitleCue(start: timing.start, end: timing.end, text: displayText));
    }

    return cues;
  }

  static List<ParsedSubtitleCue> _parseWebVtt(String content) {
    final cues = <ParsedSubtitleCue>[];

    final lines = content.split('\n');
    var startLine = 0;

    if (lines.isNotEmpty && lines.first.trimLeft().startsWith('WEBVTT')) {
      startLine = 1;
      while (startLine < lines.length && lines[startLine].trim().isNotEmpty) {
        startLine += 1;
      }
    }

    final body = lines.skip(startLine).join('\n').trim();
    if (body.isEmpty) {
      return cues;
    }

    final blocks = body.split(_blankBlockPattern);
    for (final rawBlock in blocks) {
      final block = rawBlock.trim();
      if (block.isEmpty) {
        continue;
      }

      final blockLines = block.split('\n');
      final firstLine = blockLines.first.trimLeft();
      if (firstLine.startsWith('NOTE') || firstLine.startsWith('STYLE') || firstLine.startsWith('REGION')) {
        continue;
      }

      final timingIndex = blockLines.indexWhere((line) => line.contains('-->'));
      if (timingIndex < 0) {
        continue;
      }

      final timing = _parseTimingLine(blockLines[timingIndex], format: SubtitleDocumentFormat.webvtt);
      if (timing == null) {
        continue;
      }

      final payloadLines = blockLines.skip(timingIndex + 1).toList(growable: false);
      if (payloadLines.isEmpty) {
        continue;
      }

      final rawPayload = payloadLines.join('\n');
      final speaker = _extractSpeaker(rawPayload);
      final cleanedPayload = _stripVttMarkupPreservingTimestamps(rawPayload);
      final segments = _parseWebVttSegments(cleanedPayload, timing.start, timing.end);

      final plainPayload = cleanedPayload.replaceAll(_vttTimestampTagPattern, '');
      final displayText = _normalizeCueText(_decodeEntities(plainPayload));
      if (displayText.isEmpty) {
        continue;
      }

      cues.add(
        ParsedSubtitleCue(
          start: timing.start,
          end: timing.end,
          text: displayText,
          speaker: speaker,
          segments: segments,
        ),
      );
    }

    return cues;
  }

  static _ParsedTiming? _parseTimingLine(String timingLine, {required SubtitleDocumentFormat format}) {
    final separatorIndex = timingLine.indexOf('-->');
    if (separatorIndex < 0) {
      return null;
    }

    final startPart = timingLine.substring(0, separatorIndex).trim();
    final rightPart = timingLine.substring(separatorIndex + 3).trim();
    if (startPart.isEmpty || rightPart.isEmpty) {
      return null;
    }

    final endToken = rightPart.split(RegExp(r'\s+')).first.trim();
    if (endToken.isEmpty) {
      return null;
    }

    final start = _parseTimestamp(startPart, format: format);
    final end = _parseTimestamp(endToken, format: format);
    if (start == null || end == null || end <= start) {
      return null;
    }

    return _ParsedTiming(start: start, end: end);
  }

  static Duration? _parseTimestamp(String input, {required SubtitleDocumentFormat format}) {
    final normalized = input.trim().replaceAll(',', '.');
    if (normalized.isEmpty) {
      return null;
    }

    final parts = normalized.split(':');
    if (parts.length != 2 && parts.length != 3) {
      return null;
    }

    final hasHours = parts.length == 3;
    if (format == SubtitleDocumentFormat.webvtt && !hasHours && parts[0].length > 2) {
      return null;
    }

    var cursor = 0;
    var hours = 0;

    if (hasHours) {
      final parsedHours = int.tryParse(parts[cursor]);
      if (parsedHours == null || parsedHours < 0) {
        return null;
      }
      hours = parsedHours;
      cursor += 1;
    }

    final minutes = int.tryParse(parts[cursor]);
    if (minutes == null || minutes < 0 || minutes > 59) {
      return null;
    }
    cursor += 1;

    final secondsAndMillis = parts[cursor].split('.');
    if (secondsAndMillis.length != 2) {
      return null;
    }

    final seconds = int.tryParse(secondsAndMillis[0]);
    if (seconds == null || seconds < 0 || seconds > 59) {
      return null;
    }

    final millisText = secondsAndMillis[1];
    if (millisText.isEmpty || millisText.length > 3) {
      return null;
    }

    final milliseconds = int.tryParse(millisText.padRight(3, '0'));
    if (milliseconds == null || milliseconds < 0 || milliseconds > 999) {
      return null;
    }

    return Duration(hours: hours, minutes: minutes, seconds: seconds, milliseconds: milliseconds);
  }

  static String? _extractSpeaker(String payload) {
    final match = _speakerTagPattern.firstMatch(payload);
    if (match == null) {
      return null;
    }

    final rawSpeaker = match.group(1);
    if (rawSpeaker == null || rawSpeaker.trim().isEmpty) {
      return null;
    }

    final speaker = _normalizeInlineWhitespace(_decodeEntities(rawSpeaker.trim()));
    if (speaker.isEmpty) {
      return null;
    }

    return speaker;
  }

  static String _stripTags(String input) {
    final withLineBreaks = input.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
    return withLineBreaks.replaceAll(RegExp(r'<[^>]+>'), '');
  }

  static String _stripVttMarkupPreservingTimestamps(String payload) {
    final output = StringBuffer();
    var cursor = 0;

    while (cursor < payload.length) {
      final char = payload[cursor];
      if (char != '<') {
        output.write(char);
        cursor += 1;
        continue;
      }

      final closeIndex = payload.indexOf('>', cursor + 1);
      if (closeIndex < 0) {
        output.write(char);
        cursor += 1;
        continue;
      }

      final tagContent = payload.substring(cursor + 1, closeIndex).trim();
      final lowerTagContent = tagContent.toLowerCase();

      final timestamp = _parseTimestamp(tagContent, format: SubtitleDocumentFormat.webvtt);
      if (timestamp != null) {
        output.write('<$tagContent>');
      } else if (lowerTagContent == 'br' || lowerTagContent == 'br/' || lowerTagContent == 'br /') {
        output.write('\n');
      }

      cursor = closeIndex + 1;
    }

    return output.toString();
  }

  static List<ParsedSubtitleSegment> _parseWebVttSegments(String payload, Duration cueStart, Duration cueEnd) {
    final matches = _vttTimestampTagPattern.allMatches(payload).toList(growable: false);
    if (matches.isEmpty) {
      return const <ParsedSubtitleSegment>[];
    }

    final rawSegments = <_RawSegment>[];
    var currentStart = cueStart;
    var cursor = 0;

    for (final match in matches) {
      final chunk = payload.substring(cursor, match.start);
      final decodedChunk = _decodeEntities(chunk);
      if (decodedChunk.trim().isNotEmpty) {
        rawSegments.add(_RawSegment(start: currentStart, text: decodedChunk));
      }

      final timestampText = match.group(1);
      final parsedTimestamp = timestampText == null
          ? null
          : _parseTimestamp(timestampText, format: SubtitleDocumentFormat.webvtt);
      if (parsedTimestamp != null) {
        currentStart = _clampDuration(parsedTimestamp, min: cueStart, max: cueEnd);
      }

      cursor = match.end;
    }

    final tailChunk = payload.substring(cursor);
    final decodedTailChunk = _decodeEntities(tailChunk);
    if (decodedTailChunk.trim().isNotEmpty) {
      rawSegments.add(_RawSegment(start: currentStart, text: decodedTailChunk));
    }

    if (rawSegments.isEmpty) {
      return const <ParsedSubtitleSegment>[];
    }

    final segments = <ParsedSubtitleSegment>[];
    for (var index = 0; index < rawSegments.length; index++) {
      final segment = rawSegments[index];
      final nextStart = index + 1 < rawSegments.length ? rawSegments[index + 1].start : cueEnd;

      var start = _clampDuration(segment.start, min: cueStart, max: cueEnd);
      var end = _clampDuration(nextStart, min: cueStart, max: cueEnd);
      if (end <= start) {
        end = start + const Duration(milliseconds: 1);
      }

      segments.add(ParsedSubtitleSegment(start: start, end: end, text: segment.text));
    }

    return segments;
  }

  static Duration _clampDuration(Duration value, {required Duration min, required Duration max}) {
    if (value < min) {
      return min;
    }
    if (value > max) {
      return max;
    }
    return value;
  }

  static String _decodeEntities(String input) {
    return input
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&lrm;', '\u200E')
        .replaceAll('&rlm;', '\u200F');
  }

  static String _normalizeCueText(String input) {
    final lines = input
        .split('\n')
        .map(_normalizeInlineWhitespace)
        .where((line) => line.isNotEmpty)
        .toList(growable: false);

    return lines.join('\n').trim();
  }

  static String _normalizeInlineWhitespace(String input) {
    return input.replaceAll(RegExp(r'[ \t]+'), ' ').trim();
  }
}

class _ParsedTiming {
  const _ParsedTiming({required this.start, required this.end});

  final Duration start;
  final Duration end;
}

class _RawSegment {
  const _RawSegment({required this.start, required this.text});

  final Duration start;
  final String text;
}
