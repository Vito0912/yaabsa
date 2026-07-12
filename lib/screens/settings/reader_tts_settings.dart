import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/setting_key.dart';

class ReaderTtsSettings extends ConsumerStatefulWidget {
  const ReaderTtsSettings({super.key});

  static const String routeName = '/settings/reader/tts';

  @override
  ConsumerState<ReaderTtsSettings> createState() => _ReaderTtsSettingsState();
}

class _ReaderTtsSettingsState extends ConsumerState<ReaderTtsSettings> {
  List<String> _languages = [];
  List<Map<String, String>> _voices = [];
  bool _isLoadingTts = true;

  @override
  void initState() {
    super.initState();
    _loadTtsInfo();
  }

  Future<void> _loadTtsInfo() async {
    try {
      final tts = FlutterTts();
      final dynamic rawLangs = await tts.getLanguages;

      final List<String> languages = [];
      if (rawLangs is List) {
        languages.addAll(rawLangs.map((e) => e.toString()));
      }

      final List<Map<String, String>> voices = [];
      final isVoiceSupported =
          defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS;

      if (isVoiceSupported) {
        final dynamic rawVoices = await tts.getVoices;
        if (rawVoices is List) {
          for (final voice in rawVoices) {
            if (voice is Map) {
              final name = voice['name']?.toString() ?? '';
              final locale = voice['locale']?.toString() ?? '';
              if (name.isNotEmpty && locale.isNotEmpty) {
                voices.add({'name': name, 'locale': locale});
              }
            }
          }
        }
      }

      if (mounted) {
        setState(() {
          _languages = languages..sort();
          _voices = voices..sort((a, b) => a['name']!.compareTo(b['name']!));
          _isLoadingTts = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoadingTts = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return SettingsPageScaffold(
      title: 'TTS Settings',
      embedded: true,
      showEmbeddedBackButton: canPop,
      children: [
        SettingsNavigationSection(
          title: '',
          showSectionTitle: false,
          topPadding: 0,
          settings: [
            SettingSlider<double>(
              label: 'Speech Rate',
              description: 'Adjust the TTS speech rate multiplier',
              values: const [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0],
              valueLabels: const ['0.5x', '0.75x', '1.0x (Normal)', '1.25x', '1.5x', '1.75x', '2.0x'],
              settingKey: SettingKeys.readerTtsRate,
            ),
            if (_isLoadingTts)
              const Center(
                child: Padding(padding: EdgeInsets.symmetric(vertical: 16.0), child: CircularProgressIndicator()),
              )
            else ...[
              SettingDropdown<String>(
                label: 'TTS Language',
                description: 'Select the language for text-to-speech',
                values: _languages.isNotEmpty ? _languages : const ['en-US'],
                valueLabels: _languages.isNotEmpty ? _languages : const ['en-US'],
                settingKey: SettingKeys.readerTtsLanguage,
                onChanged: (lang) {
                  ref.read(settingsManagerProvider.notifier).setGlobalSetting<String>(SettingKeys.readerTtsVoice, '');
                },
              ),
              Consumer(
                builder: (context, ref, child) {
                  final isVoiceSupported =
                      defaultTargetPlatform == TargetPlatform.android ||
                      defaultTargetPlatform == TargetPlatform.iOS ||
                      defaultTargetPlatform == TargetPlatform.macOS;
                  if (!isVoiceSupported) {
                    return const SizedBox.shrink();
                  }

                  final currentLang =
                      ref.watch(globalSettingByKeyProvider(SettingKeys.readerTtsLanguage)).value ?? 'en-US';
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
                    settingKey: SettingKeys.readerTtsVoice,
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
