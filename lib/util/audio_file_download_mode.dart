import 'package:yaabsa/util/l10n.dart';

enum AudioFileDownloadMode {
  all,
  custom,
  fromCurrent;

  String get label {
    final l10n = currentAppLocalizations();

    switch (this) {
      case AudioFileDownloadMode.all:
        return l10n.audioFileModeAll;
      case AudioFileDownloadMode.custom:
        return l10n.optionCustom;
      case AudioFileDownloadMode.fromCurrent:
        return l10n.audioFileModeFromCurrent;
    }
  }
}
