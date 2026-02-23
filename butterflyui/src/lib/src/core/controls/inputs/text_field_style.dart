import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildTextFieldStyleControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
) {
  return _TextFieldStyleControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
  );
}

class _TextFieldStyleControl extends StatefulWidget {
  const _TextFieldStyleControl({
    required this.controlId,
    required this.props,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
  });

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;

  @override
  State<_TextFieldStyleControl> createState() => _TextFieldStyleControlState();
}

class _TextFieldStyleControlState extends State<_TextFieldStyleControl> {
  late String _variant;

  @override
  void initState() {
    super.initState();
    _variant = (widget.props['variant'] ?? 'outlined').toString();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _TextFieldStyleControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_variant':
        setState(() {
          _variant = (args['variant'] ?? _variant).toString();
        });
        return _state();
      case 'get_state':
        return _state();
      default:
        throw UnsupportedError('Unknown text_field_style method: $method');
    }
  }

  Map<String, Object?> _state() => <String, Object?>{'variant': _variant};

  @override
  Widget build(BuildContext context) {
    final label = widget.props['label']?.toString();
    final hint = widget.props['hint']?.toString();
    final enabled = widget.props['enabled'] == null || widget.props['enabled'] == true;
    final borderRadius = BorderRadius.circular(coerceDouble(widget.props['radius']) ?? 8);

    InputBorder borderFor(String variant) {
      final side = BorderSide(
        width: coerceDouble(widget.props['border_width']) ?? 1,
        color: Theme.of(context).colorScheme.outline,
      );
      switch (variant) {
        case 'underline':
          return const UnderlineInputBorder();
        case 'filled':
        case 'outlined':
        default:
          return OutlineInputBorder(borderRadius: borderRadius, borderSide: side);
      }
    }

    return TextField(
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: _variant == 'filled',
        border: borderFor(_variant),
      ),
    );
  }
}
