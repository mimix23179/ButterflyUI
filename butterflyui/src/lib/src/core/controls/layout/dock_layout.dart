import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/control_utils.dart';

Widget buildDockLayoutControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  final paneSpecs = <_DockPaneSpec>[];
  final rawPanes = props['panes'];
  if (rawPanes is List) {
    for (final item in rawPanes) {
      if (item is! Map) continue;
      final map = coerceObjectMap(item);
      paneSpecs.add(_DockPaneSpec.fromMap(map, buildChild));
    }
  }

  for (final raw in rawChildren) {
    if (raw is! Map) continue;
    final map = coerceObjectMap(raw);
    final type = map['type']?.toString().toLowerCase();
    if (type == 'pane' || type == 'dock_pane') {
      paneSpecs.add(_DockPaneSpec.fromMap(map, buildChild));
      continue;
    }
    final childWidget = buildChild(map);
    paneSpecs.add(
      _DockPaneSpec(
        slot: paneSpecs.any((pane) => pane.slot == _DockSlot.center)
            ? _DockSlot.right
            : _DockSlot.center,
        child: childWidget,
      ),
    );
  }

  _DockPaneSpec? center;
  _DockPaneSpec? left;
  _DockPaneSpec? right;
  _DockPaneSpec? top;
  _DockPaneSpec? bottom;
  for (final pane in paneSpecs) {
    switch (pane.slot) {
      case _DockSlot.center:
        center ??= pane;
      case _DockSlot.left:
        left ??= pane;
      case _DockSlot.right:
        right ??= pane;
      case _DockSlot.top:
        top ??= pane;
      case _DockSlot.bottom:
        bottom ??= pane;
    }
  }

  final gap = coerceDouble(props['gap']) ?? 8.0;
  final padding = coercePadding(props['padding']) ?? EdgeInsets.zero;
  final main = center?.child ?? const SizedBox.shrink();

  Widget middle = main;
  if (left != null || right != null) {
    middle = Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (left != null) SizedBox(width: left.width ?? 280, child: left.child),
        if (left != null) SizedBox(width: gap),
        Expanded(child: main),
        if (right != null) SizedBox(width: gap),
        if (right != null)
          SizedBox(width: right.width ?? 320, child: right.child),
      ],
    );
  }

  Widget out = middle;
  if (top != null || bottom != null) {
    out = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (top != null) SizedBox(height: top.height ?? 96, child: top.child),
        if (top != null) SizedBox(height: gap),
        Expanded(child: middle),
        if (bottom != null) SizedBox(height: gap),
        if (bottom != null)
          SizedBox(height: bottom.height ?? 120, child: bottom.child),
      ],
    );
  }

  return Padding(padding: padding, child: out);
}

Widget buildPaneControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  Widget child = const SizedBox.shrink();
  if (rawChildren.isNotEmpty && rawChildren.first is Map) {
    child = buildChild(coerceObjectMap(rawChildren.first as Map));
  } else if (props['child'] is Map) {
    child = buildChild(coerceObjectMap(props['child'] as Map));
  }
  final title = props['title']?.toString();
  if (title == null || title.isEmpty) return child;

  return Card(
    margin: EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        const Divider(height: 1),
        child,
      ],
    ),
  );
}

enum _DockSlot { left, right, top, bottom, center }

class _DockPaneSpec {
  final _DockSlot slot;
  final Widget child;
  final double? width;
  final double? height;

  const _DockPaneSpec({
    required this.slot,
    required this.child,
    this.width,
    this.height,
  });

  factory _DockPaneSpec.fromMap(
    Map<String, Object?> map,
    Widget Function(Map<String, Object?> child) buildChild,
  ) {
    final type = map['type']?.toString().toLowerCase();
    final props = map['props'] is Map
        ? coerceObjectMap(map['props'] as Map)
        : const <String, Object?>{};
    final slot = _parseSlot(
      props['slot']?.toString() ??
          map['slot']?.toString() ??
          (type == 'pane' || type == 'dock_pane' ? null : 'center'),
    );
    final width = coerceDouble(props['width'] ?? map['width'] ?? props['size']);
    final height = coerceDouble(
      props['height'] ?? map['height'] ?? props['size'],
    );

    Map<String, Object?>? childMap;
    if (type == 'pane' || type == 'dock_pane') {
      if (map['children'] is List && (map['children'] as List).isNotEmpty) {
        final first = (map['children'] as List).first;
        if (first is Map) {
          childMap = coerceObjectMap(first);
        }
      } else if (props['child'] is Map) {
        childMap = coerceObjectMap(props['child'] as Map);
      }
    } else {
      childMap = map;
    }

    return _DockPaneSpec(
      slot: slot,
      width: width,
      height: height,
      child: childMap == null ? const SizedBox.shrink() : buildChild(childMap),
    );
  }
}

_DockSlot _parseSlot(String? raw) {
  switch ((raw ?? '').toLowerCase()) {
    case 'left':
      return _DockSlot.left;
    case 'right':
      return _DockSlot.right;
    case 'top':
      return _DockSlot.top;
    case 'bottom':
      return _DockSlot.bottom;
    default:
      return _DockSlot.center;
  }
}
