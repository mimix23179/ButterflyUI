import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_shells/runtime_props_control.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildTransitionControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild, {
  String controlId = '',
  ButterflyUIRegisterInvokeHandler? registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler? unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent? sendEvent,
}) {
  return buildRuntimePropsControl(
    props: props,
    controlId: controlId,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
    builder: (liveProps) {
      final enabled = liveProps['enabled'] == null
          ? true
          : (liveProps['enabled'] == true);
      final child = _resolveChild(liveProps, rawChildren, buildChild);
      if (!enabled) return child;

      final durationMs = (coerceOptionalInt(liveProps['duration_ms']) ?? 220)
          .clamp(1, 600000);
      final curve = _parseCurve(liveProps['curve']) ?? Curves.easeOutCubic;
      final rawType =
          (liveProps['transition_type'] ??
                  liveProps['transition'] ??
                  liveProps['preset'])
              ?.toString()
              .toLowerCase();
      final transitionType = (rawType == null || rawType.isEmpty)
          ? 'fade'
          : rawType;
      final stateKey =
          liveProps['state']?.toString() ??
          liveProps['value']?.toString() ??
          transitionType;

      return AnimatedSwitcher(
        duration: Duration(milliseconds: durationMs),
        switchInCurve: curve,
        switchOutCurve: curve,
        transitionBuilder: (child, animation) {
          switch (transitionType) {
            case 'scale':
              return ScaleTransition(scale: animation, child: child);
            case 'slide':
            case 'slide_and_fade':
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.08, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              );
            default:
              return FadeTransition(opacity: animation, child: child);
          }
        },
        child: KeyedSubtree(key: ValueKey<String>(stateKey), child: child),
      );
    },
  );
}

Widget _resolveChild(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  for (final raw in rawChildren) {
    if (raw is Map) {
      return buildChild(coerceObjectMap(raw));
    }
  }
  final propChild = props['child'];
  if (propChild is Map) {
    return buildChild(coerceObjectMap(propChild));
  }
  return const SizedBox.shrink();
}

Curve? _parseCurve(Object? value) {
  final s = value?.toString().toLowerCase().replaceAll('-', '_');
  switch (s) {
    case 'linear':
      return Curves.linear;
    case 'ease_in':
    case 'easein':
      return Curves.easeIn;
    case 'ease_out':
    case 'easeout':
      return Curves.easeOut;
    case 'ease_in_out':
    case 'easeinout':
      return Curves.easeInOut;
    case 'fast_out_slow_in':
    case 'fastoutslowin':
      return Curves.fastOutSlowIn;
    case 'ease_out_cubic':
    case 'easeoutcubic':
      return Curves.easeOutCubic;
  }
  return null;
}
