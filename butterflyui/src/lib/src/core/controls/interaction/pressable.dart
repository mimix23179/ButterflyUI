import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildPressableControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _PressableControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _PressableControl extends StatefulWidget {
  const _PressableControl({
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
  State<_PressableControl> createState() => _PressableControlState();
}

class _PressableControlState extends State<_PressableControl> {
  late bool _enabled;
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _PressableControl oldWidget) {
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
      _syncFromProps();
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  void _syncFromProps() {
    _enabled =
        widget.props['enabled'] == null || widget.props['enabled'] == true;
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_enabled':
        setState(() => _enabled = args['enabled'] != false);
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'press').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        if (widget.controlId.isNotEmpty) {
          widget.sendEvent(widget.controlId, event, payload);
        }
        return null;
      default:
        throw UnsupportedError('Unknown pressable method: $method');
    }
  }

  Map<String, Object?> _statePayload() => <String, Object?>{
    'enabled': _enabled,
    'hovered': _hovered,
    'focused': _focused,
    'pressed': _pressed,
  };

  @override
  Widget build(BuildContext context) {
    final hoverEnabled =
        widget.props['hover_enabled'] == null ||
        widget.props['hover_enabled'] == true;
    final focusEnabled =
        widget.props['focus_enabled'] == null ||
        widget.props['focus_enabled'] == true;
    final pressedOpacity =
        (coerceDouble(widget.props['pressed_opacity']) ?? 0.92)
            .clamp(0.1, 1.0)
            .toDouble();
    final radius = (coerceDouble(widget.props['border_radius']) ?? 8.0)
        .clamp(0.0, 999.0)
        .toDouble();
    final splashColor = coerceColor(widget.props['splash_color']);
    final hoverColor = coerceColor(widget.props['hover_color']);
    final focusColor = coerceColor(widget.props['focus_color']);

    Widget child = const SizedBox.shrink();
    for (final raw in widget.rawChildren) {
      if (raw is Map) {
        child = widget.buildChild(coerceObjectMap(raw));
        break;
      }
    }

    if (!_enabled) {
      return child;
    }

    return FocusableActionDetector(
      enabled: _enabled,
      onFocusChange: focusEnabled
          ? (focused) {
              setState(() => _focused = focused);
              if (widget.controlId.isNotEmpty) {
                widget.sendEvent(widget.controlId, 'focus', {
                  'focused': focused,
                  ..._statePayload(),
                });
              }
            }
          : null,
      onShowHoverHighlight: hoverEnabled
          ? (hovered) {
              setState(() => _hovered = hovered);
              if (widget.controlId.isNotEmpty) {
                widget.sendEvent(widget.controlId, 'hover', {
                  'hovered': hovered,
                  ..._statePayload(),
                });
              }
            }
          : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 120),
        opacity: _pressed ? pressedOpacity : 1.0,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            splashColor: splashColor,
            hoverColor: hoverColor,
            focusColor: focusColor,
            borderRadius: BorderRadius.circular(radius),
            onTap: widget.controlId.isEmpty
                ? null
                : () => widget.sendEvent(
                    widget.controlId,
                    'press',
                    _statePayload(),
                  ),
            onTapDown: (details) {
              setState(() => _pressed = true);
              if (widget.controlId.isNotEmpty) {
                widget.sendEvent(widget.controlId, 'press_down', {
                  'x': details.localPosition.dx,
                  'y': details.localPosition.dy,
                  ..._statePayload(),
                });
              }
            },
            onTapCancel: () {
              setState(() => _pressed = false);
              if (widget.controlId.isNotEmpty) {
                widget.sendEvent(
                  widget.controlId,
                  'press_cancel',
                  _statePayload(),
                );
              }
            },
            onTapUp: (details) {
              setState(() => _pressed = false);
              if (widget.controlId.isNotEmpty) {
                widget.sendEvent(widget.controlId, 'press_up', {
                  'x': details.localPosition.dx,
                  'y': details.localPosition.dy,
                  ..._statePayload(),
                });
              }
            },
            onLongPress: widget.controlId.isEmpty
                ? null
                : () => widget.sendEvent(
                    widget.controlId,
                    'long_press',
                    _statePayload(),
                  ),
            child: child,
          ),
        ),
      ),
    );
  }
}
