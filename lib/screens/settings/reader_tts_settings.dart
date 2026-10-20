import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/util/reader/reader_speech_engine.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/setting_key.dart';

class ReaderTtsSettings extends ConsumerStatefulWidget {
  const ReaderTtsSettings({super.key, this.showTitle = true});

  final bool showTitle;

  static const String routeName = '/settings/reader/tts';

  @override
  ConsumerState<ReaderTtsSettings> createState() => _ReaderTtsSettingsState();
}

class _ReaderTtsSettingsState extends ConsumerState<ReaderTtsSettings> {
  List<String> _languages = [];
  List<Map<String, String>> _voices = [];
  bool _isLoadingTts = true;
  String? _ttsError;
  int _loadGeneration = 0;

  @override
  void initState() {
    super.initState();
    _loadTtsInfo();
  }

  Future<void> _loadTtsInfo() async {
    final generation = ++_loadGeneration;

    setState(() {
      _isLoadingTts = true;
      _ttsError = null;
    });

    try {
      final id = ref.read(settingsManagerProvider.notifier).getGlobalSetting<String>(SettingKeys.readerTtsEngine);

      if (!ReaderSpeechEngines.registration(id).showStandardVoiceSettings) {
        if (mounted && generation == _loadGeneration) {
          setState(() => _isLoadingTts = false);
        }

        return;
      }

      final engine = ReaderSpeechEngines.create(id);

      final languages = await engine.languages();

      List<Map<String, String>> voices;

      try {
        voices = await engine.voices();
      } catch (_) {
        voices = [];
      }

      if (mounted && generation == _loadGeneration) {
        setState(() {
          _languages = languages..sort();
          _voices = voices..sort((a, b) => a['name']!.compareTo(b['name']!));
          _isLoadingTts = false;

          if (languages.isEmpty) {
            _ttsError = 'No speech voices are available. Check your device speech settings.';
          }
        });
      }
    } catch (_) {
      if (mounted && generation == _loadGeneration) {
        setState(() {
          _isLoadingTts = false;
          _ttsError = 'Speech is unavailable. Check your speech provider or device settings.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    ref.watch(globalSettingByKeyProvider(SettingKeys.readerTtsEngine));
    ref.listen(globalSettingByKeyProvider(SettingKeys.readerTtsEngine), (previous, next) {
      if (previous?.value != next.value) {
        unawaited(_loadTtsInfo());
      }
    });

    final selectedId = ref.read(settingsManagerProvider.notifier).getGlobalSetting<String>(SettingKeys.readerTtsEngine);
    final registration = ReaderSpeechEngines.registration(selectedId);

    return SettingsPageScaffold(
      title: 'Read aloud',
      showEmbeddedTitle: widget.showTitle,
      embedded: true,
      showEmbeddedBackButton: widget.showTitle && canPop,
      children: [
        SettingsNavigationSection(
          title: '',
          showSectionTitle: false,
          topPadding: 0,
          settings: [
            SettingDropdown<String>(
              label: 'Speech provider',
              description: 'Choose which service reads your book',
              values: ReaderSpeechEngines.available.map((engine) => engine.id).toList(),
              valueLabels: ReaderSpeechEngines.available.map((engine) => engine.label).toList(),
              settingKey: SettingKeys.readerTtsEngine,
            ),
            if (registration.settingsBuilder != null) registration.settingsBuilder!(context),
            if (registration.showStandardVoiceSettings && _ttsError != null)
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(_ttsError!),
                trailing: IconButton(
                  tooltip: 'Reload voices',
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadTtsInfo,
                ),
              ),
            SettingSlider<double>(
              label: 'Speech Rate',
              description: 'Adjust the TTS speech rate multiplier',
              values: const [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0],
              valueLabels: const ['0.5x', '0.75x', '1.0x (Normal)', '1.25x', '1.5x', '1.75x', '2.0x'],
              settingKey: SettingKeys.readerTtsRate,
            ),
            if (registration.showStandardVoiceSettings && _isLoadingTts)
              const Center(
                child: Padding(padding: EdgeInsets.symmetric(vertical: 16.0), child: CircularProgressIndicator()),
              )
            else if (registration.showStandardVoiceSettings) ...[
              SettingDropdown<String>(
                label: 'TTS Language',
                description: 'Select the language for text-to-speech',
                values: _languages.isNotEmpty ? _languages : const ['en-US'],
                valueLabels: _languages.isNotEmpty ? _languages : const ['en-US'],
                settingKey: registration.languageSettingKey,
                onChanged: (lang) {
                  ref.read(settingsManagerProvider.notifier).setGlobalSetting<String>(registration.voiceSettingKey, '');
                },
              ),
              Consumer(
                builder: (context, ref, child) {
                  final currentLang =
                      ref.watch(globalSettingByKeyProvider(registration.languageSettingKey)).value ?? 'en-US';
                  final filteredVoices = _voices
                      .where((v) => v['locale'] == currentLang || v['locale']!.startsWith('$currentLang-'))
                      .toList();

                  final values = ['', ...filteredVoices.map((v) => v['name']!)];
                  final displayLabels = <String>['System Default'];
                  int voiceIndex = 1;

                  for (final voice in filteredVoices) {
                    final name = voice['name']!;
                    final isLocal = name.toLowerCase().endsWith('local');
                    final isNetwork = name.toLowerCase().endsWith('network');
                    final typeLabel = isLocal ? ' (Local)' : (isNetwork ? ' (Network)' : '');

                    if (name.toLowerCase().contains('-x-')) {
                      displayLabels.add('Voice $voiceIndex$typeLabel');
                      voiceIndex++;
                    } else {
                      displayLabels.add('$name$typeLabel');
                    }
                  }

                  return SettingDropdown<String>(
                    label: 'TTS Voice',
                    description: 'Select a specific voice for text-to-speech',
                    values: values,
                    valueLabels: displayLabels,
                    settingKey: registration.voiceSettingKey,
                  );
                },
              ),
            ],
          ],
        ),
      ],
    );
  }
}
