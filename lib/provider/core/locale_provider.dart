import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/l10n/generated/app_localizations.dart';
import 'package:yaabsa/util/handler/tray_handler.dart' show TrayManager;
import 'package:yaabsa/util/setting_key.dart';

part 'locale_provider.g.dart';

const Locale _fallbackLocale = Locale('en');
Locale? _activeResolvedLocale;

@Riverpod(keepAlive: true)
Locale? locale(Ref ref) {
  final settingValue = ref.watch(globalSettingByKeyProvider(SettingKeys.language)).asData?.value;

  return localeFromLanguageSetting(settingValue);
}

@Riverpod(keepAlive: true)
Locale resolvedLocale(Ref ref) {
  final requestedLocale = ref.watch(localeProvider);

  return resolveCurrentAppLocale(requestedLocale: requestedLocale, systemLocales: PlatformDispatcher.instance.locales);
}

@Riverpod(keepAlive: true)
class LocaleEffects extends _$LocaleEffects {
  @override
  void build() {
    ref.listen(resolvedLocaleProvider, (previous, next) {
      _synchronizeLocale(next, previous: previous);
    });

    _synchronizeLocale(ref.read(resolvedLocaleProvider));
  }

  void _synchronizeLocale(Locale locale, {Locale? previous}) {
    _activeResolvedLocale = locale;
    Intl.defaultLocale = locale.toLanguageTag();
    timeago.setDefaultLocale(locale.languageCode);

    if (previous == locale) {
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows) {
      unawaited(TrayManager.update());
    }
  }
}

Locale currentAppLocale() {
  return _activeResolvedLocale ?? resolveCurrentAppLocale();
}

Locale? localeFromLanguageSetting(String? languageSetting) {
  final normalizedSetting = languageSetting?.trim();
  if (normalizedSetting == null || normalizedSetting.isEmpty || normalizedSetting.toLowerCase() == 'system') {
    return null;
  }

  final normalizedTag = normalizedSetting.replaceAll('_', '-');
  final exactLocale = _findSupportedLocale(normalizedTag);
  if (exactLocale != null) {
    return exactLocale;
  }

  final languageCode = normalizedTag.split('-').first.toLowerCase();
  return _findSupportedLocale(languageCode) ?? _fallbackLocale;
}

Locale resolveCurrentAppLocale({Locale? requestedLocale, Iterable<Locale>? systemLocales}) {
  if (requestedLocale != null) {
    return _findSupportedLocale(requestedLocale.toLanguageTag()) ?? _fallbackLocale;
  }

  final platformLocales = systemLocales ?? PlatformDispatcher.instance.locales;
  for (final platformLocale in platformLocales) {
    final supportedLocale = _findSupportedLocale(platformLocale.toLanguageTag());
    if (supportedLocale != null) {
      return supportedLocale;
    }

    final languageLocale = _findSupportedLocale(platformLocale.languageCode);
    if (languageLocale != null) {
      return languageLocale;
    }
  }

  return _fallbackLocale;
}

Locale? _findSupportedLocale(String languageTag) {
  final normalizedTag = languageTag.replaceAll('_', '-').toLowerCase();
  for (final supportedLocale in AppLocalizations.supportedLocales) {
    if (supportedLocale.toLanguageTag().toLowerCase() == normalizedTag) {
      return supportedLocale;
    }
  }

  return null;
}
