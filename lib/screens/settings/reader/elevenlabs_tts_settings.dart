import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/database/auth_secret_store.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/reader/elevenlabs/elevenlabs_speech_api.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/ui/components/menus/yaabsa_context_menu_button.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/setting_key.dart';

class ElevenLabsTtsSettings extends ConsumerStatefulWidget {
  const ElevenLabsTtsSettings({super.key, required this.api});

  final ElevenLabsSpeechApi api;

  @override
  ConsumerState<ElevenLabsTtsSettings> createState() => _ElevenLabsTtsSettingsState();
}

class _ElevenLabsTtsSettingsState extends ConsumerState<ElevenLabsTtsSettings> {
  final _keyController = TextEditingController();
  final _voiceController = TextEditingController();
  final _languageController = TextEditingController();
  final _preferencesForm = GlobalKey<FormState>();
  List<ElevenLabsSpeechModel> _models = const [];
  List<Map<String, String>> _voices = const [];
  CancelToken? _catalogRequest;
  bool _loadingKey = true;
  bool _savingKey = false;
  bool _savingPreferences = false;
  bool _loadingCatalog = false;
  bool _hasKey = false;
  bool _obscureKey = true;
  String? _keyError;
  String? _modelError;
  String? _voiceError;
  int _catalogGeneration = 0;

  @override
  void initState() {
    super.initState();

    final settings = ref.read(settingsManagerProvider.notifier);

    _voiceController.text = settings.getGlobalSetting<String>(SettingKeys.readerElevenLabsVoiceId);
    _languageController.text = settings.getGlobalSetting<String>(SettingKeys.readerElevenLabsLanguage);
    unawaited(_loadKey());
  }

