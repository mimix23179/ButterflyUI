#include "native_preview_host_plugin.h"

#include <flutter/standard_method_codec.h>

#include <optional>
#include <utility>

namespace native_preview_host {

namespace {

constexpr wchar_t kHostWindowClass[] = L"STATIC";

HWND CreateHostWindow(HWND parent) {
  if (!parent) {
    return nullptr;
  }
  return CreateWindowExW(
      0, kHostWindowClass, L"",
      WS_CHILD | WS_VISIBLE | WS_CLIPSIBLINGS | WS_CLIPCHILDREN, 0, 0, 1, 1,
      parent, nullptr, GetModuleHandle(nullptr), nullptr);
}

std::optional<std::string> GetString(const flutter::EncodableMap& map,
                                     const char* key) {
  const auto it = map.find(flutter::EncodableValue(key));
  if (it == map.end()) {
    return std::nullopt;
  }
  const auto* value = std::get_if<std::string>(&it->second);
  if (!value) {
    return std::nullopt;
  }
  return *value;
}

std::optional<int64_t> GetInt(const flutter::EncodableMap& map,
                              const char* key) {
  const auto it = map.find(flutter::EncodableValue(key));
  if (it == map.end()) {
    return std::nullopt;
  }
  if (const auto* value32 = std::get_if<int32_t>(&it->second)) {
    return static_cast<int64_t>(*value32);
  }
  if (const auto* value64 = std::get_if<int64_t>(&it->second)) {
    return *value64;
  }
  if (const auto* value_double = std::get_if<double>(&it->second)) {
    return static_cast<int64_t>(*value_double);
  }
  return std::nullopt;
}

std::optional<bool> GetBool(const flutter::EncodableMap& map,
                            const char* key) {
  const auto it = map.find(flutter::EncodableValue(key));
  if (it == map.end()) {
    return std::nullopt;
  }
  const auto* value = std::get_if<bool>(&it->second);
  if (!value) {
    return std::nullopt;
  }
  return *value;
}

struct EnumWindowData {
  DWORD pid = 0;
  HWND hwnd = nullptr;
};

BOOL CALLBACK EnumWindowsForPid(HWND hwnd, LPARAM lparam) {
  auto* data = reinterpret_cast<EnumWindowData*>(lparam);
  DWORD win_pid = 0;
  GetWindowThreadProcessId(hwnd, &win_pid);
  if (win_pid != data->pid) {
    return TRUE;
  }
  if (!IsWindowVisible(hwnd)) {
    return TRUE;
  }
  if (GetWindow(hwnd, GW_OWNER) != nullptr) {
    return TRUE;
  }
  data->hwnd = hwnd;
  return FALSE;
}

HWND FindWindowForProcessId(DWORD pid) {
  EnumWindowData data{pid, nullptr};
  EnumWindows(EnumWindowsForPid, reinterpret_cast<LPARAM>(&data));
  return data.hwnd;
}

void DetachWindowFromHost(HostState& host) {
  if (!host.attached_window) {
    return;
  }
  SetParent(host.attached_window, host.original_parent);
  SetWindowLongPtr(host.attached_window, GWL_STYLE, host.original_style);
  SetWindowLongPtr(host.attached_window, GWL_EXSTYLE, host.original_ex_style);
  const int width = host.original_rect.right - host.original_rect.left;
  const int height = host.original_rect.bottom - host.original_rect.top;
  SetWindowPos(host.attached_window, nullptr, host.original_rect.left,
               host.original_rect.top, width, height,
               SWP_NOZORDER | SWP_FRAMECHANGED);
  ShowWindow(host.attached_window, SW_SHOW);
  host.attached_window = nullptr;
}

bool AttachWindowToHost(HostState& host, HWND target) {
  if (!target || !IsWindow(target)) {
    return false;
  }
  if (host.attached_window == target) {
    return true;
  }
  if (host.attached_window) {
    DetachWindowFromHost(host);
  }
  host.original_parent = GetParent(target);
  host.original_style = GetWindowLongPtr(target, GWL_STYLE);
  host.original_ex_style = GetWindowLongPtr(target, GWL_EXSTYLE);
  GetWindowRect(target, &host.original_rect);

  SetParent(target, host.host_window);
  LONG_PTR style = host.original_style;
  style &= ~(WS_POPUP | WS_CAPTION | WS_THICKFRAME | WS_BORDER | WS_SYSMENU |
             WS_MINIMIZEBOX | WS_MAXIMIZEBOX);
  style |= WS_CHILD;
  SetWindowLongPtr(target, GWL_STYLE, style);
  SetWindowLongPtr(target, GWL_EXSTYLE, host.original_ex_style);

  const int width = host.width > 0 ? host.width : 1;
  const int height = host.height > 0 ? host.height : 1;
  SetWindowPos(target, nullptr, 0, 0, width, height,
               SWP_NOZORDER | SWP_FRAMECHANGED);
  ShowWindow(target, host.visible ? SW_SHOW : SW_HIDE);
  host.attached_window = target;
  return true;
}

}  // namespace

// static
void NativePreviewHostPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows* registrar) {
  auto plugin = std::make_unique<NativePreviewHostPlugin>(registrar);

  registrar->AddPlugin(std::move(plugin));
}

