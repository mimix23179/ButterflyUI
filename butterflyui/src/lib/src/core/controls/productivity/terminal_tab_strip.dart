import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

class _TerminalTab {
  final String id;
  final String title;
  final bool active;

  const _TerminalTab({required this.id, required this.title, required this.active});
}

Widget buildTerminalTabStripControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final rawTabs = props['tabs'];
  final tabs = <_TerminalTab>[];
  if (rawTabs is List) {
    for (var i = 0; i < rawTabs.length; i += 1) {
      final item = rawTabs[i];
      if (item is Map) {
        final id = (item['id'] ?? 'term_$i').toString();
        tabs.add(
          _TerminalTab(
            id: id,
            title: (item['title'] ?? id).toString(),
            active: item['active'] == true,
          ),
        );
      }
    }
  }

  if (tabs.isEmpty) {
    tabs.add(const _TerminalTab(id: 'terminal_1', title: 'Terminal 1', active: true));
  }

  return Row(
    children: [
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: tabs
                .map(
                  (tab) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(tab.title),
                      selected: tab.active,
                      onSelected: (_) {
                        sendEvent(controlId, 'select', {'id': tab.id, 'title': tab.title});
                      },
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ),
      IconButton(
        onPressed: () {
          sendEvent(controlId, 'add', {});
        },
        icon: const Icon(Icons.add),
      ),
    ],
  );
}
