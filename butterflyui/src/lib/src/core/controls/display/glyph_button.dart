import 'dart:async';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/buttons/button_runtime.dart';
import 'package:butterflyui_runtime/src/core/controls/common/color_value.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildGlyphButtonControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final tooltip = props['tooltip']?.toString();
  final enabled = props['enabled'] == null ? true : (props['enabled'] == true);
  final interactive = props['interactive'] == null
      ? true
      : (props['interactive'] == true);
  final glyph = props['glyph'] ?? props['icon'];
  final minContrast = coerceDouble(props['min_contrast']) ?? 4.5;
  final autoContrast = coerceBool(props['auto_contrast']) ?? true;
  final background = resolveColorValue(
    props['background'] ?? props['bgcolor'],
    autoContrast: autoContrast,
    minContrast: minContrast,
  );
  final color = resolveColorValue(
    props['color'] ?? props['icon_color'] ?? props['foreground'],
    background: background,
    autoContrast: autoContrast,
    minContrast: minContrast,
  );
  final size = coerceDouble(props['size'] ?? props['icon_size']);
  final iconWidget =
      buildIconValue(
        glyph,
        colorValue: props['color'] ?? props['icon_color'],
        color: color,
        background: background,
        size: size,
        autoContrast: autoContrast,
        minContrast: minContrast,
        fallbackIcon: Icons.circle,
      ) ??
      Icon(Icons.circle, size: size, color: color);

  if (!interactive) {
    Widget staticIcon = iconWidget;
    if (tooltip != null && tooltip.isNotEmpty) {
      staticIcon = Tooltip(message: tooltip, child: staticIcon);
    }
    return applyControlTransparency(child: staticIcon, props: props);
  }

  void onPressed() {
    unawaited(maybeDispatchWindowAction(props));
    emitControlPressEvents(
      controlId: controlId,
      props: props,
      payload: buildBasePressPayload(
        label: tooltip ?? '',
        variant: 'glyph_button',
        props: props,
      )..addAll(<String, Object?>{'glyph': glyph?.toString() ?? ''}),
      sendEvent: sendEvent,
    );
  }

  Widget button = IconButton(
    icon: iconWidget,
    onPressed: enabled ? onPressed : null,
  );

  if (tooltip != null && tooltip.isNotEmpty) {
    button = Tooltip(message: tooltip, child: button);
  }
  return applyControlTransparency(child: button, props: props);
}
