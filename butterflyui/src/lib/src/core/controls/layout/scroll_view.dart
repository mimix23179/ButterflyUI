import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/control_shells/layout_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_shells/scrollable_control_shell.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildScrollViewControl(
  String controlId,
  Map<String, Object?> props,
  List children,
  Widget Function(Map<String, Object?> child) buildFromControl,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUIScrollView(
    controlId: controlId,
    props: props,
    children: children,
    buildFromControl: buildFromControl,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class ButterflyUIScrollView extends StatefulWidget {
  final String controlId;
  final Map<String, Object?> props;
  final List children;
  final Widget Function(Map<String, Object?> child) buildFromControl;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  const ButterflyUIScrollView({
    super.key,
    required this.controlId,
    required this.props,
    required this.children,
    required this.buildFromControl,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  @override
  State<ButterflyUIScrollView> createState() => _ButterflyUIScrollViewState();
}

class _ButterflyUIScrollViewState extends State<ButterflyUIScrollView> {
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
  void didUpdateWidget(covariant ButterflyUIScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }

    final oldInitial = coerceDouble(oldWidget.props['initial_offset']);
    final nextInitial = coerceDouble(widget.props['initial_offset']);
    if (nextInitial != null &&
        nextInitial != oldInitial &&
        _controller.hasClients) {
      final position = _controller.position;
      final clamped = nextInitial
          .clamp(position.minScrollExtent, position.maxScrollExtent)
          .toDouble();
      if (position.pixels != clamped) {
        _controller.jumpTo(clamped);
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
    final axis =
        parseScrollableAxis(widget.props['direction']) ?? Axis.vertical;
    final reverse = widget.props['reverse'] == true;
    return handleScrollableInvoke(
      controlType: 'scroll_view',
      controller: _controller,
      axis: axis,
      reverse: reverse,
      method: method,
      args: args,
    );
  }

  @override
  Widget build(BuildContext context) {
    final childMaps = resolveControlChildMaps(widget.children, widget.props);
    final direction =
        parseScrollableAxis(widget.props['direction']) ?? Axis.vertical;
    final contentPadding = coercePadding(widget.props['content_padding']);
    final reverse = widget.props['reverse'] == true;
    final spacing =
        coerceDouble(
          widget.props['content_gap'] ??
              widget.props['spacing'] ??
              widget.props['gap'],
        ) ??
        0.0;

    final events = coerceScrollableEvents(widget.props['events']);
    final content = _buildScrollableContent(
      childMaps: childMaps,
      direction: direction,
      spacing: spacing,
      buildFromControl: widget.buildFromControl,
    );

    Widget scrollable = SingleChildScrollView(
      controller: _controller,
      scrollDirection: direction,
      reverse: reverse,
      padding: contentPadding,
      child: content,
    );

    return wrapScrollableNotifications(
      child: scrollable,
      controller: _controller,
      controlId: widget.controlId,
      events: events,
      sendEvent: widget.sendEvent,
    );
  }
}

Widget _buildScrollableContent({
  required List<Map<String, Object?>> childMaps,
  required Axis direction,
  required double spacing,
  required Widget Function(Map<String, Object?> child) buildFromControl,
}) {
  if (childMaps.isEmpty) {
    return const SizedBox.shrink();
  }

  if (childMaps.length == 1) {
    return buildFromControl(childMaps.first);
  }

  final children = childMaps.map(buildFromControl).toList();
  if (direction == Axis.horizontal) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: buildSpacedChildren(children, Axis.horizontal, spacing),
    );
  }
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: buildSpacedChildren(children, Axis.vertical, spacing),
  );
}
