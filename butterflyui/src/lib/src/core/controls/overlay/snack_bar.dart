import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/controls/common/icon_value.dart';
import 'package:butterflyui_runtime/src/core/controls/feedback/toast.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildSnackBarControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final style = props['style']?.toString() ?? 'snackbar';
  return ButterflyUIToastWidget(
    controlId: controlId,
    message: (props['message'] ?? props['text'] ?? '').toString(),
    label: props['label']?.toString(),
    open: props['open'] == true,
    durationMs: coerceOptionalInt(props['duration_ms']) ?? 2400,
    actionLabel: props['action_label']?.toString(),
    variant: props['variant']?.toString(),
    style: style,
    icon: parseIconDataLoose(props['icon']),
    animation: props['animation'] is Map
        ? coerceObjectMap(props['animation'] as Map)
        : null,
    instant: props['instant'] == true,
    priority: coerceOptionalInt(props['priority']) ?? 0,
    useFlushbar: props['use_flushbar'] == true,
    useFlutterToast: props['use_fluttertoast'] == true,
    toastPosition: props['toast_position']?.toString(),
    sendEvent: sendEvent,
  );
}
