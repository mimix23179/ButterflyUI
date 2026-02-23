import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildFoldLayerControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _FoldLayerControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _FoldLayerControl extends StatefulWidget {
  const _FoldLayerControl({
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
  State<_FoldLayerControl> createState() => _FoldLayerControlState();
}

class _FoldLayerControlState extends State<_FoldLayerControl> {
  late double _progress;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _FoldLayerControl oldWidget) {
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
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'set_progress':
        final next = coerceDouble(args['progress']);
        if (next != null) {
          setState(() => _progress = next.clamp(0.0, 1.0));
        }
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'change').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        if (widget.controlId.isNotEmpty) {
          widget.sendEvent(widget.controlId, event, payload);
        }
        return null;
      default:
        throw UnsupportedError('Unknown fold_layer method: $method');
    }
  }

  Map<String, Object?> _statePayload() => <String, Object?>{'progress': _progress};

  @override
  Widget build(BuildContext context) {
    final enabled = widget.props['enabled'] == null || widget.props['enabled'] == true;
    final axis = (widget.props['axis'] ?? 'vertical').toString().toLowerCase();
    final folds = (coerceOptionalInt(widget.props['folds']) ?? 4).clamp(1, 24);
    final shadow = (coerceDouble(widget.props['shadow']) ?? 0.15).clamp(0.0, 1.0);

    Widget child = const SizedBox.shrink();
    for (final raw in widget.rawChildren) {
      if (raw is Map) {
        child = widget.buildChild(coerceObjectMap(raw));
        break;
      }
    }

    if (!enabled) return child;

    final scale = 1 - (_progress * 0.08);
    final stripeAlpha = (shadow * _progress).clamp(0.0, 0.8);

    return LayoutBuilder(
      builder: (context, constraints) {
        final stripes = <Widget>[];
        for (var i = 0; i < folds; i += 1) {
          final odd = i.isOdd;
          stripes.add(
            Expanded(
              child: Container(
                color: odd
                    ? Colors.black.withValues(alpha: stripeAlpha)
                    : Colors.transparent,
              ),
            ),
          );
        }

        final overlay = axis == 'horizontal'
            ? Column(children: stripes)
            : Row(children: stripes);

        return Transform.scale(
          scale: scale,
          child: Stack(
            fit: StackFit.expand,
            children: [
              child,
              IgnorePointer(child: overlay),
            ],
          ),
        );
      },
    );
  }
}
