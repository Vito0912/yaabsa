import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yaabsa/screens/player/player_empty_state_mode.dart';
import 'package:yaabsa/util/globals.dart';

enum PlayerComponentType { cover, mediaInfo, seekBar, controls, utilities, subtitles, chapters, queue }

enum PlayerUtilityType { sleepTimer, speed, chapter, volume }

enum PlayerLayoutScreenSize {
  mobile,
  tablet,
  desktop;

  String get label {
    switch (this) {
      case PlayerLayoutScreenSize.mobile:
        return 'Mobile';
      case PlayerLayoutScreenSize.tablet:
        return 'Tablet';
      case PlayerLayoutScreenSize.desktop:
        return 'Desktop';
    }
  }

  static PlayerLayoutScreenSize fromBreakpoint(Breakpoint breakpoint) {
    switch (breakpoint) {
      case Breakpoint.mobile:
        return PlayerLayoutScreenSize.mobile;
      case Breakpoint.tablet:
        return PlayerLayoutScreenSize.tablet;
      case Breakpoint.desktop:
        return PlayerLayoutScreenSize.desktop;
    }
  }
}

enum PlayerMetadataTextAlign {
  start,
  center,
  end;

  String get label {
    switch (this) {
      case PlayerMetadataTextAlign.start:
        return 'Start';
      case PlayerMetadataTextAlign.center:
        return 'Center';
      case PlayerMetadataTextAlign.end:
        return 'End';
    }
  }

  TextAlign get textAlign {
    switch (this) {
      case PlayerMetadataTextAlign.start:
        return TextAlign.start;
      case PlayerMetadataTextAlign.center:
        return TextAlign.center;
      case PlayerMetadataTextAlign.end:
        return TextAlign.end;
    }
  }

  CrossAxisAlignment get crossAxisAlignment {
    switch (this) {
      case PlayerMetadataTextAlign.start:
        return CrossAxisAlignment.start;
      case PlayerMetadataTextAlign.center:
        return CrossAxisAlignment.center;
      case PlayerMetadataTextAlign.end:
        return CrossAxisAlignment.end;
    }
  }

  static PlayerMetadataTextAlign fromSettingValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return PlayerMetadataTextAlign.start;
    }

    final normalized = value.trim().toLowerCase();
    for (final mode in PlayerMetadataTextAlign.values) {
      if (mode.name.toLowerCase() == normalized) {
        return mode;
      }
    }

    return PlayerMetadataTextAlign.start;
  }
}

enum PlayerCoverFitMode {
  height,
  width,
  fill;

  String get label {
    switch (this) {
      case PlayerCoverFitMode.height:
        return 'Fill Height';
      case PlayerCoverFitMode.width:
        return 'Fill Width';
      case PlayerCoverFitMode.fill:
        return 'Fill Box';
    }
  }

  BoxFit get boxFit {
    switch (this) {
      case PlayerCoverFitMode.height:
        return BoxFit.fitHeight;
      case PlayerCoverFitMode.width:
        return BoxFit.fitWidth;
      case PlayerCoverFitMode.fill:
        return BoxFit.fill;
    }
  }

  static PlayerCoverFitMode fromSettingValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return PlayerCoverFitMode.height;
    }

    final normalized = value.trim().toLowerCase();
    for (final mode in PlayerCoverFitMode.values) {
      if (mode.name.toLowerCase() == normalized) {
        return mode;
      }
    }

    return PlayerCoverFitMode.height;
  }
}

enum PlayerSeekTimePlacement {
  inline,
  below,
  underAppBar;

  String get label {
    switch (this) {
      case PlayerSeekTimePlacement.inline:
        return 'Inline';
      case PlayerSeekTimePlacement.below:
        return 'Below Seek Bar';
      case PlayerSeekTimePlacement.underAppBar:
        return 'Under App Bar';
    }
  }

  bool get timeLabelsBelow => this == PlayerSeekTimePlacement.below;

  bool get showLabelsInComponent => this != PlayerSeekTimePlacement.underAppBar;

