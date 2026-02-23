import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildFilterDrawerControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _FilterDrawerControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _FilterDrawerControl extends StatefulWidget {
  const _FilterDrawerControl({
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
  State<_FilterDrawerControl> createState() => _FilterDrawerControlState();
}

class _FilterDrawerControlState extends State<_FilterDrawerControl> {
  late bool _open;
  Map<String, Object?> _state = <String, Object?>{};

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _FilterDrawerControl oldWidget) {
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
    _open = widget.props['open'] == true;
    _state = widget.props['state'] is Map
        ? coerceObjectMap(widget.props['state'] as Map)
        : <String, Object?>{};
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_open':
        setState(() => _open = args['open'] == true);
        _emit('toggle', _payload());
        return _payload();
      case 'set_state':
        if (args['state'] is Map) {
          setState(() => _state = coerceObjectMap(args['state'] as Map));
          _emit('change', _payload());
        }
        return _payload();
      case 'get_state':
        return _payload();
      case 'emit':
        final event = (args['event'] ?? 'change').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown filter_drawer method: $method');
    }
  }

  Map<String, Object?> _payload() => <String, Object?>{'open': _open, 'state': _state};

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final title = (widget.props['title'] ?? 'Filters').toString();
    final dense = widget.props['dense'] == true;
    final showActions = widget.props['show_actions'] != false;
    final applyLabel = (widget.props['apply_label'] ?? 'Apply').toString();
    final clearLabel = (widget.props['clear_label'] ?? 'Clear').toString();

    final bodyChildren = <Widget>[];
    for (final raw in widget.rawChildren) {
      if (raw is Map) {
        bodyChildren.add(widget.buildChild(coerceObjectMap(raw)));
      }
    }

    if (!_open) {
      return Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: () {
            setState(() => _open = true);
            _emit('open', _payload());
          },
          icon: const Icon(Icons.tune),
          label: Text(title),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(dense ? 10 : 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700))),
                IconButton(
                  onPressed: () {
                    setState(() => _open = false);
                    _emit('close', _payload());
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            if (bodyChildren.isNotEmpty) ...bodyChildren,
            if (showActions)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => _emit('clear', _payload()),
                      child: Text(clearLabel),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () => _emit('apply', _payload()),
                      child: Text(applyLabel),
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
