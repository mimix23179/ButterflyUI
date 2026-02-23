import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildGridControl(
  String controlId,
  Map<String, Object?> props,
  List<Map<String, Object?>> children,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final axis = _parseAxis(props['direction']) ?? Axis.vertical;
  final reverse = props['reverse'] == true;
  final shrinkWrap = props['shrink_wrap'] == true;
  final scrollable = props['scrollable'] == null ? true : (props['scrollable'] == true);
  final primary = axis == Axis.vertical ? (props['primary'] == true) : false;
  final ScrollPhysics? physics = scrollable ? null : const NeverScrollableScrollPhysics();
  final padding = coercePadding(props['content_padding'] ?? props['padding']);
  final columns = (coerceOptionalInt(props['columns'] ?? props['cross_axis_count']) ?? 2).clamp(1, 24);
  final spacing = coerceDouble(props['spacing']) ?? 8;
  final runSpacing = coerceDouble(props['run_spacing']) ?? spacing;
  final childAspectRatio = coerceDouble(props['child_aspect_ratio']) ?? 1;

  final tiles = <Widget>[];
  if (children.isNotEmpty) {
    tiles.addAll(children.map(buildChild));
  } else if (props['items'] is List) {
    final items = props['items'] as List;
    for (var i = 0; i < items.length; i += 1) {
      final item = items[i];
      if (item is Map) {
        final map = coerceObjectMap(item);
        final title = map['title']?.toString() ?? map['label']?.toString() ?? '${map['id'] ?? i}';
        tiles.add(
          Card(
            child: InkWell(
              onTap: controlId.isEmpty
                  ? null
                  : () {
                      sendEvent(controlId, 'select', {'index': i, 'item': map});
                    },
              child: Center(child: Text(title, textAlign: TextAlign.center)),
            ),
          ),
        );
      } else {
        tiles.add(Card(child: Center(child: Text(item?.toString() ?? ''))));
      }
    }
  }

  return GridView.count(
    crossAxisCount: columns,
    crossAxisSpacing: spacing,
    mainAxisSpacing: runSpacing,
    childAspectRatio: childAspectRatio,
    scrollDirection: axis,
    reverse: reverse,
    shrinkWrap: shrinkWrap,
    primary: primary,
    physics: physics,
    padding: padding,
    children: tiles,
  );
}

Axis? _parseAxis(Object? value) {
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
