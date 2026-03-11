import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildStackControl(
  Map<String, Object?> props,
  List children,
  Widget Function(Map<String, Object?> child) buildFromControl,
) {
  final alignment = _parseAlignment(props['alignment']) ?? Alignment.topLeft;
  final fit = _parseStackFit(props['fit']) ?? StackFit.loose;
  final clip = props['clip'] == true ? Clip.hardEdge : Clip.none;

  return LayoutBuilder(
    builder: (context, constraints) {
      final size = constraints.biggest;
      final resolvedSize = _isFinite(size) ? size : null;
      final entries = <_StackEntry>[];
      var order = 0;
      for (final child in children) {
        if (child is Map) {
          final childMap = coerceObjectMap(child);
          final childProps = childMap['props'] is Map
              ? coerceObjectMap(childMap['props'] as Map)
              : <String, Object?>{};
          final frameFromChild = childMap['frame'];
          final frameFromProps = childProps['frame'];
          final frame = <String, Object?>{
            if (frameFromChild is Map) ...coerceObjectMap(frameFromChild),
            if (frameFromProps is Map) ...coerceObjectMap(frameFromProps),
            for (final key in const <String>[
              'position',
              'inset',
              'left',
              'top',
              'right',
              'bottom',
              'width',
              'height',
              'x',
              'y',
              'anchor',
              'alignment',
              'z',
              'z_index',
              'translate',
              'translate_x',
              'translate_y',
              'scale',
              'rotate',
              'rotation',
              'opacity',
            ])
              if (childProps[key] != null) key: childProps[key],
          };
          final z = _extractZ(childMap, childProps, frame);
          final built = _buildStackChild(
            childMap,
            frame,
            resolvedSize,
            buildFromControl,
          );
          entries.add(_StackEntry(z: z, order: order, child: built));
          order += 1;
        }
      }
      entries.sort((a, b) {
        final zCompare = a.z.compareTo(b.z);
        if (zCompare != 0) return zCompare;
        return a.order.compareTo(b.order);
      });
      return Stack(
        alignment: alignment,
        fit: fit,
        clipBehavior: clip,
        children: entries.map((entry) => entry.child).toList(),
      );
    },
  );
}

Widget _buildStackChild(
  Map<String, Object?> childMap,
  Map<String, Object?> frame,
  Size? parentSize,
  Widget Function(Map<String, Object?> child) buildFromControl,
) {
  final built = buildFromControl(childMap);
  final left = _resolveDimension(
    frame['left'] ?? frame['x'],
    parentSize,
    isWidth: true,
  );
  final top = _resolveDimension(
    frame['top'] ?? frame['y'],
    parentSize,
    isWidth: false,
  );
  final right = _resolveDimension(frame['right'], parentSize, isWidth: true);
  final bottom = _resolveDimension(frame['bottom'], parentSize, isWidth: false);
  final inset = frame['inset'];
  final insetAll = _resolveDimension(inset, parentSize, isWidth: true);
  var width = _resolveDimension(frame['width'], parentSize, isWidth: true);
  var height = _resolveDimension(frame['height'], parentSize, isWidth: false);
  final anchor = _parseAlignment(frame['anchor'] ?? frame['alignment']);
  final positionMode = frame['position']?.toString().trim().toLowerCase();
  final resolvedLeft = left ?? insetAll;
  final resolvedTop = top ?? insetAll;
  final resolvedRight = right ?? insetAll;
  final resolvedBottom = bottom ?? insetAll;
  final hasPosition =
      resolvedLeft != null ||
      resolvedTop != null ||
      resolvedRight != null ||
      resolvedBottom != null ||
      width != null ||
      height != null;
  final shouldPosition =
      positionMode == null ||
      positionMode.isEmpty ||
      positionMode == 'absolute' ||
      positionMode == 'positioned';
  if (!hasPosition) {
    return _applyStackTransforms(built, frame);
  }
  if (!shouldPosition) {
    return _applyStackTransforms(built, frame);
  }
  if (resolvedLeft != null && resolvedRight != null) {
    width = null;
  }
  if (resolvedTop != null && resolvedBottom != null) {
    height = null;
  }
  Widget child = _applyStackTransforms(built, frame);
  if (anchor != null) {
    child = FractionalTranslation(
      translation: _alignmentToFraction(anchor),
      child: child,
    );
  }
  return Positioned(
    left: resolvedLeft,
    top: resolvedTop,
    right: resolvedRight,
    bottom: resolvedBottom,
    width: width,
    height: height,
    child: child,
  );
}

