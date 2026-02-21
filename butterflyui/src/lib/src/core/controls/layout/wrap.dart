import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/control_utils.dart';
import 'package:conduit_runtime/src/core/candy/theme.dart';

Widget buildWrapControl(Map<String, Object?> props, List children, CandyTokens tokens,
    Widget Function(Map<String, Object?> child) buildFromControl) {
  final spacing = coerceDouble(props['spacing']) ?? tokens.number('spacing', 'sm') ?? 0.0;
  final runSpacing = coerceDouble(props['run_spacing']) ?? spacing;
  final alignment = _parseWrapAlignment(props['alignment']) ?? WrapAlignment.start;
  final runAlignment = _parseWrapAlignment(props['run_alignment']) ?? WrapAlignment.start;
  final crossAxis = _parseWrapCrossAlignment(props['cross_axis']) ?? WrapCrossAlignment.start;
  final direction = _parseAxis(props['direction']) ?? Axis.horizontal;
  return Wrap(
    spacing: spacing,
    runSpacing: runSpacing,
    alignment: alignment,
    runAlignment: runAlignment,
    crossAxisAlignment: crossAxis,
    direction: direction,
    children: children.whereType<Map>().map((c) => buildFromControl(coerceObjectMap(c))).toList(),
  );
}

WrapAlignment? _parseWrapAlignment(Object? value) {
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

WrapCrossAlignment? _parseWrapCrossAlignment(Object? value) {
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

Axis? _parseAxis(Object? value) {
  final s = value?.toString().toLowerCase();
  switch (s) {
    case 'horizontal':
    case 'row':
      return Axis.horizontal;
    case 'vertical':
    case 'column':
      return Axis.vertical;
  }
  return null;
}
