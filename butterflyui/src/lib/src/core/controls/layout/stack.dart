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
          final frame = frameFromChild is Map
              ? coerceObjectMap(frameFromChild)
              : (frameFromProps is Map
                    ? coerceObjectMap(frameFromProps)
                    : <String, Object?>{});
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
  var width = _resolveDimension(frame['width'], parentSize, isWidth: true);
  var height = _resolveDimension(frame['height'], parentSize, isWidth: false);
  final anchor = _parseAlignment(frame['anchor'] ?? frame['alignment']);
  final hasPosition =
      left != null ||
      top != null ||
      right != null ||
      bottom != null ||
      width != null ||
      height != null;
  if (!hasPosition) {
    return built;
  }
  if (left != null && right != null) {
    width = null;
  }
  if (top != null && bottom != null) {
    height = null;
  }
  Widget child = built;
  if (anchor != null) {
    child = FractionalTranslation(
      translation: _alignmentToFraction(anchor),
      child: child,
    );
  }
  return Positioned(
    left: left,
    top: top,
    right: right,
    bottom: bottom,
    width: width,
    height: height,
    child: child,
  );
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
