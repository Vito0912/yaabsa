import 'dart:async';

import 'package:dio/dio.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/me/server_settings.dart';
import 'package:yaabsa/components/common/inputs/string_chip_list_input.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

class AdminServerConfigurationView extends ConsumerStatefulWidget {
  const AdminServerConfigurationView({super.key});

  @override
  ConsumerState<AdminServerConfigurationView> createState() => _AdminServerConfigurationViewState();
}

class _AdminServerConfigurationViewState extends ConsumerState<AdminServerConfigurationView> {
  static const String _settingsId = 'server-settings';

  static const List<String> _dateFormatLabels = <String>[
    'MM/DD/YYYY',
    'DD/MM/YYYY',
    'DD.MM.YYYY',
    'YYYY-MM-DD',
    'MMM do, yyyy',
    'MMMM do, yyyy',
    'dd MMM yyyy',
    'dd MMMM yyyy',
  ];
  static const List<String> _dateFormatValues = <String>[
    'MM/dd/yyyy',
    'dd/MM/yyyy',
    'dd.MM.yyyy',
    'yyyy-MM-dd',
    'MMM do, yyyy',
    'MMMM do, yyyy',
    'dd MMM yyyy',
    'dd MMMM yyyy',
  ];
  static const List<String> _timeFormatValues = <String>['h:mma', 'HH:mm'];
  static const List<String> _languageValues = <String>[
    'ar',
    'be',
    'bg',
    'bn',
    'ca',
    'cs',
    'da',
    'de',
    'en-us',
    'es',
    'et',
    'fi',
    'fr',
    'he',
    'hr',
    'it',
    'ja',
    'lt',
    'hu',
    'ko',
    'nl',
    'no',
    'pl',
    'pt-br',
    'ru',
    'sk',
    'sl',
    'sv',
    'tr',
    'uk',
    'vi-vn',
    'zh-cn',
    'zh-tw',
  ];
  static const String _operationStoreCoverWithItem = 'storeCoverWithItem';
  static const String _operationStoreMetadataWithItem = 'storeMetadataWithItem';
  static const String _operationSortingIgnorePrefix = 'sortingIgnorePrefix';
  static const String _operationSortingPrefixes = 'sortingPrefixes';
  static const String _operationDateFormat = 'dateFormat';
  static const String _operationTimeFormat = 'timeFormat';
  static const String _operationLanguage = 'language';
  static const String _operationScannerParseSubtitle = 'scannerParseSubtitle';
  static const String _operationScannerFindCovers = 'scannerFindCovers';
  static const String _operationScannerPreferMatchedMetadata = 'scannerPreferMatchedMetadata';
  static const String _operationScannerDisableWatcher = 'scannerDisableWatcher';
  static const String _operationAllowedOrigins = 'allowedOrigins';

  String? _activeUserId;
  ServerSettings? _settings;
  bool _isLoading = true;
  final Set<String> _savingOperations = <String>{};

  bool _isAdminType(String? userType) {
    final normalizedType = (userType ?? '').trim().toLowerCase();
    return normalizedType == 'admin' || normalizedType == 'root';
  }

  String _resolveErrorMessage(Object error, {required String fallback}) {
    if (error is DioException) {
      final responseData = error.response?.data;
      if (responseData is String && responseData.trim().isNotEmpty) {
        return responseData.trim();
      }
      if (responseData is Map) {
        final message = responseData['message'];
        if (message is String && message.trim().isNotEmpty) {
          return message.trim();
        }
        final errorText = responseData['error'];
        if (errorText is String && errorText.trim().isNotEmpty) {
          return errorText.trim();
        }
      }
      if (error.message != null && error.message!.trim().isNotEmpty) {
        return error.message!.trim();
      }
    }
    return fallback;
  }

  String _normalizeCorsOrigin(String value) {
    final trimmed = value.trim();
    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme || uri.host.trim().isEmpty) {
      return trimmed;
    }

