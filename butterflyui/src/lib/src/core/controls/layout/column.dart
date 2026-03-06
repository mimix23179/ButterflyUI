import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/control_shells/base_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_shells/layout_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildColumnControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  CandyTokens tokens,
  Widget Function(Map<String, Object?> child) buildFromControl,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _FlexColumnControl(
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

class _FlexColumnControl extends StatefulWidget {
  const _FlexColumnControl({
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
  State<_FlexColumnControl> createState() => _FlexColumnControlState();
}

class _FlexColumnControlState extends State<_FlexColumnControl> {
  late double _spacing;
  late MainAxisAlignment _mainAxis;
  late CrossAxisAlignment _crossAxis;
  late MainAxisSize _mainAxisSize;
  late Clip? _clipBehavior;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    registerInvokeHandlerIfNeeded(
      controlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      handler: _handleInvoke,
    );
  }

  @override
  void didUpdateWidget(covariant _FlexColumnControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    syncInvokeHandlerRegistration(
      previousControlId: oldWidget.controlId,
      currentControlId: widget.controlId,
      registerInvokeHandler: widget.registerInvokeHandler,
      unregisterInvokeHandler: widget.unregisterInvokeHandler,
      handler: _handleInvoke,
    );
    if (oldWidget.props != widget.props) {
      _syncFromProps();
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

  void _syncFromProps() {
    _spacing =
        coerceDouble(widget.props['spacing'] ?? widget.props['gap']) ??
        widget.tokens.number('layout', 'column_spacing') ??
        widget.tokens.number('spacing', 'md') ??
        6.0;
    _mainAxis = parseLayoutMainAxisAlignment(
      widget.props['main_axis'],
      MainAxisAlignment.start,
    );
    _crossAxis = parseLayoutCrossAxisAlignment(
      widget.props['cross_axis'],
      CrossAxisAlignment.start,
      axis: Axis.vertical,
    );
    _mainAxisSize = parseLayoutMainAxisSize(widget.props['main_axis_size']);
    _clipBehavior = parseLayoutClip(widget.props['clip_behavior']);
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_layout':
        setState(() {
          _spacing = coerceDouble(args['spacing'] ?? args['gap']) ?? _spacing;
          _mainAxis = parseLayoutMainAxisAlignment(
            args['main_axis'],
            _mainAxis,
          );
          _crossAxis = parseLayoutCrossAxisAlignment(
            args['cross_axis'],
            _crossAxis,
            axis: Axis.vertical,
          );
          if (args.containsKey('main_axis_size')) {
            _mainAxisSize = parseLayoutMainAxisSize(args['main_axis_size']);
          }
          if (args.containsKey('clip_behavior')) {
            _clipBehavior = parseLayoutClip(args['clip_behavior']);
          }
        });
        return _statePayload();
      case 'get_state':
      case 'get_layout':
        return _statePayload();
      default:
        throw UnsupportedError('Unknown column method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'spacing': _spacing,
      'main_axis': _mainAxis.name,
      'cross_axis': _crossAxis.name,
      'main_axis_size': _mainAxisSize.name,
      if (_clipBehavior != null) 'clip_behavior': _clipBehavior!.name,
    };
  }

  @override
  Widget build(BuildContext context) {
    Widget column = Column(
      crossAxisAlignment: _crossAxis,
      mainAxisAlignment: _mainAxis,
      mainAxisSize: _mainAxisSize,
      textBaseline: _crossAxis == CrossAxisAlignment.baseline
          ? TextBaseline.alphabetic
          : null,
      children: buildFlexChildren(
        rawChildren: widget.rawChildren,
        axis: Axis.vertical,
        spacing: _spacing,
        parentMainAxisSize: _mainAxisSize,
        buildChild: widget.buildFromControl,
      ),
    );
    if (_clipBehavior != null) {
      column = ClipRect(clipBehavior: _clipBehavior!, child: column);
    }
    return column;
  }
}
