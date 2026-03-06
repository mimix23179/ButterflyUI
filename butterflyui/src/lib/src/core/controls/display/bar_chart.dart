import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/controls/display/chart.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildBarChartControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return buildChartControl(
    controlId,
    <String, Object?>{'chart_type': 'bar', ...props},
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}
