import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildTimeTravelControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _TimeTravelControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _TimeTravelControl extends StatefulWidget {
  const _TimeTravelControl({
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
  State<_TimeTravelControl> createState() => _TimeTravelControlState();
}

class _TimeTravelControlState extends State<_TimeTravelControl> {
  late double _value;
  late bool _playing;

  double get _min => coerceDouble(widget.props['min']) ?? 0;
  double get _max {
    final max = coerceDouble(widget.props['max']) ?? 100;
    return max < _min ? _min : max;
  }

  @override
  void initState() {
    super.initState();
    _value = (coerceDouble(widget.props['value']) ?? _min).clamp(_min, _max).toDouble();
    _playing = widget.props['playing'] == true;
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _TimeTravelControl oldWidget) {
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
      case 'set_value':
        setState(() {
          _value = (coerceDouble(args['value']) ?? _value).clamp(_min, _max).toDouble();
        });
        return _state();
      case 'set_playing':
        setState(() {
          _playing = args['value'] == true;
        });
        return _state();
      case 'get_state':
        return _state();
      case 'emit':
        final event = (args['event'] ?? 'change').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        if (widget.controlId.isNotEmpty) {
          widget.sendEvent(widget.controlId, event, payload);
        }
        return true;
      default:
        throw UnsupportedError('Unknown time_travel method: $method');
    }
  }

  Map<String, Object?> _state() {
    return <String, Object?>{
      'value': _value,
      'min': _min,
      'max': _max,
      'playing': _playing,
    };
  }

  @override
  Widget build(BuildContext context) {
    final step = coerceDouble(widget.props['step']) ?? 1;
    final speed = coerceDouble(widget.props['speed']) ?? 1;

    return Row(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _playing = !_playing;
            });
            if (widget.controlId.isNotEmpty) {
              widget.sendEvent(widget.controlId, _playing ? 'play' : 'pause', _state());
            }
          },
          icon: Icon(_playing ? Icons.pause : Icons.play_arrow),
        ),
        Expanded(
          child: Slider(
            value: _value,
            min: _min,
            max: _max,
            onChanged: (value) {
              setState(() {
                _value = value;
              });
              if (widget.controlId.isNotEmpty) {
                widget.sendEvent(widget.controlId, 'change', _state());
              }
            },
          ),
        ),
        Text('×${speed.toStringAsFixed(2)}'),
        IconButton(
          onPressed: () {
            setState(() {
              _value = (_value - step).clamp(_min, _max).toDouble();
            });
            if (widget.controlId.isNotEmpty) {
              widget.sendEvent(widget.controlId, 'step', {'direction': 'backward', ..._state()});
            }
          },
          icon: const Icon(Icons.fast_rewind),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _value = (_value + step).clamp(_min, _max).toDouble();
            });
            if (widget.controlId.isNotEmpty) {
              widget.sendEvent(widget.controlId, 'step', {'direction': 'forward', ..._state()});
            }
          },
          icon: const Icon(Icons.fast_forward),
        ),
      ],
    );
  }
}