  static PlayerSeekTimePlacement fromSettingValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return PlayerSeekTimePlacement.inline;
    }

    final normalized = value.trim().toLowerCase();
    for (final mode in PlayerSeekTimePlacement.values) {
      if (mode.name.toLowerCase() == normalized) {
        return mode;
      }
    }

    return PlayerSeekTimePlacement.inline;
  }
}

extension PlayerComponentTypeX on PlayerComponentType {
  String get label {
    switch (this) {
      case PlayerComponentType.cover:
        return 'Cover';
      case PlayerComponentType.mediaInfo:
        return 'Media Info';
      case PlayerComponentType.seekBar:
        return 'Seek Bar';
      case PlayerComponentType.controls:
        return 'Controls';
      case PlayerComponentType.utilities:
        return 'Utilities';
      case PlayerComponentType.subtitles:
        return 'Subtitles';
      case PlayerComponentType.chapters:
        return 'Chapters';
      case PlayerComponentType.queue:
        return 'Queue';
    }
  }

  static PlayerComponentType? fromSettingValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final normalized = value.trim().toLowerCase();
    for (final type in PlayerComponentType.values) {
      if (type.name.toLowerCase() == normalized) {
        return type;
      }
    }

    return null;
  }
}

extension PlayerUtilityTypeX on PlayerUtilityType {
  String get label {
    switch (this) {
      case PlayerUtilityType.sleepTimer:
        return 'Sleep Timer';
      case PlayerUtilityType.speed:
        return 'Playback Speed';
      case PlayerUtilityType.chapter:
        return 'Chapter Picker';
      case PlayerUtilityType.volume:
        return 'Volume';
    }
  }

  static PlayerUtilityType? fromSettingValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final normalized = value.trim().toLowerCase();
    for (final type in PlayerUtilityType.values) {
      if (type.name.toLowerCase() == normalized) {
        return type;
      }
    }

    return null;
  }
}

class PlayerComponentConstraints {
  const PlayerComponentConstraints({
    required this.minWidth,
    required this.maxWidth,
    required this.minHeight,
    required this.maxHeight,
  });

  final int minWidth;
  final int maxWidth;
  final int minHeight;
  final int maxHeight;

  int resolvedMaxWidth(int columns) {
    final capped = maxWidth < columns ? maxWidth : columns;
    return capped < minWidth ? minWidth : capped;
  }

  int resolvedMaxHeight(int rows) {
    final capped = maxHeight < rows ? maxHeight : rows;
    return capped < minHeight ? minHeight : capped;
  }
}

const List<PlayerComponentType> defaultPlayerComponentOrder = <PlayerComponentType>[
  PlayerComponentType.cover,
  PlayerComponentType.mediaInfo,
  PlayerComponentType.seekBar,
  PlayerComponentType.controls,
  PlayerComponentType.utilities,
  PlayerComponentType.subtitles,
  PlayerComponentType.chapters,
  PlayerComponentType.queue,
];

const List<PlayerUtilityType> defaultPlayerUtilityOrder = <PlayerUtilityType>[
  PlayerUtilityType.speed,
  PlayerUtilityType.chapter,
  PlayerUtilityType.volume,
  PlayerUtilityType.sleepTimer,
];

