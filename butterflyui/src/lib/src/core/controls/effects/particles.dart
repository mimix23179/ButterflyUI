import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';
import 'package:butterflyui_runtime/src/core/controls/effects/particle_field.dart';

Widget buildParticlesControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final mapped = <String, Object?>{...props};
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
