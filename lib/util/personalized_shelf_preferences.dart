import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yaabsa/util/home_navigation_preferences.dart';
import 'package:yaabsa/util/setting_key.dart';

const String _newestEpisodesSectionId = 'newest-episodes';

enum PersonalizedShelfSection {
  continueListening,
  newestEpisodes,
  listenAgain,
  continueSeries,
  recentlyAdded,
  discover,
  recentSeries,
  newestAuthors;

  String get id {
    switch (this) {
      case PersonalizedShelfSection.continueListening:
        return 'continue-listening';
      case PersonalizedShelfSection.newestEpisodes:
        return _newestEpisodesSectionId;
      case PersonalizedShelfSection.listenAgain:
        return 'listen-again';
      case PersonalizedShelfSection.continueSeries:
        return 'continue-series';
      case PersonalizedShelfSection.recentlyAdded:
        return 'recently-added';
      case PersonalizedShelfSection.discover:
        return 'discover';
      case PersonalizedShelfSection.recentSeries:
        return 'recent-series';
      case PersonalizedShelfSection.newestAuthors:
        return 'newest-authors';
    }
  }

  String get label {
    switch (this) {
      case PersonalizedShelfSection.continueListening:
        return 'Continue Listening';
      case PersonalizedShelfSection.newestEpisodes:
        return 'Newest Episodes';
      case PersonalizedShelfSection.listenAgain:
        return 'Listen Again';
      case PersonalizedShelfSection.continueSeries:
        return 'Continue Series';
      case PersonalizedShelfSection.recentlyAdded:
        return 'Recently Added';
      case PersonalizedShelfSection.discover:
        return 'Discover';
      case PersonalizedShelfSection.recentSeries:
        return 'Recently Added Series';
      case PersonalizedShelfSection.newestAuthors:
        return 'Recently Added Authors';
    }
  }

  IconData get icon {
    switch (this) {
      case PersonalizedShelfSection.continueListening:
        return Icons.play_circle_outline_rounded;
      case PersonalizedShelfSection.newestEpisodes:
        return Icons.podcasts_outlined;
      case PersonalizedShelfSection.listenAgain:
        return Icons.replay_rounded;
      case PersonalizedShelfSection.continueSeries:
        return Icons.auto_stories_outlined;
      case PersonalizedShelfSection.recentlyAdded:
        return Icons.schedule_rounded;
      case PersonalizedShelfSection.discover:
        return Icons.auto_awesome_outlined;
      case PersonalizedShelfSection.recentSeries:
        return Icons.view_column_outlined;
      case PersonalizedShelfSection.newestAuthors:
        return Icons.person_outline_rounded;
    }
  }

  static PersonalizedShelfSection? fromId(String? id) {
    if (id == null) {
      return null;
    }

    final normalized = id.trim().toLowerCase();
    for (final section in PersonalizedShelfSection.values) {
      if (section.id == normalized) {
        return section;
      }
    }

    return null;
  }
}

class PersonalizedShelfPreferences {
  const PersonalizedShelfPreferences({
    required this.mediaType,
    required this.orderedSectionIds,
    required this.hiddenSectionIds,
  });

  final HomeLibraryMediaType mediaType;
  final List<String> orderedSectionIds;
  final Set<String> hiddenSectionIds;

  PersonalizedShelfPreferences withVisibility(String sectionId, bool isVisible) {
    final nextHiddenSectionIds = hiddenSectionIds.toSet();
    if (isVisible) {
      nextHiddenSectionIds.remove(sectionId);
    } else {
      nextHiddenSectionIds.add(sectionId);
    }

    return PersonalizedShelfPreferencesCodec._normalize(
      mediaType: mediaType,
      orderedSectionIds: orderedSectionIds,
      hiddenSectionIds: nextHiddenSectionIds,
    );
  }

  PersonalizedShelfPreferences reordered(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= orderedSectionIds.length || newIndex < 0 || newIndex >= orderedSectionIds.length) {
      return this;
    }

    final nextOrderedIds = orderedSectionIds.toList();
    final movedId = nextOrderedIds.removeAt(oldIndex);
    nextOrderedIds.insert(newIndex, movedId);

    return PersonalizedShelfPreferencesCodec._normalize(
      mediaType: mediaType,
      orderedSectionIds: nextOrderedIds,
      hiddenSectionIds: hiddenSectionIds,
    );
  }
}

class PersonalizedShelfPreferencesCodec {
  static const String _orderKey = 'order';
  static const String _hiddenKey = 'hidden';

  static String settingKeyFor(HomeLibraryMediaType mediaType) {
    switch (mediaType) {
      case HomeLibraryMediaType.book:
        return SettingKeys.personalizedShelfBookSectionsPreferences;
      case HomeLibraryMediaType.podcast:
        return SettingKeys.personalizedShelfPodcastSectionsPreferences;
    }
  }

