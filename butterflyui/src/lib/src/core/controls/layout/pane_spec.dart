import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/controls/layout/dock_layout.dart';

Widget buildPaneSpecControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  return buildPaneControl(props, rawChildren, buildChild);
}
