import 'package:flutter/material.dart';

Future<Object?> handleFocusableInvoke({
  required BuildContext context,
  required FocusNode focusNode,
  required String method,
  required Map<String, Object?> args,
  Future<Object?> Function(String method, Map<String, Object?> args)?
  onUnhandled,
}) async {
  switch (method) {
    case 'focus':
    case 'request_focus':
      focusNode.requestFocus();
      return true;
    case 'blur':
    case 'unfocus':
      focusNode.unfocus();
      return true;
    case 'next_focus':
      return FocusScope.of(context).nextFocus();
    case 'previous_focus':
      return FocusScope.of(context).previousFocus();
    case 'is_focused':
      return focusNode.hasFocus;
    default:
      if (onUnhandled != null) {
        return onUnhandled(method, args);
      }
      throw Exception('Unknown focusable method: $method');
  }
}
