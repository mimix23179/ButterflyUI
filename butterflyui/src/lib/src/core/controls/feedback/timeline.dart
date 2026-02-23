import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildTimelineControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _TimelineControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _TimelineControl extends StatefulWidget {
  const _TimelineControl({
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
  State<_TimelineControl> createState() => _TimelineControlState();
}

class _TimelineControlState extends State<_TimelineControl> {
  bool _play = true;

  @override
  void initState() {
    super.initState();
    _play = widget.props['play'] == null ? true : (widget.props['play'] == true);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _TimelineControl oldWidget) {
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
      case 'set_play':
        setState(() {
          _play = args['play'] == true;
        });
        return _state();
      case 'get_state':
        return _state();
      case 'emit':
        final event = (args['event'] ?? 'tick').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        if (widget.controlId.isNotEmpty) {
          widget.sendEvent(widget.controlId, event, payload);
        }
        return true;
      default:
        throw UnsupportedError('Unknown timeline method: $method');
    }
  }

  Map<String, Object?> _state() {
    return <String, Object?>{
      'play': _play,
      'tracks': widget.props['tracks'],
      'duration_ms': coerceOptionalInt(widget.props['duration_ms']) ?? 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final tracks = widget.props['tracks'] is List ? widget.props['tracks'] as List : const <Object?>[];
    final spacing = coerceDouble(widget.props['spacing']) ?? 8;
    final direction = (widget.props['direction'] ?? 'vertical').toString().toLowerCase();

    final children = <Widget>[];
    for (var index = 0; index < tracks.length; index += 1) {
      final track = tracks[index] is Map ? coerceObjectMap(tracks[index] as Map) : <String, Object?>{};
      final label = (track['label'] ?? track['id'] ?? 'Track ${index + 1}').toString();
      final start = coerceDouble(track['start']) ?? 0;
      final end = coerceDouble(track['end']) ?? 0;
      children.add(
        InkWell(
          onTap: widget.controlId.isEmpty
              ? null
              : () {
                  widget.sendEvent(widget.controlId, 'select', {
                    'index': index,
                    'track': track,
                    'label': label,
                  });
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              children: [
                Expanded(child: Text(label)),
                Text('${start.toStringAsFixed(2)} → ${end.toStringAsFixed(2)}'),
              ],
            ),
          ),
        ),
      );
    }

    final body = children.isEmpty
        ? const SizedBox.shrink()
        : direction == 'horizontal'
            ? Wrap(spacing: spacing, runSpacing: spacing, children: children)
            : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                for (var i = 0; i < children.length; i += 1) ...[
                  if (i > 0) SizedBox(height: spacing),
                  children[i],
                ],
              ]);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: _play ? 1.0 : 0.6,
      child: body,
    );
  }
}
