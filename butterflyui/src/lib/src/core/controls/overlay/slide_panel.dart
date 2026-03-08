import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_theme.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildSlidePanelControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ButterflyUISlidePanelControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ButterflyUISlidePanelControl extends StatefulWidget {
  const _ButterflyUISlidePanelControl({
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
  State<_ButterflyUISlidePanelControl> createState() =>
      _ButterflyUISlidePanelControlState();
}

class _ButterflyUISlidePanelControlState
    extends State<_ButterflyUISlidePanelControl> {
  Map<String, Object?> _liveProps = const <String, Object?>{};
  bool _open = false;
  String _side = 'left';
  double _size = 280;
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
  void didUpdateWidget(covariant _ButterflyUISlidePanelControl oldWidget) {
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
    _liveProps = <String, Object?>{...props};
    _open = _liveProps['open'] == true;
    _side = _normalizeSide(
      _liveProps['side']?.toString() ?? _liveProps['position']?.toString(),
    );
    _size =
        coerceDouble(
          _liveProps['size'] ?? _liveProps['width'] ?? _liveProps['height'],
        ) ??
        280.0;
    _dismissible = _liveProps['dismissible'] == null
        ? true
        : (_liveProps['dismissible'] == true);
    _scrimColor = coerceColor(_liveProps['scrim_color']);
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
          final incoming = args['props'];
          if (incoming is Map) {
            final map = coerceObjectMap(incoming);
            setState(() {
              _syncFromProps(<String, Object?>{..._liveProps, ...map});
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
        throw UnsupportedError('Unknown slide_panel method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'open': _open,
      'side': _side,
      'size': _size,
      'dismissible': _dismissible,
    };
  }

  String _normalizeSide(String? raw) {
    switch ((raw ?? '').toLowerCase()) {
      case 'right':
      case 'top':
      case 'bottom':
      case 'left':
        return raw!.toLowerCase();
      default:
        return 'left';
    }
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
    setState(() {
      _open = next;
    });
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

  @override
  Widget build(BuildContext context) {
    Widget child = const SizedBox.shrink();
    for (final raw in widget.rawChildren) {
      if (raw is Map) {
        child = widget.buildChild(coerceObjectMap(raw));
        break;
      }
    }
    if (child is SizedBox && _liveProps['child'] is Map) {
      child = widget.buildChild(coerceObjectMap(_liveProps['child'] as Map));
    }

    final durationMs =
        coerceOptionalInt(
          _liveProps['duration_ms'] ?? _liveProps['duration'],
        ) ??
        220;
    final curve = _curveFrom(_liveProps['curve']?.toString());

    final size = MediaQuery.of(context).size;
    final horizontal = _side == 'left' || _side == 'right';
    final panelSize = (_size <= 0)
        ? (horizontal ? size.width * 0.3 : size.height * 0.3)
        : _size;

    final panelColor =
        coerceColor(_liveProps['bgcolor'] ?? _liveProps['background']) ??
        Theme.of(context).colorScheme.surface;
    final elevation = coerceDouble(_liveProps['elevation']) ?? 4.0;
    final radius = coerceDouble(_liveProps['radius']) ?? 0.0;
    final panelMargin =
        coercePadding(_liveProps['margin'] ?? _liveProps['panel_margin']) ??
        EdgeInsets.zero;
    final panelClip =
        coerceClipBehavior(_liveProps['clip_behavior']) ?? Clip.antiAlias;

    double left = 0;
    double top = 0;
    double? right;
    double? bottom;

    if (_side == 'left') {
      left = _open
          ? panelMargin.left
          : -(panelSize + panelMargin.left + panelMargin.right);
      top = panelMargin.top;
      bottom = panelMargin.bottom;
    } else if (_side == 'right') {
      right = _open
          ? panelMargin.right
          : -(panelSize + panelMargin.left + panelMargin.right);
      top = panelMargin.top;
      bottom = panelMargin.bottom;
    } else if (_side == 'top') {
      top = _open
          ? panelMargin.top
          : -(panelSize + panelMargin.top + panelMargin.bottom);
      left = panelMargin.left;
      right = panelMargin.right;
    } else {
      bottom = _open
          ? panelMargin.bottom
          : -(panelSize + panelMargin.top + panelMargin.bottom);
      left = panelMargin.left;
      right = panelMargin.right;
    }

    return Stack(
      children: [
        if (_open)
          Positioned.fill(
            child: GestureDetector(
              onTap: _dismissible ? _dismiss : null,
              child: Container(
                color: _scrimColor ?? butterflyuiScrim(context, opacity: 0.54),
              ),
            ),
          ),
        AnimatedPositioned(
          duration: Duration(milliseconds: durationMs.clamp(0, 2000)),
          curve: curve,
          left: _side == 'right' ? null : left,
          right: _side == 'right' ? right : null,
          top: _side == 'bottom' ? null : top,
          bottom: _side == 'bottom' ? bottom : null,
          width: horizontal ? panelSize : null,
          height: horizontal ? null : panelSize,
          child: Material(
            type: MaterialType.transparency,
            child: Material(
              elevation: elevation,
              color: panelColor,
              clipBehavior: panelClip,
              borderRadius: radius <= 0 ? null : BorderRadius.circular(radius),
              child: child,
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
