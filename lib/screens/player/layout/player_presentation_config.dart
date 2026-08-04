import 'package:flutter/material.dart';
import 'package:yaabsa/util/globals.dart';

enum PlayerLayoutMode {
  adaptive,
  custom;

  static PlayerLayoutMode fromSettingValue(String? value, {required bool hasSavedCustomLayout}) {
    for (final mode in values) {
      if (mode.name == value?.trim().toLowerCase()) {
        return mode;
      }
    }

    return hasSavedCustomLayout ? PlayerLayoutMode.custom : PlayerLayoutMode.adaptive;
  }
}

enum PlayerAdaptivePreset {
  full,
  minimalistic;

  String get label => switch (this) {
    PlayerAdaptivePreset.full => 'Full',
    PlayerAdaptivePreset.minimalistic => 'Minimalistic',
  };

  static PlayerAdaptivePreset fromSettingValue(String? value) {
    return switch (value?.trim().toLowerCase()) {
      'minimalistic' || 'compact' => PlayerAdaptivePreset.minimalistic,
      'full' || 'immersive' => PlayerAdaptivePreset.full,
      _ => PlayerAdaptivePreset.full,
    };
  }
}

enum PlayerCoverSize {
  automatic,
  compact,
  large;

  String get label => switch (this) {
    PlayerCoverSize.automatic => 'Automatic',
    PlayerCoverSize.compact => 'Compact',
    PlayerCoverSize.large => 'Large',
  };

  static PlayerCoverSize fromSettingValue(String? value) {
    return values.firstWhere(
      (size) => size.name == value?.trim().toLowerCase(),
      orElse: () => PlayerCoverSize.automatic,
    );
  }

  bool resolveCompact(PlayerAdaptivePreset preset) => switch (this) {
    PlayerCoverSize.automatic => preset == PlayerAdaptivePreset.minimalistic,
    PlayerCoverSize.compact => true,
    PlayerCoverSize.large => false,
  };
}

enum PlayerTransportMode {
  jump,
  skip,
  both;

  String get label => switch (this) {
    PlayerTransportMode.jump => 'Jump',
    PlayerTransportMode.skip => 'Skip',
    PlayerTransportMode.both => 'Jump and skip',
  };

  static PlayerTransportMode fromSettingValue(
    String? value, {
    PlayerTransportMode fallback = PlayerTransportMode.both,
  }) {
    return values.firstWhere((mode) => mode.name == value?.trim().toLowerCase(), orElse: () => fallback);
  }
}

enum PlayerActionType {
  speed,
  bookmarks,
  chapter,
  volume,
  sleepTimer,
  queue;

  String get label => switch (this) {
    PlayerActionType.speed => 'Playback speed',
    PlayerActionType.bookmarks => 'Bookmarks',
    PlayerActionType.chapter => 'Chapter picker',
    PlayerActionType.volume => 'Volume',
    PlayerActionType.sleepTimer => 'Sleep timer',
    PlayerActionType.queue => 'Queue',
  };

  IconData get icon => switch (this) {
    PlayerActionType.speed => Icons.speed_rounded,
    PlayerActionType.bookmarks => Icons.bookmarks_rounded,
    PlayerActionType.chapter => Icons.menu_book_rounded,
    PlayerActionType.volume => Icons.volume_up_rounded,
    PlayerActionType.sleepTimer => Icons.bedtime_rounded,
    PlayerActionType.queue => Icons.queue_music_rounded,
  };
}

const List<PlayerActionType> defaultFullPlayerActions = <PlayerActionType>[
  PlayerActionType.speed,
  PlayerActionType.bookmarks,
  PlayerActionType.chapter,
  PlayerActionType.volume,
  PlayerActionType.sleepTimer,
  PlayerActionType.queue,
];

const List<PlayerActionType> defaultMiniPlayerActions = <PlayerActionType>[
  PlayerActionType.speed,
  PlayerActionType.sleepTimer,
];

const PlayerActionType defaultMobilePlayerLeftAction = PlayerActionType.speed;
const PlayerActionType defaultMobilePlayerRightAction = PlayerActionType.sleepTimer;

PlayerActionType decodePlayerAction(String? value, {required PlayerActionType fallback}) {
  return PlayerActionType.values.firstWhere((action) => action.name == value?.trim(), orElse: () => fallback);
}

PlayerActionType? decodeOptionalPlayerAction(String? value, {required PlayerActionType fallback}) {
  if (value?.trim().toLowerCase() == 'none') {
    return null;
  }
  return decodePlayerAction(value, fallback: fallback);
}

String encodePlayerActions(Iterable<PlayerActionType> actions) {
  return actions.map((action) => action.name).join(',');
}

List<PlayerActionType> decodePlayerActions(String? value, {required List<PlayerActionType> fallback}) {
  if (value == null) {
    return List<PlayerActionType>.from(fallback);
  }

  if (value.trim().isEmpty) {
    return <PlayerActionType>[];
  }

  final parsed = <PlayerActionType>[];
  final seen = <PlayerActionType>{};
  for (final name in value.split(',')) {
    for (final action in PlayerActionType.values) {
      if (action.name == name.trim() && seen.add(action)) {
        parsed.add(action);
      }
    }
  }

  return parsed;
}

enum AdaptivePlayerLayout { compactPortrait, compactLandscape, medium, expanded }

AdaptivePlayerLayout resolveAdaptivePlayerLayout(BuildContext context, BoxConstraints constraints) {
  final size = constraints.biggest;
  final isLandscape = size.width > size.height;
  final isShort = size.height < 620;

  if (isLandscape && (context.isMobile || isShort)) {
    return AdaptivePlayerLayout.compactLandscape;
  }
  if (context.isMobile) {
    return AdaptivePlayerLayout.compactPortrait;
  }
  if (context.isDesktop && size.width >= 1180 && size.height >= 680) {
    return AdaptivePlayerLayout.expanded;
  }
  return AdaptivePlayerLayout.medium;
}
