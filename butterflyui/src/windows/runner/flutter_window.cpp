#include "flutter_window.h"

#include <optional>
#include <string>

#include "flutter/generated_plugin_registrant.h"

namespace {

bool EncodableAsBool(const flutter::EncodableValue* value,
                     bool fallback = false) {
  if (!value) {
    return fallback;
  }
  if (const auto bool_value = std::get_if<bool>(value)) {
    return *bool_value;
  }
  if (const auto int_value = std::get_if<int32_t>(value)) {
    return *int_value != 0;
  }
  if (const auto int64_value = std::get_if<int64_t>(value)) {
    return *int64_value != 0;
  }
  if (const auto string_value = std::get_if<std::string>(value)) {
    const std::string lowered = *string_value;
    return lowered == "1" || lowered == "true" || lowered == "yes" ||
           lowered == "on";
  }
  return fallback;
}

std::string EncodableAsString(const flutter::EncodableValue* value) {
  if (!value) {
    return "";
  }
  if (const auto string_value = std::get_if<std::string>(value)) {
    return *string_value;
  }
  return "";
}

const flutter::EncodableValue* FindArg(const flutter::MethodCall<
                                       flutter::EncodableValue>& call,
                                       const char* key) {
  const auto* args = call.arguments();
  if (!args) {
    return nullptr;
  }
  const auto* map = std::get_if<flutter::EncodableMap>(args);
  if (!map) {
    return nullptr;
  }
  const auto found = map->find(flutter::EncodableValue(key));
  if (found == map->end()) {
    return nullptr;
  }
  return &found->second;
}

}  // namespace

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  RegisterWindowChannel();
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  if (window_channel_) {
    window_channel_ = nullptr;
  }
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}

void FlutterWindow::RegisterWindowChannel() {
  if (!flutter_controller_ || !flutter_controller_->engine()) {
    return;
  }

  window_channel_ =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          flutter_controller_->engine()->messenger(), "conduit/window",
          &flutter::StandardMethodCodec::GetInstance());

  window_channel_->SetMethodCallHandler(
      [this](const flutter::MethodCall<flutter::EncodableValue>& call,
             std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>>
                 result) {
        const std::string method = call.method_name();

        if (method == "setCustomFrame") {
          const bool enabled =
              EncodableAsBool(FindArg(call, "enabled"), false);
          SetCustomFrame(enabled);
          result->Success(flutter::EncodableValue(true));
          return;
        }

        if (method == "windowAction") {
          std::string action = EncodableAsString(FindArg(call, "action"));
          if (action == "minimize") {
            Minimize();
          } else if (action == "maximize") {
            Maximize();
          } else if (action == "restore") {
            Restore();
          } else if (action == "toggle_maximize" || action == "toggle-maximize" ||
                     action == "toggle") {
            ToggleMaximize();
          } else if (action == "close") {
            Close();
          } else if (action == "drag" || action == "start_drag" ||
                     action == "start-drag") {
            StartDrag();
          }
          result->Success(flutter::EncodableValue(true));
          return;
        }

        if (method == "startDrag") {
          StartDrag();
          result->Success(flutter::EncodableValue(true));
          return;
        }

        if (method == "isMaximized") {
          result->Success(flutter::EncodableValue(IsMaximized()));
          return;
        }

        result->NotImplemented();
      });
}