  static List<PersonalizedShelfSection> configurableSectionsFor(HomeLibraryMediaType mediaType) {
    switch (mediaType) {
      case HomeLibraryMediaType.book:
        return const [
          PersonalizedShelfSection.continueListening,
          PersonalizedShelfSection.continueSeries,
          PersonalizedShelfSection.recentlyAdded,
          PersonalizedShelfSection.discover,
          PersonalizedShelfSection.listenAgain,
          PersonalizedShelfSection.recentSeries,
          PersonalizedShelfSection.newestAuthors,
        ];
      case HomeLibraryMediaType.podcast:
        return const [
          PersonalizedShelfSection.continueListening,
          PersonalizedShelfSection.newestEpisodes,
          PersonalizedShelfSection.listenAgain,
          PersonalizedShelfSection.recentlyAdded,
          PersonalizedShelfSection.discover,
        ];
    }
  }

  static String defaultEncodedFor(HomeLibraryMediaType mediaType) {
    final defaults = defaultsFor(mediaType);
    return encode(defaults);
  }

  static PersonalizedShelfPreferences defaultsFor(HomeLibraryMediaType mediaType) {
    final configurableSectionIds = configurableSectionsFor(
      mediaType,
    ).map((section) => section.id).toList(growable: false);

    return PersonalizedShelfPreferences(
      mediaType: mediaType,
      orderedSectionIds: List<String>.unmodifiable(configurableSectionIds),
      hiddenSectionIds: Set<String>.unmodifiable(_alwaysHiddenSectionIdsFor(mediaType)),
    );
  }

  static PersonalizedShelfPreferences decode(String? rawValue, HomeLibraryMediaType mediaType) {
    final fallback = defaultsFor(mediaType);
    if (rawValue == null || rawValue.trim().isEmpty) {
      return fallback;
    }

    try {
      final decodedRaw = jsonDecode(rawValue);
      if (decodedRaw is! Map) {
        return fallback;
      }

      final decoded = Map<String, dynamic>.from(decodedRaw);

      final orderedSectionIds = <String>[];
      final rawOrder = decoded[_orderKey];
      if (rawOrder is List) {
        for (final rawSectionId in rawOrder) {
          final sectionId = rawSectionId?.toString().trim();
          if (sectionId == null || sectionId.isEmpty || orderedSectionIds.contains(sectionId)) {
            continue;
          }

          orderedSectionIds.add(sectionId);
        }
      }

      final hiddenSectionIds = <String>{};
      final rawHidden = decoded[_hiddenKey];
      if (rawHidden is List) {
        for (final rawSectionId in rawHidden) {
          final sectionId = rawSectionId?.toString().trim();
          if (sectionId == null || sectionId.isEmpty) {
            continue;
          }

          hiddenSectionIds.add(sectionId);
        }
      }

      return _normalize(mediaType: mediaType, orderedSectionIds: orderedSectionIds, hiddenSectionIds: hiddenSectionIds);
    } catch (_) {
      return fallback;
    }
  }

  static String encode(PersonalizedShelfPreferences preferences) {
    final normalized = _normalize(
      mediaType: preferences.mediaType,
      orderedSectionIds: preferences.orderedSectionIds,
      hiddenSectionIds: preferences.hiddenSectionIds,
    );

    final orderedHidden = normalized.orderedSectionIds
        .where((sectionId) => normalized.hiddenSectionIds.contains(sectionId))
        .toList(growable: false);

    final hiddenExtras = normalized.hiddenSectionIds.where((sectionId) => !orderedHidden.contains(sectionId)).toList()
      ..sort();

    final payload = <String, dynamic>{
      _orderKey: normalized.orderedSectionIds,
      _hiddenKey: [...orderedHidden, ...hiddenExtras],
    };

    return jsonEncode(payload);
  }

  static PersonalizedShelfPreferences _normalize({
    required HomeLibraryMediaType mediaType,
    required List<String> orderedSectionIds,
    required Set<String> hiddenSectionIds,
  }) {
    final configurableSectionIds = configurableSectionsFor(
      mediaType,
    ).map((section) => section.id).toList(growable: false);

    final normalizedOrder = <String>[];
    for (final sectionId in orderedSectionIds) {
      if (configurableSectionIds.contains(sectionId) && !normalizedOrder.contains(sectionId)) {
        normalizedOrder.add(sectionId);
      }
    }

    for (final sectionId in configurableSectionIds) {
      if (!normalizedOrder.contains(sectionId)) {
        normalizedOrder.add(sectionId);
      }
    }

    final normalizedHidden = <String>{..._alwaysHiddenSectionIdsFor(mediaType)};
    for (final sectionId in hiddenSectionIds) {
      final normalizedId = sectionId.trim();
      if (normalizedId.isEmpty) {
        continue;
      }
      normalizedHidden.add(normalizedId);
    }

    return PersonalizedShelfPreferences(
      mediaType: mediaType,
      orderedSectionIds: List<String>.unmodifiable(normalizedOrder),
      hiddenSectionIds: Set<String>.unmodifiable(normalizedHidden),
    );
  }

  static Set<String> _alwaysHiddenSectionIdsFor(HomeLibraryMediaType mediaType) {
    switch (mediaType) {
      case HomeLibraryMediaType.book:
        return const <String>{_newestEpisodesSectionId};
      case HomeLibraryMediaType.podcast:
        return const <String>{};
    }
  }
}
