import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/controls/display/glyph_button.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildIconButtonControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final icon = (props['icon'] ?? props['glyph'])?.toString();
  return buildGlyphButtonControl(
    controlId,
    {
      ...props,
      if (icon != null) 'glyph': icon,
    },
    sendEvent,
  );
}
