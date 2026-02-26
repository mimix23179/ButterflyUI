library skins_submodule_context;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

/// Context object passed to every Skins submodule widget builder.
class SkinsSubmoduleContext {
  const SkinsSubmoduleContext({
    required this.controlId,
    required this.module,
    required this.section,
    required this.onEmit,
    required this.sendEvent,
    required this.rawChildren,
    required this.buildChild,
    required this.radius,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    this.onSelectSkin,
  });

  /// The host control's identifier.
  final String controlId;

  /// The module name this context was created for (e.g. `'selector'`).
  final String module;

  /// The resolved section props for this module.
  final Map<String, Object?> section;

  /// Pre-bound emit helper that filters to configured events and
  /// attaches `schema_version`, `module`, and `state` automatically.
  final void Function(String event, Map<String, Object?> payload) onEmit;

  /// Raw runtime event sender (for external builders that need full control).
  final ButterflyUISendRuntimeEvent sendEvent;

  /// Raw child descriptors from the host's slot.
  final List<dynamic> rawChildren;

  /// Builder that renders a raw child descriptor into a [Widget].
  final Widget Function(Map<String, Object?> child) buildChild;

  /// Resolved corner radius for this section.
  final double radius;

  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;

  /// Optional callback invoked when the user selects a skin by name.
  final ValueChanged<String>? onSelectSkin;
}
