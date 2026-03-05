import 'dart:async';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/controls/buttons/button_runtime.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildButtonControl(
  String? controlId,
  Map<String, Object?> props,
  CandyTokens tokens,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final resolvedId = controlId ?? '';
  final rawVariant =
      (props['variant']?.toString() ??
              tokens.string('button', 'variant') ??
              'elevated')
          .toLowerCase()
          .trim();
  final variant = rawVariant == 'filled' ? 'elevated' : rawVariant;
  final spec = buildButtonVisualSpec(
    props: props,
    tokens: tokens,
    variant: variant,
    fallbackLabel: 'Button',
  );
  final enabled = props['enabled'] == null ? true : (props['enabled'] == true);
  final content = buildButtonContent(spec: spec, fallbackLabel: 'Button');

  void onPressed() {
    unawaited(maybeDispatchWindowAction(props));
    emitControlPressEvents(
      controlId: resolvedId,
      props: props,
      payload: buildBasePressPayload(
        label: spec.label,
        variant: variant,
        props: props,
      ),
      sendEvent: sendEvent,
    );
  }

  Widget button;
  switch (variant) {
    case 'text':
      button = TextButton(
        onPressed: enabled ? onPressed : null,
        style: spec.style,
        child: content,
      );
      break;
    case 'outlined':
      button = OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: spec.style,
        child: content,
      );
      break;
    case 'filled':
      button = FilledButton(
        onPressed: enabled ? onPressed : null,
        style: spec.style,
        child: content,
      );
      break;
    case 'elevated':
    default:
      button = ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: spec.style,
        child: content,
      );
      break;
  }
  return applyControlTransparency(child: button, props: props);
}
