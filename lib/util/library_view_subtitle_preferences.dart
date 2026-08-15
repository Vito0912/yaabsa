import 'dart:convert';

import 'package:yaabsa/util/setting_key.dart';

enum LibraryViewSubtitleView { library, series, authors }

extension LibraryViewSubtitleViewX on LibraryViewSubtitleView {
  String get label => switch (this) {
    LibraryViewSubtitleView.library => 'Library items',
    LibraryViewSubtitleView.series => 'Series',
    LibraryViewSubtitleView.authors => 'Authors',
  };

  String get settingKey => switch (this) {
    LibraryViewSubtitleView.library => SettingKeys.libraryViewSubtitlePreferences,
    LibraryViewSubtitleView.series => SettingKeys.seriesViewSubtitlePreferences,
    LibraryViewSubtitleView.authors => SettingKeys.authorsViewSubtitlePreferences,
  };
}

enum LibraryViewSubtitleMode { sort, none, custom }

extension LibraryViewSubtitleModeX on LibraryViewSubtitleMode {
  String get storageKey => name;

  String get label => switch (this) {
    LibraryViewSubtitleMode.sort => 'Automatic',
    LibraryViewSubtitleMode.none => 'Hidden',
    LibraryViewSubtitleMode.custom => 'Choose fields',
  };

  String get description => switch (this) {
    LibraryViewSubtitleMode.sort => 'Shows the information based on the current filter',
    LibraryViewSubtitleMode.none => 'Never show any information',
    LibraryViewSubtitleMode.custom => 'Choose up to three fields to show below the item/series/author',
  };

  static LibraryViewSubtitleMode? tryParse(String? raw) {
    for (final mode in LibraryViewSubtitleMode.values) {
      if (mode.storageKey == raw) {
        return mode;
      }
    }
    return null;
  }
}

enum LibraryViewSubtitleField {
  author,
  series,
  duration,
  size,
  tracks,
  addedAt,
  publishedYear,
  narrator,
  birthtime,
  modified,
  numBooks,
  totalDuration,
  updatedAt,
}

extension LibraryViewSubtitleFieldX on LibraryViewSubtitleField {
  String get storageKey => name;

  String get label => switch (this) {
    LibraryViewSubtitleField.author => 'Author',
    LibraryViewSubtitleField.series => 'Series',
    LibraryViewSubtitleField.duration => 'Duration',
    LibraryViewSubtitleField.size => 'Size',
    LibraryViewSubtitleField.tracks => 'Tracks',
    LibraryViewSubtitleField.addedAt => 'Added date',
    LibraryViewSubtitleField.publishedYear => 'Published year',
    LibraryViewSubtitleField.narrator => 'Narrator',
    LibraryViewSubtitleField.birthtime => 'File birth date',
    LibraryViewSubtitleField.modified => 'File modified date',
    LibraryViewSubtitleField.numBooks => 'Books',
    LibraryViewSubtitleField.totalDuration => 'Total duration',
    LibraryViewSubtitleField.updatedAt => 'Updated date',
  };

  String get subtitleLabel => switch (this) {
    LibraryViewSubtitleField.addedAt => 'Added',
    LibraryViewSubtitleField.modified => 'Modified',
    LibraryViewSubtitleField.updatedAt => 'Updated',
    _ => label,
  };

  String get subtitleSeparator => switch (this) {
    LibraryViewSubtitleField.addedAt ||
    LibraryViewSubtitleField.modified ||
    LibraryViewSubtitleField.updatedAt => '\u00a0',
    _ => ':\u00a0',
  };

  static LibraryViewSubtitleField? tryParse(String? raw) {
    for (final field in LibraryViewSubtitleField.values) {
      if (field.storageKey == raw) {
        return field;
      }
    }
    return null;
  }
}

class LibraryViewSubtitlePreferences {
  const LibraryViewSubtitlePreferences({required this.mode, required this.fields});

  final LibraryViewSubtitleMode mode;
  final List<LibraryViewSubtitleField> fields;
}

class LibraryViewSubtitlePreferencesCodec {
  static const int maxCustomFields = 3;

  static const List<LibraryViewSubtitleField> libraryFields = [
    LibraryViewSubtitleField.author,
    LibraryViewSubtitleField.series,
    LibraryViewSubtitleField.duration,
    LibraryViewSubtitleField.size,
    LibraryViewSubtitleField.tracks,
    LibraryViewSubtitleField.addedAt,
    LibraryViewSubtitleField.publishedYear,
    LibraryViewSubtitleField.narrator,
    LibraryViewSubtitleField.birthtime,
    LibraryViewSubtitleField.modified,
  ];

  static const List<LibraryViewSubtitleField> seriesFields = [
    LibraryViewSubtitleField.numBooks,
    LibraryViewSubtitleField.totalDuration,
    LibraryViewSubtitleField.addedAt,
  ];

  static const List<LibraryViewSubtitleField> authorsFields = [
    LibraryViewSubtitleField.numBooks,
    LibraryViewSubtitleField.addedAt,
    LibraryViewSubtitleField.updatedAt,
  ];

  static List<LibraryViewSubtitleField> fieldsFor(LibraryViewSubtitleView view) => switch (view) {
    LibraryViewSubtitleView.library => libraryFields,
    LibraryViewSubtitleView.series => seriesFields,
    LibraryViewSubtitleView.authors => authorsFields,
  };

  static LibraryViewSubtitlePreferences defaultsFor(LibraryViewSubtitleView view) {
    return const LibraryViewSubtitlePreferences(
      mode: LibraryViewSubtitleMode.sort,
      fields: <LibraryViewSubtitleField>[],
    );
  }

  static String defaultEncodedFor(LibraryViewSubtitleView view) => encode(defaultsFor(view));

  static String encode(LibraryViewSubtitlePreferences preferences) {
    return jsonEncode({
      'mode': preferences.mode.storageKey,
      'fields': preferences.fields.take(maxCustomFields).map((field) => field.storageKey).toList(growable: false),
    });
  }

  static LibraryViewSubtitlePreferences decode(String? raw, LibraryViewSubtitleView view) {
    final fallback = defaultsFor(view);
    if (raw == null || raw.trim().isEmpty) {
      return fallback;
    }

    try {
      final decodedRaw = jsonDecode(raw);
      if (decodedRaw is! Map) {
        return fallback;
      }

      final mode = LibraryViewSubtitleModeX.tryParse(decodedRaw['mode']?.toString()) ?? fallback.mode;
      final availableFields = fieldsFor(view).toSet();
      final rawFields = decodedRaw['fields'];
      final fields = rawFields is List
          ? rawFields
                .map((value) => LibraryViewSubtitleFieldX.tryParse(value?.toString()))
                .whereType<LibraryViewSubtitleField>()
                .where(availableFields.contains)
                .toSet()
                .take(maxCustomFields)
                .toList(growable: false)
          : const <LibraryViewSubtitleField>[];

      return LibraryViewSubtitlePreferences(mode: mode, fields: fields);
    } catch (_) {
      return fallback;
    }
  }
}