    final normalizedUri = Uri(
      scheme: uri.scheme.toLowerCase(),
      host: uri.host.toLowerCase(),
      port: uri.hasPort ? uri.port : null,
    );
    final serialized = normalizedUri.toString();
    return serialized.endsWith('/') ? serialized.substring(0, serialized.length - 1) : serialized;
  }

  String? _validateCorsOrigin(String value) {
    final l10n = currentAppLocalizations();
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return l10n.errorOriginRequired;
    }

    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme || uri.host.trim().isEmpty) {
      return l10n.errorOriginSchemeAndHostRequired;
    }

    final scheme = uri.scheme.toLowerCase();
    if (scheme != 'http' && scheme != 'https') {
      return l10n.errorOriginHttpHttpsOnly;
    }

    if ((uri.path.isNotEmpty && uri.path != '/') || uri.hasQuery || uri.hasFragment || uri.userInfo.isNotEmpty) {
      return l10n.errorOriginNoPathQueryFragmentOrCredentials;
    }

    return null;
  }

  List<String> _normalizeCorsOrigins(List<String> values) {
    final normalizedValues = <String>[];
    final seen = <String>{};

    for (final value in values) {
      final normalizedValue = _normalizeCorsOrigin(value);
      if (normalizedValue.isEmpty) {
        continue;
      }
      final lowered = normalizedValue.toLowerCase();
      if (seen.contains(lowered)) {
        continue;
      }
      seen.add(lowered);
      normalizedValues.add(normalizedValue);
    }

    return normalizedValues;
  }

  List<String> _normalizeSortingPrefixes(List<String> values) {
    final normalizedValues = <String>[];
    final seen = <String>{};

    for (final value in values) {
      final normalizedValue = value.trim().toLowerCase();
      if (normalizedValue.isEmpty || seen.contains(normalizedValue)) {
        continue;
      }
      seen.add(normalizedValue);
      normalizedValues.add(normalizedValue);
    }

    return normalizedValues;
  }

  String _resolveSelection(List<String> allowedValues, String? selectedValue) {
    if (selectedValue != null && allowedValues.contains(selectedValue)) {
      return selectedValue;
    }
    return allowedValues.first;
  }

  Future<void> _loadServerSettings() async {
    final l10n = currentAppLocalizations();
    setState(() {
      _isLoading = true;
    });

    try {
      final api = ref.read(absApiProvider);
      if (api == null) {
        throw StateError('No active API client.');
      }

      final authResponse = await api.getMeApi().checkLogin();
      final settings = authResponse.data?.serverSettings;
      if (settings == null) {
        throw StateError('Server did not return server settings.');
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _settings = settings;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      final fallbackMessage = l10n.errorOperationFailed(l10n.operationLoadSettings, l10n.errorUnknown);
      final message = _resolveErrorMessage(error, fallback: fallbackMessage);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateServerSettings({required String operationKey, required ServerSettings settingsUpdate}) async {
    if (_savingOperations.contains(operationKey)) {
      return;
    }

    final l10n = currentAppLocalizations();
    setState(() {
      _savingOperations.add(operationKey);
    });

    try {
      final api = ref.read(absApiProvider);
      if (api == null) {
        throw StateError('No active API client.');
      }

      final response = await api.getAdminApi().updateServerSettings(settingsUpdate: settingsUpdate);
      final updatedSettings = response.data;

      if (!mounted) {
        return;
      }

      if (updatedSettings != null) {
        setState(() {
          _settings = updatedSettings;
        });
      } else {
        await _loadServerSettings();
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      final fallbackMessage = l10n.errorOperationFailed(l10n.operationSaveServerSettings, l10n.errorUnknown);
      final message = _resolveErrorMessage(error, fallback: fallbackMessage);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _savingOperations.remove(operationKey);
        });
      }
    }
  }

  Future<void> _updateSortingPrefixes(List<String> sortingPrefixes, {List<String>? fallbackSortingPrefixes}) async {
    if (_savingOperations.contains(_operationSortingPrefixes)) {
      return;
    }

    if (sortingPrefixes.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(currentAppLocalizations().errorSortingPrefixRequired)));
      return;
    }

    final l10n = currentAppLocalizations();
    setState(() {
      _savingOperations.add(_operationSortingPrefixes);
    });

    try {
      final api = ref.read(absApiProvider);
      if (api == null) {
        throw StateError('No active API client.');
      }

      final response = await api.getAdminApi().updateSortingPrefixes(sortingPrefixes: sortingPrefixes);
      final updatedSettings = response.data?.serverSettings;

      if (!mounted) {
        return;
      }

      if (updatedSettings != null) {
        setState(() {
          _settings = updatedSettings;
        });
      } else {
        await _loadServerSettings();
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      final fallbackMessage = l10n.errorOperationFailed(l10n.operationSaveServerSettings, l10n.errorUnknown);
      final message = _resolveErrorMessage(error, fallback: fallbackMessage);
      if (fallbackSortingPrefixes != null && _settings != null) {
        setState(() {
          _settings = _settings!.copyWith(sortingPrefixes: fallbackSortingPrefixes);
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _savingOperations.remove(_operationSortingPrefixes);
        });
      }
    }
  }

  bool _isSaving(String operationKey) => _savingOperations.contains(operationKey);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentUserAsync = ref.watch(currentUserProvider);

    return currentUserAsync.when(
      data: (currentUser) {
        if (currentUser == null) {
          return Padding(padding: EdgeInsets.fromLTRB(20, 8, 20, 0), child: Text(l10n.promptSignInToManageSettings));
        }

        if (!_isAdminType(currentUser.type)) {
          return Padding(padding: EdgeInsets.fromLTRB(20, 8, 20, 0), child: Text(l10n.errorAdminRequired));
        }

        if (_activeUserId != currentUser.id) {
          _activeUserId = currentUser.id;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            unawaited(_loadServerSettings());
          });
        }

        if (_settings == null && _isLoading) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: YaabsaCircularProgressIndicator()),
          );
        }

        if (_settings == null) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(child: Text(l10n.errorOperationFailed(l10n.operationLoadSettings, l10n.errorUnknown))),
                TextButton(onPressed: () => unawaited(_loadServerSettings()), child: Text(l10n.actionRetry)),
              ],
            ),
          );
        }

        final settings = _settings!;
        final scannerWatcherDisabled = settings.scannerDisableWatcher ?? false;
        final sortingIgnorePrefix = settings.sortingIgnorePrefix ?? false;
        final sortingPrefixes = _normalizeSortingPrefixes(settings.sortingPrefixes ?? const <String>[]);
        final selectedDateFormat = _resolveSelection(_dateFormatValues, settings.dateFormat);
        final selectedTimeFormat = _resolveSelection(_timeFormatValues, settings.timeFormat);
        final selectedLanguage = _resolveSelection(_languageValues, settings.language);
        final allowedOrigins = _normalizeCorsOrigins(settings.allowedOrigins ?? const <String>[]);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isLoading) const YaabsaLinearProgressIndicator(minHeight: 2),
            SettingsNavigationSection(
              title: l10n.settingsCategoryGeneral,
              topPadding: 12,
              settings: [
                SettingSwitchTile.remote(
                  label: l10n.settingStoreCoversWithItem,
                  subtitle: l10n.settingStoreCoversWithItemDescription,
                  value: settings.storeCoverWithItem ?? false,
                  isLoading: _isSaving(_operationStoreCoverWithItem),
                  onValueChanged: _isSaving(_operationStoreCoverWithItem)
                      ? null
                      : (nextValue) {
                          unawaited(
                            _updateServerSettings(
                              operationKey: _operationStoreCoverWithItem,
                              settingsUpdate: ServerSettings(id: _settingsId, storeCoverWithItem: nextValue),
                            ),
                          );
                        },
                ),
                SettingSwitchTile.remote(
                  label: l10n.settingStoreMetadataWithItem,
                  subtitle: l10n.settingStoreMetadataWithItemDescription,
                  value: settings.storeMetadataWithItem ?? false,
                  isLoading: _isSaving(_operationStoreMetadataWithItem),
                  onValueChanged: _isSaving(_operationStoreMetadataWithItem)
                      ? null
                      : (nextValue) {
                          unawaited(
                            _updateServerSettings(
                              operationKey: _operationStoreMetadataWithItem,
                              settingsUpdate: ServerSettings(id: _settingsId, storeMetadataWithItem: nextValue),
                            ),
                          );
                        },
                ),
                SettingSwitchTile.remote(
                  label: l10n.settingIgnorePrefixesWhenSorting,
                  subtitle: l10n.settingIgnorePrefixesWhenSortingDescription,
                  value: sortingIgnorePrefix,
                  isLoading: _isSaving(_operationSortingIgnorePrefix),
                  onValueChanged: _isSaving(_operationSortingIgnorePrefix)
                      ? null
                      : (nextValue) {
                          unawaited(
                            _updateServerSettings(
                              operationKey: _operationSortingIgnorePrefix,
                              settingsUpdate: ServerSettings(id: _settingsId, sortingIgnorePrefix: nextValue),
                            ),
                          );
                        },
                ),
                if (sortingIgnorePrefix)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: StringChipListInput(
                      label: l10n.fieldPrefixesToIgnore,
                      values: sortingPrefixes,
                      enabled: !_isSaving(_operationSortingPrefixes),
                      normalizer: (value) => value.trim().toLowerCase(),
                      onChanged: (nextValues) {
                        final normalizedPrefixes = _normalizeSortingPrefixes(nextValues);
                        if (normalizedPrefixes.isEmpty) {
                          unawaited(_updateSortingPrefixes(normalizedPrefixes));
                          return;
                        }

                        final fallbackPrefixes = sortingPrefixes;
                        setState(() {
                          _settings = _settings?.copyWith(sortingPrefixes: normalizedPrefixes);
                        });
                        unawaited(
                          _updateSortingPrefixes(normalizedPrefixes, fallbackSortingPrefixes: fallbackPrefixes),
                        );
                      },
                    ),
                  ),
              ],
            ),
            SettingsNavigationSection(
              title: l10n.settingsCategoryRegional,
              settings: [
                SettingDropdown<String>.remote(
                  label: l10n.fieldDateFormat,
                  values: _dateFormatValues,
                  valueLabels: _dateFormatLabels,
                  value: selectedDateFormat,
                  enabled: !_isSaving(_operationDateFormat),
                  isLoading: _isSaving(_operationDateFormat),
                  onValueChanged: (nextValue) {
                    unawaited(
                      _updateServerSettings(
                        operationKey: _operationDateFormat,
                        settingsUpdate: ServerSettings(id: _settingsId, dateFormat: nextValue),
                      ),
                    );
                  },
                ),
                SettingDropdown<String>.remote(
                  label: l10n.fieldTimeFormat,
                  values: _timeFormatValues,
                  valueLabels: [l10n.optionTimeFormat12Hour, l10n.optionTimeFormat24Hour],
                  value: selectedTimeFormat,
                  enabled: !_isSaving(_operationTimeFormat),
                  isLoading: _isSaving(_operationTimeFormat),
                  onValueChanged: (nextValue) {
                    unawaited(
                      _updateServerSettings(
                        operationKey: _operationTimeFormat,
                        settingsUpdate: ServerSettings(id: _settingsId, timeFormat: nextValue),
                      ),
                    );
                  },
                ),
                SettingDropdown<String>.remote(
                  label: l10n.fieldLanguage,
                  values: _languageValues,
                  valueLabels: _languageValues
                      .map((languageCode) => l10n.serverLanguageName(languageCode.replaceAll('-', '_')))
                      .toList(growable: false),
                  value: selectedLanguage,
                  enabled: !_isSaving(_operationLanguage),
                  isLoading: _isSaving(_operationLanguage),
                  onValueChanged: (nextValue) {
                    unawaited(
                      _updateServerSettings(
                        operationKey: _operationLanguage,
                        settingsUpdate: ServerSettings(id: _settingsId, language: nextValue),
                      ),
                    );
                  },
                ),
              ],
            ),
            SettingsNavigationSection(
              title: l10n.settingsCategoryScanner,
              settings: [
                SettingSwitchTile.remote(
                  label: l10n.settingParseSubtitles,
                  subtitle: l10n.settingParseSubtitlesDescription,
                  value: settings.scannerParseSubtitle ?? false,
                  isLoading: _isSaving(_operationScannerParseSubtitle),
                  onValueChanged: _isSaving(_operationScannerParseSubtitle)
                      ? null
                      : (nextValue) {
                          unawaited(
                            _updateServerSettings(
                              operationKey: _operationScannerParseSubtitle,
                              settingsUpdate: ServerSettings(id: _settingsId, scannerParseSubtitle: nextValue),
                            ),
                          );
                        },
                ),
                SettingSwitchTile.remote(
                  label: l10n.settingFindCovers,
                  subtitle: l10n.settingFindCoversDescription,
                  value: settings.scannerFindCovers ?? false,
                  isLoading: _isSaving(_operationScannerFindCovers),
                  onValueChanged: _isSaving(_operationScannerFindCovers)
                      ? null
                      : (nextValue) {
                          unawaited(
                            _updateServerSettings(
                              operationKey: _operationScannerFindCovers,
                              settingsUpdate: ServerSettings(id: _settingsId, scannerFindCovers: nextValue),
                            ),
                          );
                        },
                ),
                SettingSwitchTile.remote(
                  label: l10n.settingPreferMatchedMetadata,
                  subtitle: l10n.settingPreferMatchedMetadataDescription,
                  value: settings.scannerPreferMatchedMetadata ?? false,
                  isLoading: _isSaving(_operationScannerPreferMatchedMetadata),
                  onValueChanged: _isSaving(_operationScannerPreferMatchedMetadata)
                      ? null
                      : (nextValue) {
                          unawaited(
                            _updateServerSettings(
                              operationKey: _operationScannerPreferMatchedMetadata,
                              settingsUpdate: ServerSettings(id: _settingsId, scannerPreferMatchedMetadata: nextValue),
                            ),
                          );
                        },
                ),
                SettingSwitchTile.remote(
                  label: l10n.settingScanLibrariesAutomatically,
                  subtitle: l10n.settingScanLibrariesAutomaticallyDescription,
                  value: !scannerWatcherDisabled,
                  isLoading: _isSaving(_operationScannerDisableWatcher),
                  onValueChanged: _isSaving(_operationScannerDisableWatcher)
                      ? null
                      : (nextValue) {
                          unawaited(
                            _updateServerSettings(
                              operationKey: _operationScannerDisableWatcher,
                              settingsUpdate: ServerSettings(id: _settingsId, scannerDisableWatcher: !nextValue),
                            ),
                          );
                        },
                ),
              ],
            ),
            SettingsNavigationSection(
              title: l10n.settingsCategorySecurity,
              settings: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: StringChipListInput(
                    label: l10n.fieldAllowedCorsOrigins,
                    values: allowedOrigins,
                    enabled: !_isSaving(_operationAllowedOrigins),
                    validator: _validateCorsOrigin,
                    normalizer: _normalizeCorsOrigin,
                    onChanged: (nextValues) {
                      final normalizedOrigins = _normalizeCorsOrigins(nextValues);
                      unawaited(
                        _updateServerSettings(
                          operationKey: _operationAllowedOrigins,
                          settingsUpdate: ServerSettings(id: _settingsId, allowedOrigins: normalizedOrigins),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: YaabsaCircularProgressIndicator()),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Text(
          l10n.errorOperationFailed(l10n.operationLoadUser, l10n.errorUnknown),
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
