import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/database/auth_secret_store.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/screens/settings/reader/elevenlabs_tts_settings.dart';
import 'package:yaabsa/util/reader/elevenlabs/elevenlabs_reader_speech_engine.dart';
import 'package:yaabsa/util/reader/elevenlabs/elevenlabs_speech_api.dart';
import 'package:yaabsa/util/reader/elevenlabs/elevenlabs_speech_audio_generator.dart';
import 'package:yaabsa/util/reader/reader_speech_engine.dart';
import 'package:yaabsa/util/setting_key.dart';

void registerReaderSpeechProviders(ProviderContainer container) {
  final api = ElevenLabsSpeechApi(
    readApiKey: () => container.read(authSecretStoreProvider).readSpeechProviderApiKey('elevenlabs'),
  );

  ReaderSpeechEngines.register(
    ReaderSpeechEngineRegistration(
      id: 'elevenlabs',
      label: 'ElevenLabs',
      create: () => ElevenLabsReaderSpeechEngine(
        api: api,
        readModel: () => container
            .read(settingsManagerProvider.notifier)
            .getGlobalSetting<String>(SettingKeys.readerElevenLabsModel),
      ),
      settingsBuilder: (context) => ElevenLabsTtsSettings(api: api),
      createAudioGenerator: () => ElevenLabsSpeechAudioGenerator(
        api: api,
        readModel: () => container
            .read(settingsManagerProvider.notifier)
            .getGlobalSetting<String>(SettingKeys.readerElevenLabsModel),
      ),
      showStandardVoiceSettings: false,
      voiceSettingKey: SettingKeys.readerElevenLabsVoiceId,
      languageSettingKey: SettingKeys.readerElevenLabsLanguage,
      playbackSettingKeys: const [
        SettingKeys.readerElevenLabsModel,
        SettingKeys.readerElevenLabsVoiceId,
        SettingKeys.readerElevenLabsLanguage,
        SettingKeys.readerElevenLabsKeyRevision,
      ],
    ),
  );
}
