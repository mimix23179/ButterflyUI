import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/controls/buttons/button.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/card.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/column.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/container.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/row.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/stack.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/wrap.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildCandySurfaceControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?>) buildChild,
) {
  return buildContainerControl(props, rawChildren, buildChild);
}

Widget buildCandyRowControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  CandyTokens tokens,
  Widget Function(Map<String, Object?>) buildChild,
) {
  return buildRowControl(props, rawChildren, tokens, buildChild);
}

Widget buildCandyColumnControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  CandyTokens tokens,
  Widget Function(Map<String, Object?>) buildChild,
) {
  return buildColumnControl(props, rawChildren, tokens, buildChild);
}

Widget buildCandyStackControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?>) buildChild,
) {
  return buildStackControl(props, rawChildren, buildChild);
}

Widget buildCandyWrapControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  CandyTokens tokens,
  Widget Function(Map<String, Object?>) buildChild,
) {
  return buildWrapControl(props, rawChildren, tokens, buildChild);
}

Widget buildCandyButtonAliasControl(
  String controlId,
  Map<String, Object?> props,
  CandyTokens tokens,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return buildButtonControl(controlId, props, tokens, sendEvent);
}

Widget buildCandyCardAliasControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  CandyTokens tokens,
  Widget Function(Map<String, Object?>) buildChild,
) {
  return buildCardControl(props, rawChildren, tokens, buildChild);
}

Widget buildCandyGalleryControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?>) buildChild,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final spacing = (props['spacing'] as num?)?.toDouble() ?? 12;

  final children = <Widget>[];
  if (rawChildren.isNotEmpty) {
    for (final child in rawChildren) {
      if (child is Map) {
        children.add(buildChild(Map<String, Object?>.from(child)));
      }
    }
  }

  if (children.isEmpty) {
    final items = props['items'];
    if (items is List) {
      for (var i = 0; i < items.length; i += 1) {
        final item = items[i];
        final label = item is Map
            ? (item['title'] ?? item['label'] ?? 'Item ${i + 1}').toString()
            : (item?.toString() ?? 'Item ${i + 1}');
        final id = item is Map
            ? (item['id'] ?? item['value'] ?? 'item_$i').toString()
            : 'item_$i';
        children.add(
          InkWell(
            onTap: () => sendEvent(controlId, 'select', {'id': id, 'label': label}),
            child: Card(
              child: SizedBox(
                width: 160,
                height: 96,
                child: Center(child: Text(label, textAlign: TextAlign.center)),
              ),
            ),
          ),
        );
      }
    }
  }

  if (children.isEmpty) {
    return const SizedBox.shrink();
  }

  return Wrap(spacing: spacing, runSpacing: spacing, children: children);
}
