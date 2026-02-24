import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildAnimationControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  if (props['enabled'] == false) {
    return _resolveChild(props, rawChildren, buildChild);
  }

  final child = _resolveChild(props, rawChildren, buildChild);
  final durationMs = (coerceOptionalInt(props['duration_ms']) ?? 220).clamp(
    1,
    600000,
  );
  final curve = _parseCurve(props['curve']) ?? Curves.easeOutCubic;
  final targetOpacity = (coerceDouble(props['opacity']) ?? 1.0).clamp(0.0, 1.0);
  final targetScale = (coerceDouble(props['scale']) ?? 1.0).clamp(0.001, 10.0);
  final targetOffset = _parseOffset(props['offset']);
  final targetRotation = (coerceDouble(props['rotation']) ?? 0.0) *
      (math.pi / 180.0);

  return TweenAnimationBuilder<double>(
    tween: Tween(begin: 0.0, end: 1.0),
    duration: Duration(milliseconds: durationMs),
    curve: curve,
    child: child,
    builder: (context, t, builtChild) {
      Widget out = builtChild ?? const SizedBox.shrink();
      if (targetOffset != null) {
        out = Transform.translate(
          offset: Offset(targetOffset.dx * t, targetOffset.dy * t),
          child: out,
        );
      }
      if (targetRotation != 0) {
        out = Transform.rotate(angle: targetRotation * t, child: out);
      }
      if (targetScale != 1.0) {
        out = Transform.scale(
          scale: 1.0 + ((targetScale - 1.0) * t),
          child: out,
        );
      }
      if (targetOpacity != 1.0) {
        out = Opacity(opacity: (1.0 + ((targetOpacity - 1.0) * t)), child: out);
      }
      return out;
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

Offset? _parseOffset(Object? value) {
  if (value is List && value.length >= 2) {
    return Offset(coerceDouble(value[0]) ?? 0.0, coerceDouble(value[1]) ?? 0.0);
  }
  if (value is Map) {
    final map = coerceObjectMap(value);
    return Offset(coerceDouble(map['x']) ?? 0.0, coerceDouble(map['y']) ?? 0.0);
  }
  return null;
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
