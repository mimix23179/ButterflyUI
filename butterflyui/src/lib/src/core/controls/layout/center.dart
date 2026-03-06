import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/controls/layout/align_control.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildCenterControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return buildAlignControl(
    controlId,
    <String, Object?>{'alignment': 'center', ...props},
    rawChildren,
    buildChild,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}
