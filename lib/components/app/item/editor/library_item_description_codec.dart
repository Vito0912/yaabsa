import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

Document quillDocumentFromHtml(String? htmlText) {
  final source = (htmlText ?? '').trim();
  if (source.isEmpty) {
    return Document();
  }

  final fragment = html_parser.parseFragment(source);
  final delta = Delta();

  for (final node in fragment.nodes) {
    _appendHtmlNode(node, delta, const _InlineAttributes(), null);
  }

  if (!_deltaEndsWithNewline(delta)) {
    delta.insert('\n');
  }

  return Document.fromDelta(delta);
}

String quillDocumentToHtml(Document document) {
  final rawDelta = document.toDelta().toJson();
  final lines = <_HtmlLine>[];
  var currentSpans = <_HtmlSpan>[];

  for (final operation in rawDelta) {
    final insert = operation['insert'];
    if (insert is! String) {
      continue;
    }

    final attrs = _toStringDynamicMap(operation['attributes']);
    final parts = insert.split('\n');

    for (var i = 0; i < parts.length; i++) {
      final part = parts[i];
      if (part.isNotEmpty) {
        currentSpans = <_HtmlSpan>[...currentSpans, _HtmlSpan(part, attrs)];
      }

      if (i < parts.length - 1) {
        final lineAttrs = <String, dynamic>{};
        for (final entry in attrs.entries) {
          if (_isBlockAttribute(entry.key)) {
            lineAttrs[entry.key] = entry.value;
          }
        }
        lines.add(_HtmlLine(spans: currentSpans, attributes: lineAttrs));
        currentSpans = <_HtmlSpan>[];
      }
    }
  }

  if (currentSpans.isNotEmpty) {
    lines.add(_HtmlLine(spans: currentSpans, attributes: const <String, dynamic>{}));
  }

  if (lines.isEmpty) {
    return '<p></p>';
  }

  final html = StringBuffer();
  var index = 0;
  while (index < lines.length) {
    final currentLine = lines[index];
    final listType = currentLine.attributes['list'];
    if (listType == 'bullet' || listType == 'ordered') {
      final listTag = listType == 'ordered' ? 'ol' : 'ul';
      html.write('<$listTag>');
      while (index < lines.length && lines[index].attributes['list'] == listType) {
        html.write('<li>${_renderInlineSpans(lines[index].spans)}</li>');
        index++;
      }
      html.write('</$listTag>');
      continue;
    }

    html.write(_renderStandardLine(currentLine));
    index++;
  }

  return html.toString();
}

void _appendHtmlNode(dom.Node node, Delta delta, _InlineAttributes inline, String? listType) {
  if (node is dom.Text) {
    _appendText(node.text, delta, inline);
    return;
  }

  if (node is! dom.Element) {
    return;
  }

  final tag = node.localName?.toLowerCase();
  if (tag == null) {
    return;
  }

  switch (tag) {
    case 'br':
      delta.insert('\n');
      return;
    case 'ul':
      for (final child in node.children.where((entry) => entry.localName?.toLowerCase() == 'li')) {
        _appendHtmlNode(child, delta, inline, 'bullet');
      }
      return;
    case 'ol':
      for (final child in node.children.where((entry) => entry.localName?.toLowerCase() == 'li')) {
        _appendHtmlNode(child, delta, inline, 'ordered');
      }
      return;
    case 'li':
      for (final child in node.nodes) {
        _appendHtmlNode(child, delta, inline, listType);
      }
      _insertNewline(delta, listType == null ? const <String, dynamic>{} : <String, dynamic>{'list': listType});
      return;
    case 'h1':
    case 'h2':
    case 'h3':
    case 'h4':
    case 'h5':
    case 'h6':
      final headerLevel = int.tryParse(tag.substring(1)) ?? 1;
      for (final child in node.nodes) {
        _appendHtmlNode(child, delta, inline, listType);
      }
      _insertNewline(delta, <String, dynamic>{'header': headerLevel});
      return;
    case 'blockquote':
      for (final child in node.nodes) {
        _appendHtmlNode(child, delta, inline, listType);
      }
      _insertNewline(delta, const <String, dynamic>{'blockquote': true});
      return;
    case 'pre':
      for (final child in node.nodes) {
        _appendHtmlNode(child, delta, inline.withCode(), listType);
      }
      _insertNewline(delta, const <String, dynamic>{'code-block': true});
      return;
    case 'p':
    case 'div':
    case 'section':
    case 'article':
      for (final child in node.nodes) {
        _appendHtmlNode(child, delta, inline, listType);
      }
      _insertNewline(delta, null);
      return;
    default:
      var nextInline = inline;
      if (tag == 'b' || tag == 'strong') {
        nextInline = nextInline.withBold();
      } else if (tag == 'i' || tag == 'em') {
        nextInline = nextInline.withItalic();
      } else if (tag == 'u') {
        nextInline = nextInline.withUnderline();
      } else if (tag == 's' || tag == 'strike' || tag == 'del') {
        nextInline = nextInline.withStrike();
      } else if (tag == 'code') {
        nextInline = nextInline.withCode();
      } else if (tag == 'a') {
        nextInline = nextInline.withLink(node.attributes['href']);
      }

      for (final child in node.nodes) {
        _appendHtmlNode(child, delta, nextInline, listType);
      }
  }
}

