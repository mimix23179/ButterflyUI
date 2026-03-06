import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/control_shells/base_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_shells/layout_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildCardControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  CandyTokens tokens,
  Widget Function(Map<String, Object?> child) buildFromControl,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _CardControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    tokens: tokens,
    buildFromControl: buildFromControl,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _CardControl extends StatefulWidget {
  const _CardControl({
    required this.controlId,
    required this.props,
    required this.rawChildren,
    required this.tokens,
    required this.buildFromControl,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final CandyTokens tokens;
  final Widget Function(Map<String, Object?> child) buildFromControl;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_CardControl> createState() => _CardControlState();
}

class _CardControlState extends State<_CardControl> {
  late Map<String, Object?> _liveProps;

  @override
  void initState() {
    super.initState();
    _liveProps = <String, Object?>{...widget.props};
    registerInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      handler: _handleInvoke,
    );
  }

  @override
  void didUpdateWidget(covariant _CardControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    syncInvokeHandlerRegistration(
      previousControlId: oldWidget.controlId,
      currentControlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
      handler: _handleInvoke,
    );
    if (oldWidget.props != widget.props) {
      _liveProps = <String, Object?>{...widget.props};
    }
  }

  @override
  void dispose() {
    unregisterInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
    );
    super.dispose();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_style':
      case 'set_layout':
        setState(() {
          _liveProps = <String, Object?>{..._liveProps, ...args};
        });
        return _statePayload();
      case 'get_state':
      case 'get_layout':
        return _statePayload();
      default:
        throw UnsupportedError('Unknown card method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      if (_liveProps['bgcolor'] != null) 'bgcolor': _liveProps['bgcolor'],
      if (_liveProps['border_color'] != null)
        'border_color': _liveProps['border_color'],
      if (_liveProps['border_width'] != null)
        'border_width': _liveProps['border_width'],
      if (_liveProps['radius'] != null) 'radius': _liveProps['radius'],
      if (_liveProps['elevation'] != null) 'elevation': _liveProps['elevation'],
    };
  }

  @override
  Widget build(BuildContext context) {
    final childMap = firstControlChildMap(widget.rawChildren);
    Widget cardChild = childMap == null
        ? const SizedBox.shrink()
        : widget.buildFromControl(childMap);
    final contentPadding = coercePadding(_liveProps['content_padding']);
    if (contentPadding != null) {
      cardChild = Padding(padding: contentPadding, child: cardChild);
    }
    final contentAlignment = parseLayoutAlignment(
      _liveProps['content_alignment'],
    );
    if (contentAlignment != null) {
      cardChild = Align(alignment: contentAlignment, child: cardChild);
    }
    final bgColor =
        coerceColor(_liveProps['bgcolor']) ?? widget.tokens.color('surface');
    final borderColor =
        coerceColor(_liveProps['border_color']) ??
        widget.tokens.color('border');
    final borderWidth = coerceDouble(_liveProps['border_width']) ?? 0.0;
    final radius =
        coerceDouble(_liveProps['radius']) ??
        widget.tokens.number('card', 'radius') ??
        widget.tokens.number('radii', 'md');
    final elevation =
        coerceDouble(_liveProps['elevation']) ??
        widget.tokens.number('card', 'elevation') ??
        0.0;
    final shape = RoundedRectangleBorder(
      borderRadius: radius == null
          ? BorderRadius.zero
          : BorderRadius.circular(radius),
      side: borderColor == null || borderWidth <= 0
          ? BorderSide.none
          : BorderSide(color: borderColor, width: borderWidth),
    );
    return Card(
      color: bgColor,
      elevation: elevation,
      margin: EdgeInsets.zero,
      shape: shape,
      child: cardChild,
    );
  }
}
