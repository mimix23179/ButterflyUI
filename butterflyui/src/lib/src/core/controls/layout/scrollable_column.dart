import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildScrollableColumnControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ScrollableColumnControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ScrollableColumnControl extends StatefulWidget {
  const _ScrollableColumnControl({
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
  State<_ScrollableColumnControl> createState() => _ScrollableColumnControlState();
}

class _ScrollableColumnControlState extends State<_ScrollableColumnControl> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    final initialOffset = coerceDouble(widget.props['initial_offset']) ?? 0.0;
    _controller = ScrollController(initialScrollOffset: initialOffset);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ScrollableColumnControl oldWidget) {
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
    _controller.dispose();
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    if (!_controller.hasClients) {
      throw StateError('ScrollableColumn has no attached ScrollPosition');
    }
    final position = _controller.position;

    Future<void> moveTo(double target) async {
      final animate = args['animate'] == null ? true : (args['animate'] == true);
      final durationMs = coerceOptionalInt(args['duration_ms']) ?? 250;
      final clamped = target
          .clamp(position.minScrollExtent, position.maxScrollExtent)
          .toDouble();
      if (animate) {
        await _controller.animateTo(
          clamped,
          duration: Duration(milliseconds: durationMs),
          curve: Curves.easeOutCubic,
        );
      } else {
        _controller.jumpTo(clamped);
      }
    }

    switch (method) {
      case 'get_scroll_metrics':
        return <String, Object?>{
          'pixels': position.pixels,
          'min_scroll_extent': position.minScrollExtent,
          'max_scroll_extent': position.maxScrollExtent,
          'viewport_dimension': position.viewportDimension,
        };
      case 'scroll_to':
        await moveTo(coerceDouble(args['offset']) ?? 0.0);
        return null;
      case 'scroll_to_start':
        await moveTo(position.minScrollExtent);
        return null;
      case 'scroll_to_end':
        await moveTo(position.maxScrollExtent);
        return null;
      default:
        throw UnsupportedError('Unknown scrollable_column method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = coerceDouble(widget.props['spacing'] ?? widget.props['gap']) ?? 0.0;
    final reverse = widget.props['reverse'] == true;
    final children = <Widget>[];

    for (final raw in widget.rawChildren) {
      if (raw is! Map) continue;
      children.add(widget.buildChild(coerceObjectMap(raw)));
    }

    if (spacing > 0 && children.length > 1) {
      final spaced = <Widget>[];
      for (var i = 0; i < children.length; i += 1) {
        if (i > 0) spaced.add(SizedBox(height: spacing));
        spaced.add(children[i]);
      }
      children
        ..clear()
        ..addAll(spaced);
    }

    return SingleChildScrollView(
      controller: _controller,
      reverse: reverse,
      padding: coercePadding(widget.props['content_padding']),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
