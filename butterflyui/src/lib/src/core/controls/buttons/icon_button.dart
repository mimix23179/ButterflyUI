import 'dart:async';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/buttons/button_runtime.dart';
import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/controls/common/color_value.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildIconButtonControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final iconValue = props['icon'] ?? props['glyph'] ?? props['value'];
  final tooltip = props['tooltip']?.toString();
  final enabled = props['enabled'] == null ? true : (props['enabled'] == true);
  final minContrast = coerceDouble(props['min_contrast']) ?? 4.5;
  final autoContrast = coerceBool(props['auto_contrast']) ?? true;
  final background = resolveColorValue(
    props['background'] ?? props['bgcolor'],
    autoContrast: autoContrast,
    minContrast: minContrast,
  );
  final iconColor = resolveColorValue(
    props['color'] ??
        props['icon_color'] ??
        props['foreground'] ??
        props['text_color'],
    background: background,
    autoContrast: autoContrast,
    minContrast: minContrast,
  );
  final iconSize = coerceDouble(props['size'] ?? props['icon_size']);
  final splashRadius = coerceDouble(props['splash_radius']);
  final iconWidget =
      buildIconValue(
        iconValue,
        colorValue: props['color'] ?? props['icon_color'] ?? iconColor,
        color: iconColor,
        background: background,
        size: iconSize,
        autoContrast: autoContrast,
        minContrast: minContrast,
        fallbackIcon: Icons.help_outline,
      ) ??
      Icon(Icons.help_outline, size: iconSize, color: iconColor);
  final padding = coercePadding(props['padding']);

  void onPressed() {
    unawaited(maybeDispatchWindowAction(props));
    emitControlPressEvents(
      controlId: controlId,
      props: props,
      payload: buildBasePressPayload(
        label: tooltip ?? '',
        variant: 'icon_button',
        props: props,
      )..addAll(<String, Object?>{'icon': iconValue?.toString() ?? ''}),
      sendEvent: sendEvent,
    );
  }

  Widget button = IconButton(
    icon: iconWidget,
    splashRadius: splashRadius,
    onPressed: enabled ? onPressed : null,
    color: iconColor,
    style:
        (background != null ||
            props['padding'] != null ||
            props['shape'] != null)
        ? ButtonStyle(
            backgroundColor: background == null
                ? null
                : WidgetStateProperty.all(background),
            padding: padding == null ? null : WidgetStateProperty.all(padding),
          )
        : null,
  );

  if (tooltip != null && tooltip.isNotEmpty) {
    button = Tooltip(message: tooltip, child: button);
  }
  return applyControlTransparency(child: button, props: props);
}
