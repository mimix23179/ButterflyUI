import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildPathFieldControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _PathFieldControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _PathFieldControl extends StatefulWidget {
  const _PathFieldControl({
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
  State<_PathFieldControl> createState() => _PathFieldControlState();
}

class _PathFieldControlState extends State<_PathFieldControl> {
  late final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _PathFieldControl oldWidget) {
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
    _controller.dispose();
    super.dispose();
  }

  void _syncFromProps() {
    final value = (widget.props['value'] ?? '').toString();
    if (_controller.text != value) {
      _controller.text = value;
      _controller.selection = TextSelection.collapsed(offset: value.length);
    }
  }

  void _emit(String event, [Map<String, Object?> payload = const <String, Object?>{}]) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_value':
        return _controller.text;
      case 'set_value':
        final value = (args['value'] ?? '').toString();
        setState(() {
          _controller.text = value;
          _controller.selection = TextSelection.collapsed(offset: value.length);
        });
        return _controller.text;
      default:
        throw UnsupportedError('Unknown path_field method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.props['enabled'] == null || widget.props['enabled'] == true;
    final showBrowse = widget.props['show_browse'] == null || widget.props['show_browse'] == true;
    final showClear = widget.props['show_clear'] == null || widget.props['show_clear'] == true;

    return TextField(
      controller: _controller,
      enabled: enabled,
      decoration: InputDecoration(
        isDense: widget.props['dense'] == true,
        labelText: widget.props['label']?.toString(),
        hintText: widget.props['placeholder']?.toString(),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showBrowse)
              IconButton(
                onPressed: enabled
                    ? () => _emit('browse', {
                        'value': _controller.text,
                        'mode': widget.props['mode']?.toString(),
                        'file_type': widget.props['file_type']?.toString(),
                      })
                    : null,
                icon: const Icon(Icons.folder_open),
              ),
            if (showClear)
              IconButton(
                onPressed: enabled
                    ? () {
                        setState(() {
                          _controller.clear();
                        });
                        _emit('change', {'value': ''});
                      }
                    : null,
                icon: const Icon(Icons.clear),
              ),
          ],
        ),
      ),
      onChanged: (value) => _emit('change', {'value': value}),
      onSubmitted: (value) => _emit('submit', {'value': value}),
    );
  }
}
