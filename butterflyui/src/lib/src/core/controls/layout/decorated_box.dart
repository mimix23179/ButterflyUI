import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildDecoratedBoxControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  Widget child = _resolveChild(props, rawChildren, buildChild);

  final padding = coercePadding(props['padding']);
  if (padding != null) {
    child = Padding(padding: padding, child: child);
  }

  final color = coerceColor(props['color'] ?? props['bgcolor']);
  final gradient = coerceGradient(props['gradient']);
  final image = coerceDecorationImage(props['image']);
  final shadow = coerceBoxShadow(props['shadow']);
  final borderColor = coerceColor(props['border_color']);
  final borderWidth = coerceDouble(props['border_width']) ?? 0.0;
  final radius = coerceDouble(props['radius'] ?? props['border_radius']);
  final shape = _parseShape(props['shape']) ?? BoxShape.rectangle;
  final clipBehavior = _parseClip(props['clip_behavior']) ?? Clip.none;

  final decoration = BoxDecoration(
    color: color,
    gradient: gradient,
    image: image,
    boxShadow: shadow,
    border: borderColor == null || borderWidth <= 0
        ? null
        : Border.all(color: borderColor, width: borderWidth),
    borderRadius: shape == BoxShape.circle || radius == null
        ? null
        : BorderRadius.circular(radius),
    shape: shape,
  );

  child = DecoratedBox(decoration: decoration, child: child);

  if (shape == BoxShape.circle) {
    child = ClipOval(clipBehavior: clipBehavior, child: child);
  } else if (clipBehavior != Clip.none) {
    child = ClipRRect(
      clipBehavior: clipBehavior,
      borderRadius: radius == null
          ? BorderRadius.zero
          : BorderRadius.circular(radius),
      child: child,
    );
  }

  final margin = coercePadding(props['margin']);
  if (margin != null) {
    child = Padding(padding: margin, child: child);
  }

  return child;
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

BoxShape? _parseShape(Object? value) {
  switch (value?.toString().toLowerCase()) {
    case 'circle':
      return BoxShape.circle;
    case 'rectangle':
    case 'rect':
      return BoxShape.rectangle;
  }
  return null;
}

Clip? _parseClip(Object? value) {
  switch (value?.toString().toLowerCase()) {
    case 'none':
      return Clip.none;
    case 'hardedge':
    case 'hard_edge':
      return Clip.hardEdge;
    case 'antialias':
    case 'anti_alias':
      return Clip.antiAlias;
    case 'antialiaswithsavelayer':
    case 'anti_alias_with_save_layer':
      return Clip.antiAliasWithSaveLayer;
  }
  return null;
}
