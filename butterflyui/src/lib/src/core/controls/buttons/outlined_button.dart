import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/controls/buttons/button.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildOutlinedButtonControl(
  String controlId,
  Map<String, Object?> props,
  CandyTokens tokens,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return buildButtonControl(
    controlId,
    <String, Object?>{'variant': 'outlined', ...props},
    tokens,
    sendEvent,
  );
}
