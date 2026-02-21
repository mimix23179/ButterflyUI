import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildPortalControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  Map<String, Object?>? baseMap;
  Map<String, Object?>? portalMap;

  if (props['child'] is Map) {
    baseMap = coerceObjectMap(props['child'] as Map);
  } else if (rawChildren.isNotEmpty && rawChildren.first is Map) {
    baseMap = coerceObjectMap(rawChildren.first as Map);
  }

  if (props['portal'] is Map) {
    portalMap = coerceObjectMap(props['portal'] as Map);
  } else if (props['overlay'] is Map) {
    portalMap = coerceObjectMap(props['overlay'] as Map);
  } else if (rawChildren.length > 1 && rawChildren[1] is Map) {
    portalMap = coerceObjectMap(rawChildren[1] as Map);
  }

  final open = props['open'] == null ? true : (props['open'] == true);
  final dismissible = props['dismissible'] == true;
  final passThrough = props['passthrough'] == true;
  final scrimColor = coerceColor(props['scrim_color']);
  final alignment = _coerceAlignment(props['alignment']) ?? Alignment.center;
  final offset = _coerceOffset(props['offset']) ?? Offset.zero;
  final clip = props['clip'] == true ? Clip.antiAlias : Clip.none;

  final base = baseMap == null ? const SizedBox.shrink() : buildChild(baseMap);
  final portalChild = portalMap == null
      ? const SizedBox.shrink()
      : Align(
          alignment: alignment,
          child: Transform.translate(
            offset: offset,
            child: buildChild(portalMap),
          ),
        );

  return Stack(
    clipBehavior: clip,
    fit: StackFit.expand,
    children: <Widget>[
      base,
      if (open && dismissible)
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (controlId.isEmpty) return;
              sendEvent(controlId, 'dismiss', const <String, Object?>{});
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: scrimColor ?? Colors.transparent,
              ),
            ),
          ),
        ),
      if (open)
        Positioned.fill(
          child: IgnorePointer(ignoring: passThrough, child: portalChild),
        ),
    ],
  );
}

Alignment? _coerceAlignment(Object? value) {
  if (value == null) return null;
  if (value is List && value.length >= 2) {
    final x = coerceDouble(value[0]) ?? 0.0;
    final y = coerceDouble(value[1]) ?? 0.0;
    return Alignment(x, y);
  }
  if (value is Map) {
    final map = coerceObjectMap(value);
    final x = coerceDouble(map['x']) ?? 0.0;
    final y = coerceDouble(map['y']) ?? 0.0;
    return Alignment(x, y);
  }
  switch (value.toString().toLowerCase().replaceAll('-', '_')) {
    case 'center':
      return Alignment.center;
    case 'top':
    case 'top_center':
      return Alignment.topCenter;
    case 'bottom':
    case 'bottom_center':
      return Alignment.bottomCenter;
    case 'left':
    case 'center_left':
    case 'start':
      return Alignment.centerLeft;
    case 'right':
    case 'center_right':
    case 'end':
      return Alignment.centerRight;
    case 'top_left':
      return Alignment.topLeft;
    case 'top_right':
      return Alignment.topRight;
    case 'bottom_left':
      return Alignment.bottomLeft;
    case 'bottom_right':
      return Alignment.bottomRight;
    default:
      return null;
  }
}

Offset? _coerceOffset(Object? value) {
  if (value is List && value.length >= 2) {
    final x = coerceDouble(value[0]) ?? 0.0;
    final y = coerceDouble(value[1]) ?? 0.0;
    return Offset(x, y);
  }
  if (value is Map) {
    final map = coerceObjectMap(value);
    final x = coerceDouble(map['x']) ?? 0.0;
    final y = coerceDouble(map['y']) ?? 0.0;
    return Offset(x, y);
  }
  return null;
}
