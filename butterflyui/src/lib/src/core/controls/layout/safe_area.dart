import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildSafeAreaControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  Map<String, Object?>? firstChild;
  for (final raw in rawChildren) {
    if (raw is Map) {
      firstChild = coerceObjectMap(raw);
      break;
    }
  }

  return SafeArea(
    left: props['left'] == null ? true : (props['left'] == true),
    top: props['top'] == null ? true : (props['top'] == true),
    right: props['right'] == null ? true : (props['right'] == true),
    bottom: props['bottom'] == null ? true : (props['bottom'] == true),
    minimum: coercePadding(props['minimum']) ?? EdgeInsets.zero,
    maintainBottomViewPadding: props['maintain_bottom_view_padding'] == true,
    child: firstChild == null ? const SizedBox.shrink() : buildChild(firstChild),
  );
}