const Map<PlayerComponentType, PlayerComponentConstraints> _componentConstraints =
    <PlayerComponentType, PlayerComponentConstraints>{
      PlayerComponentType.cover: PlayerComponentConstraints(minWidth: 6, maxWidth: 100, minHeight: 6, maxHeight: 100),
      PlayerComponentType.mediaInfo: PlayerComponentConstraints(minWidth: 8, maxWidth: 40, minHeight: 6, maxHeight: 40),
      PlayerComponentType.seekBar: PlayerComponentConstraints(minWidth: 20, maxWidth: 40, minHeight: 2, maxHeight: 10),
      PlayerComponentType.controls: PlayerComponentConstraints(minWidth: 10, maxWidth: 40, minHeight: 4, maxHeight: 12),
      PlayerComponentType.utilities: PlayerComponentConstraints(minWidth: 8, maxWidth: 40, minHeight: 4, maxHeight: 16),
      PlayerComponentType.subtitles: PlayerComponentConstraints(
        minWidth: 10,
        maxWidth: 40,
        minHeight: 2,
        maxHeight: 10,
      ),
      PlayerComponentType.chapters: PlayerComponentConstraints(minWidth: 8, maxWidth: 40, minHeight: 6, maxHeight: 40),
      PlayerComponentType.queue: PlayerComponentConstraints(minWidth: 8, maxWidth: 40, minHeight: 6, maxHeight: 40),
    };

PlayerComponentConstraints playerComponentConstraintsFor(PlayerComponentType type) {
  return _componentConstraints[type]!;
}

const int _playerGridColumns = 40;
const int _playerGridRows = 44;

int playerGridColumnsForSize(PlayerLayoutScreenSize screenSize) {
  return _playerGridColumns;
}

int playerGridRowsForSize(PlayerLayoutScreenSize screenSize) {
  return _playerGridRows;
}

int _intFromDynamic(dynamic value, int fallback) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value) ?? fallback;
  }
  return fallback;
}

bool _boolFromDynamic(dynamic value, bool fallback) {
  if (value is bool) {
    return value;
  }
  if (value is String) {
    if (value.toLowerCase() == 'true') {
      return true;
    }
    if (value.toLowerCase() == 'false') {
      return false;
    }
  }
  return fallback;
}

double _doubleFromDynamic(dynamic value, double fallback) {
  if (value is double) {
    return value;
  }
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value) ?? fallback;
  }
  return fallback;
}

List<PlayerUtilityType> _utilityListFromDynamic(dynamic value) {
  if (value is! List<dynamic>) {
    return <PlayerUtilityType>[];
  }

  return value
      .map((entry) => PlayerUtilityTypeX.fromSettingValue(entry?.toString()))
      .whereType<PlayerUtilityType>()
      .toList(growable: false);
}

class PlayerComponentPlacement {
  const PlayerComponentPlacement({
    required this.type,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.visible,
    this.emptyMode = PlayerCollectionEmptyMode.full,
    this.showAuthor = true,
    this.showNarrator = false,
    this.showSeries = true,
    this.textAlign = PlayerMetadataTextAlign.start,
    this.scale = 1.0,
    this.coverFitMode = PlayerCoverFitMode.height,
    this.seekTimePlacement = PlayerSeekTimePlacement.inline,
    this.seekTrackHeight = 8.0,
    this.seekTimeLabelFontSize = 12.0,
    this.cardStyle = false,
  });

