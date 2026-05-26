import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yaabsa/util/setting_key.dart';

enum HomeLibraryMediaType {
  book,
  podcast;

  static HomeLibraryMediaType fromLibraryMediaType(String? libraryMediaType) {
    return libraryMediaType == 'podcast' ? HomeLibraryMediaType.podcast : HomeLibraryMediaType.book;
  }

  String get label {
    switch (this) {
      case HomeLibraryMediaType.book:
        return 'Book';
      case HomeLibraryMediaType.podcast:
        return 'Podcast';
    }
  }
}

enum HomePrimaryView {
  shelf,
  library,
  podcastAdd,
  collections,
  playlists,
  series,
  authors,
  narrators;

  String get storageKey => name;

  String get tabIntent => name;

  String get label {
    switch (this) {
      case HomePrimaryView.shelf:
        return 'Shelf';
      case HomePrimaryView.library:
        return 'Library';
      case HomePrimaryView.podcastAdd:
        return 'Add';
      case HomePrimaryView.collections:
        return 'Collections';
      case HomePrimaryView.playlists:
        return 'Playlists';
      case HomePrimaryView.series:
        return 'Series';
      case HomePrimaryView.authors:
        return 'Authors';
      case HomePrimaryView.narrators:
        return 'Narrators';
    }
  }

  IconData get icon {
    switch (this) {
      case HomePrimaryView.shelf:
        return Icons.home;
      case HomePrimaryView.library:
        return Icons.collections_bookmark_outlined;
      case HomePrimaryView.podcastAdd:
        return Icons.add_circle_outline_rounded;
      case HomePrimaryView.collections:
        return Icons.collections_outlined;
      case HomePrimaryView.playlists:
        return Icons.playlist_play_rounded;
      case HomePrimaryView.series:
        return Icons.view_column_outlined;
      case HomePrimaryView.authors:
        return Icons.person_outline_rounded;
      case HomePrimaryView.narrators:
        return Icons.record_voice_over_rounded;
    }
  }

  static HomePrimaryView? fromStorageKey(String? key) {
    if (key == null) {
      return null;
    }

    final normalized = key.trim().toLowerCase();
    if (normalized == 'add' || normalized == 'podcastadd' || normalized == 'podcast_add') {
      return HomePrimaryView.podcastAdd;
    }

    for (final view in HomePrimaryView.values) {
      if (view.storageKey == normalized) {
        return view;
      }
    }

    return null;
  }

  static HomePrimaryView? fromLabel(String? label) {
    if (label == null) {
      return null;
    }

    final normalized = label.trim().toLowerCase();
    for (final view in HomePrimaryView.values) {
      if (view.label.toLowerCase() == normalized) {
        return view;
      }
    }

    return null;
  }

  static HomePrimaryView? fromTabIntent(String? tabIntent) {
    final normalized = tabIntent?.trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    if (normalized == 'add' || normalized == 'podcastadd' || normalized == 'podcast_add') {
      return HomePrimaryView.podcastAdd;
    }

    return fromStorageKey(normalized);
  }
}

class HomeNavigationPreferences {
  const HomeNavigationPreferences({
    required this.mediaType,
    required this.orderedViews,
    required this.hiddenViews,
    required this.defaultView,
  });

  final HomeLibraryMediaType mediaType;
  final List<HomePrimaryView> orderedViews;
  final Set<HomePrimaryView> hiddenViews;
  final HomePrimaryView defaultView;

  List<HomePrimaryView> get visibleViews {
    return orderedViews.where((view) => !hiddenViews.contains(view)).toList(growable: false);
  }

  HomeNavigationPreferences withVisibility(HomePrimaryView view, bool isVisible) {
    final nextHiddenViews = hiddenViews.toSet();
    if (isVisible) {
      nextHiddenViews.remove(view);
    } else {
      nextHiddenViews.add(view);
    }

    return HomeNavigationPreferencesCodec._normalize(
      mediaType: mediaType,
      orderedViews: orderedViews,
      hiddenViews: nextHiddenViews,
      requestedDefaultView: defaultView,
    );
  }

  HomeNavigationPreferences withDefault(HomePrimaryView view) {
    return HomeNavigationPreferencesCodec._normalize(
      mediaType: mediaType,
      orderedViews: orderedViews,
      hiddenViews: hiddenViews,
      requestedDefaultView: view,
    );
  }

  HomeNavigationPreferences reordered(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= orderedViews.length || newIndex < 0 || newIndex >= orderedViews.length) {
      return this;
    }

    final nextOrderedViews = orderedViews.toList();
    final movedView = nextOrderedViews.removeAt(oldIndex);
    nextOrderedViews.insert(newIndex, movedView);

    return HomeNavigationPreferencesCodec._normalize(
      mediaType: mediaType,
      orderedViews: nextOrderedViews,
      hiddenViews: hiddenViews,
      requestedDefaultView: defaultView,
    );
  }
}

class HomeNavigationPreferencesCodec {
  static const String _defaultKey = 'default';
  static const String _orderKey = 'order';
  static const String _hiddenKey = 'hidden';

  static String settingKeyFor(HomeLibraryMediaType mediaType) {
    switch (mediaType) {
      case HomeLibraryMediaType.book:
        return SettingKeys.homeBookViewPreferences;
      case HomeLibraryMediaType.podcast:
        return SettingKeys.homePodcastViewPreferences;
    }
  }

