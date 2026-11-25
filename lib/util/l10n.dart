import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart' show FlutterQuillLocalizations;
import 'package:material_ui/material_ui.dart' show GlobalMaterialLocalizations;
import 'package:yaabsa/l10n/generated/app_localizations.dart';
import 'package:yaabsa/provider/core/locale_provider.dart' show currentAppLocale;

export 'package:yaabsa/l10n/generated/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

AppLocalizations currentAppLocalizations() {
  return lookupAppLocalizations(currentAppLocale());
}

const List<LocalizationsDelegate<dynamic>> yaabsaLocalizationsDelegates = [
  AppLocalizations.delegate,
  ...GlobalMaterialLocalizations.delegates,
  FlutterQuillLocalizations.delegate,
];
