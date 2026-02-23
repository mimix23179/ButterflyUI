import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildNumericFieldControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _NumericFieldControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _NumericFieldControl extends StatefulWidget {
  const _NumericFieldControl({
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
  State<_NumericFieldControl> createState() => _NumericFieldControlState();
}

class _NumericFieldControlState extends State<_NumericFieldControl> {
  late final TextEditingController _controller = TextEditingController();
  late double _value;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _NumericFieldControl oldWidget) {
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
    _value = coerceDouble(widget.props['value']) ?? 0;
    _controller.text = _format(_value);
  }

  String _format(double value) {
    final decimals = (coerceOptionalInt(widget.props['decimals']) ?? 0).clamp(0, 8);
    return value.toStringAsFixed(decimals);
  }

  double _clamp(double value) {
    final min = coerceDouble(widget.props['min']);
    final max = coerceDouble(widget.props['max']);
    var out = value;
    if (min != null && out < min) out = min;
    if (max != null && out > max) out = max;
    return out;
  }

  void _setValue(double value, {bool emit = true}) {
    final next = _clamp(value);
    setState(() {
      _value = next;
      _controller.text = _format(next);
    });
    if (emit && widget.controlId.isNotEmpty) {
      widget.sendEvent(widget.controlId, 'change', {'value': _value});
    }
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'get_value':
        return _value;
      case 'set_value':
        _setValue(coerceDouble(args['value']) ?? _value);
        return _value;
      default:
        throw UnsupportedError('Unknown numeric_field method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.props['enabled'] == null || widget.props['enabled'] == true;
    final step = coerceDouble(widget.props['step']) ?? 1;

    return TextField(
      controller: _controller,
      enabled: enabled,
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
      decoration: InputDecoration(
        labelText: widget.props['label']?.toString(),
        hintText: widget.props['placeholder']?.toString(),
        isDense: widget.props['dense'] == true,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: enabled ? () => _setValue(_value + step) : null,
              icon: const Icon(Icons.expand_less),
            ),
            IconButton(
              onPressed: enabled ? () => _setValue(_value - step) : null,
              icon: const Icon(Icons.expand_more),
            ),
          ],
        ),
      ),
      onChanged: (raw) {
        final next = double.tryParse(raw);
        if (next == null) return;
        _setValue(next);
      },
      onSubmitted: (_) {
        if (widget.controlId.isNotEmpty) {
          widget.sendEvent(widget.controlId, 'submit', {'value': _value});
        }
      },
    );
  }
}
