import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/navigation/sidebar.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildNavigatorControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final sections = _coerceSections(props);
  return ButterflyUISidebar(
    controlId: controlId,
    sections: sections,
    selectedId: props['selected_id']?.toString(),
    showSearch: props['show_search'] == true,
    query: props['query']?.toString() ?? '',
    collapsible: props['collapsible'] == true,
    dense: props['dense'] == true,
    sendEvent: sendEvent,
  );
}

List<Map<String, Object?>> _coerceSections(Map<String, Object?> props) {
  final out = <Map<String, Object?>>[];
  final rawSections = props['sections'];
  if (rawSections is List) {
    for (final raw in rawSections) {
      if (raw is Map) {
        out.add(coerceObjectMap(raw));
      }
    }
  }
  if (out.isNotEmpty) return out;

  final rawItems = props['items'];
  if (rawItems is List) {
    final items = <Object?>[];
    for (final raw in rawItems) {
      items.add(raw);
    }
    out.add({'title': 'Navigation', 'items': items});
  }
  return out;
}
