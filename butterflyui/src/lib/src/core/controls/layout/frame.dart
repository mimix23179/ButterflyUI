import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/controls/layout/container.dart';

Widget buildFrameControl(
  Map<String, Object?> props,
  List children,
  Widget Function(Map<String, Object?> child) buildFromControl,
) {
  return buildContainerControl(props, children, buildFromControl);
}
