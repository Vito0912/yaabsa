import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/database/auth_secret_store.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/reader/elevenlabs/elevenlabs_speech_api.dart';
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
        _keyError = 'Could not read secure storage. Unlock your keyring and try again';
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
        setState(() => _keyError = 'Could not save the API key securely. Unlock your keyring and try again');
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
              modelError = error.toString();
            }
          }),
      widget.api
          .voices(cancelToken: token)
          .then((value) {
            voices = value;
          })
          .catchError((Object error) {
            if (!token.isCancelled) {
              voiceError = error.toString();
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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Speech preferences saved')));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not save speech preferences')));
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
              TextField(
                controller: _keyController,
                enabled: !_loadingKey && !_savingKey,
                obscureText: _obscureKey,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: 'API key',
                  helperText: 'Stored securely on this device',
                  errorText: _keyError,
                  suffixIcon: IconButton(
                    tooltip: _obscureKey ? 'Show API key' : 'Hide API key',
                    icon: Icon(_obscureKey ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _obscureKey = !_obscureKey),
                  ),
                ),
                onSubmitted: (_) => unawaited(_saveKey()),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: _loadingKey || _savingKey ? null : () => unawaited(_saveKey()),
                    icon: const Icon(Icons.key_outlined),
                    label: Text(_savingKey ? 'Saving' : 'Save API key'),
                  ),
                  OutlinedButton.icon(
                    onPressed: !_hasKey || _loadingCatalog ? null : () => unawaited(_loadCatalog()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh voices and models'),
                  ),
                ],
              ),
              if (_loadingKey || _loadingCatalog) ...[const SizedBox(height: 12), const LinearProgressIndicator()],
            ],
          ),
        ),
        SettingDropdown<String>(
          label: 'Model',
          description: 'Choose a v2 or v4 speech model',
          values: choices.map((model) => model.id).toList(),
          valueLabels: choices.map((model) => model.name).toList(),
          settingKey: SettingKeys.readerElevenLabsModel,
        ),
        if (_modelError != null) ListTile(leading: const Icon(Icons.info_outline), title: Text(_modelError!)),
        if (_voices.isNotEmpty)
          SettingDropdown<String>(
            label: 'Voice',
            values: ['', ..._voices.map((voice) => voice['id']!)],
            valueLabels: ['Choose a voice', ..._voices.map((voice) => voice['name']!)],
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
                TextFormField(
                  controller: _voiceController,
                  enabled: !_savingPreferences,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: const InputDecoration(
                    labelText: 'Voice ID',
                    helperText: 'Use any voice available to your account',
                  ),
                  validator: (value) =>
                      value?.trim().isNotEmpty == true && !RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(value!.trim())
                      ? 'Enter a valid voice ID'
                      : null,
                  onFieldSubmitted: (_) => unawaited(_savePreferences()),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _languageController,
                  enabled: !_savingPreferences,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    labelText: 'Preferred language',
                    hintText: 'en, de, fr',
                    helperText: selectedModel?.supportsLanguageCode == false
                        ? 'This model detects the language from the text'
                        : 'Leave empty to detect the language from the text',
                    suffixIcon: selectedModel?.languages.isNotEmpty == true
                        ? PopupMenuButton<String>(
                            tooltip: 'Choose language',
                            icon: const Icon(Icons.language),
                            onSelected: (value) => _languageController.text = value,
                            itemBuilder: (context) => [
                              const PopupMenuItem(value: '', child: Text('Automatic')),
                              for (final language in selectedModel!.languages.entries)
                                PopupMenuItem(value: language.key, child: Text(language.value)),
                            ],
                          )
                        : null,
                  ),
                  validator: (value) {
                    final language = value?.trim() ?? '';

                    if (language.isEmpty) {
                      return null;
                    }
                    if (!RegExp(r'^[a-zA-Z]{2,3}(?:[-_][a-zA-Z0-9]{2,8})*$').hasMatch(language)) {
                      return 'Enter a language code such as en or de';
                    }

                    final code = language.replaceAll('_', '-').split('-').first.toLowerCase();

                    if (selectedModel?.languages.isNotEmpty == true && !selectedModel!.languages.containsKey(code)) {
                      return 'This model does not support that language';
                    }

                    return null;
                  },
                  onFieldSubmitted: (_) => unawaited(_savePreferences()),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: FilledButton.tonal(
                    onPressed: _savingPreferences ? null : () => unawaited(_savePreferences()),
                    child: Text(_savingPreferences ? 'Saving' : 'Save speech preferences'),
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