  final PlayerComponentType type;
  final int x;
  final int y;
  final int width;
  final int height;
  final bool visible;
  final PlayerCollectionEmptyMode emptyMode;
  final bool showAuthor;
  final bool showNarrator;
  final bool showSeries;
  final PlayerMetadataTextAlign textAlign;
  final double scale;
  final PlayerCoverFitMode coverFitMode;
  final PlayerSeekTimePlacement seekTimePlacement;
  final double seekTrackHeight;
  final double seekTimeLabelFontSize;
  final bool cardStyle;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type.name,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'visible': visible,
      'emptyMode': emptyMode.name,
      'showAuthor': showAuthor,
      'showNarrator': showNarrator,
      'showSeries': showSeries,
      'textAlign': textAlign.name,
      'scale': scale,
      'coverFitMode': coverFitMode.name,
      'seekTimePlacement': seekTimePlacement.name,
      'seekTrackHeight': seekTrackHeight,
      'seekTimeLabelFontSize': seekTimeLabelFontSize,
      'cardStyle': cardStyle,
    };
  }

  static PlayerComponentPlacement? fromMap(Map<String, dynamic> map) {
    final type = PlayerComponentTypeX.fromSettingValue(map['type']?.toString());
    if (type == null) {
      return null;
    }

    return PlayerComponentPlacement(
      type: type,
      x: _intFromDynamic(map['x'], 0),
      y: _intFromDynamic(map['y'], 0),
      width: _intFromDynamic(map['width'], 2),
      height: _intFromDynamic(map['height'], 2),
      visible: _boolFromDynamic(map['visible'], false),
      emptyMode: PlayerCollectionEmptyModeX.fromSettingValue(map['emptyMode']?.toString()),
      showAuthor: _boolFromDynamic(map['showAuthor'], true),
      showNarrator: _boolFromDynamic(map['showNarrator'], false),
      showSeries: _boolFromDynamic(map['showSeries'], true),
      textAlign: PlayerMetadataTextAlign.fromSettingValue(map['textAlign']?.toString()),
      scale: (map['scale'] is num) ? (map['scale'] as num).toDouble() : 1.0,
      coverFitMode: PlayerCoverFitMode.fromSettingValue(map['coverFitMode']?.toString()),
      seekTimePlacement: PlayerSeekTimePlacement.fromSettingValue(map['seekTimePlacement']?.toString()),
      seekTrackHeight: _doubleFromDynamic(map['seekTrackHeight'], 8.0),
      seekTimeLabelFontSize: _doubleFromDynamic(map['seekTimeLabelFontSize'], 12.0),
      cardStyle: _boolFromDynamic(map['cardStyle'], false),
    );
  }

  PlayerComponentPlacement copyWith({
    int? x,
    int? y,
    int? width,
    int? height,
    bool? visible,
    PlayerCollectionEmptyMode? emptyMode,
    bool? showAuthor,
    bool? showNarrator,
    bool? showSeries,
    PlayerMetadataTextAlign? textAlign,
    double? scale,
    PlayerCoverFitMode? coverFitMode,
    PlayerSeekTimePlacement? seekTimePlacement,
    double? seekTrackHeight,
    double? seekTimeLabelFontSize,
    bool? cardStyle,
  }) {
    return PlayerComponentPlacement(
      type: type,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      visible: visible ?? this.visible,
      emptyMode: emptyMode ?? this.emptyMode,
      showAuthor: showAuthor ?? this.showAuthor,
      showNarrator: showNarrator ?? this.showNarrator,
      showSeries: showSeries ?? this.showSeries,
      textAlign: textAlign ?? this.textAlign,
      scale: scale ?? this.scale,
      coverFitMode: coverFitMode ?? this.coverFitMode,
      seekTimePlacement: seekTimePlacement ?? this.seekTimePlacement,
      seekTrackHeight: seekTrackHeight ?? this.seekTrackHeight,
      seekTimeLabelFontSize: seekTimeLabelFontSize ?? this.seekTimeLabelFontSize,
      cardStyle: cardStyle ?? this.cardStyle,
    );
  }
}

class PlayerLayoutProfile {
  const PlayerLayoutProfile({required this.placements, required this.utilityOrder, required this.hiddenUtilities});

  final List<PlayerComponentPlacement> placements;
  final List<PlayerUtilityType> utilityOrder;
  final List<PlayerUtilityType> hiddenUtilities;

  factory PlayerLayoutProfile.defaults(PlayerLayoutScreenSize screenSize) {
    return PlayerLayoutProfile(
      placements: _defaultPlacementsForScreen(screenSize),
      utilityOrder: List<PlayerUtilityType>.from(_defaultUtilityOrderForScreen(screenSize)),
      hiddenUtilities: List<PlayerUtilityType>.from(_defaultHiddenUtilitiesForScreen(screenSize)),
    );
  }

