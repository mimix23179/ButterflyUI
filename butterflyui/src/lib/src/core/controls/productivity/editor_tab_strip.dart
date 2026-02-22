import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _EditorTabItem {
  final String id;
  final String title;
  final bool active;
  final bool dirty;

  const _EditorTabItem({
    required this.id,
    required this.title,
    required this.active,
    required this.dirty,
  });
}

Widget buildEditorTabStripControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final rawTabs = props['tabs'];
  final tabs = <_EditorTabItem>[];
  if (rawTabs is List) {
    for (var i = 0; i < rawTabs.length; i += 1) {
      final item = rawTabs[i];
      if (item is Map) {
        final id = (item['id'] ?? 'doc_$i').toString();
        tabs.add(
          _EditorTabItem(
            id: id,
            title: (item['title'] ?? item['path'] ?? id).toString(),
            active: item['active'] == true,
            dirty: item['dirty'] == true,
          ),
        );
      }
    }
  }

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: tabs
          .map(
            (tab) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InputChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(tab.title),
                    if (tab.dirty)
                      const Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Icon(Icons.circle, size: 8),
                      ),
                  ],
                ),
                selected: tab.active,
                onPressed: () {
                  sendEvent(controlId, 'select', {'id': tab.id});
                },
                onDeleted: () {
                  sendEvent(controlId, 'close', {'id': tab.id});
                },
              ),
            ),
          )
          .toList(growable: false),
    ),
  );
}
