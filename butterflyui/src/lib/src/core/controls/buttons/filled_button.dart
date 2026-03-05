import 'dart:async';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/controls/buttons/button_runtime.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildFilledButtonControl(
  String controlId,
  Map<String, Object?> props,
  CandyTokens tokens,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final effectiveProps = <String, Object?>{'variant': 'filled', ...props};
  final spec = buildButtonVisualSpec(
    props: effectiveProps,
    tokens: tokens,
    variant: 'filled',
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
        variant: 'filled',
        props: effectiveProps,
      ),
      sendEvent: sendEvent,
    );
  }

  final button = FilledButton(
    onPressed: enabled ? onPressed : null,
    style: spec.style,
    child: content,
  );
  return applyControlTransparency(child: button, props: effectiveProps);
}