NativePreviewHostPlugin::NativePreviewHostPlugin(
    flutter::PluginRegistrarWindows* registrar)
    : registrar_(registrar) {
  auto* view = registrar_->GetView();
  parent_hwnd_ = view ? view->GetNativeWindow() : nullptr;

  channel_ = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      registrar_->messenger(), "conduit/native_preview_host",
      &flutter::StandardMethodCodec::GetInstance());

  channel_->SetMethodCallHandler(
      [this](const auto& call, auto result) {
        HandleMethodCall(call, std::move(result));
      });
}

NativePreviewHostPlugin::~NativePreviewHostPlugin() {
  for (auto& entry : hosts_) {
    DetachWindowFromHost(entry.second);
    if (entry.second.host_window) {
      DestroyWindow(entry.second.host_window);
    }
  }
  hosts_.clear();
}

void NativePreviewHostPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  const auto* args =
      std::get_if<flutter::EncodableMap>(method_call.arguments());
  if (!args) {
    result->Error("bad_args", "Expected map arguments.");
    return;
  }
  const auto host_id = GetString(*args, "host_id");
  if (!host_id || host_id->empty()) {
    result->Error("bad_args", "host_id is required.");
    return;
  }

  if (method_call.method_name() == "createHost") {
    auto& host = hosts_[*host_id];
    if (!host.host_window) {
      host.host_window = CreateHostWindow(parent_hwnd_);
    }
    if (!host.host_window) {
      result->Error("create_failed", "Failed to create host window.");
      return;
    }
    result->Success(flutter::EncodableValue(true));
    return;
  }

  if (method_call.method_name() == "destroyHost") {
    const auto it = hosts_.find(*host_id);
    if (it == hosts_.end()) {
      result->Success(flutter::EncodableValue(true));
      return;
    }
    DetachWindowFromHost(it->second);
    if (it->second.host_window) {
      DestroyWindow(it->second.host_window);
    }
    hosts_.erase(it);
    result->Success(flutter::EncodableValue(true));
    return;
  }

  const auto it = hosts_.find(*host_id);
  if (it == hosts_.end()) {
    result->Error("missing_host", "Host not found.");
    return;
  }
  auto& host = it->second;

  if (method_call.method_name() == "updateRect") {
    const auto x = GetInt(*args, "x").value_or(0);
    const auto y = GetInt(*args, "y").value_or(0);
    const auto width = GetInt(*args, "width").value_or(0);
    const auto height = GetInt(*args, "height").value_or(0);

    if (!host.host_window || !parent_hwnd_) {
      result->Success(flutter::EncodableValue(false));
      return;
    }
    POINT point{static_cast<LONG>(x), static_cast<LONG>(y)};
    ScreenToClient(parent_hwnd_, &point);
    SetWindowPos(host.host_window, nullptr, point.x, point.y,
                 static_cast<int>(width), static_cast<int>(height),
                 SWP_NOZORDER | SWP_NOACTIVATE);
    host.width = static_cast<int>(width);
    host.height = static_cast<int>(height);
    if (host.attached_window) {
      SetWindowPos(host.attached_window, nullptr, 0, 0, host.width, host.height,
                   SWP_NOZORDER | SWP_NOACTIVATE);
    }
    ShowWindow(host.host_window, host.visible ? SW_SHOW : SW_HIDE);
    result->Success(flutter::EncodableValue(true));
    return;
  }

  if (method_call.method_name() == "setVisible") {
    const auto visible = GetBool(*args, "visible").value_or(true);
    host.visible = visible;
    if (host.host_window) {
      ShowWindow(host.host_window, visible ? SW_SHOW : SW_HIDE);
    }
    if (host.attached_window) {
      ShowWindow(host.attached_window, visible ? SW_SHOW : SW_HIDE);
    }
    result->Success(flutter::EncodableValue(true));
    return;
  }

  if (method_call.method_name() == "attachWindow") {
    HWND target = nullptr;
    if (const auto handle = GetInt(*args, "window_handle")) {
      target = reinterpret_cast<HWND>(static_cast<intptr_t>(*handle));
    } else if (const auto pid = GetInt(*args, "process_id")) {
      target = FindWindowForProcessId(static_cast<DWORD>(*pid));
    }

    if (!host.host_window) {
      host.host_window = CreateHostWindow(parent_hwnd_);
    }
    if (!host.host_window || !target) {
      result->Success(flutter::EncodableValue(false));
      return;
    }
    const bool attached = AttachWindowToHost(host, target);
    result->Success(flutter::EncodableValue(attached));
    return;
  }

  if (method_call.method_name() == "detachWindow") {
    DetachWindowFromHost(host);
    result->Success(flutter::EncodableValue(true));
    return;
  }

  result->NotImplemented();
}

}  // namespace native_preview_host
