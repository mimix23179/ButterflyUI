import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/candy/theme.dart';

Widget buildCardControl(Map<String, Object?> props, List children, CandyTokens tokens,
    Widget Function(Map<String, Object?> child) buildFromControl) {
  final childMap = _firstChildMap(children);
  Widget cardChild = childMap == null ? const SizedBox.shrink() : buildFromControl(childMap);
  final contentPadding = coercePadding(props['content_padding']);
  if (contentPadding != null) {
    cardChild = Padding(padding: contentPadding, child: cardChild);
  }
  final contentAlignment = _parseAlignment(props['content_alignment']);
  if (contentAlignment != null) {
    cardChild = Align(alignment: contentAlignment, child: cardChild);
  }
  final bgColor = coerceColor(props['bgcolor']) ?? tokens.color('surface');
  final borderColor = coerceColor(props['border_color']) ?? tokens.color('border');
  final borderWidth = coerceDouble(props['border_width']);
  final radius = coerceDouble(props['radius']) ?? tokens.number('card', 'radius') ?? tokens.number('radii', 'md');
  final elevation = coerceDouble(props['elevation']) ?? tokens.number('card', 'elevation') ?? 0.0;
  final shape = RoundedRectangleBorder(
    borderRadius: radius == null ? BorderRadius.zero : BorderRadius.circular(radius),
    side: borderColor == null ? BorderSide.none : BorderSide(color: borderColor, width: borderWidth ?? 1.0),
  );
  return Card(
    color: bgColor,
    elevation: elevation,
    margin: EdgeInsets.zero,
    shape: shape,
    child: cardChild,
  );
}

Map<String, Object?>? _firstChildMap(List children) {
  for (final child in children) {
    if (child is Map) {
      return coerceObjectMap(child);
    }
  }
  return null;
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
  final s = value.toString().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
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