  Future<void> _loadKey() async {
    try {
      final key = await ref.read(authSecretStoreProvider).readSpeechProviderApiKey('elevenlabs');

      if (!mounted) {
        return;
      }

      setState(() {
        _keyController.text = key ?? '';
        _hasKey = key?.isNotEmpty == true;
        _loadingKey = false;
      });

      if (_hasKey) {
        unawaited(_loadCatalog());
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _loadingKey = false;
        _keyError = context.l10n.errorSecureStorageUnavailable;
      });
    }
  }

  Future<void> _saveKey() async {
    if (_savingKey) {
      return;
    }

    final value = _keyController.text.trim();

    setState(() {
      _savingKey = true;
      _keyError = null;
    });

    try {
      await ref.read(authSecretStoreProvider).writeSpeechProviderApiKey('elevenlabs', value);
      await ref
          .read(settingsManagerProvider.notifier)
          .setGlobalSetting<int>(SettingKeys.readerElevenLabsKeyRevision, DateTime.now().microsecondsSinceEpoch);

      if (!mounted) {
        return;
      }

      setState(() {
        _hasKey = value.isNotEmpty;
        _models = const [];
        _voices = const [];
      });

      if (_hasKey) {
        await _loadCatalog();
      } else {
        _catalogGeneration++;
        _catalogRequest?.cancel();
        setState(() {
          _loadingCatalog = false;
          _modelError = null;
          _voiceError = null;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _keyError = context.l10n.errorSecureStorageUnavailable);
      }
    } finally {
      if (mounted) {
        setState(() => _savingKey = false);
      }
    }
  }

  Future<void> _loadCatalog() async {
    if (!_hasKey) {
      return;
    }

    final generation = ++_catalogGeneration;

    _catalogRequest?.cancel();

    final token = _catalogRequest = CancelToken();

    setState(() {
      _loadingCatalog = true;
      _modelError = null;
      _voiceError = null;
    });

    List<ElevenLabsSpeechModel> models = const [];
    List<Map<String, String>> voices = const [];
    String? modelError;
    String? voiceError;

    await Future.wait<void>([
      widget.api
          .models(cancelToken: token)
          .then((value) {
            models = value;
          })
          .catchError((Object error) {
            if (!token.isCancelled) {
              modelError = _catalogErrorMessage(error);
            }
          }),
      widget.api
          .voices(cancelToken: token)
          .then((value) {
            voices = value;
          })
          .catchError((Object error) {
            if (!token.isCancelled) {
              voiceError = _catalogErrorMessage(error);
            }
          }),
    ]);

    if (!mounted || generation != _catalogGeneration) {
      return;
    }

    setState(() {
      _models = models;
      _voices = voices..sort((a, b) => a['name']!.compareTo(b['name']!));
      _modelError = modelError;
      _voiceError = voiceError;
      _loadingCatalog = false;
    });
  }

  String _catalogErrorMessage(Object error) {
    if (error is ElevenLabsSpeechException) {
      return error.message;
    }

    return context.l10n.errorElevenLabsUnavailable;
  }

  Future<void> _savePreferences() async {
    if (_savingPreferences || !(_preferencesForm.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _savingPreferences = true);

    try {
      final settings = ref.read(settingsManagerProvider.notifier);

      await settings.setGlobalSetting<String>(SettingKeys.readerElevenLabsVoiceId, _voiceController.text.trim());
      await settings.setGlobalSetting<String>(SettingKeys.readerElevenLabsLanguage, _languageController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.readerSpeechPreferencesSaved)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.readerSpeechSaveFailed)));
      }
    } finally {
      if (mounted) {
        setState(() => _savingPreferences = false);
      }
    }
  }

  @override
  void dispose() {
    _catalogGeneration++;
    _catalogRequest?.cancel();
    _keyController.dispose();
    _voiceController.dispose();
    _languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.read(settingsManagerProvider.notifier);
    final localizations = context.l10n;

    ref.watch(globalSettingByKeyProvider(SettingKeys.readerElevenLabsModel));

    final modelId = settings.getGlobalSetting<String>(SettingKeys.readerElevenLabsModel);
    final models = _models.isNotEmpty ? _models : defaultElevenLabsModels;
    final selectedModel = models.where((model) => model.id == modelId).firstOrNull;
    final choices = [
      ...models,
      if (isAllowedElevenLabsModel(modelId) && !models.any((model) => model.id == modelId))
        ElevenLabsSpeechModel(id: modelId, name: modelId),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('ElevenLabs', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              StyledTextField(
                controller: _keyController,
                enabled: !_loadingKey && !_savingKey,
                obscureText: _obscureKey,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.visiblePassword,
                onSubmitted: (_) => unawaited(_saveKey()),
                label: localizations.fieldApiKey,
                helperText: localizations.readerSpeechApiKeyStored,
                errorText: _keyError,
                suffixIcon: IconButton(
                  tooltip: _obscureKey ? localizations.actionShow : localizations.actionHide,
                  icon: Icon(_obscureKey ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                  onPressed: () => setState(() => _obscureKey = !_obscureKey),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: _loadingKey || _savingKey ? null : () => unawaited(_saveKey()),
                    icon: const Icon(Icons.key_outlined),
                    label: Text(_savingKey ? localizations.statusSaving : localizations.actionSave),
                  ),
                  OutlinedButton.icon(
                    onPressed: !_hasKey || _loadingCatalog ? null : () => unawaited(_loadCatalog()),
                    icon: const Icon(Icons.refresh),
                    label: Text(localizations.actionRefresh),
                  ),
                ],
              ),
              if (_loadingKey || _loadingCatalog) ...[
                const SizedBox(height: 12),
                const YaabsaLinearProgressIndicator(),
              ],
            ],
          ),
        ),
        SettingDropdown<String>(
          label: localizations.fieldModel,
          description: localizations.readerSpeechModelDescription,
          values: choices.map((model) => model.id).toList(),
          valueLabels: choices.map((model) => model.name).toList(),
          settingKey: SettingKeys.readerElevenLabsModel,
        ),
        if (_modelError != null) ListTile(leading: const Icon(Icons.info_outline), title: Text(_modelError!)),
        if (_voices.isNotEmpty)
          SettingDropdown<String>(
            label: localizations.fieldVoice,
            values: ['', ..._voices.map((voice) => voice['id']!)],
            valueLabels: [localizations.readerSpeechVoiceChoose, ..._voices.map((voice) => voice['name']!)],
            settingKey: SettingKeys.readerElevenLabsVoiceId,
            onChanged: (value) => _voiceController.text = value,
          ),
        if (_voiceError != null) ListTile(leading: const Icon(Icons.info_outline), title: Text(_voiceError!)),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Form(
            key: _preferencesForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StyledTextFormField(
                  controller: _voiceController,
                  enabled: !_savingPreferences,
                  autocorrect: false,
                  enableSuggestions: false,
                  validator: (value) =>
                      value?.trim().isNotEmpty == true && !RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(value!.trim())
                      ? context.l10n.readerSpeechVoiceInvalid
                      : null,
                  onFieldSubmitted: (_) => unawaited(_savePreferences()),
                  label: localizations.fieldVoiceId,
                  helperText: localizations.readerSpeechVoiceIdDescription,
                ),
                const SizedBox(height: 16),
                StyledTextFormField(
                  controller: _languageController,
                  enabled: !_savingPreferences,
                  autocorrect: false,
                  enableSuggestions: false,
                  validator: (value) {
                    final language = value?.trim() ?? '';

                    if (language.isEmpty) {
                      return null;
                    }
                    if (!RegExp(r'^[a-zA-Z]{2,3}(?:[-_][a-zA-Z0-9]{2,8})*$').hasMatch(language)) {
                      return context.l10n.readerSpeechLanguageCodeExample;
                    }

                    final code = language.replaceAll('_', '-').split('-').first.toLowerCase();

                    if (selectedModel?.languages.isNotEmpty == true && !selectedModel!.languages.containsKey(code)) {
                      return context.l10n.readerSpeechLanguageUnsupported;
                    }

                    return null;
                  },
                  onFieldSubmitted: (_) => unawaited(_savePreferences()),
                  label: localizations.readerSpeechPreferredLanguage,
                  hintText: localizations.readerSpeechLanguageHint,
                  helperText: selectedModel?.supportsLanguageCode == false
                      ? localizations.readerSpeechDetectsLanguage
                      : localizations.readerSpeechDetectLanguage,
                  suffixIcon: selectedModel?.languages.isNotEmpty == true
                      ? YaabsaContextMenuButton<String>(
                          tooltip: localizations.readerSpeechLanguageChoose,
                          icon: const Icon(Icons.language),
                          onSelected: (value) => _languageController.text = value,
                          itemBuilder: (context) => [
                            PopupMenuItem(value: '', child: Text(localizations.optionAutomatic)),
                            for (final language in selectedModel!.languages.entries)
                              PopupMenuItem(value: language.key, child: Text(language.value)),
                          ],
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: FilledButton.tonal(
                    onPressed: _savingPreferences ? null : () => unawaited(_savePreferences()),
                    child: Text(_savingPreferences ? localizations.statusSaving : localizations.actionSave),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
