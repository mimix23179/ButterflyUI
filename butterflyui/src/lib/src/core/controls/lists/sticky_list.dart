import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_shells/runtime_props_control.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildStickyListControl(
  String controlId,
  Map<String, Object?> props,
  List rawChildren,
  Widget Function(Map<String, Object?> child) buildFromControl,
  ButterflyUISendRuntimeEvent sendEvent, {
  ButterflyUIRegisterInvokeHandler? registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler? unregisterInvokeHandler,
}) {
  return buildRuntimePropsControl(
    props: props,
    controlId: controlId,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
    stateBuilder: (liveProps) {
      final sections = _coerceSections(liveProps['sections']);
      return <String, Object?>{
        ...liveProps,
        'section_count': sections.length,
        'child_count': rawChildren.whereType<Map>().length,
      };
    },
    builder: (liveProps) {
      final sections = _coerceSections(liveProps['sections']);
      final spacing = coerceDouble(liveProps['spacing']) ?? 8;
      final reverse = liveProps['reverse'] == true;
      final shrinkWrap = liveProps['shrink_wrap'] == true;
      final scrollable = liveProps['scrollable'] == null
          ? true
          : (liveProps['scrollable'] == true);
      final cacheExtent = coerceDouble(liveProps['cache_extent']);
      final padding = coercePadding(liveProps['padding']) ?? EdgeInsets.zero;

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
          separatorBuilder: (context, index) => SizedBox(height: spacing),
          itemBuilder: (_, index) => buildFromControl(childMaps[index]),
        );
      }

      final widgets = <Widget>[];
      for (
        var sectionIndex = 0;
        sectionIndex < sections.length;
        sectionIndex += 1
      ) {
        final section = sections[sectionIndex];
        final headerText = (section['header'] ?? section['title'] ?? '')
            .toString();
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
        final items = section['items'] is List
            ? (section['items'] as List)
            : const <Object?>[];
        for (var itemIndex = 0; itemIndex < items.length; itemIndex += 1) {
          final item = items[itemIndex];
          final itemMap = item is Map
              ? coerceObjectMap(item)
              : <String, Object?>{'label': item};
          final label =
              (itemMap['label'] ??
                      itemMap['title'] ??
                      itemMap['text'] ??
                      itemMap['id'] ??
                      '$itemIndex')
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
    },
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
