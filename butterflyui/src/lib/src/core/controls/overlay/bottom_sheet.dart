import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_theme.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildBottomSheetControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _BottomSheetControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _BottomSheetControl extends StatefulWidget {
  const _BottomSheetControl({
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
  State<_BottomSheetControl> createState() => _BottomSheetControlState();
}

class _BottomSheetControlState extends State<_BottomSheetControl>
    with SingleTickerProviderStateMixin {
  late bool _open;
  late double _height;
  double? _maxHeight;
  double? _minHeight;
  bool _dismissible = true;
  Color? _scrimColor;

  @override
  void initState() {
    super.initState();
    _syncFromProps(widget.props);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _BottomSheetControl oldWidget) {
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
      _syncFromProps(widget.props);
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  void _syncFromProps(Map<String, Object?> props) {
    _open = props['open'] == true;
    _height = coerceDouble(props['height']) ?? 320.0;
    _maxHeight = coerceDouble(props['max_height']);
    _minHeight = coerceDouble(props['min_height']);
    _dismissible = props['dismissible'] == null
        ? true
        : (props['dismissible'] == true);
    _scrimColor = coerceColor(props['scrim_color']);
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_open':
        {
          final next = args['value'] == true || args['open'] == true;
          _setOpen(next, emitLifecycle: true);
          return _statePayload();
        }
      case 'set_props':
        {
          final rawProps = args['props'];
          if (rawProps is Map) {
            final props = coerceObjectMap(rawProps);
            setState(() {
              if (props.containsKey('open')) {
                _open = props['open'] == true;
              }
              if (props.containsKey('height')) {
                _height = coerceDouble(props['height']) ?? _height;
              }
              if (props.containsKey('max_height')) {
                _maxHeight = coerceDouble(props['max_height']);
              }
              if (props.containsKey('min_height')) {
                _minHeight = coerceDouble(props['min_height']);
              }
              if (props.containsKey('dismissible')) {
                _dismissible = props['dismissible'] == true;
              }
              if (props.containsKey('scrim_color')) {
                _scrimColor = coerceColor(props['scrim_color']);
              }
            });
            _emit('state', _statePayload());
          }
          return _statePayload();
        }
      case 'get_state':
        return _statePayload();
      case 'emit':
      case 'trigger':
        {
          final fallback = method == 'trigger' ? 'change' : method;
          final event = (args['event'] ?? args['name'] ?? fallback).toString();
          final payload = args['payload'] is Map
              ? coerceObjectMap(args['payload'] as Map)
              : <String, Object?>{};
          _emit(event, payload);
          return true;
        }
      default:
        throw UnsupportedError('Unknown bottom_sheet method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'open': _open,
      'height': _height,
      'max_height': _maxHeight,
      'min_height': _minHeight,
      'dismissible': _dismissible,
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  void _setOpen(bool next, {required bool emitLifecycle}) {
    if (_open == next) {
      _emit('state', _statePayload());
      return;
    }
    setState(() => _open = next);
    if (emitLifecycle) {
      _emit(next ? 'open' : 'close', _statePayload());
      _emit('change', _statePayload());
    }
    _emit('state', _statePayload());
  }

  void _dismiss() {
    if (!_dismissible) return;
    _setOpen(false, emitLifecycle: true);
    _emit('dismiss', _statePayload());
  }

  Widget _resolveChild() {
    for (final raw in widget.rawChildren) {
      if (raw is Map) {
        return widget.buildChild(coerceObjectMap(raw));
      }
    }
    final nested = widget.props['child'];
    if (nested is Map) {
      return widget.buildChild(coerceObjectMap(nested));
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final viewSize = MediaQuery.of(context).size;
    final durationMs =
        coerceOptionalInt(
          widget.props['duration_ms'] ?? widget.props['duration'],
        ) ??
        220;
    final curve = _curveFrom(widget.props['curve']?.toString());

    var targetHeight = _height;
    if (_maxHeight != null) {
      targetHeight = targetHeight.clamp(0.0, _maxHeight!);
    }
    if (_minHeight != null) {
      targetHeight = targetHeight.clamp(_minHeight!, double.infinity);
    }
    if (targetHeight <= 0) {
      targetHeight = viewSize.height * 0.35;
    }

    final radius = coerceDouble(widget.props['radius']) ?? 16.0;
    final elevation = coerceDouble(widget.props['elevation']) ?? 8.0;
    final background =
        coerceColor(widget.props['bgcolor'] ?? widget.props['background']) ??
        Theme.of(context).colorScheme.surface;
    final panelAlignment =
        coerceAlignmentGeometry(
          widget.props['alignment'] ??
              widget.props['align'] ??
              widget.props['panel_alignment'],
        ) ??
        Alignment.bottomCenter;
    final panelMargin =
        coercePadding(widget.props['margin'] ?? widget.props['panel_margin']) ??
        EdgeInsets.zero;
    final panelWidth = coerceDouble(
      widget.props['width'] ?? widget.props['panel_width'],
    );
    final panelMinWidth = coerceDouble(
      widget.props['min_width'] ?? widget.props['panel_min_width'],
    );
    final panelMaxWidth = coerceDouble(
      widget.props['max_width'] ?? widget.props['panel_max_width'],
    );
    final panelClip =
        coerceClipBehavior(widget.props['clip_behavior']) ?? Clip.antiAlias;
    final showHandle =
        widget.props['show_handle'] == null ||
        widget.props['show_handle'] == true;

    Widget panel = Material(
      color: background,
      elevation: elevation,
      borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
      clipBehavior: panelClip,
      child: SizedBox(
        height: targetHeight,
        child: Column(
          children: [
            if (showHandle)
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 6),
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            Expanded(child: _resolveChild()),
          ],
        ),
      ),
    );
    if (panelWidth != null) {
      panel = SizedBox(width: panelWidth, child: panel);
    }
    if (panelMinWidth != null || panelMaxWidth != null) {
      panel = ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: panelMinWidth ?? 0,
          maxWidth: panelMaxWidth ?? double.infinity,
        ),
        child: panel,
      );
    }
    if (panelMargin.left != 0 ||
        panelMargin.top != 0 ||
        panelMargin.right != 0 ||
        panelMargin.bottom != 0) {
      panel = Padding(padding: panelMargin, child: panel);
    }

    return Stack(
      children: [
        if (_open)
          Positioned.fill(
            child: GestureDetector(
              onTap: _dismissible ? _dismiss : null,
              child: AnimatedOpacity(
                opacity: _open ? 1 : 0,
                duration: Duration(milliseconds: durationMs.clamp(0, 2000)),
                curve: curve,
                child: Container(
                  color:
                      _scrimColor ?? butterflyuiScrim(context, opacity: 0.54),
                ),
              ),
            ),
          ),
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !_open,
            child: Align(
              alignment: panelAlignment,
              child: AnimatedSlide(
                offset: _open ? Offset.zero : const Offset(0, 1),
                duration: Duration(milliseconds: durationMs.clamp(0, 2000)),
                curve: curve,
                child: panel,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Curve _curveFrom(String? raw) {
    switch ((raw ?? '').toLowerCase().replaceAll('-', '_')) {
      case 'linear':
        return Curves.linear;
      case 'ease_in':
      case 'easein':
        return Curves.easeIn;
      case 'ease_in_out':
      case 'easeinout':
        return Curves.easeInOut;
      default:
        return Curves.easeOutCubic;
    }
  }
}
