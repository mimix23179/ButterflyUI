import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildInspectorPanelControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final title = props['title']?.toString() ?? 'Inspector';
  final sections = _coerceSections(props['sections']);

  final childWidgets = <Widget>[];
  for (final raw in rawChildren) {
    if (raw is Map) {
      childWidgets.add(buildChild(coerceObjectMap(raw)));
    }
  }

  if (childWidgets.isNotEmpty) {
    return _wrapPanel(title, childWidgets);
  }

  final sectionTiles = sections
      .map(
        (section) => _InspectorSectionTile(
          controlId: controlId,
          section: section,
          sendEvent: sendEvent,
        ),
      )
      .toList();
  if (sectionTiles.isEmpty) {
    return _wrapPanel(title, const <Widget>[
      Padding(
        padding: EdgeInsets.all(12),
        child: Text('No sections configured'),
      ),
    ]);
  }
  return _wrapPanel(title, sectionTiles);
}

Widget _wrapPanel(String title, List<Widget> children) {
  return Card(
    margin: EdgeInsets.zero,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
        ),
        const Divider(height: 1),
        ...children,
      ],
    ),
  );
}

class _InspectorSectionTile extends StatelessWidget {
  final String controlId;
  final Map<String, Object?> section;
  final ButterflyUISendRuntimeEvent sendEvent;

  const _InspectorSectionTile({
    required this.controlId,
    required this.section,
    required this.sendEvent,
  });

  @override
  Widget build(BuildContext context) {
    final id = section['id']?.toString() ?? section['title']?.toString() ?? '';
    final title =
        section['title']?.toString() ?? section['label']?.toString() ?? id;
    final open = section['open'] == true;
    final rows = _coerceRows(section['items'] ?? section['rows']);

    return ExpansionTile(
      key: ValueKey<String>('inspector:$id'),
      initiallyExpanded: open,
      title: Text(
        title.isEmpty ? 'Section' : title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      onExpansionChanged: (expanded) {
        if (controlId.isEmpty) return;
        sendEvent(controlId, 'section_toggle', <String, Object?>{
          'id': id,
          'open': expanded,
        });
      },
      children: rows
          .map(
            (row) => ListTile(
              dense: true,
              title: Text(
                row['label']?.toString() ?? row['key']?.toString() ?? '',
              ),
              subtitle: row['description'] == null
                  ? null
                  : Text(row['description']!.toString()),
              trailing: Text(row['value']?.toString() ?? ''),
              onTap: controlId.isEmpty
                  ? null
                  : () {
                      sendEvent(controlId, 'select', <String, Object?>{
                        'section_id': id,
                        'item': row,
                        'item_id':
                            row['id']?.toString() ?? row['key']?.toString(),
                      });
                    },
            ),
          )
          .toList(),
    );
  }
}

List<Map<String, Object?>> _coerceSections(Object? raw) {
  if (raw is! List) return const <Map<String, Object?>>[];
  final out = <Map<String, Object?>>[];
  for (final section in raw) {
    if (section is Map) {
      out.add(coerceObjectMap(section));
    }
  }
  return out;
}

List<Map<String, Object?>> _coerceRows(Object? raw) {
  if (raw is! List) return const <Map<String, Object?>>[];
  final out = <Map<String, Object?>>[];
  for (final row in raw) {
    if (row is Map) {
      out.add(coerceObjectMap(row));
    } else {
      out.add(<String, Object?>{'label': row?.toString() ?? ''});
    }
  }
  return out;
}
