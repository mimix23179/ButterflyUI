import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_theme.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Offset? _parseOffset(Object? value) {
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

Curve _curveFromName(String? name) {
  final normalized = (name ?? '')
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');
  switch (normalized) {
    case 'linear':
      return Curves.linear;
    case 'easein':
    case 'ease_in':
      return Curves.easeIn;
    case 'easeout':
    case 'ease_out':
      return Curves.easeOut;
    case 'easeinout':
    case 'ease_in_out':
      return Curves.easeInOut;
    case 'fastoutslowin':
    case 'fast_out_slow_in':
      return Curves.fastOutSlowIn;
    case 'easeoutcubic':
    case 'ease_out_cubic':
    default:
      return Curves.easeOutCubic;
  }
}

Widget buildPopoverControl(
  String controlId,
  Map<String, Object?> props,
  Widget anchor,
  Widget content,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return ButterflyUIPopover(
    controlId: controlId,
    props: props,
    anchor: anchor,
    content: content,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class ButterflyUIPopover extends StatefulWidget {
  const ButterflyUIPopover({
    super.key,
    required this.controlId,
    required this.props,
    required this.anchor,
    required this.content,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.sendEvent,
  });

  final String controlId;
  final Map<String, Object?> props;
  final Widget anchor;
  final Widget content;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<ButterflyUIPopover> createState() => _ButterflyUIPopoverState();
}

class _ButterflyUIPopoverState extends State<ButterflyUIPopover> {
  final LayerLink _link = LayerLink();
  Map<String, Object?> _liveProps = const <String, Object?>{};
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _syncFromProps(widget.props);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant ButterflyUIPopover oldWidget) {
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
        throw UnsupportedError('Unknown popover method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'open': _open,
      'position': _position,
      'dismissible': _dismissible,
      'offset': <double>[_offset.dx, _offset.dy],
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) {
      return;
    }
    widget.sendEvent(widget.controlId, event, payload);
  }

  String get _position => _liveProps['position']?.toString() ?? 'bottom';

  Offset get _offset => _parseOffset(_liveProps['offset']) ?? Offset.zero;

  bool get _dismissible =>
      _liveProps['dismissible'] == null || _liveProps['dismissible'] == true;

  Duration get _duration => Duration(
    milliseconds:
        (coerceOptionalInt(
                  _liveProps['duration_ms'] ??
                      (_liveProps['transition'] is Map
                          ? coerceObjectMap(
                              _liveProps['transition'] as Map,
                            )['duration_ms']
                          : null),
                ) ??
                180)
            .clamp(0, 2000),
  );

  String get _transitionType {
    final transition = _liveProps['transition'] is Map
        ? coerceObjectMap(_liveProps['transition'] as Map)
        : const <String, Object?>{};
    return (_liveProps['transition_type']?.toString() ??
            transition['type']?.toString() ??
            'fade')
        .toLowerCase();
  }

  Curve get _transitionCurve {
    final transition = _liveProps['transition'] is Map
        ? coerceObjectMap(_liveProps['transition'] as Map)
        : const <String, Object?>{};
    return _curveFromName(transition['curve']?.toString() ?? 'ease_out_cubic');
  }

  Alignment _targetAnchor() {
    switch (_position.toLowerCase()) {
      case 'top':
        return Alignment.topCenter;
      case 'left':
        return Alignment.centerLeft;
      case 'right':
        return Alignment.centerRight;
      case 'bottom':
      default:
        return Alignment.bottomCenter;
    }
  }

  Alignment _followerAnchor() {
    switch (_position.toLowerCase()) {
      case 'top':
        return Alignment.bottomCenter;
      case 'left':
        return Alignment.centerRight;
      case 'right':
        return Alignment.centerLeft;
      case 'bottom':
      default:
        return Alignment.topCenter;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CompositedTransformTarget(link: _link, child: widget.anchor),
        if (_open && _dismissible)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  _open = false;
                  _liveProps = <String, Object?>{..._liveProps, 'open': false};
                });
                _emit('dismiss', _statePayload());
                _emit('close', _statePayload());
              },
              child: Container(
                color:
                    coerceColor(_liveProps['scrim_color']) ??
                    butterflyuiScrim(context, opacity: 0.0),
              ),
            ),
          ),
        if (_open)
          Positioned.fill(
            child: CompositedTransformFollower(
              link: _link,
              offset: _offset,
              targetAnchor: _targetAnchor(),
              followerAnchor: _followerAnchor(),
              child: AnimatedSwitcher(
                duration: _duration,
                switchInCurve: _transitionCurve,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  final curved = CurvedAnimation(
                    parent: animation,
                    curve: _transitionCurve,
                  );
                  final normalizedType = _transitionType
                      .trim()
                      .toLowerCase()
                      .replaceAll('-', '_')
                      .replaceAll(' ', '_');
                  switch (normalizedType) {
                    case 'slide':
                    case 'glass_sheet':
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.04),
                          end: Offset.zero,
                        ).animate(curved),
                        child: FadeTransition(opacity: curved, child: child),
                      );
                    case 'zoom':
                    case 'pop':
                      return ScaleTransition(
                        scale: Tween<double>(
                          begin: 0.96,
                          end: 1.0,
                        ).animate(curved),
                        child: FadeTransition(opacity: curved, child: child),
                      );
                    case 'fade':
                    default:
                      return FadeTransition(opacity: curved, child: child);
                  }
                },
                child: KeyedSubtree(
                  key: ValueKey<String>(
                    'popover:${widget.controlId}:${widget.content.hashCode}:${_open ? 1 : 0}',
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: widget.content,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
