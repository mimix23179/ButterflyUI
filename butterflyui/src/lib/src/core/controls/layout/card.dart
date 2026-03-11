import 'package:flutter/widgets.dart';

import 'package:butterflyui_runtime/src/core/controls/layout/container.dart';
import 'package:butterflyui_runtime/src/core/styling/theme.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildCardControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  StylingTokens tokens,
  Widget Function(Map<String, Object?> child) buildFromControl,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final resolvedProps = <String, Object?>{
    ...props,
    if (!props.containsKey('content_padding')) 'content_padding': 16.0,
    if (!props.containsKey('radius'))
      'radius':
          tokens.number('card', 'radius') ?? tokens.number('radii', 'md') ?? 16.0,
    if (!props.containsKey('bgcolor') &&
        !props.containsKey('background') &&
        !props.containsKey('gradient'))
      'bgcolor': tokens.color('surface'),
    if (!props.containsKey('border_color')) 'border_color': tokens.color('border'),
    if (!props.containsKey('shadow') &&
        !props.containsKey('elevation') &&
        (tokens.number('card', 'elevation') ?? 0) > 0)
      'shadow': <String, Object?>{
        'color': tokens.color('shadow') ?? tokens.color('border'),
        'blur_radius': 18.0,
        'offset': const <double>[0, 8],
      },
  };

  return buildContainerControl(
    controlId,
    resolvedProps,
    rawChildren,
    buildFromControl,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}
