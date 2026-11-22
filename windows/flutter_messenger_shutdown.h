#ifndef YAABSA_FLUTTER_MESSENGER_SHUTDOWN_H_
#define YAABSA_FLUTTER_MESSENGER_SHUTDOWN_H_

#include <flutter_messenger.h>

inline void SetFlutterMessengerCallbackIfAvailable(
    FlutterDesktopMessengerRef messenger,
    const char* channel,
    FlutterDesktopMessageCallback callback,
    void* user_data) {
  if (FlutterDesktopMessengerIsAvailable(messenger)) {
    FlutterDesktopMessengerSetCallback(messenger, channel, callback, user_data);
  }
}

#define FlutterDesktopMessengerSetCallback SetFlutterMessengerCallbackIfAvailable

#endif  // YAABSA_FLUTTER_MESSENGER_SHUTDOWN_H_
