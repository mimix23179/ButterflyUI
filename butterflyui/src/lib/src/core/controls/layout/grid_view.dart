import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/layout/grid.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildGridViewControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final children = <Map<String, Object?>>[];
  for (final child in rawChildren) {
    if (child is Map) {
      children.add(coerceObjectMap(child));
    }
  }
  return buildGridControl(controlId, props, children, buildChild, sendEvent);
}
