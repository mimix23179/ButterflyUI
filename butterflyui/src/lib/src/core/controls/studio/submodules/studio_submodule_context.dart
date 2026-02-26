library studio_submodule_context;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

/// Context object passed to every Studio submodule widget builder.
///
/// Carries the resolved section props for the active module plus the shared
/// callbacks and helpers used by surface renderers, panel widgets, and tool
/// sections alike.
class StudioSubmoduleContext {
  const StudioSubmoduleContext({
    required this.controlId,
    required this.module,
    required this.section,
    required this.runtimeProps,
    required this.activeSurface,
    required this.selectedIds,
    required this.zoom,
    required this.onEmit,
    required this.onSelectEntity,
    required this.sendEvent,
    required this.rawChildren,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
  });

  /// The host control's identifier.
  final String controlId;

  /// The module name this context was created for (e.g. `'canvas'`,
  /// `'inspector'`, `'selection_tools'`).
  final String module;

  /// The resolved section props for this module.
  final Map<String, Object?> section;

  /// Full runtime props of the Studio host — useful for cross-module reads
  /// (e.g. a panel reading the active selection state).
  final Map<String, Object?> runtimeProps;

  /// The currently active surface module token (e.g. `'canvas'`,
  /// `'timeline_surface'`).
  final String activeSurface;

  /// Currently selected entity / clip / node IDs on the active surface.
  final Set<String> selectedIds;

  /// Canvas zoom level (used by the canvas surface renderer).
  final double zoom;

  /// Pre-bound emit helper that fires an event with the module name
  /// and any additional payload keys.
  final void Function(String event, Map<String, Object?> payload) onEmit;

  /// Callback invoked when the user taps an entity on a surface.
  ///
  /// [id] is the entity identifier; [additive] controls multi-select.
  final void Function(String id, {bool additive}) onSelectEntity;

  /// Raw runtime event sender (for builders that need full control).
  final ButterflyUISendRuntimeEvent sendEvent;

  /// Raw child descriptors from the host's slot.
  final List<dynamic> rawChildren;

  /// Builder that renders a raw child descriptor into a [Widget].
  final Widget Function(Map<String, Object?> child) buildChild;

  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
}
