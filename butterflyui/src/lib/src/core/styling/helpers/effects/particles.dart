import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/styling/helpers/helper_bridge.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';
import 'package:butterflyui_runtime/src/core/styling/helpers/effects/particle_field.dart';

Widget buildParticlesControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final resolved = resolveStylingHelperProps(props, controlType: 'particles');
  final mapped = <String, Object?>{...resolved};
  if (mapped.containsKey('density') && !mapped.containsKey('count')) {
    mapped['count'] = mapped['density'];
  }
  return buildParticleFieldControl(
    controlId,
    mapped,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}