  factory PlayerLayoutProfile.fromMap(PlayerLayoutScreenSize screenSize, Map<String, dynamic> map) {
    final rawPlacements = map['placements'];
    final parsedPlacements = <PlayerComponentPlacement>[];

    if (rawPlacements is List<dynamic>) {
      for (final entry in rawPlacements) {
        if (entry is Map<String, dynamic>) {
          final parsed = PlayerComponentPlacement.fromMap(entry);
          if (parsed != null) {
            parsedPlacements.add(parsed);
          }
        } else if (entry is Map) {
          final converted = entry.map((key, value) => MapEntry(key.toString(), value));
          final parsed = PlayerComponentPlacement.fromMap(converted);
          if (parsed != null) {
            parsedPlacements.add(parsed);
          }
        }
      }
    }

    final mergedPlacements = _mergeWithDefaultPlacements(screenSize, parsedPlacements);

    final fallbackUtilityOrder = _defaultUtilityOrderForScreen(screenSize);

    final parsedUtilityOrder = _utilityListFromDynamic(map['utilityOrder']);
    final utilityOrder = parsedUtilityOrder.isEmpty
        ? List<PlayerUtilityType>.from(fallbackUtilityOrder)
        : _mergeWithDefaultUtilities(parsedUtilityOrder, fallbackOrder: fallbackUtilityOrder);

    final hiddenUtilities = _dedupeUtilities(
      _utilityListFromDynamic(map['hiddenUtilities']),
    ).where((type) => utilityOrder.contains(type)).toList(growable: false);

    return PlayerLayoutProfile(
      placements: mergedPlacements,
      utilityOrder: utilityOrder,
      hiddenUtilities: hiddenUtilities,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'placements': placements.map((placement) => placement.toMap()).toList(growable: false),
      'utilityOrder': utilityOrder.map((entry) => entry.name).toList(growable: false),
      'hiddenUtilities': hiddenUtilities.map((entry) => entry.name).toList(growable: false),
    };
  }

  PlayerComponentPlacement placementFor(PlayerComponentType type) {
    return placements.firstWhere((placement) => placement.type == type);
  }

  PlayerLayoutProfile upsertPlacement(PlayerComponentPlacement updatedPlacement) {
    final nextPlacements = placements
        .map((placement) => placement.type == updatedPlacement.type ? updatedPlacement : placement)
        .toList(growable: false);

    return copyWith(placements: nextPlacements);
  }

  PlayerLayoutProfile copyWith({
    List<PlayerComponentPlacement>? placements,
    List<PlayerUtilityType>? utilityOrder,
    List<PlayerUtilityType>? hiddenUtilities,
  }) {
    return PlayerLayoutProfile(
      placements: placements ?? this.placements,
      utilityOrder: utilityOrder ?? this.utilityOrder,
      hiddenUtilities: hiddenUtilities ?? this.hiddenUtilities,
    );
  }

  List<PlayerComponentPlacement> get orderedPlacements {
    final sorted = List<PlayerComponentPlacement>.from(placements);
    sorted.sort((a, b) {
      final byY = a.y.compareTo(b.y);
      if (byY != 0) {
        return byY;
      }
      return a.x.compareTo(b.x);
    });
    return sorted;
  }
}

class PlayerLayoutConfig {
  const PlayerLayoutConfig({required this.mobile, required this.tablet, required this.desktop});

  final PlayerLayoutProfile mobile;
  final PlayerLayoutProfile tablet;
  final PlayerLayoutProfile desktop;

  factory PlayerLayoutConfig.defaults() {
    return PlayerLayoutConfig(
      mobile: PlayerLayoutProfile.defaults(PlayerLayoutScreenSize.mobile),
      tablet: PlayerLayoutProfile.defaults(PlayerLayoutScreenSize.tablet),
      desktop: PlayerLayoutProfile.defaults(PlayerLayoutScreenSize.desktop),
    );
  }

