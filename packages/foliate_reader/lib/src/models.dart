class FoliateLocation {
  final String? cfi;
  final double fraction;
  final Map<String, dynamic>? location;
  final FoliateTOCItem? tocItem;
  final FoliateTOCItem? pageItem;

  FoliateLocation({this.cfi, required this.fraction, this.location, this.tocItem, this.pageItem});

  factory FoliateLocation.fromJson(Map<String, dynamic> json) {
    return FoliateLocation(
      cfi: json['cfi'] as String?,
      fraction: (json['fraction'] as num?)?.toDouble() ?? 0.0,
      location: json['location'] != null ? Map<String, dynamic>.from(json['location'] as Map) : null,
      tocItem: json['tocItem'] != null
          ? FoliateTOCItem.fromJson(Map<String, dynamic>.from(json['tocItem'] as Map))
          : null,
      pageItem: json['pageItem'] != null
          ? FoliateTOCItem.fromJson(Map<String, dynamic>.from(json['pageItem'] as Map))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cfi': cfi,
      'fraction': fraction,
      'location': location,
      'tocItem': tocItem?.toJson(),
      'pageItem': pageItem?.toJson(),
    };
  }
}

class FoliateTOCItem {
  final String? label;
  final String? href;
  final List<FoliateTOCItem>? subitems;

  FoliateTOCItem({this.label, this.href, this.subitems});

  factory FoliateTOCItem.fromJson(Map<String, dynamic> json) {
    final sub = json['subitems'];
    return FoliateTOCItem(
      label: json['label']?.toString(),
      href: json['href']?.toString(),
      subitems: sub is List
          ? sub
                .map((e) {
                  try {
                    return FoliateTOCItem.fromJson(Map<String, dynamic>.from(e as Map));
                  } catch (_) {
                    return null;
                  }
                })
                .whereType<FoliateTOCItem>()
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'label': label, 'href': href, 'subitems': subitems?.map((e) => e.toJson()).toList()};
  }
}

class FoliateMetadata {
  final String? title;
  final String? author;
  final String? identifier;
  final List<String>? language;
  final String? description;
  final List<dynamic>? publisher;
  final String? published;
  final String? modified;
  final List<dynamic>? subject;
  final String? rights;

  FoliateMetadata({
    this.title,
    this.author,
    this.identifier,
    this.language,
    this.description,
    this.publisher,
    this.published,
    this.modified,
    this.subject,
    this.rights,
  });

  factory FoliateMetadata.fromJson(Map<String, dynamic> json) {
    final lang = json['language'];
    String? authorName;
    final authorVal = json['author'];
    if (authorVal is String) {
      authorName = authorVal;
    } else if (authorVal is List) {
      final names = <String>[];
      for (final item in authorVal) {
        if (item is Map) {
          final name = item['name'];
          if (name != null) {
            names.add(name.toString());
          }
        } else if (item != null) {
          names.add(item.toString());
        }
      }
      if (names.isNotEmpty) {
        authorName = names.join(', ');
      }
    } else if (authorVal is Map) {
      authorName = authorVal['name']?.toString();
    } else if (authorVal != null) {
      authorName = authorVal.toString();
    }

    List<String>? parsedLang;
    if (lang is List) {
      parsedLang = lang.map((e) {
        if (e is Map) {
          return e['name']?.toString() ?? e.toString();
        }
        return e.toString();
      }).toList();
    } else if (lang != null) {
      parsedLang = [lang.toString()];
    }

    return FoliateMetadata(
      title: json['title']?.toString(),
      author: authorName,
      identifier: json['identifier']?.toString(),
      language: parsedLang,
      description: json['description']?.toString(),
      publisher: json['publisher'] is List ? json['publisher'] as List : null,
      published: json['published']?.toString(),
      modified: json['modified']?.toString(),
      subject: json['subject'] is List ? json['subject'] as List : null,
      rights: json['rights']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'identifier': identifier,
      'language': language,
      'description': description,
      'publisher': publisher,
      'published': published,
      'modified': modified,
      'subject': subject,
      'rights': rights,
    };
  }
}

class FoliateAnnotation {
  final String value;
  final String color;
  final String? note;
  final String type;

  FoliateAnnotation({required this.value, required this.color, this.note, this.type = 'highlight'});

  factory FoliateAnnotation.fromJson(Map<String, dynamic> json) {
    return FoliateAnnotation(
      value: json['value'] as String,
      color: json['color'] as String,
      note: json['note'] as String?,
      type: json['type'] as String? ?? 'highlight',
    );
  }

  Map<String, dynamic> toJson() {
    return {'value': value, 'color': color, 'note': note, 'type': type};
  }
}

class FoliateSelection {
  final String cfi;
  final String text;
  final int index;
  final double x;
  final double y;
  final double height;

  FoliateSelection({
    required this.cfi,
    required this.text,
    required this.index,
    required this.x,
    required this.y,
    required this.height,
  });

  factory FoliateSelection.fromJson(Map<String, dynamic> json) {
    return FoliateSelection(
      cfi: json['cfi'] as String,
      text: json['text'] as String,
      index: json['index'] as int,
      x: (json['x'] as num?)?.toDouble() ?? 0.0,
      y: (json['y'] as num?)?.toDouble() ?? 0.0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'cfi': cfi, 'text': text, 'index': index, 'x': x, 'y': y, 'height': height};
  }
}

class FoliateSearchResult {
  final String cfi;
  final String excerpt;

  FoliateSearchResult({required this.cfi, required this.excerpt});

  factory FoliateSearchResult.fromJson(Map<String, dynamic> json) {
    return FoliateSearchResult(cfi: json['cfi'] as String? ?? '', excerpt: json['excerpt'] as String? ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'cfi': cfi, 'excerpt': excerpt};
  }
}
