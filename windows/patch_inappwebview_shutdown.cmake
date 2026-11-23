function(yaabsa_patch_inappwebview_shutdown)
  set(target flutter_inappwebview_windows_plugin)
  if(NOT TARGET ${target})
    return()
  endif()

  get_target_property(plugin_dir ${target} SOURCE_DIR)
  file(STRINGS "${plugin_dir}/../pubspec.yaml" version REGEX "^version: 0\u005c\u005c.6\u005c\u005c.0$")
  if(NOT version)
    return()
  endif()

  set(manager in_app_webview/in_app_webview_manager.cpp)
  set(original "${plugin_dir}/${manager}")
  set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS "${original}")
  file(READ "${original}" source)

  set(constructor "    if (!rohelper_) {")
  set(destructor "    windowWebViews.clear();")
  if(NOT source MATCHES "InAppWebViewManager::~InAppWebViewManager"
      OR NOT source MATCHES "InAppWebViewManager::InAppWebViewManager"
      OR NOT source MATCHES "if \u005c\u005c(!rohelper_\u005c\u005c)"
      OR NOT source MATCHES "windowWebViews\u005c\u005c.clear\u005c\u005c(\u005c\u005c)")
    message(FATAL_ERROR "The WebView 0.6.0 shutdown patch no longer matches its source.")
  endif()

  string(REPLACE "  InAppWebViewManager::InAppWebViewManager(" [=[
  namespace {
    size_t live_webview_managers = 0;
  }

  InAppWebViewManager::InAppWebViewManager(]=] source "${source}")
  string(REPLACE "${constructor}" [=[
    ++live_webview_managers;
    if (!rohelper_) {]=] source "${source}")
  string(REPLACE "${destructor}" [=[
    windowWebViews.clear();
    if (--live_webview_managers == 0) {
      compositor_ = nullptr;
      graphics_context_.reset();
      dispatcher_queue_controller_ = nullptr;
      rohelper_.reset();
      valid_ = false;
    }]=] source "${source}")

  set(patched "${CMAKE_CURRENT_BINARY_DIR}/yaabsa_webview_manager.cpp")
  if(EXISTS "${patched}")
    file(READ "${patched}" previous_source)
  endif()
  if(NOT source STREQUAL previous_source)
    file(WRITE "${patched}" "${source}")
  endif()
  get_target_property(sources ${target} SOURCES)
  list(REMOVE_ITEM sources "${manager}")
  set_property(TARGET ${target} PROPERTY SOURCES "${sources}")
  target_sources(${target} PRIVATE "${patched}")
  target_include_directories(${target} PRIVATE "${plugin_dir}/in_app_webview")
endfunction()

yaabsa_patch_inappwebview_shutdown()
