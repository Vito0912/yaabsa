#include "include/yaabsa_flutter_tts_windows/yaabsa_flutter_tts_windows_plugin.h"
// This must be included before many other Windows headers.
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>
#include <windows.h>

#include <algorithm>
#include <cstdint>
#include <exception>
#include <memory>
#include <set>
#include <sstream>
#include <string>
#include <utility>
#include <variant>

typedef std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>>
    FlutterResult;

#include <winrt/Windows.Media.Core.h>
#include <winrt/Windows.Media.Playback.h>
#include <winrt/Windows.Media.SpeechSynthesis.h>
using namespace winrt;
using namespace Windows::Media::SpeechSynthesis;
#include <winrt/Windows.Foundation.Collections.h>
#include <winrt/Windows.Foundation.h>
namespace {
class FlutterTtsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);
  FlutterTtsPlugin();
  virtual ~FlutterTtsPlugin();

 private:
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void speak(const std::string, FlutterResult&);
  void pause();
  void continuePlay();
  void stop();
  void setVolume(const double);
  void setPitch(const double);
  void setRate(const double);
  void getVoices(flutter::EncodableList&);
  void setVoice(const std::string, const std::string, FlutterResult&);
  void getLanguages(flutter::EncodableList&);
  void setLanguage(const std::string, FlutterResult&);
  void addMplayer();
  void DispatchMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      FlutterResult& result);
  winrt::Windows::Foundation::IAsyncAction asyncSpeak(const std::string);
  bool speaking();

  std::unique_ptr<flutter::MethodChannel<>> methodChannel;
  SpeechSynthesizer synth{nullptr};
  winrt::Windows::Media::Playback::MediaPlayer mPlayer{nullptr};
  winrt::event_token mediaEndedToken{};
  bool isPaused;
  bool isSpeaking;
  bool awaitSpeakCompletion;
  FlutterResult speakResult;
};

void FlutterTtsPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows* registrar) {
  auto plugin = std::make_unique<FlutterTtsPlugin>();
  plugin->methodChannel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "flutter_tts",
          &flutter::StandardMethodCodec::GetInstance());

  plugin->methodChannel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto& call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });
  registrar->AddPlugin(std::move(plugin));
}

void FlutterTtsPlugin::addMplayer() {
  auto player = winrt::Windows::Media::Playback::MediaPlayer();
  const auto endedToken = player.MediaEnded([this](auto const&, auto const&) {
    methodChannel->InvokeMethod("speak.onComplete", NULL);
    if (speakResult) {
      auto completion = std::move(speakResult);
      completion->Success(1);
    }
    isSpeaking = false;
  });

  mPlayer = std::move(player);
  mediaEndedToken = endedToken;
}

bool FlutterTtsPlugin::speaking() { return isSpeaking; }

winrt::Windows::Foundation::IAsyncAction FlutterTtsPlugin::asyncSpeak(
    const std::string text) {
  SpeechSynthesisStream speechStream{
      co_await synth.SynthesizeTextToStreamAsync(to_hstring(text))};
  winrt::param::hstring cType = L"Audio";
  winrt::Windows::Media::Core::MediaSource source =
      winrt::Windows::Media::Core::MediaSource::CreateFromStream(speechStream,
                                                                 cType);
  mPlayer.Source(source);
  mPlayer.Play();
}

void FlutterTtsPlugin::speak(const std::string text, FlutterResult& result) {
  isSpeaking = true;
  auto my_task{asyncSpeak(text)};
  methodChannel->InvokeMethod("speak.onStart", NULL);
  if (awaitSpeakCompletion) {
    speakResult = std::move(result);
  } else {
    result->Success(1);
  }
};

void FlutterTtsPlugin::pause() {
  if (!mPlayer) {
    return;
  }

  mPlayer.Pause();
  isPaused = true;
  methodChannel->InvokeMethod("speak.onPause", NULL);
}

void FlutterTtsPlugin::continuePlay() {
  mPlayer.Play();
  isPaused = false;
  methodChannel->InvokeMethod("speak.onContinue", NULL);
}

void FlutterTtsPlugin::stop() {
  if (!mPlayer) {
    return;
  }

  mPlayer.MediaEnded(mediaEndedToken);
  mPlayer.Close();
  mPlayer = nullptr;
  isSpeaking = false;
  isPaused = false;

  methodChannel->InvokeMethod("speak.onCancel", nullptr);
  if (speakResult) {
    auto completion = std::move(speakResult);
    completion->Success(1);
  }
}

