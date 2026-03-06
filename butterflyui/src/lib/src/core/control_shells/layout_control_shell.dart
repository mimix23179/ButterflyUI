import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

List<Map<String, Object?>> resolveControlChildMaps(
  List<dynamic> rawChildren,
  Map<String, Object?> props,
) {
  final sourceChildren = rawChildren.isEmpty && props['children'] is List
      ? props['children'] as List
      : rawChildren;
  return sourceChildren
      .whereType<Map>()
      .map((child) => coerceObjectMap(child))
      .toList();
}

Map<String, Object?>? firstControlChildMap(
  List<dynamic> rawChildren, {
  Map<String, Object?>? props,
}) {
  for (final child in rawChildren) {
    if (child is Map) {
      return coerceObjectMap(child);
    }
  }
  final propChild = props == null ? null : props['child'];
  if (propChild is Map) {
    return coerceObjectMap(propChild);
  }
  return null;
}

List<Widget> buildSpacedChildren(
  List<Widget> items,
  Axis axis,
  double spacing,
) {
  if (spacing <= 0 || items.length < 2) return items;
  final out = <Widget>[];
  for (var index = 0; index < items.length; index += 1) {
    if (index > 0) {
      out.add(
        axis == Axis.horizontal
            ? SizedBox(width: spacing)
            : SizedBox(height: spacing),
      );
    }
    out.add(items[index]);
  }
  return out;
}

List<Widget> buildFlexChildren({
  required List<dynamic> rawChildren,
  required Axis axis,
  required double spacing,
  required MainAxisSize parentMainAxisSize,
  required Widget Function(Map<String, Object?> child) buildChild,
}) {
  final built = <Widget>[];
  for (final child in rawChildren) {
    if (child is! Map) continue;
    final childMap = coerceObjectMap(child);
    final childType = childMap['type']?.toString() ?? '';
    if (childType == 'expanded') {
      final expandedProps = childMap['props'] is Map
          ? coerceObjectMap(childMap['props'] as Map)
          : <String, Object?>{};
      final flex = coerceOptionalInt(expandedProps['flex']) ?? 1;
      final fit = parseLayoutFlexFit(expandedProps['fit']) ?? FlexFit.tight;
      final innerChild = firstControlChildMap(
        childMap['children'] as List? ?? const <dynamic>[],
      );
      Widget widget = innerChild == null
          ? const SizedBox.shrink()
          : buildChild(innerChild);
      if (fit == FlexFit.loose) {
        widget = Flexible(flex: flex, fit: fit, child: widget);
      } else {
        widget = Expanded(flex: flex, child: widget);
      }
      built.add(widget);
      continue;
    }

    Widget widget = buildChild(childMap);
    final childProps = childMap['props'] is Map
        ? coerceObjectMap(childMap['props'] as Map)
        : <String, Object?>{};
    final flex =
        coerceOptionalInt(childProps['flex']) ??
        (childProps['expand'] == true ? 1 : null);
    if (flex != null && flex > 0) {
      if (parentMainAxisSize == MainAxisSize.min) {
        widget = Flexible(flex: flex, fit: FlexFit.loose, child: widget);
      } else {
        widget = Expanded(flex: flex, child: widget);
      }
    }
    built.add(widget);
  }
  return buildSpacedChildren(built, axis, spacing);
}

Axis? parseLayoutAxis(Object? value) {
  final s = value?.toString().toLowerCase();
  switch (s) {
    case 'horizontal':
    case 'row':
    case 'x':
      return Axis.horizontal;
    case 'vertical':
    case 'column':
    case 'y':
      return Axis.vertical;
  }
  return null;
}

Clip? parseLayoutClip(Object? value) {
  final s = value?.toString().toLowerCase();
  switch (s) {
    case 'hardedge':
    case 'hard_edge':
      return Clip.hardEdge;
    case 'antialias':
    case 'anti_alias':
      return Clip.antiAlias;
    case 'antialiaswithsavelayer':
    case 'anti_alias_with_save_layer':
      return Clip.antiAliasWithSaveLayer;
    case 'none':
      return Clip.none;
  }
  return null;
}

Alignment? parseLayoutAlignment(Object? value) {
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

MainAxisAlignment parseLayoutMainAxisAlignment(
  Object? value,
  MainAxisAlignment fallback,
) {
  final s = value?.toString().toLowerCase();
  switch (s) {
    case 'start':
    case 'top':
    case 'left':
      return MainAxisAlignment.start;
    case 'center':
      return MainAxisAlignment.center;
    case 'end':
    case 'bottom':
    case 'right':
      return MainAxisAlignment.end;
    case 'spacebetween':
    case 'space_between':
      return MainAxisAlignment.spaceBetween;
    case 'spacearound':
    case 'space_around':
      return MainAxisAlignment.spaceAround;
    case 'spaceevenly':
    case 'space_evenly':
      return MainAxisAlignment.spaceEvenly;
  }
  return fallback;
}

CrossAxisAlignment parseLayoutCrossAxisAlignment(
  Object? value,
  CrossAxisAlignment fallback, {
  required Axis axis,
}) {
  final s = value?.toString().toLowerCase();
  switch (s) {
    case 'start':
      return CrossAxisAlignment.start;
    case 'center':
      return CrossAxisAlignment.center;
    case 'end':
      return CrossAxisAlignment.end;
    case 'stretch':
      return CrossAxisAlignment.stretch;
    case 'baseline':
      return axis == Axis.vertical
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.baseline;
  }
  return fallback;
}

MainAxisSize parseLayoutMainAxisSize(Object? value) {
  final s = value?.toString().toLowerCase();
  return s == 'min' ? MainAxisSize.min : MainAxisSize.max;
}

FlexFit? parseLayoutFlexFit(Object? value) {
  final s = value?.toString().toLowerCase();
  switch (s) {
    case 'loose':
      return FlexFit.loose;
    case 'tight':
      return FlexFit.tight;
  }
  return null;
}

WrapAlignment? parseLayoutWrapAlignment(Object? value) {
  final s = value?.toString().toLowerCase();
  switch (s) {
    case 'start':
      return WrapAlignment.start;
    case 'center':
      return WrapAlignment.center;
    case 'end':
      return WrapAlignment.end;
    case 'spacebetween':
    case 'space_between':
      return WrapAlignment.spaceBetween;
    case 'spacearound':
    case 'space_around':
      return WrapAlignment.spaceAround;
    case 'spaceevenly':
    case 'space_evenly':
      return WrapAlignment.spaceEvenly;
  }
  return null;
}

WrapCrossAlignment? parseLayoutWrapCrossAlignment(Object? value) {
  final s = value?.toString().toLowerCase();
  switch (s) {
    case 'start':
      return WrapCrossAlignment.start;
    case 'center':
      return WrapCrossAlignment.center;
    case 'end':
      return WrapCrossAlignment.end;
  }
  return null;
}

BoxConstraints? buildLayoutConstraints({
  double? minWidth,
  double? minHeight,
  double? maxWidth,
  double? maxHeight,
}) {
  if (minWidth == null &&
      minHeight == null &&
      maxWidth == null &&
      maxHeight == null) {
    return null;
  }
  return BoxConstraints(
    minWidth: minWidth ?? 0.0,
    minHeight: minHeight ?? 0.0,
    maxWidth: maxWidth ?? double.infinity,
    maxHeight: maxHeight ?? double.infinity,
  );
}
