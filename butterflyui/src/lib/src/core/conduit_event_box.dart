import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show kPrimaryMouseButton;
import 'package:flutter/services.dart';

import 'webview/webview_api.dart';

class ConduitEventBox extends StatefulWidget {
  final String controlId;
  final String controlType;
  final Map<String, Object?> props;
  final List<String> events;
  final bool enabled;
  final ConduitSendRuntimeEvent sendEvent;
  final ConduitRegisterInvokeHandler registerInvokeHandler;
  final ConduitUnregisterInvokeHandler unregisterInvokeHandler;
  final Widget child;

  const ConduitEventBox({
    super.key,
    required this.controlId,
    required this.controlType,
    required this.props,
    required this.events,
    required this.enabled,
    required this.sendEvent,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
    required this.child,
  });

  @override
  State<ConduitEventBox> createState() => _ConduitEventBoxState();
}

class _ConduitEventBoxState extends State<ConduitEventBox> {
  late final FocusNode _focusNode = FocusNode(
    debugLabel: 'conduit:${widget.controlId}',
  );

  Offset? _lastTapLocal;
  Offset? _lastTapGlobal;
  int? _activePrimaryPointer;
  Offset? _primaryDownGlobal;
  bool _primaryMoved = false;
  int? _primaryDownTimestampMs;

  @override
  void initState() {
    super.initState();
    // Register focus-related imperative actions for any control.
    widget.registerInvokeHandler(widget.controlId, _handleInvoke);
  }