  factory PlayerLayoutConfig.fromSettingValue(String? rawValue) {
    if (rawValue == null || rawValue.trim().isEmpty) {
      return PlayerLayoutConfig.defaults();
    }

    try {
      final decoded = jsonDecode(rawValue);
      if (decoded is! Map<String, dynamic>) {
        return PlayerLayoutConfig.defaults();
      }

      final mobileMap = _ensureMap(decoded['mobile']);
      final tabletMap = _ensureMap(decoded['tablet']);
      final desktopMap = _ensureMap(decoded['desktop']);

      return PlayerLayoutConfig(
        mobile: PlayerLayoutProfile.fromMap(PlayerLayoutScreenSize.mobile, mobileMap),
        tablet: PlayerLayoutProfile.fromMap(PlayerLayoutScreenSize.tablet, tabletMap),
        desktop: PlayerLayoutProfile.fromMap(PlayerLayoutScreenSize.desktop, desktopMap),
      );
    } catch (_) {
      return PlayerLayoutConfig.defaults();
    }
  }

  String toSettingValue() {
    return jsonEncode(<String, dynamic>{
      'mobile': mobile.toMap(),
      'tablet': tablet.toMap(),
      'desktop': desktop.toMap(),
    });
  }

  PlayerLayoutProfile profileFor(PlayerLayoutScreenSize screenSize) {
    switch (screenSize) {
      case PlayerLayoutScreenSize.mobile:
        return mobile;
      case PlayerLayoutScreenSize.tablet:
        return tablet;
      case PlayerLayoutScreenSize.desktop:
        return desktop;
    }
  }

  PlayerLayoutConfig copyWithProfile(PlayerLayoutScreenSize screenSize, PlayerLayoutProfile profile) {
    switch (screenSize) {
      case PlayerLayoutScreenSize.mobile:
        return PlayerLayoutConfig(mobile: profile, tablet: tablet, desktop: desktop);
      case PlayerLayoutScreenSize.tablet:
        return PlayerLayoutConfig(mobile: mobile, tablet: profile, desktop: desktop);
      case PlayerLayoutScreenSize.desktop:
        return PlayerLayoutConfig(mobile: mobile, tablet: tablet, desktop: profile);
    }
  }
}

Map<String, dynamic> _ensureMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, val) => MapEntry(key.toString(), val));
  }
  return <String, dynamic>{};
}

List<PlayerComponentPlacement> _mergeWithDefaultPlacements(
  PlayerLayoutScreenSize screenSize,
  List<PlayerComponentPlacement> placements,
) {
  final defaults = _defaultPlacementsForScreen(screenSize);
  final byType = <PlayerComponentType, PlayerComponentPlacement>{
    for (final placement in placements) placement.type: placement,
  };

  return defaults.map((defaultPlacement) => byType[defaultPlacement.type] ?? defaultPlacement).toList(growable: false);
}

List<PlayerUtilityType> _mergeWithDefaultUtilities(
  List<PlayerUtilityType> utilities, {
  required List<PlayerUtilityType> fallbackOrder,
}) {
  final deduped = _dedupeUtilities(utilities);
  final seen = <PlayerUtilityType>{...deduped};
  final merged = <PlayerUtilityType>[...deduped];

  for (final utility in fallbackOrder) {
    if (seen.add(utility)) {
      merged.add(utility);
    }
  }

  return merged;
}

List<PlayerUtilityType> _dedupeUtilities(List<PlayerUtilityType> utilities) {
  final seen = <PlayerUtilityType>{};
  final deduped = <PlayerUtilityType>[];

  for (final utility in utilities) {
    if (seen.add(utility)) {
      deduped.add(utility);
    }
  }

  return deduped;
}

