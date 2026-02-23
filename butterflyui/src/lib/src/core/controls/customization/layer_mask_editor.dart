import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildLayerMaskEditorControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _LayerMaskEditorControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _LayerMaskEditorControl extends StatefulWidget {
  const _LayerMaskEditorControl({
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
  State<_LayerMaskEditorControl> createState() => _LayerMaskEditorControlState();
}

class _LayerMaskEditorControlState extends State<_LayerMaskEditorControl> {
  late double _opacity;
  late double _feather;
  late double _brushSize;
  late bool _invert;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _LayerMaskEditorControl oldWidget) {
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
    super.dispose();
  }

  void _syncFromProps() {
    _opacity = (coerceDouble(widget.props['opacity']) ?? 1.0).clamp(0.0, 1.0);
    _feather = (coerceDouble(widget.props['feather']) ?? 0.0).clamp(0.0, 1.0);
    _brushSize = (coerceDouble(widget.props['brush_size']) ?? 24.0).clamp(1.0, 256.0);
    _invert = widget.props['invert'] == true;
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_value':
        setState(() {
          _opacity = (coerceDouble(args['opacity']) ?? _opacity).clamp(0.0, 1.0);
          _feather = (coerceDouble(args['feather']) ?? _feather).clamp(0.0, 1.0);
          _brushSize = (coerceDouble(args['brush_size']) ?? _brushSize).clamp(1.0, 256.0);
          _invert = args['invert'] == null ? _invert : args['invert'] == true;
        });
        _emit('change', _state());
        return _state();
      case 'get_state':
        return _state();
      case 'emit':
        final event = (args['event'] ?? 'custom').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return true;
      default:
        throw UnsupportedError('Unknown layer_mask_editor method: $method');
    }
  }

  Map<String, Object?> _state() => {
    'opacity': _opacity,
    'feather': _feather,
    'brush_size': _brushSize,
    'invert': _invert,
  };

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final dense = widget.props['dense'] == true;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SliderRow(
          dense: dense,
          label: 'Brush',
          value: _brushSize,
          min: 1,
          max: 256,
          onChanged: (v) {
            setState(() => _brushSize = v);
            _emit('change', _state());
          },
        ),
        _SliderRow(
          dense: dense,
          label: 'Opacity',
          value: _opacity,
          min: 0,
          max: 1,
          onChanged: (v) {
            setState(() => _opacity = v);
            _emit('change', _state());
          },
        ),
        _SliderRow(
          dense: dense,
          label: 'Feather',
          value: _feather,
          min: 0,
          max: 1,
          onChanged: (v) {
            setState(() => _feather = v);
            _emit('change', _state());
          },
        ),
        SwitchListTile(
          dense: dense,
          title: const Text('Invert'),
          value: _invert,
          onChanged: (v) {
            setState(() => _invert = v);
            _emit('change', _state());
          },
        ),
      ],
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.dense,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final bool dense;
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: dense,
      title: Text(label),
      subtitle: Slider(value: value, min: min, max: max, onChanged: onChanged),
      trailing: Text(value.toStringAsFixed(2)),
    );
  }
}
