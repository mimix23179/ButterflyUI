import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/controls/display/chart.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildLineChartControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return buildChartControl(
    controlId,
    <String, Object?>{'chart_type': 'line', ...props},
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}
