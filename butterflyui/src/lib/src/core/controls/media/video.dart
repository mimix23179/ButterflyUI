import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildVideoControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _VideoControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _VideoControl extends StatefulWidget {
  const _VideoControl({
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
  State<_VideoControl> createState() => _VideoControlState();
}

class _VideoControlState extends State<_VideoControl> {
  bool _playing = false;
  double _position = 0;

  @override
  void initState() {
    super.initState();
    _playing = widget.props['autoplay'] == true;
    _position = coerceDouble(widget.props['position']) ?? 0;
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _VideoControl oldWidget) {
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
      case 'play':
        setState(() => _playing = true);
        return _state();
      case 'pause':
        setState(() => _playing = false);
        return _state();
      case 'set_position':
        setState(() => _position = coerceDouble(args['position']) ?? _position);
        return _state();
      case 'get_state':
        return _state();
      case 'emit':
        final event = (args['event'] ?? 'progress').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        if (widget.controlId.isNotEmpty) {
          widget.sendEvent(widget.controlId, event, payload);
        }
        return true;
      default:
        throw UnsupportedError('Unknown video method: $method');
    }
  }

  Map<String, Object?> _state() {
    return <String, Object?>{
      'playing': _playing,
      'position': _position,
      'source': widget.props['source'],
    };
  }

  @override
  Widget build(BuildContext context) {
    final source = widget.props['source']?.toString() ?? '';
    final fit = (widget.props['fit'] ?? 'contain').toString();

    BoxFit boxFit;
    switch (fit) {
      case 'cover':
        boxFit = BoxFit.cover;
        break;
      case 'fill':
        boxFit = BoxFit.fill;
        break;
      case 'contain':
      default:
        boxFit = BoxFit.contain;
        break;
    }

    return AspectRatio(
      aspectRatio: coerceDouble(widget.props['aspect_ratio']) ?? (16 / 9),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(coerceDouble(widget.props['radius']) ?? 8),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            FittedBox(
              fit: boxFit,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Icon(Icons.ondemand_video, color: Colors.white.withOpacity(0.8), size: 72),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 10,
              child: Row(
                children: [
                  Icon(_playing ? Icons.pause_circle_filled : Icons.play_circle_fill, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (_position.clamp(0, 100) / 100),
                      minHeight: 4,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      source,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
