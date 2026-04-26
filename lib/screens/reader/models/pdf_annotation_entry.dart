import 'dart:convert';
import 'dart:math' as math;

import 'package:pdfrx/pdfrx.dart';
import 'package:yaabsa/models/internal_annotation.dart';

const String kPdfAnnotationPrefix = 'pdf:';
const int _kRectPrecisionScale = 100;
const double _kRectMergeVerticalTolerance = 1.5;
const double _kRectMergeHorizontalGapTolerance = 3.0;

bool isPdfAnnotationCfi(String cfi) => cfi.startsWith(kPdfAnnotationPrefix);

double? _toDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

int? _toInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}

num? _toNum(dynamic value) {
  if (value is num) {
    return value;
  }
  if (value is String) {
    return num.tryParse(value);
  }
  return null;
}

double _roundCoordinate(double value) {
  return (_encodeCoordinate(value) / _kRectPrecisionScale).toDouble();
}

int _encodeCoordinate(double value) {
  return (value * _kRectPrecisionScale).round();
}

double? _decodeCoordinate(dynamic value, {required bool scaled}) {
  final number = _toNum(value);
  if (number == null) {
    return null;
  }

  if (!scaled) {
    return number.toDouble();
  }

  return number.toDouble() / _kRectPrecisionScale;
}

PdfRect? _normalizeRect(double left, double top, double right, double bottom) {
  if (left > right || top < bottom) {
    return null;
  }

  return PdfRect(_roundCoordinate(left), _roundCoordinate(top), _roundCoordinate(right), _roundCoordinate(bottom));
}

PdfRect? _parseRectFromLegacyMap(Map rawRect) {
  final left = _toDouble(rawRect['l']);
  final top = _toDouble(rawRect['t']);
  final right = _toDouble(rawRect['r']);
  final bottom = _toDouble(rawRect['b']);
  if (left == null || top == null || right == null || bottom == null) {
    return null;
  }

  return _normalizeRect(left, top, right, bottom);
}

PdfRect? _parseRectFromCompactList(List rawRect, {required bool scaled}) {
  if (rawRect.length < 4) {
    return null;
  }

  final left = _decodeCoordinate(rawRect[0], scaled: scaled);
  final top = _decodeCoordinate(rawRect[1], scaled: scaled);
  final right = _decodeCoordinate(rawRect[2], scaled: scaled);
  final bottom = _decodeCoordinate(rawRect[3], scaled: scaled);
  if (left == null || top == null || right == null || bottom == null) {
    return null;
  }

  return _normalizeRect(left, top, right, bottom);
}

String _annotationTypeCode(AnnotationType type) {
  return switch (type) {
    AnnotationType.highlight => 'h',
    AnnotationType.underline => 'u',
    AnnotationType.bookmark => 'b',
  };
}

AnnotationType? _annotationTypeFromCode(String? code) {
  return switch (code) {
    'h' => AnnotationType.highlight,
    'u' => AnnotationType.underline,
    'b' => AnnotationType.bookmark,
    _ => null,
  };
}

List<PdfRect> _compactRects(List<PdfRect> sourceRects) {
  if (sourceRects.isEmpty) {
    return const <PdfRect>[];
  }

  final normalized = sourceRects
      .map((rect) => _normalizeRect(rect.left, rect.top, rect.right, rect.bottom))
      .whereType<PdfRect>()
      .toList(growable: false);
  if (normalized.isEmpty) {
    return const <PdfRect>[];
  }

  final sorted = List<PdfRect>.from(normalized)
    ..sort((a, b) {
      final topDiff = b.top - a.top;
      if (topDiff.abs() > _kRectMergeVerticalTolerance) {
        return topDiff > 0 ? 1 : -1;
      }

      final leftDiff = a.left - b.left;
      if (leftDiff.abs() > _kRectMergeHorizontalGapTolerance) {
        return leftDiff > 0 ? 1 : -1;
      }

      return 0;
    });

  final merged = <PdfRect>[];
  for (final rect in sorted) {
    if (merged.isEmpty) {
      merged.add(rect);
      continue;
    }

    final previous = merged.last;
    final isSameLine =
        (previous.top - rect.top).abs() <= _kRectMergeVerticalTolerance &&
        (previous.bottom - rect.bottom).abs() <= _kRectMergeVerticalTolerance;
    final hasHorizontalGap = rect.left - previous.right;

    if (!isSameLine || hasHorizontalGap > _kRectMergeHorizontalGapTolerance) {
      merged.add(rect);
      continue;
    }

    merged[merged.length - 1] = PdfRect(
      math.min(previous.left, rect.left),
      math.max(previous.top, rect.top),
      math.max(previous.right, rect.right),
      math.min(previous.bottom, rect.bottom),
    );
  }

  return merged;
}

String _encodePdfAnnotationPayload(Map<String, dynamic> payload) {
  final encoded = base64UrlEncode(utf8.encode(jsonEncode(payload)));
  return '$kPdfAnnotationPrefix$encoded';
}

Map<String, dynamic>? _decodePdfAnnotationPayload(String cfi) {
  if (!cfi.startsWith(kPdfAnnotationPrefix)) {
    return null;
  }

  final encoded = cfi.substring(kPdfAnnotationPrefix.length);
  try {
    final decodedJson = jsonDecode(utf8.decode(base64Url.decode(encoded)));
    if (decodedJson is Map<String, dynamic>) {
      return decodedJson;
    }
  } catch (_) {
    return null;
  }

  return null;
}

