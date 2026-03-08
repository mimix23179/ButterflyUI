import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildPortalControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ButterflyUIPortal(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _ButterflyUIPortal extends StatefulWidget {
  const _ButterflyUIPortal({
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
  State<_ButterflyUIPortal> createState() => _ButterflyUIPortalState();
}

class _ButterflyUIPortalState extends State<_ButterflyUIPortal> {
  Map<String, Object?> _liveProps = const <String, Object?>{};
  bool _open = true;

  @override
  void initState() {
    super.initState();
    _syncFromProps(widget.props);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ButterflyUIPortal oldWidget) {
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
    _open = _liveProps['open'] == null ? true : (_liveProps['open'] == true);
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_open':
        {
          setState(() {
            _open = args['value'] == true || args['open'] == true;
            _liveProps = <String, Object?>{..._liveProps, 'open': _open};
          });
          return _statePayload();
        }
      case 'set_props':
        {
          final incoming = args['props'];
          if (incoming is Map) {
            setState(() {
              _syncFromProps(<String, Object?>{
                ..._liveProps,
                ...coerceObjectMap(incoming),
              });
            });
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
        throw UnsupportedError('Unknown portal method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'open': _open,
      'dismissible': _liveProps['dismissible'] == true,
      'passthrough': _liveProps['passthrough'] == true,
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) {
      return;
    }
    widget.sendEvent(widget.controlId, event, payload);
  }

  Map<String, Object?>? _baseMap() {
    if (_liveProps['child'] is Map) {
      return coerceObjectMap(_liveProps['child'] as Map);
    }
    if (widget.rawChildren.isNotEmpty && widget.rawChildren.first is Map) {
      return coerceObjectMap(widget.rawChildren.first as Map);
    }
    return null;
  }

  Map<String, Object?>? _portalMap() {
    if (_liveProps['portal'] is Map) {
      return coerceObjectMap(_liveProps['portal'] as Map);
    }
    if (_liveProps['overlay'] is Map) {
      return coerceObjectMap(_liveProps['overlay'] as Map);
    }
    if (widget.rawChildren.length > 1 && widget.rawChildren[1] is Map) {
      return coerceObjectMap(widget.rawChildren[1] as Map);
    }
    return null;
  }

  Alignment? _coerceAlignment(Object? value) {
    if (value == null) return null;
    if (value is List && value.length >= 2) {
      final x = coerceDouble(value[0]) ?? 0.0;
      final y = coerceDouble(value[1]) ?? 0.0;
      return Alignment(x, y);
    }
    if (value is Map) {
      final map = coerceObjectMap(value);
      final x = coerceDouble(map['x']) ?? 0.0;
      final y = coerceDouble(map['y']) ?? 0.0;
      return Alignment(x, y);
    }
    switch (value.toString().toLowerCase().replaceAll('-', '_')) {
      case 'center':
        return Alignment.center;
      case 'top':
      case 'top_center':
        return Alignment.topCenter;
      case 'bottom':
      case 'bottom_center':
        return Alignment.bottomCenter;
      case 'left':
      case 'center_left':
      case 'start':
        return Alignment.centerLeft;
      case 'right':
      case 'center_right':
      case 'end':
        return Alignment.centerRight;
      case 'top_left':
        return Alignment.topLeft;
      case 'top_right':
        return Alignment.topRight;
      case 'bottom_left':
        return Alignment.bottomLeft;
      case 'bottom_right':
        return Alignment.bottomRight;
      default:
        return null;
    }
  }

  Offset? _coerceOffset(Object? value) {
    if (value is List && value.length >= 2) {
      final x = coerceDouble(value[0]) ?? 0.0;
      final y = coerceDouble(value[1]) ?? 0.0;
      return Offset(x, y);
    }
    if (value is Map) {
      final map = coerceObjectMap(value);
      final x = coerceDouble(map['x']) ?? 0.0;
      final y = coerceDouble(map['y']) ?? 0.0;
      return Offset(x, y);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final baseMap = _baseMap();
    final portalMap = _portalMap();
    final base = baseMap == null
        ? const SizedBox.shrink()
        : widget.buildChild(baseMap);
    final open = _open;
    final dismissible = _liveProps['dismissible'] == true;
    final passThrough = _liveProps['passthrough'] == true;
    final scrimColor = coerceColor(_liveProps['scrim_color']);
    final alignment =
        _coerceAlignment(_liveProps['alignment']) ?? Alignment.center;
    final offset = _coerceOffset(_liveProps['offset']) ?? Offset.zero;
    final clip = _liveProps['clip'] == true ? Clip.antiAlias : Clip.none;

    final portalChild = portalMap == null
        ? const SizedBox.shrink()
        : Align(
            alignment: alignment,
            child: Transform.translate(
              offset: offset,
              child: widget.buildChild(portalMap),
            ),
          );

    return Stack(
      clipBehavior: clip,
      fit: StackFit.expand,
      children: <Widget>[
        base,
        if (open && dismissible)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  _open = false;
                  _liveProps = <String, Object?>{..._liveProps, 'open': false};
                });
                _emit('dismiss', _statePayload());
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: scrimColor ?? Colors.transparent,
                ),
              ),
            ),
          ),
        if (open)
          Positioned.fill(
            child: IgnorePointer(ignoring: passThrough, child: portalChild),
          ),
      ],
    );
  }
}
