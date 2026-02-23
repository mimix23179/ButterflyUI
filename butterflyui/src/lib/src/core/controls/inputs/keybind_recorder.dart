import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildKeybindRecorderControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _KeybindRecorderControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _KeybindRecorderControl extends StatefulWidget {
  const _KeybindRecorderControl({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_KeybindRecorderControl> createState() => _KeybindRecorderControlState();
}

class _KeybindRecorderControlState extends State<_KeybindRecorderControl> {
  late String _value;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _KeybindRecorderControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    _syncFromProps();
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _syncFromProps() {
    _value = (widget.props['value'] ?? '').toString();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_value':
        return _value;
      case 'set_value':
        setState(() {
          _value = (args['value'] ?? '').toString();
        });
        _emit('change', {'value': _value});
        return _value;
      case 'emit':
        final event = (args['event'] ?? 'custom').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return true;
      default:
        throw UnsupportedError('Unknown keybind_recorder method: $method');
    }
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final logical = event.logicalKey;
    final parts = <String>[];
    if (HardwareKeyboard.instance.isControlPressed) parts.add('Ctrl');
    if (HardwareKeyboard.instance.isMetaPressed) parts.add('Meta');
    if (HardwareKeyboard.instance.isAltPressed) parts.add('Alt');
    if (HardwareKeyboard.instance.isShiftPressed) parts.add('Shift');

    var key = logical.keyLabel;
    if (key.isEmpty) {
      key = logical.debugName ?? logical.keyId.toRadixString(16);
    }
    parts.add(key);

    final next = parts.join('+');
    setState(() => _value = next);
    _emit('change', {'value': _value});
    _emit('record', {'value': _value});
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.props['enabled'] == null || widget.props['enabled'] == true;
    final placeholder = (widget.props['placeholder'] ?? 'Press shortcut').toString();

    return Focus(
      focusNode: _focusNode,
      onKeyEvent: enabled ? _onKey : null,
      child: GestureDetector(
        onTap: enabled ? () => _focusNode.requestFocus() : null,
        child: InputDecorator(
          isFocused: _focusNode.hasFocus,
          isEmpty: _value.isEmpty,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: placeholder,
            suffixIcon: widget.props['show_clear'] == true && _value.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      setState(() => _value = '');
                      _emit('change', {'value': _value});
                    },
                    icon: const Icon(Icons.clear),
                  )
                : null,
          ),
          child: Text(_value.isEmpty ? placeholder : _value),
        ),
      ),
    );
  }
}
