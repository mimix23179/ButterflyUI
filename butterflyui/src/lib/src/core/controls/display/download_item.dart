import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildDownloadItemControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _DownloadItemControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _DownloadItemControl extends StatefulWidget {
  const _DownloadItemControl({
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
  State<_DownloadItemControl> createState() => _DownloadItemControlState();
}

class _DownloadItemControlState extends State<_DownloadItemControl> {
  late double _progress;
  late bool _paused;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _DownloadItemControl oldWidget) {
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
    _progress = (coerceDouble(widget.props['progress']) ?? 0).clamp(0.0, 1.0);
    _paused = widget.props['paused'] == true;
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_progress':
        final next = coerceDouble(args['progress']);
        if (next != null) {
          setState(() => _progress = next.clamp(0.0, 1.0));
          _emit('progress', _statePayload());
        }
        return _statePayload();
      case 'set_paused':
        setState(() => _paused = args['paused'] == true);
        _emit(_paused ? 'pause' : 'resume', _statePayload());
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
        throw UnsupportedError('Unknown download_item method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'id': widget.props['id']?.toString() ?? '',
      'progress': _progress,
      'paused': _paused,
      'status': widget.props['status']?.toString() ?? '',
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final title = (widget.props['title'] ?? widget.props['id'] ?? 'Download').toString();
    final subtitle = widget.props['subtitle']?.toString();
    final speed = widget.props['speed']?.toString();
    final eta = widget.props['eta']?.toString();
    final status = (widget.props['status'] ?? (_paused ? 'Paused' : 'Downloading')).toString();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                      if (subtitle != null && subtitle.isNotEmpty)
                        Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.75))),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() => _paused = !_paused);
                    _emit(_paused ? 'pause' : 'resume', _statePayload());
                  },
                  icon: Icon(_paused ? Icons.play_arrow : Icons.pause),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: _progress),
            const SizedBox(height: 6),
            Text(
              '${(_progress * 100).toStringAsFixed(0)}% • $status${speed == null ? '' : ' • $speed'}${eta == null ? '' : ' • ETA $eta'}',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
