import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildRouteViewControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  final children = <Widget>[];
  for (final raw in rawChildren) {
    if (raw is Map) {
      children.add(buildChild(coerceObjectMap(raw)));
    }
  }

  final propChildren = props['children'];
  if (children.isEmpty && propChildren is List) {
    for (final raw in propChildren) {
      if (raw is Map) {
        children.add(buildChild(coerceObjectMap(raw)));
      }
    }
  }

  final rawChild = props['child'];
  if (children.isEmpty && rawChild is Map) {
    children.add(buildChild(coerceObjectMap(rawChild)));
  }

  if (children.isEmpty) return const SizedBox.shrink();
  if (children.length == 1) return children.first;

  final layout = (props['layout'] ?? props['child_layout'] ?? 'column')
      .toString()
      .toLowerCase();
  final spacing = coerceDouble(props['spacing']) ?? 0.0;

  switch (layout) {
    case 'row':
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _withSpacing(children, spacing, Axis.horizontal),
      );
    case 'stack':
      return Stack(children: children);
    case 'wrap':
      return Wrap(spacing: spacing, runSpacing: spacing, children: children);
    case 'column':
    default:
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _withSpacing(children, spacing, Axis.vertical),
      );
  }
}

List<Widget> _withSpacing(List<Widget> children, double spacing, Axis axis) {
  if (spacing <= 0 || children.length <= 1) return children;
  final out = <Widget>[];
  for (var index = 0; index < children.length; index += 1) {
    if (index > 0) {
      out.add(
        axis == Axis.horizontal
            ? SizedBox(width: spacing)
            : SizedBox(height: spacing),
      );
    }
    out.add(children[index]);
  }
  return out;
}

Widget buildRouteControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ButterflyUIRouteControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ButterflyUIRouteControl extends StatefulWidget {
  const _ButterflyUIRouteControl({
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
  State<_ButterflyUIRouteControl> createState() =>
      _ButterflyUIRouteControlState();
}

class _ButterflyUIRouteControlState extends State<_ButterflyUIRouteControl> {
  String? _routeId;
  String? _lastEmittedRouteId;
  DateTime? _lastRouteEmitAt;

  @override
  void initState() {
    super.initState();
    _routeId = widget.props['route_id']?.toString();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ButterflyUIRouteControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    final nextRouteId = widget.props['route_id']?.toString();
    if (nextRouteId != _routeId) {
      _routeId = nextRouteId;
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method.trim().toLowerCase()) {
      case 'set_route_id':
      case 'set_route':
        final next = args['route_id']?.toString() ?? args['id']?.toString();
        if (next == null || next.isEmpty) {
          return {'ok': false};
        }
        setState(() {
          _routeId = next;
        });
        _emitRouteChange(next);
        return {'ok': true, 'route_id': _routeId};
      case 'get_state':
        return {'route_id': _routeId};
      case 'emit':
        final event = (args['event'] ?? 'route_event').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        if (widget.controlId.isNotEmpty) {
          widget.sendEvent(widget.controlId, event, payload);
        }
        return true;
      default:
        throw Exception('Unknown route invoke method: $method');
    }
  }

  void _emitRouteChange(String routeId) {
    if (widget.controlId.isEmpty) return;
    final now = DateTime.now();
    final throttleMs =
        (coerceOptionalInt(widget.props['route_event_throttle_ms']) ?? 48)
            .clamp(0, 1000);
    if (throttleMs > 0 &&
        _lastEmittedRouteId == routeId &&
        _lastRouteEmitAt != null &&
        now.difference(_lastRouteEmitAt!).inMilliseconds < throttleMs) {
      return;
    }
    _lastEmittedRouteId = routeId;
    _lastRouteEmitAt = now;
    widget.sendEvent(widget.controlId, 'change', {'route_id': routeId});
    if (widget.props['emit_route_change_alias'] == true) {
      widget.sendEvent(widget.controlId, 'route_change', {'route_id': routeId});
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildRouteViewControl(
      widget.props,
      widget.rawChildren,
      widget.buildChild,
    );
  }
}

