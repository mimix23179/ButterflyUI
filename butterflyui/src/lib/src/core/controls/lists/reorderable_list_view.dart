import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/controls/lists/reorderable_list.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildReorderableListViewControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return buildReorderableListControl(
    controlId,
    props,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}
