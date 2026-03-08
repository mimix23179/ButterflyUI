import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/control_shells/base_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_shells/layout_control_shell.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildWrapControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  CandyTokens tokens,
  Widget Function(Map<String, Object?> child) buildFromControl,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _WrapControl(
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

class _WrapControl extends StatefulWidget {
  const _WrapControl({
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
  State<_WrapControl> createState() => _WrapControlState();
}

class _WrapControlState extends State<_WrapControl> {
  late double _spacing;
  late double _runSpacing;
  late WrapAlignment _alignment;
  late WrapAlignment _runAlignment;
  late WrapCrossAlignment _crossAxis;
  late Axis _direction;
  late VerticalDirection _verticalDirection;
  late Clip _clipBehavior;

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
  void didUpdateWidget(covariant _WrapControl oldWidget) {
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
        coerceDouble(widget.props['spacing']) ??
        widget.tokens.number('spacing', 'sm') ??
        0.0;
    _runSpacing = coerceDouble(widget.props['run_spacing']) ?? _spacing;
    _alignment =
        parseLayoutWrapAlignment(widget.props['alignment']) ??
        WrapAlignment.start;
    _runAlignment =
        parseLayoutWrapAlignment(widget.props['run_alignment']) ??
        WrapAlignment.start;
    _direction = parseLayoutAxis(widget.props['direction']) ?? Axis.horizontal;
    _crossAxis =
        parseLayoutWrapCrossAlignment(
          widget.props['cross_axis'] ?? widget.props['cross_alignment'],
          axis: _direction,
        ) ??
        WrapCrossAlignment.start;
    _verticalDirection =
        _parseVerticalDirection(widget.props['vertical_direction']) ??
        VerticalDirection.down;
    _clipBehavior = parseLayoutClip(widget.props['clip_behavior']) ?? Clip.none;
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_layout':
        setState(() {
          final nextDirection =
              parseLayoutAxis(args['direction']) ?? _direction;
          _spacing = coerceDouble(args['spacing']) ?? _spacing;
          _runSpacing = coerceDouble(args['run_spacing']) ?? _runSpacing;
          _alignment =
              parseLayoutWrapAlignment(args['alignment']) ?? _alignment;
          _runAlignment =
              parseLayoutWrapAlignment(args['run_alignment']) ?? _runAlignment;
          _crossAxis =
              parseLayoutWrapCrossAlignment(
                args['cross_axis'] ?? args['cross_alignment'],
                axis: nextDirection,
              ) ??
              _crossAxis;
          _direction = nextDirection;
          if (args.containsKey('vertical_direction')) {
            _verticalDirection =
                _parseVerticalDirection(args['vertical_direction']) ??
                _verticalDirection;
          }
          if (args.containsKey('clip_behavior')) {
            _clipBehavior =
                parseLayoutClip(args['clip_behavior']) ?? _clipBehavior;
          }
        });
        return _statePayload();
      case 'get_state':
      case 'get_layout':
        return _statePayload();
      default:
        throw UnsupportedError('Unknown wrap method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'spacing': _spacing,
      'run_spacing': _runSpacing,
      'alignment': _alignment.name,
      'run_alignment': _runAlignment.name,
      'cross_axis': _crossAxis.name,
      'direction': _direction == Axis.horizontal ? 'horizontal' : 'vertical',
      'vertical_direction': _verticalDirection.name,
      if (_clipBehavior != Clip.none) 'clip_behavior': _clipBehavior.name,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: _spacing,
      runSpacing: _runSpacing,
      alignment: _alignment,
      runAlignment: _runAlignment,
      crossAxisAlignment: _crossAxis,
      direction: _direction,
      verticalDirection: _verticalDirection,
      clipBehavior: _clipBehavior,
      children: resolveControlChildMaps(
        widget.rawChildren,
        widget.props,
      ).map(widget.buildFromControl).toList(),
    );
  }
}

VerticalDirection? _parseVerticalDirection(Object? value) {
  switch (value?.toString().toLowerCase()) {
    case 'up':
      return VerticalDirection.up;
    case 'down':
      return VerticalDirection.down;
  }
  return null;
}