void _appendText(String text, Delta delta, _InlineAttributes inline) {
  if (text.isEmpty) {
    return;
  }

  final normalized = text.replaceAll('\r\n', '\n');
  final parts = normalized.split('\n');
  for (var i = 0; i < parts.length; i++) {
    final part = parts[i];
    if (part.isNotEmpty) {
      delta.insert(part, inline.toMap());
    }

    if (i < parts.length - 1) {
      delta.insert('\n');
    }
  }
}

void _insertNewline(Delta delta, Map<String, dynamic>? attrs) {
  if (_deltaEndsWithNewline(delta)) {
    return;
  }

  delta.insert('\n', attrs == null || attrs.isEmpty ? null : attrs);
}

bool _deltaEndsWithNewline(Delta delta) {
  final operations = delta.toList();
  if (operations.isEmpty) {
    return false;
  }

  final last = operations.last;
  final data = last.data;
  return data is String && data.endsWith('\n');
}

bool _isBlockAttribute(String key) {
  return key == 'list' || key == 'header' || key == 'blockquote' || key == 'code-block';
}

Map<String, dynamic> _toStringDynamicMap(Object? raw) {
  if (raw is Map<String, dynamic>) {
    return raw;
  }
  if (raw is Map) {
    return raw.map((key, value) => MapEntry(key.toString(), value));
  }
  return <String, dynamic>{};
}

String _renderStandardLine(_HtmlLine line) {
  final inner = _renderInlineSpans(line.spans);
  final headerLevel = line.attributes['header'];
  if (headerLevel is num) {
    final level = headerLevel.clamp(1, 6).toInt();
    return '<h$level>${inner.isEmpty ? '<br>' : inner}</h$level>';
  }

  if (line.attributes['blockquote'] == true) {
    return '<blockquote>${inner.isEmpty ? '<br>' : inner}</blockquote>';
  }

  if (line.attributes['code-block'] == true) {
    return '<pre><code>${inner.isEmpty ? ' ' : inner}</code></pre>';
  }

  return '<p>${inner.isEmpty ? '<br>' : inner}</p>';
}

String _renderInlineSpans(List<_HtmlSpan> spans) {
  if (spans.isEmpty) {
    return '';
  }

  final buffer = StringBuffer();
  for (final span in spans) {
    var text = _escapeHtml(span.text);
    final attrs = span.attributes;

    if (attrs['code'] == true) {
      text = '<code>$text</code>';
    }
    if (attrs['bold'] == true) {
      text = '<strong>$text</strong>';
    }
    if (attrs['italic'] == true) {
      text = '<em>$text</em>';
    }
    if (attrs['underline'] == true) {
      text = '<u>$text</u>';
    }
    if (attrs['strike'] == true) {
      text = '<s>$text</s>';
    }
    final link = attrs['link'];
    if (link is String && link.trim().isNotEmpty) {
      final safeHref = _escapeHtml(link.trim());
      text = '<a href="$safeHref">$text</a>';
    }

    buffer.write(text);
  }

  return buffer.toString();
}

String _escapeHtml(String input) {
  return input
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;');
}

class _InlineAttributes {
  const _InlineAttributes({
    this.bold = false,
    this.italic = false,
    this.underline = false,
    this.strike = false,
    this.code = false,
    this.link,
  });

  final bool bold;
  final bool italic;
  final bool underline;
  final bool strike;
  final bool code;
  final String? link;

  _InlineAttributes withBold() =>
      _InlineAttributes(bold: true, italic: italic, underline: underline, strike: strike, code: code, link: link);
  _InlineAttributes withItalic() =>
      _InlineAttributes(bold: bold, italic: true, underline: underline, strike: strike, code: code, link: link);
  _InlineAttributes withUnderline() =>
      _InlineAttributes(bold: bold, italic: italic, underline: true, strike: strike, code: code, link: link);
  _InlineAttributes withStrike() =>
      _InlineAttributes(bold: bold, italic: italic, underline: underline, strike: true, code: code, link: link);
  _InlineAttributes withCode() =>
      _InlineAttributes(bold: bold, italic: italic, underline: underline, strike: strike, code: true, link: link);
  _InlineAttributes withLink(String? value) => _InlineAttributes(
    bold: bold,
    italic: italic,
    underline: underline,
    strike: strike,
    code: code,
    link: value?.trim().isEmpty ?? true ? link : value?.trim(),
  );

  Map<String, dynamic>? toMap() {
    final map = <String, dynamic>{};
    if (bold) {
      map['bold'] = true;
    }
    if (italic) {
      map['italic'] = true;
    }
    if (underline) {
      map['underline'] = true;
    }
    if (strike) {
      map['strike'] = true;
    }
    if (code) {
      map['code'] = true;
    }
    if (link != null && link!.isNotEmpty) {
      map['link'] = link;
    }

    return map.isEmpty ? null : map;
  }
}

class _HtmlSpan {
  const _HtmlSpan(this.text, this.attributes);

  final String text;
  final Map<String, dynamic> attributes;
}

class _HtmlLine {
  const _HtmlLine({required this.spans, required this.attributes});

  final List<_HtmlSpan> spans;
  final Map<String, dynamic> attributes;
}