void FlutterTtsPlugin::setVolume(const double newVolume) {
  synth.Options().AudioVolume(newVolume);
}

void FlutterTtsPlugin::setPitch(const double newPitch) {
  synth.Options().AudioPitch(newPitch);
}

void FlutterTtsPlugin::setRate(const double newRate) {
  synth.Options().SpeakingRate(newRate + 0.5);
}

void FlutterTtsPlugin::getVoices(flutter::EncodableList& voices) {
  auto synthVoices = SpeechSynthesizer::AllVoices();
  std::for_each(begin(synthVoices), end(synthVoices),
                [&voices](const VoiceInformation& voice) {
                  flutter::EncodableMap voiceInfo;
                  voiceInfo[flutter::EncodableValue("locale")] =
                      to_string(voice.Language());
                  voiceInfo[flutter::EncodableValue("name")] =
                      to_string(voice.DisplayName());
                  //  Convert VoiceGender to string
                  std::string gender;
                  switch (voice.Gender()) {
                    case VoiceGender::Male:
                      gender = "male";
                      break;
                    case VoiceGender::Female:
                      gender = "female";
                      break;
                    default:
                      gender = "unknown";
                      break;
                  }
                  voiceInfo[flutter::EncodableValue("gender")] = gender;
                  // Identifier example
                  // "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Speech_OneCore\Voices\Tokens\MSTTS_V110_enUS_MarkM"
                  voiceInfo[flutter::EncodableValue("identifier")] =
                      to_string(voice.Id());
                  voices.push_back(flutter::EncodableMap(voiceInfo));
                });
}

void FlutterTtsPlugin::setVoice(const std::string voiceLanguage,
                                const std::string voiceName,
                                FlutterResult& result) {
  bool found = false;
  auto voices = SpeechSynthesizer::AllVoices();
  VoiceInformation newVoice = synth.Voice();
  std::for_each(begin(voices), end(voices),
                [&voiceLanguage, &voiceName, &found,
                 &newVoice](const VoiceInformation& voice) {
                  if (to_string(voice.Language()) == voiceLanguage &&
                      to_string(voice.DisplayName()) == voiceName) {
                    newVoice = voice;
                    found = true;
                  }
                });
  synth.Voice(newVoice);
  if (found) {
    result->Success(1);
  } else {
    result->Success(0);
  }
}

void FlutterTtsPlugin::getLanguages(flutter::EncodableList& languages) {
  auto synthVoices = SpeechSynthesizer::AllVoices();
  std::set<flutter::EncodableValue> languagesSet = {};
  std::for_each(begin(synthVoices), end(synthVoices),
                [&languagesSet](const VoiceInformation& voice) {
                  languagesSet.insert(
                      flutter::EncodableValue(to_string(voice.Language())));
                });
  std::for_each(begin(languagesSet), end(languagesSet),
                [&languages](const flutter::EncodableValue value) {
                  languages.push_back(value);
                });
}
void FlutterTtsPlugin::setLanguage(const std::string voiceLanguage,
                                   FlutterResult& result) {
  bool found = false;
  auto voices = SpeechSynthesizer::AllVoices();
  VoiceInformation newVoice = synth.Voice();
  std::for_each(
      begin(voices), end(voices),
      [&voiceLanguage, &newVoice, &found](const VoiceInformation& voice) {
        if (to_string(voice.Language()) == voiceLanguage) {
          newVoice = voice;
          found = true;
        }
      });
  synth.Voice(newVoice);
  if (found) {
    result->Success(1);
  } else {
    result->Success(0);
  }
}

FlutterTtsPlugin::FlutterTtsPlugin() {
  isPaused = false;
  isSpeaking = false;
  awaitSpeakCompletion = false;
  speakResult = FlutterResult();
}

FlutterTtsPlugin::~FlutterTtsPlugin() {
  if (methodChannel) {
    methodChannel->SetMethodCallHandler(nullptr);
  }

  if (mPlayer) {
    mPlayer.MediaEnded(mediaEndedToken);
    mPlayer.Close();
  }
  if (synth) {
    synth.Close();
  }
}

void FlutterTtsPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    FlutterResult result) {
  const auto& method = method_call.method_name();
  const bool needsSynthesizer = method == "speak" || method == "setLanguage" ||
                                method == "setVoice" || method == "setVolume" ||
                                method == "setPitch" ||
                                method == "setSpeechRate";

  try {
    if (needsSynthesizer && !synth) {
      synth = SpeechSynthesizer();
    }
    if (method == "speak" && !mPlayer) {
      addMplayer();
    }

    DispatchMethodCall(method_call, result);
  } catch (const winrt::hresult_error& error) {
    if (result) {
      result->Error(
          "tts_windows_error", winrt::to_string(error.message()),
          flutter::EncodableValue(static_cast<int32_t>(error.code().value)));
    }
  } catch (const std::exception& error) {
    if (result) {
      result->Error("tts_windows_error", error.what());
    }
  }
}

void FlutterTtsPlugin::DispatchMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    FlutterResult& result) {
  if (method_call.method_name().compare("getPlatformVersion") == 0) {
    std::ostringstream version_stream;
    version_stream << "Windows UWP";
    result->Success(flutter::EncodableValue(version_stream.str()));
  }

  else if (method_call.method_name().compare("awaitSpeakCompletion") == 0) {
    const flutter::EncodableValue arg = method_call.arguments()[0];
    if (std::holds_alternative<bool>(arg)) {
      awaitSpeakCompletion = std::get<bool>(arg);
      result->Success(1);
    } else {
      result->Success(0);
    }
  } else if (method_call.method_name().compare("speak") == 0) {
    if (isPaused) {
      continuePlay();
      result->Success(1);
      return;
    }
    const flutter::EncodableValue arg = method_call.arguments()[0];
    if (std::holds_alternative<std::string>(arg)) {
      if (!speaking()) {
        const std::string text = std::get<std::string>(arg);
        speak(text, result);
      } else {
        result->Success(0);
      }
    } else {
      result->Success(0);
    }
  } else if (method_call.method_name().compare("pause") == 0) {
    FlutterTtsPlugin::pause();
    result->Success(1);
  } else if (method_call.method_name().compare("setLanguage") == 0) {
    const flutter::EncodableValue arg = method_call.arguments()[0];
    if (std::holds_alternative<std::string>(arg)) {
      const std::string lang = std::get<std::string>(arg);
      setLanguage(lang, result);
    } else {
      result->Success(0);
    }
  } else if (method_call.method_name().compare("setVolume") == 0) {
    const flutter::EncodableValue arg = method_call.arguments()[0];
    if (std::holds_alternative<double>(arg)) {
      const double newVolume = std::get<double>(arg);
      setVolume(newVolume);
      result->Success(1);
    } else {
      result->Success(0);
    }

  } else if (method_call.method_name().compare("setSpeechRate") == 0) {
    const flutter::EncodableValue arg = method_call.arguments()[0];
    if (std::holds_alternative<double>(arg)) {
      const double newRate = std::get<double>(arg);
      setRate(newRate);
      result->Success(1);
    } else {
      result->Success(0);
    }

  } else if (method_call.method_name().compare("setPitch") == 0) {
    const flutter::EncodableValue arg = method_call.arguments()[0];
    if (std::holds_alternative<double>(arg)) {
      const double newPitch = std::get<double>(arg);
      setPitch(newPitch);
      result->Success(1);
    } else {
      result->Success(0);
    }
  } else if (method_call.method_name().compare("setVoice") == 0) {
    const flutter::EncodableValue arg = method_call.arguments()[0];
    if (std::holds_alternative<flutter::EncodableMap>(arg)) {
      const flutter::EncodableMap voiceInfo =
          std::get<flutter::EncodableMap>(arg);
      std::string voiceLanguage = "";
      std::string voiceName = "";
      auto voiceLanguage_it = voiceInfo.find(flutter::EncodableValue("locale"));
      if (voiceLanguage_it != voiceInfo.end()) {
        voiceLanguage = std::get<std::string>(voiceLanguage_it->second);
      }
      auto voiceName_it = voiceInfo.find(flutter::EncodableValue("name"));
      if (voiceName_it != voiceInfo.end()) {
        voiceName = std::get<std::string>(voiceName_it->second);
      }
      setVoice(voiceLanguage, voiceName, result);
    } else {
      result->Success(0);
    }
  } else if (method_call.method_name().compare("stop") == 0) {
    stop();
    result->Success(1);
  } else if (method_call.method_name().compare("getLanguages") == 0) {
    flutter::EncodableList l;
    getLanguages(l);
    result->Success(l);
  } else if (method_call.method_name().compare("getVoices") == 0) {
    flutter::EncodableList l;
    getVoices(l);
    result->Success(l);
  } else {
    result->NotImplemented();
  }
}
}  // namespace

void YaabsaFlutterTtsWindowsPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  FlutterTtsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
