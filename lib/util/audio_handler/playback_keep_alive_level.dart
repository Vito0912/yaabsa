import 'package:yaabsa/util/l10n.dart';

enum PlaybackKeepAliveLevel {
  off(0),
  quiet(0.005),
  medium(0.005),
  stronger(0.02);

  const PlaybackKeepAliveLevel(this.gain);

  String get label {
    final l10n = currentAppLocalizations();
    switch (this) {
      case PlaybackKeepAliveLevel.off:
        return l10n.statusOff;
      case PlaybackKeepAliveLevel.quiet:
        return l10n.playbackKeepAliveQuiet;
      case PlaybackKeepAliveLevel.medium:
        return l10n.playbackKeepAliveMedium;
      case PlaybackKeepAliveLevel.stronger:
        return l10n.playbackKeepAliveStronger;
    }
  }

  final double gain;

  static PlaybackKeepAliveLevel fromSettingValue(String? value) {
    for (final level in values) {
      if (level.name == value?.trim()) {
        return level;
      }
    }

    return off;
  }
}
