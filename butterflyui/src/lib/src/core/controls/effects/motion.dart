import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/candy/theme.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildMotionControl(
  String controlId,
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _MotionControl(
    controlId: controlId,
    props: props,
    rawChildren: rawChildren,
    buildChild: buildChild,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
  );
}

class _MotionControl extends StatefulWidget {
  const _MotionControl({
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
  State<_MotionControl> createState() => _MotionControlState();
}

class _MotionControlState extends State<_MotionControl>
    with SingleTickerProviderStateMixin {
  late Map<String, Object?> _state;
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;
  late final AnimationController _entryController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 240),
  );
  late Animation<double> _entryProgress = CurvedAnimation(
    parent: _entryController,
    curve: Curves.easeOutCubic,
  );

  @override
  void initState() {
    super.initState();
    _state = {...widget.props};
    _configureEntryAnimation(start: true);
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _MotionControl oldWidget) {
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
      _state = {...widget.props};
      _configureEntryAnimation(start: false);
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    _entryController.dispose();
    super.dispose();
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_props':
        setState(() {
          _state = {..._state, ...args};
          _configureEntryAnimation(start: false);
        });
        return _statePayload();
      case 'set_play':
        setState(() {
          _state['play'] = args['play'] == true;
          _configureEntryAnimation(start: true);
        });
        return _statePayload();
      case 'get_state':
        return _statePayload();
      default:
        throw UnsupportedError('Unknown motion method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      ..._state,
      'hovered': _hovered,
      'pressed': _pressed,
      'focused': _focused,
      'play': _state['play'] != false,
    };
  }

  void _configureEntryAnimation({required bool start}) {
    final duration = _resolveDuration(_state);
    if (_entryController.duration != duration) {
      _entryController.duration = duration;
    }
    _entryProgress = CurvedAnimation(
      parent: _entryController,
      curve: _parseCurve(_state['curve']) ?? Curves.easeOutCubic,
    );
    final play = _state['play'] != false;
    if (!play) {
      _entryController.value = 0.0;
      _entryController.stop();
      return;
    }
    if (start) {
      _entryController.forward(from: 0.0);
    } else if (!_entryController.isAnimating && _entryController.value == 0.0) {
      _entryController.forward(from: 0.0);
    }
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  void _setHover(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
    _emit('state_changed', {'state': 'hover', 'value': value});
  }

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
    _emit('state_changed', {'state': 'press', 'value': value});
  }

