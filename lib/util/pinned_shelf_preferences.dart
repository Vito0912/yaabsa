import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';

part 'pinned_shelf_preferences.freezed.dart';
part 'pinned_shelf_preferences.g.dart';

@freezed
abstract class PinnedShelfEntry with _$PinnedShelfEntry {
  const PinnedShelfEntry._();

  const factory PinnedShelfEntry({
    required String itemId,
    String? episodeId,
    @JsonKey(fromJson: _pinnedAtFromJson, toJson: _pinnedAtToJson) required DateTime pinnedAt,
  }) = _PinnedShelfEntry;

  factory PinnedShelfEntry.fromJson(Map<String, dynamic> json) => _$PinnedShelfEntryFromJson(json);

  bool get isPodcastEpisode => episodeId != null;

  String get key => pinnedShelfEntryKey(itemId, episodeId);
}

String pinnedShelfEntryKey(String itemId, [String? episodeId]) {
  return episodeId == null ? itemId : '$itemId:$episodeId';
}

DateTime _pinnedAtFromJson(Object? value) {
  final milliseconds = jsonIntFromDynamic(value);
  if (milliseconds == null) {
    throw const FormatException('Pinned shelf entry has an invalid pinnedAt value.');
  }
  return DateTime.fromMillisecondsSinceEpoch(milliseconds);
}

int _pinnedAtToJson(DateTime value) => value.millisecondsSinceEpoch;

class PinnedShelfPreferencesCodec {
  const PinnedShelfPreferencesCodec._();

  static Map<String, List<PinnedShelfEntry>> decode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const <String, List<PinnedShelfEntry>>{};
    }

    try {
      final decoded = jsonDecode(value);
      if (decoded is! Map) {
        return const <String, List<PinnedShelfEntry>>{};
      }

      final result = <String, List<PinnedShelfEntry>>{};
      for (final entry in decoded.entries) {
        final libraryId = entry.key.toString().trim();
        final rawEntries = entry.value;
        if (libraryId.isEmpty || rawEntries is! List) {
          continue;
        }

        final pins = <PinnedShelfEntry>[];
        final seenKeys = <String>{};
        for (final rawEntry in rawEntries) {
          if (rawEntry is! Map) {
            continue;
          }
          try {
            final pin = PinnedShelfEntry.fromJson(Map<String, dynamic>.from(rawEntry));
            if (pin.itemId.trim().isEmpty || !seenKeys.add(pin.key)) {
              continue;
            }
            pins.add(pin);
          } catch (_) {
            // Ignore a malformed entry without discarding valid pins.
          }
        }
        result[libraryId] = List<PinnedShelfEntry>.unmodifiable(pins);
      }

      return Map<String, List<PinnedShelfEntry>>.unmodifiable(result);
    } catch (_) {
      return const <String, List<PinnedShelfEntry>>{};
    }
  }

  static String encode(Map<String, List<PinnedShelfEntry>> value) {
    return jsonEncode(
      value.map(
        (libraryId, entries) => MapEntry(libraryId, entries.map((entry) => entry.toJson()).toList(growable: false)),
      ),
    );
  }
}
