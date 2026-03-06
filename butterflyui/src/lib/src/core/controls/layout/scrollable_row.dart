import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/control_shells/scrollable_control_shell.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildScrollableRowControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ScrollableRowControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ScrollableRowControl extends StatefulWidget {
  const _ScrollableRowControl({
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
  State<_ScrollableRowControl> createState() => _ScrollableRowControlState();
}

class _ScrollableRowControlState extends State<_ScrollableRowControl> {
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
  void didUpdateWidget(covariant _ScrollableRowControl oldWidget) {
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

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    return handleScrollableInvoke(
      controlType: 'scrollable_row',
      controller: _controller,
      axis: Axis.horizontal,
      reverse: widget.props['reverse'] == true,
      method: method,
      args: args,
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing =
        coerceDouble(widget.props['spacing'] ?? widget.props['gap']) ?? 0.0;
    final reverse = widget.props['reverse'] == true;
    final children = <Widget>[];

    for (final raw in widget.rawChildren) {
      if (raw is! Map) continue;
      children.add(widget.buildChild(coerceObjectMap(raw)));
    }

    if (spacing > 0 && children.length > 1) {
      final spaced = <Widget>[];
      for (var i = 0; i < children.length; i += 1) {
        if (i > 0) spaced.add(SizedBox(width: spacing));
        spaced.add(children[i]);
      }
      children
        ..clear()
        ..addAll(spaced);
    }

    final scrollable = SingleChildScrollView(
      controller: _controller,
      reverse: reverse,
      scrollDirection: Axis.horizontal,
      padding: coercePadding(widget.props['content_padding']),
      child: Row(children: children),
    );

    return wrapScrollableNotifications(
      child: scrollable,
      controller: _controller,
      controlId: widget.controlId,
      events: coerceScrollableEvents(widget.props['events']),
      sendEvent: widget.sendEvent,
    );
  }
}
