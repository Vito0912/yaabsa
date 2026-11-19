#ifndef YAABSA_FLUTTER_TTS_WINDOWS_PLUGIN_H_
#define YAABSA_FLUTTER_TTS_WINDOWS_PLUGIN_H_

#include <flutter_plugin_registrar.h>

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FLUTTER_PLUGIN_EXPORT __declspec(dllimport)
#endif

#if defined(__cplusplus)
extern "C" {
#endif

FLUTTER_PLUGIN_EXPORT void YaabsaFlutterTtsWindowsPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar);

#if defined(__cplusplus)
}  // extern "C"
#endif

#endif  // YAABSA_FLUTTER_TTS_WINDOWS_PLUGIN_H_
