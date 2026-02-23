import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/controls/navigation/breadcrumbs.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildCrumbTrailControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return buildBreadcrumbsControl(controlId, props, sendEvent);
}
