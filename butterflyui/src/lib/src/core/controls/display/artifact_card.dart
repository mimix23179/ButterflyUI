import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildArtifactCardControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ArtifactCardControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ArtifactCardControl extends StatefulWidget {
  const _ArtifactCardControl({
    required this.controlId,
    required this.props,
    required this.rawChildren,
    required this.buildChild,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_ArtifactCardControl> createState() => _ArtifactCardControlState();
}

class _ArtifactCardControlState extends State<_ArtifactCardControl> {
  late String _title;
  late String _message;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ArtifactCardControl oldWidget) {
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
    _title = (widget.props['title'] ?? widget.props['label'] ?? '').toString();
    _message = (widget.props['message'] ?? '').toString();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_content':
        setState(() {
          if (args['title'] != null) _title = args['title'].toString();
          if (args['message'] != null) _message = args['message'].toString();
        });
        _emit('change', _statePayload());
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'action').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown artifact_card method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{'title': _title, 'message': _message};
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final actionLabel = widget.props['action_label']?.toString();
    final clickable = widget.props['clickable'] == true;
    Widget? child;
    for (final raw in widget.rawChildren) {
      if (raw is Map) {
        child = widget.buildChild(coerceObjectMap(raw));
        break;
      }
    }

    final card = Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_title.isNotEmpty) Text(_title, style: Theme.of(context).textTheme.titleMedium),
            if (_message.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(_message),
            ],
            if (child != null) ...[
              const SizedBox(height: 8),
              child,
            ],
            if (actionLabel != null && actionLabel.isNotEmpty) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _emit('action', _statePayload()),
                  child: Text(actionLabel),
                ),
              ),
            ],
          ],
        ),
      ),
    );

    if (!clickable) return card;
    return InkWell(
      onTap: () => _emit('tap', _statePayload()),
      child: card,
    );
  }
}
