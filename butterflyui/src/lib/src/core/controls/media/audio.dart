import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildAudioControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _AudioControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _AudioControl extends StatefulWidget {
  const _AudioControl({
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
  State<_AudioControl> createState() => _AudioControlState();
}

class _AudioControlState extends State<_AudioControl> {
  late bool _playing;
  late double _position;
  late double _duration;
  late double _volume;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _AudioControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    if (oldWidget.props != widget.props) {
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
    _playing = widget.props['autoplay'] == true;
    _duration = (coerceDouble(widget.props['duration']) ?? 0).clamp(0, 86400).toDouble();
    _position = (coerceDouble(widget.props['position']) ?? 0).clamp(0, _duration <= 0 ? 0 : _duration).toDouble();
    _volume = (coerceDouble(widget.props['volume']) ?? 1).clamp(0, 1).toDouble();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'play':
        setState(() => _playing = true);
        _emit('play', _statePayload());
        return _statePayload();
      case 'pause':
        setState(() => _playing = false);
        _emit('pause', _statePayload());
        return _statePayload();
      case 'set_position':
        final next = coerceDouble(args['seconds']);
        if (next != null) {
          setState(() => _position = next.clamp(0, _duration <= 0 ? next : _duration).toDouble());
          _emit('seek', _statePayload());
        }
        return _statePayload();
      case 'set_volume':
        final next = coerceDouble(args['volume']);
        if (next != null) {
          setState(() => _volume = next.clamp(0, 1).toDouble());
          _emit('volume', _statePayload());
        }
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'state').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown audio method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'src': widget.props['src']?.toString() ?? '',
      'playing': _playing,
      'position': _position,
      'duration': _duration,
      'volume': _volume,
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.props['title']?.toString() ?? 'Audio';
    final artist = widget.props['artist']?.toString();
    final muted = widget.props['muted'] == true;
    final effectiveVolume = muted ? 0.0 : _volume;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            if (artist != null && artist.isNotEmpty) Text(artist),
            Row(
              children: [
                IconButton(
                  icon: Icon(_playing ? Icons.pause_circle : Icons.play_circle),
                  onPressed: () {
                    setState(() => _playing = !_playing);
                    _emit(_playing ? 'play' : 'pause', _statePayload());
                  },
                ),
                Expanded(
                  child: Slider(
                    min: 0,
                    max: _duration <= 0 ? 1 : _duration,
                    value: _duration <= 0 ? 0 : _position.clamp(0, _duration),
                    onChanged: (next) => setState(() => _position = next),
                    onChangeEnd: (next) => _emit('seek', _statePayload()),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.volume_up, size: 18),
                Expanded(
                  child: Slider(
                    min: 0,
                    max: 1,
                    value: effectiveVolume,
                    onChanged: (next) {
                      setState(() => _volume = next);
                      _emit('volume', _statePayload());
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
