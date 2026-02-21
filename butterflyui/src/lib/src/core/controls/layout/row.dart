import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/candy/theme.dart';

Widget buildRowControl(
  Map<String, Object?> props,
  List children,
  CandyTokens tokens,
  Widget Function(Map<String, Object?> child) buildFromControl,
) {
  final sourceChildren = children.isEmpty && props['children'] is List
      ? props['children'] as List
      : children;
  final spacing =
      coerceDouble(props['spacing'] ?? props['gap']) ??
      tokens.number('layout', 'row_spacing') ??
      tokens.number('spacing', 'sm') ??
      0.0;
  final mainAxis = _parseMainAxisAlignment(
    props['main_axis'],
    MainAxisAlignment.start,
  );
  final crossAxis = _parseCrossAxisAlignment(
    props['cross_axis'],
    CrossAxisAlignment.center,
  );
  final mainAxisSize = _parseMainAxisSize(props['main_axis_size']);
  final clipBehavior = _parseClip(props['clip_behavior']);
  final rowChildren = _buildFlexChildren(
    sourceChildren,
    Axis.horizontal,
    spacing,
    mainAxisSize,
    buildFromControl,
  );
  Widget row = Row(
    crossAxisAlignment: crossAxis,
    mainAxisAlignment: mainAxis,
    mainAxisSize: mainAxisSize,
    textBaseline: crossAxis == CrossAxisAlignment.baseline
        ? TextBaseline.alphabetic
        : null,
    children: rowChildren,
  );
  if (clipBehavior != null) {
    row = ClipRect(clipBehavior: clipBehavior, child: row);
  }
  return row;
}

List<Widget> _buildFlexChildren(
  List children,
  Axis axis,
  double spacing,
  MainAxisSize parentMainAxisSize,
  Widget Function(Map<String, Object?> child) buildFromControl,
) {
  final built = <Widget>[];
  for (final child in children) {
    if (child is! Map) continue;
    final childMap = coerceObjectMap(child);
    final childType = childMap['type']?.toString() ?? '';
    if (childType == 'expanded') {
      final expandedProps = (childMap['props'] is Map)
          ? coerceObjectMap(childMap['props'] as Map)
          : <String, Object?>{};
      final flex = coerceOptionalInt(expandedProps['flex']) ?? 1;
      final fit = _parseFlexFit(expandedProps['fit']) ?? FlexFit.tight;
      final innerChild = _firstChildMap(
        childMap['children'] as List? ?? const [],
      );
      Widget widget = innerChild == null
          ? const SizedBox.shrink()
          : buildFromControl(innerChild);
      if (fit == FlexFit.loose) {
        widget = Flexible(flex: flex, fit: fit, child: widget);
      } else {
        widget = Expanded(flex: flex, child: widget);
      }
      built.add(widget);
      continue;
    }
    Widget widget = buildFromControl(childMap);
    final childProps = (childMap['props'] is Map)
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

  if (spacing <= 0 || built.length < 2) return built;

  final spaced = <Widget>[];
  for (var i = 0; i < built.length; i += 1) {
    if (i > 0) {
      spaced.add(
        axis == Axis.horizontal
            ? SizedBox(width: spacing)
            : SizedBox(height: spacing),
      );
    }
    spaced.add(built[i]);
  }
  return spaced;
}

Map<String, Object?>? _firstChildMap(List children) {
  for (final child in children) {
    if (child is Map) {
      return coerceObjectMap(child);
    }
  }
  return null;
}

MainAxisAlignment _parseMainAxisAlignment(
  Object? value,
  MainAxisAlignment fallback,
) {
  final s = value?.toString().toLowerCase();
  switch (s) {
    case 'start':
    case 'left':
      return MainAxisAlignment.start;
    case 'center':
      return MainAxisAlignment.center;
    case 'end':
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

CrossAxisAlignment _parseCrossAxisAlignment(
  Object? value,
  CrossAxisAlignment fallback,
) {
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
      return CrossAxisAlignment.baseline;
  }
  return fallback;
}

FlexFit? _parseFlexFit(Object? value) {
  final s = value?.toString().toLowerCase();
  switch (s) {
    case 'loose':
      return FlexFit.loose;
    case 'tight':
      return FlexFit.tight;
  }
  return null;
}

MainAxisSize _parseMainAxisSize(Object? value) {
  final s = value?.toString().toLowerCase();
  if (s == 'min') return MainAxisSize.min;
  return MainAxisSize.max;
}

Clip? _parseClip(Object? value) {
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