  void _setFocused(bool value) {
    if (_focused == value) return;
    setState(() => _focused = value);
    _emit('state_changed', {'state': 'focus', 'value': value});
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
    if (child is SizedBox && _state['child'] is Map) {
      child = widget.buildChild(coerceObjectMap(_state['child'] as Map));
    }

    final duration = _resolveDuration(_state);
    final curve = _parseCurve(_state['curve']) ?? Curves.easeOutCubic;
    final interactive = _state['interactive'] != false;
    final selected = _state['selected'] == true;
    final disabled = _state['disabled'] == true || _state['enabled'] == false;

    final presetName = (_state['preset'] ?? _state['motion'] ?? '')
        .toString()
        .toLowerCase()
        .replaceAll('-', '_');
    final presetStates = _presetStates(presetName, _state);
    final configuredStates = _coerceStateMap(_state['states']);
    final mergedStates = <String, Map<String, Object?>>{
      ...presetStates,
      ...configuredStates,
    };

    final fromMap = _coerceMap(_state['from']);
    final scalarTo = <String, Object?>{
      if (_state['opacity'] != null) 'opacity': _state['opacity'],
      if (_state['scale'] != null) 'scale': _state['scale'],
      if (_state['x'] != null) 'x': _state['x'],
      if (_state['y'] != null) 'y': _state['y'],
      if (_state['blur'] != null) 'blur': _state['blur'],
      if (_state['glow'] != null) 'glow': _state['glow'],
      if (_state['shadow'] != null) 'shadow': _state['shadow'],
    };
    final toMap = CandyTokens.mergeMaps(_coerceMap(_state['to']), scalarTo);

    return AnimatedBuilder(
      animation: _entryProgress,
      builder: (context, _) {
        final base = _interpolateMaps(fromMap, toMap, _entryProgress.value);
        var active = <String, Object?>{...base};
        if (disabled) {
          active = CandyTokens.mergeMaps(
            active,
            mergedStates['disabled'] ?? const {},
          );
        }
        if (selected) {
          active = CandyTokens.mergeMaps(
            active,
            mergedStates['selected'] ?? const {},
          );
        }
        if (_focused) {
          active = CandyTokens.mergeMaps(
            active,
            mergedStates['focus'] ?? const {},
          );
        }
        if (_hovered) {
          active = CandyTokens.mergeMaps(
            active,
            mergedStates['hover'] ?? const {},
          );
        }
        if (_pressed) {
          active = CandyTokens.mergeMaps(
            active,
            mergedStates['press'] ?? const {},
          );
        }

        final opacity = (coerceDouble(active['opacity']) ?? 1.0).clamp(
          0.0,
          1.0,
        );
        final scale = (coerceDouble(active['scale']) ?? 1.0).clamp(0.001, 8.0);
        final dx =
            _readOffset(active, axis: 'x') ?? coerceDouble(active['x']) ?? 0.0;
        final dy =
            _readOffset(active, axis: 'y') ?? coerceDouble(active['y']) ?? 0.0;
        final rotation =
            ((coerceDouble(active['rotation']) ??
                        coerceDouble(active['angle']) ??
                        0.0) /
                    360.0)
                .clamp(-1.0, 1.0);
        final blur = (coerceDouble(active['blur']) ?? 0.0).clamp(0.0, 120.0);
        final glow = _coerceMap(active['glow']);
        final shadow = _coerceMap(active['shadow']);

        final glowColor = coerceColor(glow['color']);
        final glowBlur = coerceDouble(glow['blur']) ?? 0.0;
        final glowSpread = coerceDouble(glow['spread']) ?? 0.0;
        final glowOpacity = (coerceDouble(glow['opacity']) ?? 0.0).clamp(
          0.0,
          1.0,
        );

        final shadowColor =
            coerceColor(shadow['color']) ??
            Colors.black.withValues(alpha: 0.18);
        final shadowBlur = coerceDouble(shadow['blur']) ?? 0.0;
        final shadowSpread = coerceDouble(shadow['spread']) ?? 0.0;
        final shadowDx = coerceDouble(shadow['x']) ?? 0.0;
        final shadowDy = coerceDouble(shadow['y']) ?? 0.0;

        final boxShadows = <BoxShadow>[];
        if (shadowBlur > 0 || shadowSpread > 0) {
          boxShadows.add(
            BoxShadow(
              color: shadowColor,
              blurRadius: shadowBlur,
              spreadRadius: shadowSpread,
              offset: Offset(shadowDx, shadowDy),
            ),
          );
        }
        if (glowColor != null &&
            (glowBlur > 0 || glowSpread > 0) &&
            glowOpacity > 0) {
          boxShadows.add(
            BoxShadow(
              color: glowColor.withValues(alpha: glowOpacity),
              blurRadius: glowBlur,
              spreadRadius: glowSpread,
              offset: Offset.zero,
            ),
          );
        }

        Widget out = child;
        out = AnimatedContainer(
          duration: duration,
          curve: curve,
          decoration: BoxDecoration(
            boxShadow: boxShadows.isEmpty ? null : boxShadows,
          ),
          child: out,
        );
        if (blur > 0) {
          out = ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: out,
          );
        }
        out = TweenAnimationBuilder<Offset>(
          tween: Tween<Offset>(begin: Offset.zero, end: Offset(dx, dy)),
          duration: duration,
          curve: curve,
          builder: (context, offset, animatedChild) {
            return Transform.translate(offset: offset, child: animatedChild);
          },
          child: out,
        );
        out = AnimatedRotation(
          turns: rotation,
          duration: duration,
          curve: curve,
          child: out,
        );
        out = AnimatedScale(
          scale: scale,
          duration: duration,
          curve: curve,
          child: out,
        );
        out = AnimatedOpacity(
          opacity: opacity,
          duration: duration,
          curve: curve,
          child: out,
        );

        if (!interactive || disabled) return out;
        return Focus(
          onFocusChange: _setFocused,
          child: MouseRegion(
            onEnter: (_) => _setHover(true),
            onExit: (_) => _setHover(false),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTapDown: (_) => _setPressed(true),
              onTapUp: (_) => _setPressed(false),
              onTapCancel: () => _setPressed(false),
              child: out,
            ),
          ),
        );
      },
    );
  }
}

Duration _resolveDuration(Map<String, Object?> props) {
  final explicit = (coerceOptionalInt(props['duration_ms']) ?? -1).clamp(
    -1,
    600000,
  );
  if (explicit > 0) return Duration(milliseconds: explicit);
  final token = (props['duration'] ?? '').toString().toLowerCase();
  switch (token) {
    case 'short':
      return const Duration(milliseconds: 120);
    case 'long':
      return const Duration(milliseconds: 360);
    case 'medium':
    default:
      return const Duration(milliseconds: 220);
  }
}

