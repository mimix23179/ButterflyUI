import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildFittedBoxControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  final child = _resolveChild(props, rawChildren, buildChild);
  final fit = _parseFit(props['fit']) ?? BoxFit.contain;
  final alignment = _parseAlignment(props['alignment']) ?? Alignment.center;
  final clipBehavior = _parseClip(props['clip_behavior']) ?? Clip.none;
  return FittedBox(
    fit: fit,
    alignment: alignment,
    clipBehavior: clipBehavior,
    child: child,
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

BoxFit? _parseFit(Object? value) {
  switch (value?.toString().toLowerCase()) {
    case 'fill':
      return BoxFit.fill;
    case 'contain':
      return BoxFit.contain;
    case 'cover':
      return BoxFit.cover;
    case 'fitwidth':
    case 'fit_width':
      return BoxFit.fitWidth;
    case 'fitheight':
    case 'fit_height':
      return BoxFit.fitHeight;
    case 'none':
      return BoxFit.none;
    case 'scaledown':
    case 'scale_down':
      return BoxFit.scaleDown;
  }
  return null;
}

AlignmentGeometry? _parseAlignment(Object? value) {
  if (value == null) return null;
  if (value is List && value.length >= 2) {
    return Alignment(
      coerceDouble(value[0]) ?? 0.0,
      coerceDouble(value[1]) ?? 0.0,
    );
  }
  if (value is Map) {
    final map = coerceObjectMap(value);
    return Alignment(
      coerceDouble(map['x']) ?? 0.0,
      coerceDouble(map['y']) ?? 0.0,
    );
  }
  switch (value.toString().toLowerCase().replaceAll('-', '_')) {
    case 'center':
      return Alignment.center;
    case 'top_left':
      return Alignment.topLeft;
    case 'top_center':
    case 'top':
      return Alignment.topCenter;
    case 'top_right':
      return Alignment.topRight;
    case 'center_left':
    case 'left':
    case 'start':
      return Alignment.centerLeft;
    case 'center_right':
    case 'right':
    case 'end':
      return Alignment.centerRight;
    case 'bottom_left':
      return Alignment.bottomLeft;
    case 'bottom_center':
    case 'bottom':
      return Alignment.bottomCenter;
    case 'bottom_right':
      return Alignment.bottomRight;
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