List<PlayerComponentPlacement> _defaultPlacementsForScreen(PlayerLayoutScreenSize screenSize) {
  switch (screenSize) {
    case PlayerLayoutScreenSize.mobile:
      return const <PlayerComponentPlacement>[
        PlayerComponentPlacement(type: PlayerComponentType.cover, x: 0, y: 0, width: 40, height: 15, visible: true),
        PlayerComponentPlacement(
          type: PlayerComponentType.mediaInfo,
          x: 0,
          y: 19,
          width: 40,
          height: 10,
          visible: true,
          textAlign: PlayerMetadataTextAlign.center,
        ),
        PlayerComponentPlacement(type: PlayerComponentType.utilities, x: 0, y: 40, width: 40, height: 4, visible: true),
        PlayerComponentPlacement(
          type: PlayerComponentType.subtitles,
          x: 0,
          y: 32,
          width: 40,
          height: 4,
          visible: false,
        ),
        PlayerComponentPlacement(
          type: PlayerComponentType.chapters,
          x: 0,
          y: 15,
          width: 8,
          height: 6,
          visible: false,
          emptyMode: PlayerCollectionEmptyMode.hide,
        ),
        PlayerComponentPlacement(
          type: PlayerComponentType.queue,
          x: 6,
          y: 15,
          width: 8,
          height: 6,
          visible: false,
          emptyMode: PlayerCollectionEmptyMode.full,
        ),
        PlayerComponentPlacement(
          type: PlayerComponentType.controls,
          x: 0,
          y: 35,
          width: 40,
          height: 4,
          visible: true,
          scale: 1.3,
        ),
        PlayerComponentPlacement(
          type: PlayerComponentType.seekBar,
          x: 1,
          y: 15,
          width: 38,
          height: 4,
          visible: true,
          seekTimePlacement: PlayerSeekTimePlacement.below,
          seekTrackHeight: 12.0,
          seekTimeLabelFontSize: 14.0,
        ),
      ];
    case PlayerLayoutScreenSize.tablet:
      return const <PlayerComponentPlacement>[
        PlayerComponentPlacement(
          type: PlayerComponentType.cover,
          x: 0,
          y: 0,
          width: 16,
          height: 35,
          visible: true,
          coverFitMode: PlayerCoverFitMode.width,
        ),
        PlayerComponentPlacement(
          type: PlayerComponentType.mediaInfo,
          x: 17,
          y: 0,
          width: 23,
          height: 20,
          visible: true,
        ),
        PlayerComponentPlacement(
          type: PlayerComponentType.utilities,
          x: 19,
          y: 15,
          width: 18,
          height: 5,
          visible: true,
          scale: 1.2,
        ),
        PlayerComponentPlacement(
          type: PlayerComponentType.subtitles,
          x: 0,
          y: 39,
          width: 10,
          height: 5,
          visible: false,
        ),
        PlayerComponentPlacement(
          type: PlayerComponentType.chapters,
          x: 28,
          y: 20,
          width: 12,
          height: 14,
          visible: true,
          emptyMode: PlayerCollectionEmptyMode.full,
          cardStyle: true,
        ),
        PlayerComponentPlacement(
          type: PlayerComponentType.queue,
          x: 16,
          y: 20,
          width: 12,
          height: 14,
          visible: true,
          emptyMode: PlayerCollectionEmptyMode.full,
          cardStyle: true,
        ),
        PlayerComponentPlacement(
          type: PlayerComponentType.controls,
          x: 0,
          y: 39,
          width: 40,
          height: 5,
          visible: true,
          scale: 1.4,
        ),
        PlayerComponentPlacement(
          type: PlayerComponentType.seekBar,
          x: 1,
          y: 34,
          width: 38,
          height: 5,
          visible: true,
          seekTimePlacement: PlayerSeekTimePlacement.below,
          seekTrackHeight: 16.0,
          seekTimeLabelFontSize: 18.0,
        ),
      ];
    case PlayerLayoutScreenSize.desktop:
      return const <PlayerComponentPlacement>[
        PlayerComponentPlacement(
          type: PlayerComponentType.cover,
          x: 0,
          y: 0,
          width: 14,
          height: 44,
          visible: true,
          coverFitMode: PlayerCoverFitMode.width,
        ),
        PlayerComponentPlacement(
          type: PlayerComponentType.mediaInfo,
          x: 15,
          y: 1,
          width: 12,
          height: 21,
          visible: true,
        ),
        PlayerComponentPlacement(
          type: PlayerComponentType.utilities,
          x: 14,
          y: 39,
          width: 26,
          height: 4,
          visible: true,
          scale: 1.5,
        ),
        PlayerComponentPlacement(type: PlayerComponentType.subtitles, x: 8, y: 3, width: 10, height: 2, visible: false),
        PlayerComponentPlacement(
          type: PlayerComponentType.chapters,
          x: 27,
          y: 0,
          width: 13,
          height: 17,
          visible: true,
          emptyMode: PlayerCollectionEmptyMode.compact,
          cardStyle: true,
        ),
        PlayerComponentPlacement(
          type: PlayerComponentType.queue,
          x: 27,
          y: 17,
          width: 13,
          height: 15,
          visible: true,
          emptyMode: PlayerCollectionEmptyMode.full,
          cardStyle: true,
        ),
        PlayerComponentPlacement(
          type: PlayerComponentType.controls,
          x: 14,
          y: 35,
          width: 26,
          height: 4,
          visible: true,
          scale: 1.8,
        ),
        PlayerComponentPlacement(
          type: PlayerComponentType.seekBar,
          x: 15,
          y: 32,
          width: 24,
          height: 4,
          visible: true,
          seekTimePlacement: PlayerSeekTimePlacement.below,
          seekTrackHeight: 16.0,
          seekTimeLabelFontSize: 18.0,
        ),
      ];
  }
}