  @override
  void dispose() {
    widget.unregisterInvokeHandler(widget.controlId);
    _focusNode.dispose();
    super.dispose();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'request_focus':
        _focusNode.requestFocus();
        return true;
      case 'unfocus':
        _focusNode.unfocus();
        return true;
      case 'next_focus':
        return FocusScope.of(context).nextFocus();
      case 'previous_focus':
        return FocusScope.of(context).previousFocus();
      case 'is_focused':
        return _focusNode.hasFocus;
      default:
        // Not handled here.
        throw Exception('Unknown invoke method: $method');
    }
  }

  bool _has(String name) => widget.events.contains(name);

  Map<String, Object?> _basePayload() {
    return <String, Object?>{
      // conduit_session will also inject these, but adding here helps devtools/logs.
      'control_id': widget.controlId,
      'event_type': 'unknown',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'modifiers': _currentModifiers(),
    };
  }

  Map<String, Object?> _currentModifiers() {
    final pressed = HardwareKeyboard.instance.logicalKeysPressed;
    bool has(LogicalKeyboardKey k) => pressed.contains(k);
    final shift =
        has(LogicalKeyboardKey.shiftLeft) || has(LogicalKeyboardKey.shiftRight);
    final ctrl =
        has(LogicalKeyboardKey.controlLeft) ||
        has(LogicalKeyboardKey.controlRight);
    final alt =
        has(LogicalKeyboardKey.altLeft) || has(LogicalKeyboardKey.altRight);
    final meta =
        has(LogicalKeyboardKey.metaLeft) || has(LogicalKeyboardKey.metaRight);
    return <String, Object?>{
      'shift': shift,
      'ctrl': ctrl,
      'alt': alt,
      'meta': meta,
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    final enriched = <String, Object?>{};
    enriched.addAll(payload);
    enriched['event_type'] = event;
    widget.sendEvent(widget.controlId, event, enriched);
  }

  bool _shouldHandleClicks() {
    // Avoid double-firing for controls that already emit native click-ish events.
    // This is intentionally conservative.
    const native = <String>{
      'button',
      'elevated_button',
      'icon_button',
      'async_action_button',
      'pressable',
      'glyph_button',
      'chip',
      'tag_chip',
      'item_tile',
      'token',
      'checkbox',
      'switch',
      'slider',
      'select',
      'radio',
      'tabs',
      'accordion',
      'context_menu',
      'command_bar',
      'menu_bar',
    };
    return !native.contains(widget.controlType);
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (!_has('click')) return;
    // Only track primary-button pointer taps here. Using Listener avoids
    // GestureDetector tap-arena conflicts with interactive descendants.
    if (event.buttons != 0 && (event.buttons & kPrimaryMouseButton) == 0) {
      return;
    }
    _activePrimaryPointer = event.pointer;
    _primaryDownGlobal = event.position;
    _primaryMoved = false;
    _primaryDownTimestampMs = DateTime.now().millisecondsSinceEpoch;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (!_has('click')) return;
    if (_activePrimaryPointer == null ||
        _activePrimaryPointer != event.pointer) {
      return;
    }
    final start = _primaryDownGlobal;
    if (start == null) return;
    final dx = event.position.dx - start.dx;
    final dy = event.position.dy - start.dy;
    if ((dx * dx) + (dy * dy) > (6 * 6)) {
      _primaryMoved = true;
    }
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (!_has('click')) return;
    if (_activePrimaryPointer == null ||
        _activePrimaryPointer != event.pointer) {
      return;
    }
    final downTs = _primaryDownTimestampMs;
    final elapsed = downTs == null
        ? 0
        : DateTime.now().millisecondsSinceEpoch - downTs;
    final isTapLike = !_primaryMoved && elapsed <= 700;
    if (isTapLike) {
      final local = event.localPosition;
      final global = event.position;
      _lastTapLocal = local;
      _lastTapGlobal = global;
      _emit('click', <String, Object?>{
        ..._basePayload(),
        'local_x': local.dx,
        'local_y': local.dy,
        'global_x': global.dx,
        'global_y': global.dy,
      });
    }
    _resetPrimaryPointerState();
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    if (_activePrimaryPointer != null &&
        _activePrimaryPointer == event.pointer) {
      _resetPrimaryPointerState();
    }
  }

  void _resetPrimaryPointerState() {
    _activePrimaryPointer = null;
    _primaryDownGlobal = null;
    _primaryMoved = false;
    _primaryDownTimestampMs = null;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      // Still allow hover/focus events? For now, disable interactivity.
      return widget.child;
    }

    final wantsHover =
        _has('hover_enter') || _has('hover_exit') || _has('hover_move');
    final wantsFocus =
        _has('focus') ||
        _has('blur') ||
        _has('key_down') ||
        _has('key_up') ||
        widget.props['focusable'] == true;
    final wantsClick =
        (_has('click') ||
            _has('double_click') ||
            _has('long_press') ||
            _has('context_menu')) &&
        _shouldHandleClicks();
    final wantsPan = _has('pan_start') || _has('pan_update') || _has('pan_end');
    final wantsScale =
        _has('scale_start') || _has('scale_update') || _has('scale_end');

    Widget built = widget.child;

    if (wantsHover) {
      built = MouseRegion(
        onEnter: (e) {
          if (!_has('hover_enter')) return;
          _emit('hover_enter', <String, Object?>{
            ..._basePayload(),
            'local_x': e.localPosition.dx,
            'local_y': e.localPosition.dy,
            'global_x': e.position.dx,
            'global_y': e.position.dy,
            'buttons': e.buttons,
          });
        },
        onExit: (e) {
          if (!_has('hover_exit')) return;
          _emit('hover_exit', <String, Object?>{
            ..._basePayload(),
            'local_x': e.localPosition.dx,
            'local_y': e.localPosition.dy,
            'global_x': e.position.dx,
            'global_y': e.position.dy,
            'buttons': e.buttons,
          });
        },
        onHover: (e) {
          if (!_has('hover_move')) return;
          _emit('hover_move', <String, Object?>{
            ..._basePayload(),
            'local_x': e.localPosition.dx,
            'local_y': e.localPosition.dy,
            'global_x': e.position.dx,
            'global_y': e.position.dy,
            'buttons': e.buttons,
          });
        },
        child: built,
      );
    }

    if (wantsFocus) {
      final autofocus = widget.props['autofocus'] == true;
      final focusable =
          widget.props['focusable'] == true ||
          _has('focus') ||
          _has('blur') ||
          _has('key_down') ||
          _has('key_up');
      built = Focus(
        focusNode: _focusNode,
        autofocus: autofocus,
        canRequestFocus: focusable,
        onFocusChange: (hasFocus) {
          if (hasFocus && _has('focus')) {
            _emit('focus', <String, Object?>{..._basePayload()});
          }
          if (!hasFocus && _has('blur')) {
            _emit('blur', <String, Object?>{..._basePayload()});
          }
        },
        onKeyEvent: (node, evt) {
          if (_has('key_down') &&
              (evt is KeyDownEvent || evt is KeyRepeatEvent)) {
            final isRepeat = evt is KeyRepeatEvent;
            _emit('key_down', <String, Object?>{
              ..._basePayload(),
              'key': <String, Object?>{
                'logical': evt.logicalKey.keyLabel,
                'key_id': evt.logicalKey.keyId,
                'physical': evt.physicalKey.usbHidUsage,
                'repeat': isRepeat,
              },
            });
          } else if (evt is KeyUpEvent && _has('key_up')) {
            _emit('key_up', <String, Object?>{
              ..._basePayload(),
              'key': <String, Object?>{
                'logical': evt.logicalKey.keyLabel,
                'key_id': evt.logicalKey.keyId,
                'physical': evt.physicalKey.usbHidUsage,
              },
            });
          }
          return KeyEventResult.ignored;
        },
        child: built,
      );
    }

    if (wantsClick && _has('click')) {
      built = Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: _handlePointerDown,
        onPointerMove: _handlePointerMove,
        onPointerUp: _handlePointerUp,
        onPointerCancel: _handlePointerCancel,
        child: built,
      );
    }

    if (wantsClick || wantsPan || wantsScale) {
      built = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onDoubleTapDown: wantsClick
            ? (d) {
                _lastTapLocal = d.localPosition;
                _lastTapGlobal = d.globalPosition;
              }
            : null,
        onDoubleTap: wantsClick && _has('double_click')
            ? () {
                final local = _lastTapLocal;
                final global = _lastTapGlobal;
                _emit('double_click', <String, Object?>{
                  ..._basePayload(),
                  if (local != null) ...<String, Object?>{
                    'local_x': local.dx,
                    'local_y': local.dy,
                  },
                  if (global != null) ...<String, Object?>{
                    'global_x': global.dx,
                    'global_y': global.dy,
                  },
                });
              }
            : null,
        onLongPress: wantsClick && _has('long_press')
            ? () {
                final local = _lastTapLocal;
                final global = _lastTapGlobal;
                _emit('long_press', <String, Object?>{
                  ..._basePayload(),
                  if (local != null) ...<String, Object?>{
                    'local_x': local.dx,
                    'local_y': local.dy,
                  },
                  if (global != null) ...<String, Object?>{
                    'global_x': global.dx,
                    'global_y': global.dy,
                  },
                });
              }
            : null,
        onSecondaryTapDown: wantsClick && _has('context_menu')
            ? (d) => _emit('context_menu', <String, Object?>{
                ..._basePayload(),
                'local_x': d.localPosition.dx,
                'local_y': d.localPosition.dy,
                'global_x': d.globalPosition.dx,
                'global_y': d.globalPosition.dy,
              })
            : null,
        onPanStart: wantsPan && _has('pan_start')
            ? (d) => _emit('pan_start', <String, Object?>{
                ..._basePayload(),
                'local_x': d.localPosition.dx,
                'local_y': d.localPosition.dy,
                'global_x': d.globalPosition.dx,
                'global_y': d.globalPosition.dy,
              })
            : null,
        onPanUpdate: wantsPan && _has('pan_update')
            ? (d) => _emit('pan_update', <String, Object?>{
                ..._basePayload(),
                'local_x': d.localPosition.dx,
                'local_y': d.localPosition.dy,
                'global_x': d.globalPosition.dx,
                'global_y': d.globalPosition.dy,
                'delta_x': d.delta.dx,
                'delta_y': d.delta.dy,
              })
            : null,
        onPanEnd: wantsPan && _has('pan_end')
            ? (d) => _emit('pan_end', <String, Object?>{
                ..._basePayload(),
                'velocity_x': d.velocity.pixelsPerSecond.dx,
                'velocity_y': d.velocity.pixelsPerSecond.dy,
              })
            : null,
        onScaleStart: wantsScale && _has('scale_start')
            ? (d) => _emit('scale_start', <String, Object?>{
                ..._basePayload(),
                'focal_x': d.focalPoint.dx,
                'focal_y': d.focalPoint.dy,
              })
            : null,
        onScaleUpdate: wantsScale && _has('scale_update')
            ? (d) => _emit('scale_update', <String, Object?>{
                ..._basePayload(),
                'scale': d.scale,
                'rotation': d.rotation,
                'focal_x': d.focalPoint.dx,
                'focal_y': d.focalPoint.dy,
              })
            : null,
        onScaleEnd: wantsScale && _has('scale_end')
            ? (d) => _emit('scale_end', <String, Object?>{
                ..._basePayload(),
                'velocity_x': d.velocity.pixelsPerSecond.dx,
                'velocity_y': d.velocity.pixelsPerSecond.dy,
              })
            : null,
        child: built,
      );
    }

    return built;
  }
}
