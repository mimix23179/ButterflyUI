import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildResizablePanelControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ResizablePanelControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ResizablePanelControl extends StatefulWidget {
  const _ResizablePanelControl({
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
  State<_ResizablePanelControl> createState() => _ResizablePanelControlState();
}

class _ResizablePanelControlState extends State<_ResizablePanelControl> {
  double? _size;

  @override
  void initState() {
    super.initState();
    _size = coerceDouble(widget.props['size']);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ResizablePanelControl oldWidget) {
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
      _size = coerceDouble(widget.props['size']) ?? _size;
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
      case 'set_size':
        setState(() {
          _size = coerceDouble(args['size']) ?? _size;
        });
        _emit('resize', {'size': _size});
        return {'size': _size};
      case 'get_state':
        return {'size': _size};
      case 'emit':
        final event = (args['event'] ?? 'resize').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown resizable_panel method: $method');
    }
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final children = widget.rawChildren
        .whereType<Map>()
        .map(coerceObjectMap)
        .toList(growable: false);
    if (children.isEmpty) return const SizedBox.shrink();
    if (children.length == 1) return widget.buildChild(children.first);

    final axis = _parseAxis(widget.props['axis']);
    final handleSize = coerceDouble(widget.props['drag_handle_size']) ?? 8.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final total = axis == Axis.horizontal
            ? constraints.maxWidth
            : constraints.maxHeight;
        final minSize = coerceDouble(widget.props['min_size']) ?? 80.0;
        final maxSize = coerceDouble(widget.props['max_size']) ?? (total - 80.0);
        final clampedMax = maxSize.clamp(minSize, total).toDouble();
        final current = (_size ?? (total * 0.5)).clamp(minSize, clampedMax).toDouble();

        final first = SizedBox(
          width: axis == Axis.horizontal ? current : null,
          height: axis == Axis.vertical ? current : null,
          child: widget.buildChild(children[0]),
        );
        final second = Expanded(child: widget.buildChild(children[1]));

        final handle = GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanUpdate: (details) {
            final delta = axis == Axis.horizontal ? details.delta.dx : details.delta.dy;
            setState(() {
              _size = (current + delta).clamp(minSize, clampedMax).toDouble();
            });
            _emit('resize', {'size': _size});
          },
          onPanEnd: (_) => _emit('resize_end', {'size': _size}),
          child: SizedBox(
            width: axis == Axis.horizontal ? handleSize : null,
            height: axis == Axis.vertical ? handleSize : null,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.35),
              ),
            ),
          ),
        );

        if (axis == Axis.horizontal) {
          return Row(children: [first, handle, second]);
        }
        return Column(children: [first, handle, second]);
      },
    );
  }
}

Axis _parseAxis(Object? value) {
  final normalized = value?.toString().toLowerCase().trim();
  if (normalized == 'horizontal' || normalized == 'x') {
    return Axis.horizontal;
  }
  return Axis.vertical;
}
