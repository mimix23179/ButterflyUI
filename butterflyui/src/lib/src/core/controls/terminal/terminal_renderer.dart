import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/controls/terminal/terminal_host.dart';
import 'package:butterflyui_runtime/src/core/controls/terminal/terminal_registry.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget? buildTerminalAliasedControl({
  required String type,
  required String controlId,
  required Map<String, Object?> props,
  required List<dynamic> rawChildren,
  required Widget Function(Map<String, Object?> child) buildChild,
  required ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  required ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  required ButterflyUISendRuntimeEvent sendEvent,
}) {
  final module = terminalModuleFromControlType(type);
  if (module == null) return null;
  return buildTerminalControl(
    controlId,
    <String, Object?>{...props, 'module': module},
    rawChildren,
    buildChild,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}
