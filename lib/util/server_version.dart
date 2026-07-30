bool serverVersionAtLeast(String? version, {required int major, required int minor, int patch = 0}) {
  final match = RegExp(r'^\s*v?(\d+)\.(\d+)(?:\.(\d+))?').firstMatch(version ?? '');
  if (match == null) {
    return false;
  }

  final currentMajor = int.parse(match.group(1)!);
  final currentMinor = int.parse(match.group(2)!);
  final currentPatch = int.tryParse(match.group(3) ?? '') ?? 0;

  if (currentMajor != major) {
    return currentMajor > major;
  }
  if (currentMinor != minor) {
    return currentMinor > minor;
  }
  return currentPatch >= patch;
}

bool serverSupportsMediaProgressAndBookmarkRoutes(String? version) {
  return serverVersionAtLeast(version, major: 2, minor: 36);
}
