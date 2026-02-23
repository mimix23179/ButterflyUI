import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildBrushPanelControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _BrushPanelControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _BrushPanelControl extends StatefulWidget {
  const _BrushPanelControl({
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
  State<_BrushPanelControl> createState() => _BrushPanelControlState();
}

class _BrushPanelControlState extends State<_BrushPanelControl> {
  late double _size;
  late double _hardness;
  late double _opacity;
  late double _flow;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _BrushPanelControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (!mapEquals(oldWidget.props, widget.props)) {
      _syncFromProps();
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  void _syncFromProps() {
    _size = (coerceDouble(widget.props['size']) ?? 16).clamp(1, 256).toDouble();
    _hardness = (coerceDouble(widget.props['hardness']) ?? 50)
        .clamp(0, 100)
        .toDouble();
    _opacity = (coerceDouble(widget.props['opacity']) ?? 100)
        .clamp(0, 100)
        .toDouble();
    _flow = (coerceDouble(widget.props['flow']) ?? 100)
        .clamp(0, 100)
        .toDouble();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_value':
        final key = args['key']?.toString();
        final value = coerceDouble(args['value']);
        if (key != null && value != null) {
          setState(() {
            switch (key) {
              case 'size':
                _size = value.clamp(1, 256).toDouble();
                break;
              case 'hardness':
                _hardness = value.clamp(0, 100).toDouble();
                break;
              case 'opacity':
                _opacity = value.clamp(0, 100).toDouble();
                break;
              case 'flow':
                _flow = value.clamp(0, 100).toDouble();
                break;
            }
          });
          _emit('change', {'key': key, 'value': value, ..._statePayload()});
        }
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'change').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown brush_panel method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'size': _size,
      'hardness': _hardness,
      'opacity': _opacity,
      'flow': _flow,
      'color': widget.props['color'],
      'blend_mode': widget.props['blend_mode'],
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _slider(
              'Size',
              _size,
              1,
              256,
              (v) => setState(() => _size = v),
              'size',
            ),
            _slider(
              'Hardness',
              _hardness,
              0,
              100,
              (v) => setState(() => _hardness = v),
              'hardness',
            ),
            _slider(
              'Opacity',
              _opacity,
              0,
              100,
              (v) => setState(() => _opacity = v),
              'opacity',
            ),
            _slider(
              'Flow',
              _flow,
              0,
              100,
              (v) => setState(() => _flow = v),
              'flow',
            ),
          ],
        ),
      ),
    );
  }

  Widget _slider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
    String key,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(1)}'),
        Slider(
          min: min,
          max: max,
          value: value.clamp(min, max),
          onChanged: (next) {
            onChanged(next);
            _emit('change', {'key': key, 'value': next, ..._statePayload()});
          },
        ),
      ],
    );
  }
}
