import 'package:flutter/services.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/setting_key.dart';

class ChangelogSection {
  const ChangelogSection({required this.title, required this.entries});

  final String title;
  final List<String> entries;
}

class ChangelogRelease {
  const ChangelogRelease({required this.version, required this.sections});

  final String version;
  final List<ChangelogSection> sections;
}

class Changelog {
  static List<ChangelogRelease> pendingReleases = const [];

  static bool isNewerVersion(String version, String previousVersion) {
    final pattern = RegExp(r'^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$');
    final current = pattern.firstMatch(version);
    final previous = pattern.firstMatch(previousVersion);
    if (current == null || previous == null) {
      return false;
    }

    for (var index = 1; index <= 3; index++) {
      final comparison = int.parse(current.group(index)!).compareTo(int.parse(previous.group(index)!));
      if (comparison != 0) {
        return comparison > 0;
      }
    }

    return false;
  }

  static Future<List<ChangelogRelease>> load() async {
    final source = await rootBundle.loadString('CHANGELOG.md');
    return parse(source);
  }

  static List<ChangelogRelease> parse(String source) {
    final releases = <ChangelogRelease>[];
    final releaseHeading = RegExp(r'^##\s+\[?v?(\d+\.\d+\.\d+)\]?(?:\s.*)?$');
    final bullet = RegExp(r'^\s*[-*+]\s+');
    List<ChangelogSection>? sections;
    List<String>? entries;

    for (final rawLine in source.split('\n')) {
      final line = rawLine.trimRight();
      final release = releaseHeading.firstMatch(line);
      if (release != null) {
        sections = [];
        entries = null;
        releases.add(ChangelogRelease(version: release.group(1)!, sections: sections));
        continue;
      }

      if (line.startsWith('## ')) {
        sections = null;
        entries = null;
        continue;
      }

      if (sections == null || line.trim().isEmpty) {
        continue;
      }

      if (line.startsWith('### ')) {
        entries = [];
        sections.add(ChangelogSection(title: line.substring(4).trim(), entries: entries));
        continue;
      }

      if (entries == null) {
        entries = [];
        sections.add(ChangelogSection(title: 'Updates', entries: entries));
      }

      final text = line.replaceFirst(bullet, '').trim();
      if (rawLine.startsWith('  ') && !bullet.hasMatch(line) && entries.isNotEmpty) {
        entries[entries.length - 1] = '${entries.last} $text';
      } else {
        entries.add(text);
      }
    }

    return releases.where((release) => release.sections.any((section) => section.entries.isNotEmpty)).toList();
  }

  static Future<void> prepareStartup(SettingsManager settings, String currentVersion) async {
    final previousVersion = settings.getGlobalSetting<String>(SettingKeys.changelogLastVersion, defaultValue: '');
    if (previousVersion.isEmpty) {
      await settings.setGlobalSetting(SettingKeys.changelogLastVersion, currentVersion);
      return;
    }

    if (previousVersion == currentVersion) {
      return;
    }

    final disabled = settings.getGlobalSetting<bool>(SettingKeys.changelogDisabled, defaultValue: false);
    if (!disabled) {
      final releases = await load();
      final isUpgrade = isNewerVersion(currentVersion, previousVersion);

      pendingReleases = releases.where((release) {
        if (!isUpgrade) {
          return release.version == currentVersion;
        }

        final newerThanPrevious = isNewerVersion(release.version, previousVersion);
        final newerThanInstalled = isNewerVersion(release.version, currentVersion);
        return newerThanPrevious && !newerThanInstalled;
      }).toList();
    }

    if (pendingReleases.isEmpty) {
      await settings.setGlobalSetting(SettingKeys.changelogLastVersion, currentVersion);
    }
  }
}
