import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildRatingDisplayControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final value = (coerceDouble(props['value']) ?? 0).clamp(0.0, 100.0);
  final max = (coerceOptionalInt(props['max']) ?? 5).clamp(1, 10);
  final allowHalf = props['allow_half'] == true;
  final dense = props['dense'] == true;

  IconData iconForIndex(int index) {
    final full = index + 1 <= value;
    final half = allowHalf && !full && (index + 0.5) <= value;
    if (full) return Icons.star;
    if (half) return Icons.star_half;
    return Icons.star_border;
  }

  return Builder(
    builder: (context) {
      final starColor = Theme.of(context).colorScheme.secondary;
      return Wrap(
        spacing: dense ? 2 : 4,
        children: List<Widget>.generate(max, (index) {
          return InkWell(
            onTap: controlId.isEmpty
                ? null
                : () {
                    sendEvent(controlId, 'rate', {
                      'value': index + 1,
                      'index': index,
                    });
                  },
            child: Icon(
              iconForIndex(index),
              size: dense ? 16 : 20,
              color: starColor,
            ),
          );
        }),
      );
    },
  );
}
