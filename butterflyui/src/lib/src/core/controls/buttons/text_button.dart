import 'dart:async';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/controls/buttons/button_runtime.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildTextButtonControl(
  String controlId,
  Map<String, Object?> props,
  CandyTokens tokens,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final effectiveProps = <String, Object?>{'variant': 'text', ...props};
  final spec = buildButtonVisualSpec(
    props: effectiveProps,
    tokens: tokens,
    variant: 'text',
    fallbackLabel: 'Button',
  );
  final enabled = effectiveProps['enabled'] == null
      ? true
      : (effectiveProps['enabled'] == true);
  final content = buildButtonContent(spec: spec, fallbackLabel: 'Button');

  void onPressed() {
    unawaited(maybeDispatchWindowAction(effectiveProps));
    emitControlPressEvents(
      controlId: controlId,
      props: effectiveProps,
      payload: buildBasePressPayload(
        label: spec.label,
        variant: 'text',
        props: effectiveProps,
      ),
      sendEvent: sendEvent,
    );
  }

  final button = TextButton(
    onPressed: enabled ? onPressed : null,
    style: spec.style,
    child: content,
  );
  return applyControlTransparency(child: button, props: effectiveProps);
}
