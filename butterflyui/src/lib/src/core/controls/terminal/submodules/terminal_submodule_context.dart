import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

/// Context object passed to every Terminal submodule widget builder.
///
/// Carries the resolved section props for the active module plus shared
/// callbacks and helpers used by view renderers, input widgets, and
/// provider widgets.
class TerminalSubmoduleContext {
  const TerminalSubmoduleContext({
    required this.controlId,
    required this.module,
    required this.section,
    required this.runtimeProps,
    required this.activeSessionId,
    required this.fg,
    required this.bg,
    required this.sendEvent,
    required this.rawChildren,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
  });

  /// The control's unique runtime ID.
  final String controlId;

  /// Normalized name of the currently active module (e.g. `'workbench'`).
  final String module;

  /// Resolved props map for [module], already extracted via `_sectionProps`.
  final Map<String, Object?> section;

  /// Full live runtime-props for the terminal control.
  final Map<String, Object?> runtimeProps;

  /// The currently active session id.
  final String activeSessionId;

  /// Foreground colour derived from `text_color`.
  final Color fg;

  /// Background colour derived from `bgcolor`/`background`.
  final Color bg;

  /// Low-level send-event RPC (used by advanced submodules).
  final ButterflyUISendRuntimeEvent sendEvent;

  /// Raw child descriptors forwarded from the host widget.
  final List<dynamic> rawChildren;

  /// Builds a Flutter widget from a raw child descriptor map.
  final Widget Function(Map<String, Object?> child) buildChild;

  /// Registers an invoke handler for [controlId] RPCs.
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;

  /// Unregisters a previously registered invoke handler.
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;

  /// Convenience: look up a top-level key from [runtimeProps] as a string.
  String prop(String key, [String fallback = '']) =>
      (runtimeProps[key] ?? fallback).toString();

  /// Convenience: look up a key from [section] as a string.
  String sectionProp(String key, [String fallback = '']) =>
      (section[key] ?? fallback).toString();
}