Widget _applyStackTransforms(Widget child, Map<String, Object?> frame) {
  Widget current = child;
  final opacity = coerceDouble(frame['opacity']);
  final scale = _resolveScale(frame['scale']);
  final translate = _resolveTranslate(frame['translate']);
  final translateX = coerceDouble(frame['translate_x']) ?? translate?.dx ?? 0.0;
  final translateY = coerceDouble(frame['translate_y']) ?? translate?.dy ?? 0.0;
  final rotate =
      coerceDouble(frame['rotate'] ?? frame['rotation']) ?? 0.0;

  if (scale != null && scale != 1.0) {
    current = Transform.scale(scale: scale, child: current);
  }
  if (rotate != 0.0) {
    current = Transform.rotate(angle: rotate, child: current);
  }
  if (translateX != 0.0 || translateY != 0.0) {
    current = Transform.translate(
      offset: Offset(translateX, translateY),
      child: current,
    );
  }
  if (opacity != null && opacity < 1.0) {
    current = Opacity(opacity: opacity.clamp(0.0, 1.0), child: current);
  }
  return current;
}

double? _resolveScale(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is List && value.isNotEmpty) {
    return coerceDouble(value.first);
  }
  if (value is Map) {
    final map = coerceObjectMap(value);
    return coerceDouble(map['x'] ?? map['scale']);
  }
  return double.tryParse(value.toString());
}

Offset? _resolveTranslate(Object? value) {
  if (value == null) return null;
  if (value is List && value.length >= 2) {
    return Offset(coerceDouble(value[0]) ?? 0.0, coerceDouble(value[1]) ?? 0.0);
  }
  if (value is Map) {
    final map = coerceObjectMap(value);
    return Offset(
      coerceDouble(map['x'] ?? map['dx']) ?? 0.0,
      coerceDouble(map['y'] ?? map['dy']) ?? 0.0,
    );
  }
  return null;
}

double _extractZ(
  Map<String, Object?> childMap,
  Map<String, Object?> props,
  Map<String, Object?> frame,
) {
  final fromFrame = coerceDouble(frame['z'] ?? frame['z_index']);
  if (fromFrame != null) return fromFrame;
  final fromProps = coerceDouble(props['z'] ?? props['z_index']);
  if (fromProps != null) return fromProps;
  return coerceDouble(childMap['z'] ?? childMap['z_index']) ?? 0.0;
}

Offset _alignmentToFraction(Alignment alignment) {
  final dx = -(alignment.x + 1) / 2;
  final dy = -(alignment.y + 1) / 2;
  return Offset(dx, dy);
}

double? _resolveDimension(
  Object? value,
  Size? parentSize, {
  required bool isWidth,
}) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  final width = parentSize?.width;
  final height = parentSize?.height;
  final max = isWidth ? width : height;
  final raw = value.toString().trim().toLowerCase();
  if (raw.isEmpty) return null;
  if (raw.endsWith('%')) {
    final percent = double.tryParse(raw.substring(0, raw.length - 1));
    if (percent == null || max == null || !max.isFinite) return null;
    return max * percent / 100;
  }
  if (raw.endsWith('vw')) {
    final percent = double.tryParse(raw.substring(0, raw.length - 2));
    if (percent == null || width == null || !width.isFinite) return null;
    return width * percent / 100;
  }
  if (raw.endsWith('vh')) {
    final percent = double.tryParse(raw.substring(0, raw.length - 2));
    if (percent == null || height == null || !height.isFinite) return null;
    return height * percent / 100;
  }
  if (raw.endsWith('vmin')) {
    final percent = double.tryParse(raw.substring(0, raw.length - 4));
    if (percent == null || width == null || height == null) return null;
    final base = math.min(width, height);
    if (!base.isFinite) return null;
    return base * percent / 100;
  }
  if (raw.endsWith('vmax')) {
    final percent = double.tryParse(raw.substring(0, raw.length - 4));
    if (percent == null || width == null || height == null) return null;
    final base = math.max(width, height);
    if (!base.isFinite) return null;
    return base * percent / 100;
  }
  final cleaned = raw.endsWith('px') ? raw.substring(0, raw.length - 2) : raw;
  return double.tryParse(cleaned);
}

bool _isFinite(Size size) {
  return size.width.isFinite && size.height.isFinite;
}

Alignment? _parseAlignment(Object? value) {
  if (value == null) return null;
  if (value is List && value.length >= 2) {
    final x = coerceDouble(value[0]) ?? 0.0;
    final y = coerceDouble(value[1]) ?? 0.0;
    return Alignment(x, y);
  }
  if (value is Map) {
    final map = coerceObjectMap(value);
    final x = coerceDouble(map['x']);
    final y = coerceDouble(map['y']);
    if (x != null || y != null) {
      return Alignment(x ?? 0.0, y ?? 0.0);
    }
  }
  final s = value
      .toString()
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');
  switch (s) {
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
  }
  return null;
}

StackFit? _parseStackFit(Object? value) {
  final s = value?.toString().toLowerCase();
  switch (s) {
    case 'expand':
      return StackFit.expand;
    case 'passthrough':
      return StackFit.passthrough;
    case 'loose':
      return StackFit.loose;
  }
  return null;
}

class _StackEntry {
  final double z;
  final int order;
  final Widget child;

  const _StackEntry({
    required this.z,
    required this.order,
    required this.child,
  });
}
