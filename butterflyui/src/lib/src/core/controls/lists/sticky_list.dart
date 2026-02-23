import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildStickyListControl(
  String controlId,
  Map<String, Object?> props,
  List rawChildren,
  Widget Function(Map<String, Object?> child) buildFromControl,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final sections = _coerceSections(props['sections']);
  final spacing = coerceDouble(props['spacing']) ?? 8;
  final reverse = props['reverse'] == true;
  final shrinkWrap = props['shrink_wrap'] == true;
  final scrollable = props['scrollable'] == null ? true : (props['scrollable'] == true);
  final cacheExtent = coerceDouble(props['cache_extent']);
  final padding = coercePadding(props['padding']) ?? EdgeInsets.zero;

  if (sections.isEmpty) {
    final childMaps = <Map<String, Object?>>[];
    for (final raw in rawChildren) {
      if (raw is Map) childMaps.add(coerceObjectMap(raw));
    }
    if (childMaps.isEmpty) return const SizedBox.shrink();
    return ListView.separated(
      reverse: reverse,
      shrinkWrap: shrinkWrap,
      cacheExtent: cacheExtent,
      physics: scrollable
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      padding: padding,
      itemCount: childMaps.length,
      separatorBuilder: (_, __) => SizedBox(height: spacing),
      itemBuilder: (_, index) => buildFromControl(childMaps[index]),
    );
  }

  final widgets = <Widget>[];
  for (var sectionIndex = 0; sectionIndex < sections.length; sectionIndex += 1) {
    final section = sections[sectionIndex];
    final headerText = (section['header'] ?? section['title'] ?? '').toString();
    if (headerText.isNotEmpty) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            headerText,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      );
    }
    final items = section['items'] is List ? (section['items'] as List) : const <Object?>[];
    for (var itemIndex = 0; itemIndex < items.length; itemIndex += 1) {
      final item = items[itemIndex];
      final itemMap = item is Map ? coerceObjectMap(item) : <String, Object?>{'label': item};
      final label =
          (itemMap['label'] ?? itemMap['title'] ?? itemMap['text'] ?? itemMap['id'] ?? '$itemIndex')
              .toString();
      widgets.add(
        InkWell(
          onTap: controlId.isEmpty
              ? null
              : () {
                  sendEvent(controlId, 'select', {
                    'section_index': sectionIndex,
                    'item_index': itemIndex,
                    'item': itemMap,
                    'label': label,
                    'id': itemMap['id']?.toString() ?? label,
                  });
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Text(label),
          ),
        ),
      );
    }
    if (sectionIndex < sections.length - 1) {
      widgets.add(SizedBox(height: spacing));
    }
  }

  return ListView(
    reverse: reverse,
    shrinkWrap: shrinkWrap,
    cacheExtent: cacheExtent,
    physics: scrollable
        ? const AlwaysScrollableScrollPhysics()
        : const NeverScrollableScrollPhysics(),
    padding: padding,
    children: widgets,
  );
}

List<Map<String, Object?>> _coerceSections(Object? raw) {
  if (raw is! List) return const <Map<String, Object?>>[];
  final out = <Map<String, Object?>>[];
  for (final item in raw) {
    if (item is Map) out.add(coerceObjectMap(item));
  }
  return out;
}