List<PlayerUtilityType> _defaultUtilityOrderForScreen(PlayerLayoutScreenSize screenSize) {
  return defaultPlayerUtilityOrder;
}

List<PlayerUtilityType> _defaultHiddenUtilitiesForScreen(PlayerLayoutScreenSize screenSize) {
  switch (screenSize) {
    case PlayerLayoutScreenSize.mobile:
      return const <PlayerUtilityType>[PlayerUtilityType.volume];
    case PlayerLayoutScreenSize.tablet:
      return const <PlayerUtilityType>[PlayerUtilityType.chapter, PlayerUtilityType.volume];
    case PlayerLayoutScreenSize.desktop:
      return const <PlayerUtilityType>[PlayerUtilityType.volume, PlayerUtilityType.chapter];
  }
}

PlayerLayoutProfile normalizePlayerLayoutProfile(
  PlayerLayoutProfile profile,
  PlayerLayoutScreenSize screenSize, {
  bool allowOverlap = true,
}) {
  final columns = playerGridColumnsForSize(screenSize);
  final rows = playerGridRowsForSize(screenSize);
  final occupied = <String>{};

  bool isFree(int x, int y, int width, int height) {
    if (x < 0 || y < 0 || x + width > columns || y + height > rows) {
      return false;
    }

    for (var row = y; row < y + height; row++) {
      for (var col = x; col < x + width; col++) {
        if (occupied.contains('$col:$row')) {
          return false;
        }
      }
    }

    return true;
  }

  void mark(int x, int y, int width, int height) {
    for (var row = y; row < y + height; row++) {
      for (var col = x; col < x + width; col++) {
        occupied.add('$col:$row');
      }
    }
  }

  final normalized = <PlayerComponentPlacement>[];

  for (final placement in profile.placements) {
    final constraints = playerComponentConstraintsFor(placement.type);
    final resolvedMaxWidth = constraints.resolvedMaxWidth(columns);
    final resolvedMaxHeight = constraints.resolvedMaxHeight(rows);

    final width = placement.width.clamp(constraints.minWidth, resolvedMaxWidth);
    final height = placement.height.clamp(constraints.minHeight, resolvedMaxHeight);
    var x = placement.x.clamp(0, columns - width);
    var y = placement.y.clamp(0, rows - height);

    if (!allowOverlap && !isFree(x, y, width, height)) {
      var found = false;
      for (var row = 0; row <= rows - height && !found; row++) {
        for (var col = 0; col <= columns - width; col++) {
          if (isFree(col, row, width, height)) {
            x = col;
            y = row;
            found = true;
            break;
          }
        }
      }
    }

    if (!allowOverlap) {
      mark(x, y, width, height);
    }

    normalized.add(placement.copyWith(x: x, y: y, width: width, height: height));
  }

  return profile.copyWith(placements: normalized);
}
