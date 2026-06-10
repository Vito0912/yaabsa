import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/me/server_settings.dart';
import 'package:yaabsa/components/common/inputs/string_chip_list_input.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

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
  static const List<String> _timeFormatLabels = <String>['h:mma (am/pm)', 'HH:mm (24-hour)'];
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
  static const List<String> _languageLabels = <String>[
    'Arabic',
    'Belarusian',
    'Bulgarian',
    'Bengali',
    'Catalan',
    'Czech',
    'Danish',
    'German',
    'English',
    'Spanish',
    'Estonian',
    'Finnish',
    'French',
    'Hebrew',
    'Croatian',
    'Italian',
    'Japanese',
    'Lithuanian',
    'Hungarian',
    'Korean',
    'Dutch',
    'Norwegian',
    'Polish',
    'Portuguese (Brazil)',
    'Russian',
    'Slovak',
    'Slovenian',
    'Swedish',
    'Turkish',
    'Ukrainian',
    'Vietnamese',
    'Chinese (Simplified)',
    'Chinese (Traditional)',
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
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Origin cannot be empty.';
    }

    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme || uri.host.trim().isEmpty) {
      return 'Origin must include scheme and host.';
    }

    final scheme = uri.scheme.toLowerCase();
    if (scheme != 'http' && scheme != 'https') {
      return 'Only http and https origins are supported.';
    }

    if ((uri.path.isNotEmpty && uri.path != '/') || uri.hasQuery || uri.hasFragment || uri.userInfo.isNotEmpty) {
      return 'Origin must not include path, query, fragment, or user info.';
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

      final message = _resolveErrorMessage(error, fallback: 'Failed to load server settings.');
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

      final message = _resolveErrorMessage(error, fallback: 'Failed to update server settings.');
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
      const message = 'At least one sorting prefix is required.';
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(message)));
      return;
    }

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

      final message = _resolveErrorMessage(error, fallback: 'Failed to update sorting prefixes.');
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
    final currentUserAsync = ref.watch(currentUserProvider);

    return currentUserAsync.when(
      data: (currentUser) {
        if (currentUser == null) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text('No active user. Sign in to manage server settings.'),
          );
        }

        if (!_isAdminType(currentUser.type)) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Text('This page requires an admin account.'),
          );
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
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (_settings == null) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                const Expanded(child: Text('Failed to load server settings.')),
                TextButton(onPressed: () => unawaited(_loadServerSettings()), child: const Text('Retry')),
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
            if (_isLoading) const LinearProgressIndicator(minHeight: 2),
            SettingsNavigationSection(
              title: 'General',
              topPadding: 12,
              settings: [
                SettingSwitchTile.remote(
                  label: 'Store covers with item',
                  subtitle:
                      'Store covers in the library item folder instead of /metadata/items (only one file named cover will be kept)',
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
                  label: 'Store metadata with item',
                  subtitle: 'Store metadata files in library item folders instead of /metadata/items',
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
                  label: 'Ignore prefixes when sorting',
                  subtitle:
                      'Ignore prefix values like "the" when sorting titles (e.g. "The Book Title" is sorted as "Book Title, The")',
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
                      label: 'Prefixes to Ignore (case insensitive)',
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
              title: 'Regional',
              settings: [
                SettingDropdown<String>.remote(
                  label: 'Date Format',
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
                  label: 'Time Format',
                  values: _timeFormatValues,
                  valueLabels: _timeFormatLabels,
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
                  label: 'Language',
                  values: _languageValues,
                  valueLabels: _languageLabels,
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
              title: 'Scanner',
              settings: [
                SettingSwitchTile.remote(
                  label: 'Parse subtitles',
                  subtitle: 'Extract subtitles from audiobook folder names. Subtitle text must be separated by " - "',
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
                  label: 'Find covers',
                  subtitle: 'Attempt to find covers online if missing (extends scan time)',
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
                  label: 'Prefer matched metadata',
                  subtitle: 'Overwrite existing details with matched metadata during Quick Match',
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
                  label: 'Automatically scan libraries for changes',
                  subtitle:
                      'Automatically add or update items when file changes are detected (requires server restart)',
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
              title: 'Security',
              settings: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: StringChipListInput(
                    label: 'Allowed CORS Origins',
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
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
        child: Text('Failed to load user data: $error', style: TextStyle(color: Theme.of(context).colorScheme.error)),
      ),
    );
  }
}
