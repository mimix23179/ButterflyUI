import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/controls/webview/webview.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

String? _toFileUrl(String? value) {
  if (value == null) return null;
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  if (trimmed.startsWith('file://')) return trimmed;
  final normalized = trimmed.replaceAll('\\', '/');
  if (RegExp(r'^[a-zA-Z]:/').hasMatch(normalized)) {
    return 'file:///$normalized';
  }
  return Uri.file(trimmed).toString();
}

String? _directoryBaseUrl(String? value) {
  final fileUrl = _toFileUrl(value);
  if (fileUrl == null || fileUrl.isEmpty) return null;
  final uri = Uri.tryParse(fileUrl);
  if (uri == null) return null;
  final segments = uri.pathSegments;
  if (segments.isEmpty) return fileUrl;
  final parentSegments = segments.length > 1
      ? segments.sublist(0, segments.length - 1)
      : const <String>[];
  return uri.replace(pathSegments: parentSegments).toString();
}

Widget buildHtmlViewControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  final html = (props['html'] ?? props['value'] ?? props['text'] ?? '').toString();
  final htmlFile = props['html_file']?.toString();
  final fileUrl = _toFileUrl(htmlFile);
  final resolvedBaseUrl = props['base_url']?.toString() ?? _directoryBaseUrl(htmlFile);
  final webviewProps = <String, Object?>{
    ...props,
    'html': html,
    'base_url': resolvedBaseUrl,
    if (props['url'] == null || (props['url']?.toString().isEmpty ?? true))
      'url': html.isEmpty ? (fileUrl ?? '') : '',
  };

  final child = buildWebViewControl(
    controlId,
    webviewProps,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );

  final fixedHeight = coerceDouble(props['height']);
  if (fixedHeight != null) {
    return SizedBox(height: fixedHeight, child: child);
  }
  return child;
}
