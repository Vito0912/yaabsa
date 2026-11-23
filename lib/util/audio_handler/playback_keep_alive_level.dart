enum PlaybackKeepAliveLevel {
  off('Off', 0),
  quiet('Quiet', 0.005),
  medium('Medium', 0.005),
  stronger('Stronger', 0.02);

  const PlaybackKeepAliveLevel(this.label, this.gain);

  final String label;

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
