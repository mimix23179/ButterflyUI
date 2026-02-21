import 'package:flutter/material.dart';

import 'package:conduit_runtime/src/core/control_utils.dart';

Widget buildIconControl(
  IconData iconData,
  Map<String, Object?> props,
) {
  final size = coerceDouble(props['size']);
  final color = coerceColor(props['color']);
  final tooltip = props['tooltip']?.toString();
  final icon = Icon(iconData, size: size, color: color);
  if (tooltip == null || tooltip.isEmpty) return icon;
  return Tooltip(message: tooltip, child: icon);
}
