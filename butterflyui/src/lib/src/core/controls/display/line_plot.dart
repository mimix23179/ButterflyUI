import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/controls/display/chart.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildLinePlotControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return buildChartControl(controlId, {
    ...props,
    'chart_type': 'line',
  }, sendEvent);
}