  static List<HomePrimaryView> availableViewsFor(HomeLibraryMediaType mediaType) {
    switch (mediaType) {
      case HomeLibraryMediaType.book:
        return const [
          HomePrimaryView.shelf,
          HomePrimaryView.library,
          HomePrimaryView.collections,
          HomePrimaryView.playlists,
          HomePrimaryView.series,
          HomePrimaryView.authors,
          HomePrimaryView.narrators,
        ];
      case HomeLibraryMediaType.podcast:
        return const [
          HomePrimaryView.shelf,
          HomePrimaryView.library,
          HomePrimaryView.podcastAdd,
          HomePrimaryView.collections,
          HomePrimaryView.playlists,
        ];
    }
  }

  static String defaultEncodedFor(HomeLibraryMediaType mediaType) {
    final defaults = defaultsFor(mediaType);
    return encode(defaults);
  }

  static HomeNavigationPreferences defaultsFor(HomeLibraryMediaType mediaType) {
    final availableViews = availableViewsFor(mediaType);

    return HomeNavigationPreferences(
      mediaType: mediaType,
      orderedViews: List<HomePrimaryView>.unmodifiable(availableViews),
      hiddenViews: Set<HomePrimaryView>.unmodifiable(<HomePrimaryView>{}),
      defaultView: availableViews.first,
    );
  }

  static HomeNavigationPreferences decode(String? rawValue, HomeLibraryMediaType mediaType) {
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
      final availableViews = availableViewsFor(mediaType);

      final order = <HomePrimaryView>[];
      final rawOrder = decoded[_orderKey];
      if (rawOrder is List) {
        for (final rawView in rawOrder) {
          final parsedView = HomePrimaryView.fromStorageKey(rawView?.toString());
          if (parsedView != null && availableViews.contains(parsedView) && !order.contains(parsedView)) {
            order.add(parsedView);
          }
        }
      }

      for (final availableView in availableViews) {
        if (!order.contains(availableView)) {
          order.add(availableView);
        }
      }

      final hidden = <HomePrimaryView>{};
      final rawHidden = decoded[_hiddenKey];
      if (rawHidden is List) {
        for (final rawView in rawHidden) {
          final parsedView = HomePrimaryView.fromStorageKey(rawView?.toString());
          if (parsedView != null && order.contains(parsedView)) {
            hidden.add(parsedView);
          }
        }
      }

      final requestedDefault = HomePrimaryView.fromStorageKey(decoded[_defaultKey]?.toString());

      return _normalize(
        mediaType: mediaType,
        orderedViews: order,
        hiddenViews: hidden,
        requestedDefaultView: requestedDefault,
      );
    } catch (_) {
      return fallback;
    }
  }

  static String encode(HomeNavigationPreferences preferences) {
    final normalized = _normalize(
      mediaType: preferences.mediaType,
      orderedViews: preferences.orderedViews,
      hiddenViews: preferences.hiddenViews,
      requestedDefaultView: preferences.defaultView,
    );

    final orderedHidden = normalized.orderedViews
        .where((view) => normalized.hiddenViews.contains(view))
        .map((view) => view.storageKey)
        .toList(growable: false);

    final payload = <String, dynamic>{
      _defaultKey: normalized.defaultView.storageKey,
      _orderKey: normalized.orderedViews.map((view) => view.storageKey).toList(growable: false),
      _hiddenKey: orderedHidden,
    };

    return jsonEncode(payload);
  }

  static HomeNavigationPreferences _normalize({
    required HomeLibraryMediaType mediaType,
    required List<HomePrimaryView> orderedViews,
    required Set<HomePrimaryView> hiddenViews,
    required HomePrimaryView? requestedDefaultView,
  }) {
    final availableViews = availableViewsFor(mediaType);

    final normalizedOrder = <HomePrimaryView>[];
    for (final view in orderedViews) {
      if (availableViews.contains(view) && !normalizedOrder.contains(view)) {
        normalizedOrder.add(view);
      }
    }

    for (final view in availableViews) {
      if (!normalizedOrder.contains(view)) {
        normalizedOrder.add(view);
      }
    }

    final normalizedHidden = <HomePrimaryView>{};
    for (final view in hiddenViews) {
      if (normalizedOrder.contains(view)) {
        normalizedHidden.add(view);
      }
    }

    var visibleViews = normalizedOrder.where((view) => !normalizedHidden.contains(view)).toList(growable: false);
    if (visibleViews.isEmpty) {
      normalizedHidden.clear();
      visibleViews = List<HomePrimaryView>.from(normalizedOrder, growable: false);
    }

    final defaultView =
        requestedDefaultView != null &&
            normalizedOrder.contains(requestedDefaultView) &&
            !normalizedHidden.contains(requestedDefaultView)
        ? requestedDefaultView
        : visibleViews.first;

    return HomeNavigationPreferences(
      mediaType: mediaType,
      orderedViews: List<HomePrimaryView>.unmodifiable(normalizedOrder),
      hiddenViews: Set<HomePrimaryView>.unmodifiable(normalizedHidden),
      defaultView: defaultView,
    );
  }
}