Curve? _parseCurve(Object? value) {
  final s = value?.toString().toLowerCase().replaceAll('-', '_');
  switch (s) {
    case 'linear':
      return Curves.linear;
    case 'ease_in':
    case 'easein':
      return Curves.easeIn;
    case 'ease_out':
    case 'easeout':
      return Curves.easeOut;
    case 'ease_in_out':
    case 'easeinout':
      return Curves.easeInOut;
    case 'emphasized':
      return const Cubic(0.2, 0.0, 0.0, 1.0);
    case 'spring':
      return Curves.elasticOut;
    case 'fast_out_slow_in':
    case 'fastoutslowin':
      return Curves.fastOutSlowIn;
    case 'ease_out_cubic':
    case 'easeoutcubic':
      return Curves.easeOutCubic;
  }
  return null;
}

Map<String, Object?> _coerceMap(Object? raw) {
  if (raw is Map) return coerceObjectMap(raw);
  return <String, Object?>{};
}

double? _readOffset(Map<String, Object?> map, {required String axis}) {
  final raw = map['offset'] ?? map['translate'] ?? map['position'];
  if (raw is List && raw.length >= 2) {
    return coerceDouble(axis == 'x' ? raw[0] : raw[1]);
  }
  if (raw is Map) {
    final m = coerceObjectMap(raw);
    return coerceDouble(m[axis]);
  }
  return null;
}

Map<String, Map<String, Object?>> _coerceStateMap(Object? raw) {
  final out = <String, Map<String, Object?>>{};
  if (raw is! Map) return out;
  final source = coerceObjectMap(raw);
  for (final entry in source.entries) {
    if (entry.value is Map) {
      out[entry.key.toLowerCase()] = coerceObjectMap(entry.value as Map);
    }
  }
  return out;
}

Map<String, Map<String, Object?>> _presetStates(
  String preset,
  Map<String, Object?> props,
) {
  final states = <String, Map<String, Object?>>{};
  switch (preset) {
    case 'hover_lift':
      states['hover'] = {
        'y': -2.0,
        'scale': 1.01,
        'shadow': {'blur': 10.0, 'y': 4.0},
      };
      states['press'] = {'scale': 0.985, 'y': 0.0};
      break;
    case 'press_sink':
      states['press'] = {'scale': 0.975, 'y': 0.0};
      break;
    case 'hover_lift_glow':
      states['hover'] = {
        'y': -2.0,
        'scale': 1.02,
        'glow': {
          'color': props['glow_color'] ?? '#38bdf8',
          'blur': coerceDouble(props['glow_blur']) ?? 18.0,
          'spread': coerceDouble(props['glow_spread']) ?? 2.0,
          'opacity': coerceDouble(props['glow_opacity']) ?? 0.78,
        },
      };
      states['press'] = {'scale': 0.98, 'y': 0.0};
      break;
    case 'focus_pulse':
      states['focus'] = {
        'scale': 1.01,
        'glow': {
          'color': props['glow_color'] ?? '#60a5fa',
          'blur': 14.0,
          'opacity': 0.62,
        },
      };
      break;
    case 'enter_fade_up':
      states['hover'] = {'y': -1.0};
      break;
    case 'shared_axis':
      final axis = (props['axis'] ?? 'y').toString().toLowerCase();
      if (axis == 'x') {
        states['hover'] = {'x': 4.0};
      } else if (axis == 'z') {
        states['hover'] = {'scale': 1.02};
      } else {
        states['hover'] = {'y': -2.0};
      }
      break;
  }
  return states;
}

Map<String, Object?> _interpolateMaps(
  Map<String, Object?> from,
  Map<String, Object?> to,
  double t,
) {
  if (from.isEmpty && to.isEmpty) return const <String, Object?>{};
  if (from.isEmpty) return to;
  if (to.isEmpty) return from;
  final out = <String, Object?>{};
  final keys = <String>{...from.keys, ...to.keys};
  for (final key in keys) {
    final a = from[key];
    final b = to[key];
    final ad = coerceDouble(a);
    final bd = coerceDouble(b);
    if (ad != null && bd != null) {
      out[key] = lerpDouble(ad, bd, t);
      continue;
    }
    if (a is Map && b is Map) {
      out[key] = _interpolateMaps(coerceObjectMap(a), coerceObjectMap(b), t);
      continue;
    }
    out[key] = t < 0.5 ? (a ?? b) : (b ?? a);
  }
  return out;
}
