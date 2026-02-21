#ifndef FLUTTER_PLUGIN_NATIVE_PREVIEW_HOST_PLUGIN_IMPL_H_
#define FLUTTER_PLUGIN_NATIVE_PREVIEW_HOST_PLUGIN_IMPL_H_

#include <windows.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <map>
#include <memory>
#include <string>

namespace native_preview_host {

struct HostState {
  HWND host_window = nullptr;
  HWND attached_window = nullptr;
  HWND original_parent = nullptr;
  LONG_PTR original_style = 0;
  LONG_PTR original_ex_style = 0;
  RECT original_rect = {0, 0, 0, 0};
  int width = 0;
  int height = 0;
  bool visible = true;
};

class NativePreviewHostPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

  explicit NativePreviewHostPlugin(flutter::PluginRegistrarWindows* registrar);

  virtual ~NativePreviewHostPlugin();

  NativePreviewHostPlugin(const NativePreviewHostPlugin&) = delete;
  NativePreviewHostPlugin& operator=(const NativePreviewHostPlugin&) = delete;

 private:
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  flutter::PluginRegistrarWindows* registrar_ = nullptr;
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> channel_;
  HWND parent_hwnd_ = nullptr;
  std::map<std::string, HostState> hosts_;
};

}  // namespace native_preview_host

#endif  // FLUTTER_PLUGIN_NATIVE_PREVIEW_HOST_PLUGIN_IMPL_H_
