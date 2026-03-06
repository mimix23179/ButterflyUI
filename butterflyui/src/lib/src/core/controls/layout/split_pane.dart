import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/controls/layout/split_view.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildSplitPaneControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return buildSplitViewControl(
    controlId,
    props,
    rawChildren,
    buildChild,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}
