//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <audioplayers_windows/audioplayers_windows_plugin.h>
#include <clipboard/clipboard_plugin.h>
#include <connectivity_plus/connectivity_plus_windows_plugin.h>
#include <desktop_multi_window/desktop_multi_window_plugin.h>
#include <dynamic_color/dynamic_color_plugin_c_api.h>
#include <fc_native_video_thumbnail/fc_native_video_thumbnail_plugin_c_api.h>
#include <file_selector_windows/file_selector_windows.h>
#include <flutter_secure_storage_windows/flutter_secure_storage_windows_plugin.h>
#include <flutter_timezone/flutter_timezone_plugin_c_api.h>
#include <flutter_tts/flutter_tts_plugin.h>
#include <flutter_webrtc/flutter_web_r_t_c_plugin.h>
#include <fvp/fvp_plugin_c_api.h>
#include <gal/gal_plugin_c_api.h>
#include <irondash_engine_context/irondash_engine_context_plugin_c_api.h>
#include <local_auth_windows/local_auth_plugin.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <rive_native/rive_native_plugin.h>
#include <sentry_flutter/sentry_flutter_plugin.h>
#include <share_plus/share_plus_windows_plugin_c_api.h>
#include <speech_to_text_windows/speech_to_text_windows.h>
#include <super_native_extensions/super_native_extensions_plugin_c_api.h>
#include <url_launcher_windows/url_launcher_windows.h>
#include <video_player_win/video_player_win_plugin_c_api.h>
#include <webcrypto/webcrypto_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  AudioplayersWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("AudioplayersWindowsPlugin"));
  ClipboardPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ClipboardPlugin"));
  ConnectivityPlusWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ConnectivityPlusWindowsPlugin"));
  DesktopMultiWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopMultiWindowPlugin"));
  DynamicColorPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DynamicColorPluginCApi"));
  FcNativeVideoThumbnailPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FcNativeVideoThumbnailPluginCApi"));
  FileSelectorWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FileSelectorWindows"));
  FlutterSecureStorageWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterSecureStorageWindowsPlugin"));
  FlutterTimezonePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterTimezonePluginCApi"));
  FlutterTtsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterTtsPlugin"));
  FlutterWebRTCPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterWebRTCPlugin"));
  FvpPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FvpPluginCApi"));
  GalPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("GalPluginCApi"));
  IrondashEngineContextPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("IrondashEngineContextPluginCApi"));
  LocalAuthPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("LocalAuthPlugin"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  RiveNativePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("RiveNativePlugin"));
  SentryFlutterPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SentryFlutterPlugin"));
  SharePlusWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SharePlusWindowsPluginCApi"));
  SpeechToTextWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SpeechToTextWindows"));
  SuperNativeExtensionsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SuperNativeExtensionsPluginCApi"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
  VideoPlayerWinPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("VideoPlayerWinPluginCApi"));
  WebcryptoPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WebcryptoPlugin"));
}
