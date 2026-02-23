import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildDetailsPaneControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _DetailsPaneControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _DetailsPaneControl extends StatefulWidget {
  const _DetailsPaneControl({
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
  State<_DetailsPaneControl> createState() => _DetailsPaneControlState();
}

class _DetailsPaneControlState extends State<_DetailsPaneControl> {
  late bool _showDetails;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _DetailsPaneControl oldWidget) {
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
    _showDetails = widget.props['show_details'] == true;
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_show_details':
        setState(() => _showDetails = args['value'] == true);
        _emit('toggle', _statePayload());
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'toggle').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown details_pane method: $method');
    }
  }

  Map<String, Object?> _statePayload() => <String, Object?>{'show_details': _showDetails};

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final paneChildren = <Widget>[];
    for (final raw in widget.rawChildren) {
      if (raw is Map) {
        paneChildren.add(widget.buildChild(coerceObjectMap(raw)));
      }
    }

    final master = paneChildren.isNotEmpty ? paneChildren.first : const SizedBox.shrink();
    final details = paneChildren.length > 1 ? paneChildren[1] : const SizedBox.shrink();

    final mode = (widget.props['mode'] ?? 'auto').toString().toLowerCase();
    final splitRatio = (coerceDouble(widget.props['split_ratio']) ?? 0.38).clamp(0.1, 0.9);
    final stackBreakpoint = coerceDouble(widget.props['stack_breakpoint']) ?? 860;
    final showBack = widget.props['show_back'] == true;
    final backLabel = (widget.props['back_label'] ?? 'Back').toString();
    final divider = widget.props['divider'] != false;

    return LayoutBuilder(
      builder: (context, constraints) {
        final stackMode = mode == 'stack' || (mode == 'auto' && constraints.maxWidth < stackBreakpoint);
        if (stackMode) {
          if (_showDetails) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (showBack)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() => _showDetails = false);
                        _emit('back', _statePayload());
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: Text(backLabel),
                    ),
                  ),
                Expanded(child: details),
              ],
            );
          }
          return master;
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: (splitRatio * 1000).round(), child: master),
            if (divider) const VerticalDivider(width: 1, thickness: 1),
            Expanded(flex: ((1 - splitRatio) * 1000).round(), child: details),
          ],
        );
      },
    );
  }
}
