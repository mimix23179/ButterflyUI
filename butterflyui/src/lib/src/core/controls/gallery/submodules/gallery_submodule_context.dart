library gallery_submodule_context;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

/// Shared context passed to every Gallery per-category section builder.
class GallerySubmoduleContext {
  const GallerySubmoduleContext({
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
  });

  /// Host control identifier.
  final String controlId;

  /// Normalized module identifier (e.g. `'toolbar'`, `'item_tile'`).
  final String module;

  /// The section payload map for this module.
  final Map<String, Object?> section;

  /// Pre-bound emit callback that runs through gallery's event filter.
  /// Use this for gallery-specific events (select, filter_change, etc.).
  final void Function(String event, Map<String, Object?> payload) onEmit;

  /// Raw send-event handle — needed by external builders (search_bar,
  /// skeleton, empty_state) that take the raw callback directly.
  final ButterflyUISendRuntimeEvent sendEvent;

  /// Children passed to the host control, forwarded to builders that need
  /// them (e.g. grid_layout, item_preview).
  final List<dynamic> rawChildren;

  /// Builds a child control from a raw child map (used by grid_layout /
  /// item_preview).
  final Widget Function(Map<String, Object?> child) buildChild;

  /// Resolved corner radius for this section's container.
  final double radius;

  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
}
