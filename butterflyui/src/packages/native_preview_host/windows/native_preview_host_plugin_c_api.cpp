#define FLUTTER_PLUGIN_IMPL
#include "include/native_preview_host/native_preview_host_plugin.h"

#include <flutter/plugin_registrar.h>
#include <flutter/plugin_registrar_windows.h>

#include "native_preview_host_plugin.h"

FLUTTER_PLUGIN_EXPORT void NativePreviewHostPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  auto plugin_registrar =
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar);
  native_preview_host::NativePreviewHostPlugin::RegisterWithRegistrar(
      plugin_registrar);
}

FLUTTER_PLUGIN_EXPORT void NativePreviewHostPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  NativePreviewHostPluginRegisterWithRegistrar(registrar);
}
