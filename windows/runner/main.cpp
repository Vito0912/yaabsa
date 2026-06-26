#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>
#include <string>

#include "flutter_window.h"
#include "utils.h"
#include "app_links/app_links_plugin_c_api.h"

void RegisterUriScheme() {
  wchar_t exe_path[MAX_PATH];
  GetModuleFileName(NULL, exe_path, MAX_PATH);

  std::wstring key_path = L"Software\\Classes\\yaabsa";
  HKEY hKey;
  if (RegCreateKeyEx(HKEY_CURRENT_USER, key_path.c_str(), 0, NULL, REG_OPTION_NON_VOLATILE, KEY_WRITE, NULL, &hKey, NULL) == ERROR_SUCCESS) {
    const wchar_t* protocol_desc = L"URL:yaabsa Protocol";
    RegSetValueEx(hKey, NULL, 0, REG_SZ, (BYTE*)protocol_desc, static_cast<DWORD>((wcslen(protocol_desc) + 1) * sizeof(wchar_t)));
    const wchar_t* protocol_val = L"";
    RegSetValueEx(hKey, L"URL Protocol", 0, REG_SZ, (BYTE*)protocol_val, sizeof(wchar_t));
    RegCloseKey(hKey);
  }

  std::wstring command_key_path = L"Software\\Classes\\yaabsa\\shell\\open\\command";
  if (RegCreateKeyEx(HKEY_CURRENT_USER, command_key_path.c_str(), 0, NULL, REG_OPTION_NON_VOLATILE, KEY_WRITE, NULL, &hKey, NULL) == ERROR_SUCCESS) {
    std::wstring command = L"\"" + std::wstring(exe_path) + L"\" \"%1\"";
    RegSetValueEx(hKey, NULL, 0, REG_SZ, (BYTE*)command.c_str(), static_cast<DWORD>((command.length() + 1) * sizeof(wchar_t)));
    RegCloseKey(hKey);
  }
}

// Hopefully should redirect the app link to the existing instance
bool SendAppLinkToInstance(const std::wstring& title) {
  HWND hwnd = ::FindWindow(L"FLUTTER_RUNNER_WIN32_WINDOW", title.c_str());
  if (hwnd) {
    SendAppLink(hwnd);
    ShowWindow(hwnd, SW_RESTORE);
    SetForegroundWindow(hwnd);
    return true;
  }
  return false;
}

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  RegisterUriScheme();

  if (SendAppLinkToInstance(L"yaabsa")) {
    return EXIT_SUCCESS;
  }

  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);
  if (!window.Create(L"yaabsa", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
