import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:conduit_runtime/src/core/webview/webview_api.dart';

class ConduitKeyListener extends StatefulWidget {
  final String controlId;
  final Widget child;
  final bool autofocus;
  final bool enabled;
  final ConduitSendRuntimeEvent sendEvent;

  const ConduitKeyListener({
    super.key,
    required this.controlId,
    required this.child,
    required this.autofocus,
    required this.enabled,
    required this.sendEvent,
  });

  @override
  State<ConduitKeyListener> createState() => _ConduitKeyListenerState();
}

class _ConduitKeyListenerState extends State<ConduitKeyListener> {
  late final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Map<String, Object?> _eventPayload(KeyEvent event) {
    final logical = event.logicalKey;
    final physical = event.physicalKey;
    final keyboard = HardwareKeyboard.instance;
    return {
      'key': logical.keyLabel,
      'logical_key': logical.debugName,
      'key_id': logical.keyId,
      'physical_key': physical.debugName,
      'physical_id': physical.usbHidUsage,
      'is_down': event is KeyDownEvent || event is KeyRepeatEvent,
      'is_up': event is KeyUpEvent,
      'repeat': event is KeyRepeatEvent,
      'alt': keyboard.isAltPressed,
      'ctrl': keyboard.isControlPressed,
      'meta': keyboard.isMetaPressed,
      'shift': keyboard.isShiftPressed,
    };
  }

  void _handleKey(KeyEvent event) {
    if (!widget.enabled) return;
    widget.sendEvent(widget.controlId, 'key', _eventPayload(event));
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onKeyEvent: _handleKey,
      child: widget.child,
    );
  }
}

