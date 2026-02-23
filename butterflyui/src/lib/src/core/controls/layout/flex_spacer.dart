import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';

Widget buildFlexSpacerControl(Map<String, Object?> props) {
  final flex = (coerceOptionalInt(props['flex']) ?? 1).clamp(1, 1000);
  return Spacer(flex: flex);
}