AnnotationType? _annotationTypeFromName(String? name) {
  return switch (name) {
    'highlight' => AnnotationType.highlight,
    'underline' => AnnotationType.underline,
    'bookmark' => AnnotationType.bookmark,
    _ => null,
  };
}

class PdfAnnotationEntry {
  const PdfAnnotationEntry({
    required this.type,
    required this.pageNumber,
    required this.start,
    required this.end,
    required this.rects,
    required this.color,
    required this.opacity,
    this.noteText,
    this.thickness,
  });

  final AnnotationType type;
  final int pageNumber;
  final int start;
  final int end;
  final List<PdfRect> rects;
  final String color;
  final double opacity;
  final String? noteText;
  final double? thickness;

  factory PdfAnnotationEntry.fromRange({
    required AnnotationType type,
    required PdfPageTextRange range,
    required String color,
    required double opacity,
    String? noteText,
    double? thickness,
  }) {
    final fragmentRects = range
        .enumerateFragmentBoundingRects()
        .map((rect) => rect.bounds)
        .where((r) => r.isNotEmpty)
        .toList(growable: false);
    final sourceRects = fragmentRects.isNotEmpty ? fragmentRects : <PdfRect>[range.bounds];
    final compactRects = _compactRects(sourceRects);
    final rects = compactRects.isNotEmpty ? compactRects : _compactRects(<PdfRect>[range.bounds]);

    return PdfAnnotationEntry(
      type: type,
      pageNumber: range.pageNumber,
      start: range.start,
      end: range.end,
      rects: rects,
      color: color,
      opacity: opacity,
      noteText: noteText?.trim().isNotEmpty == true ? noteText!.trim() : null,
      thickness: thickness,
    );
  }

  static PdfAnnotationEntry? fromInternalAnnotation(InternalAnnotation annotation) {
    final payload = _decodePdfAnnotationPayload(annotation.cfi);
    if (payload == null) {
      return null;
    }

    final version = _toInt(payload['v']) ?? 1;
    final pageNumber = _toInt(payload['p'] ?? payload['page']);
    final start = _toInt(payload['s'] ?? payload['start']);
    final end = _toInt(payload['e'] ?? payload['end']);
    final rawRects = payload['r'] ?? payload['rects'];
    if (pageNumber == null || pageNumber < 1 || start == null || end == null || start >= end || rawRects is! List) {
      return null;
    }

    final rects = <PdfRect>[];
    for (final rawRect in rawRects) {
      final parsedRect = switch (rawRect) {
        Map() => _parseRectFromLegacyMap(rawRect),
        List() => _parseRectFromCompactList(rawRect, scaled: version >= 2),
        _ => null,
      };
      if (parsedRect != null) {
        rects.add(parsedRect);
      }
    }

    if (rects.isEmpty) {
      return null;
    }

    final type =
        annotation.type ??
        _annotationTypeFromCode(payload['t'] as String?) ??
        _annotationTypeFromName(payload['kind'] as String?);
    if (type == null ||
        (type != AnnotationType.highlight && type != AnnotationType.underline && type != AnnotationType.bookmark)) {
      return null;
    }

    final defaultColor = switch (type) {
      AnnotationType.highlight => '#FFEB3B',
      AnnotationType.underline => '#2196F3',
      AnnotationType.bookmark => '#FFEB3B',
    };
    final defaultOpacity = switch (type) {
      AnnotationType.highlight => 0.35,
      AnnotationType.underline => 1.0,
      AnnotationType.bookmark => 0.28,
    };
    final compactRects = _compactRects(rects);
    final normalizedRects = compactRects.isNotEmpty ? compactRects : rects;
    final normalizedText = annotation.text?.trim();

    return PdfAnnotationEntry(
      type: type,
      pageNumber: pageNumber,
      start: start,
      end: end,
      rects: normalizedRects,
      color: annotation.color ?? defaultColor,
      opacity: annotation.opacity ?? defaultOpacity,
      noteText: normalizedText != null && normalizedText.isNotEmpty ? normalizedText : null,
      thickness: type == AnnotationType.underline ? annotation.thickness : null,
    );
  }

  PdfAnnotationEntry copyWith({
    AnnotationType? type,
    int? pageNumber,
    int? start,
    int? end,
    List<PdfRect>? rects,
    String? color,
    double? opacity,
    String? noteText,
    double? thickness,
  }) {
    return PdfAnnotationEntry(
      type: type ?? this.type,
      pageNumber: pageNumber ?? this.pageNumber,
      start: start ?? this.start,
      end: end ?? this.end,
      rects: rects ?? this.rects,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
      noteText: noteText ?? this.noteText,
      thickness: thickness ?? this.thickness,
    );
  }

  Map<String, dynamic> _toPayload() {
    final compactRects = _compactRects(rects);
    final normalizedRects = compactRects.isNotEmpty ? compactRects : rects;

    return {
      'v': 2,
      't': _annotationTypeCode(type),
      'p': pageNumber,
      's': start,
      'e': end,
      'r': normalizedRects
          .map(
            (rect) => [
              _encodeCoordinate(rect.left),
              _encodeCoordinate(rect.top),
              _encodeCoordinate(rect.right),
              _encodeCoordinate(rect.bottom),
            ],
          )
          .toList(growable: false),
    };
  }

  String get cfi => _encodePdfAnnotationPayload(_toPayload());

  InternalAnnotation toInternalAnnotation() {
    return InternalAnnotation(
      cfi: cfi,
      text: type == AnnotationType.bookmark ? noteText : null,
      color: color,
      opacity: opacity,
      thickness: type == AnnotationType.underline ? thickness : null,
      type: type,
    );
  }
}
