import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildAttachmentTileControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _AttachmentTileControl(
    controlId: controlId,
    props: props,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _AttachmentTileControl extends StatefulWidget {
  const _AttachmentTileControl({
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
  State<_AttachmentTileControl> createState() => _AttachmentTileControlState();
}

class _AttachmentTileControlState extends State<_AttachmentTileControl> {
  late String _src;

  @override
  void initState() {
    super.initState();
    _src = widget.props['src']?.toString() ?? '';
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _AttachmentTileControl oldWidget) {
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
      _src = widget.props['src']?.toString() ?? '';
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
      case 'set_src':
        setState(() => _src = args['src']?.toString() ?? '');
        _emit('change', _statePayload());
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'open').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown attachment_tile method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'src': _src,
      'label': widget.props['label']?.toString() ?? '',
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.props['label']?.toString() ?? _src;
    final subtitle = widget.props['subtitle']?.toString();
    final type = widget.props['type']?.toString().toLowerCase() ?? '';
    final clickable = widget.props['clickable'] == null || widget.props['clickable'] == true;
    final showRemove = widget.props['show_remove'] == true;
    final icon = switch (type) {
      'image' => Icons.image,
      'audio' => Icons.audio_file,
      'video' => Icons.video_file,
      'pdf' => Icons.picture_as_pdf,
      _ => Icons.attach_file,
    };

    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: subtitle == null ? null : Text(subtitle),
      trailing: showRemove
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => _emit('remove', _statePayload()),
            )
          : null,
      onTap: clickable ? () => _emit('open', _statePayload()) : null,
    );
  }
}
