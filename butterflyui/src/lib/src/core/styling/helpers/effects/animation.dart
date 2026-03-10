import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/styling/theme.dart';
import 'package:butterflyui_runtime/src/core/styling/helpers/helper_bridge.dart';
import 'package:butterflyui_runtime/src/core/styling/effects/visuals/renderers/render_layers.dart';
import 'package:butterflyui_runtime/src/core/control_shells/runtime_props_control.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildAnimationControl(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild, {
  String controlId = '',
  ButterflyUIRegisterInvokeHandler? registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler? unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent? sendEvent,
}) {
  return buildRuntimePropsControl(
    props: props,
    controlId: controlId,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
    sendEvent: sendEvent,
    builder: (liveProps) {
      final resolvedProps = resolveStylingHelperProps(
        liveProps,
        controlType: 'animation',
      );
      return wrapWithEffectRenderLayers(
        controlId: controlId.isEmpty ? 'animation' : controlId,
        props: resolvedProps,
        child: _AnimationControl(
          props: resolvedProps,
          rawChildren: rawChildren,
          buildChild: buildChild,
        ),
      );
    },
  );
}

class _AnimationControl extends StatefulWidget {
  const _AnimationControl({
    required this.props,
    required this.rawChildren,
    required this.buildChild,
  });

  final Map<String, Object?> props;
  final List<dynamic> rawChildren;
  final Widget Function(Map<String, Object?> child) buildChild;

  @override
  State<_AnimationControl> createState() => _AnimationControlState();
}

class _AnimationControlState extends State<_AnimationControl>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;
  Duration _duration = const Duration(milliseconds: 220);

  @override
  void initState() {
    super.initState();
    _duration = _resolveDuration(widget.props);
    _controller = AnimationController(vsync: this, duration: _duration);
    _progress = CurvedAnimation(
      parent: _controller,
      curve: _parseCurve(widget.props['curve']) ?? Curves.easeOutCubic,
    );
    _startOrStop();
  }

  @override
  void didUpdateWidget(covariant _AnimationControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextDuration = _resolveDuration(widget.props);
    if (_duration != nextDuration) {
      _duration = nextDuration;
      _controller.duration = _duration;
    }
    _progress = CurvedAnimation(
      parent: _controller,
      curve: _parseCurve(widget.props['curve']) ?? Curves.easeOutCubic,
    );
    _startOrStop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startOrStop() {
    final enabled = widget.props['enabled'] != false;
    final play = widget.props['play'] != false;
    if (!enabled || !play) {
      _controller.value = widget.props['reverse'] == true ? 1.0 : 0.0;
      _controller.stop();
      return;
    }
    final repeat = widget.props['repeat'] == true;
    final mirror = widget.props['mirror'] == true;
    final delayMs = (coerceOptionalInt(widget.props['delay_ms']) ?? 0).clamp(
      0,
      600000,
    );
    void kick() {
      if (!mounted) return;
      if (repeat) {
        _controller.repeat(reverse: mirror);
      } else {
        _controller.forward(from: 0.0);
      }
    }

    if (delayMs > 0) {
      _controller.stop();
      Future<void>.delayed(Duration(milliseconds: delayMs), kick);
    } else {
      kick();
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = _resolveChild(
      widget.props,
      widget.rawChildren,
      widget.buildChild,
    );
    final reverse = widget.props['reverse'] == true;
    final track = _buildTrack(widget.props);

    if (widget.props['enabled'] == false) {
      return child;
    }
    return AnimatedBuilder(
      animation: _progress,
      child: child,
      builder: (context, builtChild) {
        final t = reverse ? (1.0 - _progress.value) : _progress.value;
        final sampled = _sampleTrack(track, t.clamp(0.0, 1.0));
        return _composeFrame(sampled, builtChild ?? const SizedBox.shrink());
      },
    );
  }
}

Widget _composeFrame(Map<String, Object?> frame, Widget child) {
  Widget out = child;
  final opacity = (_readDouble(frame, 'opacity') ?? 1.0).clamp(0.0, 1.0);
  final scale = (_readDouble(frame, 'scale') ?? 1.0).clamp(0.001, 10.0);
  final x =
      _readDouble(frame, 'x') ??
      _readDouble(frame, 'translate_x') ??
      _readOffset(frame, axis: 'x');
  final y =
      _readDouble(frame, 'y') ??
      _readDouble(frame, 'translate_y') ??
      _readOffset(frame, axis: 'y');
  final rotationDeg =
      _readDouble(frame, 'rotation') ??
      _readDouble(frame, 'angle') ??
      _readDouble(frame, 'rotate') ??
      0.0;
  final rotation = rotationDeg * (math.pi / 180.0);
  final blur = (_readDouble(frame, 'blur') ?? 0).clamp(0.0, 120.0);
  final glowBlur =
      (_readDouble(frame, 'glow_blur') ??
              _readDouble(frame, 'shadow_blur') ??
              0)
          .clamp(0.0, 120.0);
  final glowSpread =
      (_readDouble(frame, 'glow_spread') ??
      _readDouble(frame, 'shadow_spread') ??
      0);
  final glowOpacity =
      (_readDouble(frame, 'glow_opacity') ??
              _readDouble(frame, 'shadow_opacity') ??
              0.0)
          .clamp(0.0, 1.0);
  final glowColor =
      _readColor(frame, 'glow_color') ??
      _readColor(frame, 'shadow_color') ??
      _readColor(frame, 'color');
  final tint = _readColor(frame, 'color');

  if (x != null || y != null) {
    out = Transform.translate(offset: Offset(x ?? 0.0, y ?? 0.0), child: out);
  }
  if (rotation != 0) {
    out = Transform.rotate(angle: rotation, child: out);
  }
  if (scale != 1.0) {
    out = Transform.scale(scale: scale, child: out);
  }
  if (blur > 0) {
    out = ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: out,
    );
  }
  if (glowBlur > 0 && glowOpacity > 0) {
    out = DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: (glowColor ?? Colors.white).withValues(alpha: glowOpacity),
            blurRadius: glowBlur,
            spreadRadius: glowSpread,
            offset: Offset.zero,
          ),
        ],
      ),
      child: out,
    );
  }
  if (tint != null) {
    out = ColorFiltered(
      colorFilter: ColorFilter.mode(
        tint.withValues(alpha: 0.24),
        BlendMode.srcATop,
      ),
      child: out,
    );
  }
  if (opacity != 1.0) {
    out = Opacity(opacity: opacity, child: out);
  }
  return out;
}

List<_FramePoint> _buildTrack(Map<String, Object?> props) {
  final from = props['from'] is Map
      ? coerceObjectMap(props['from'] as Map)
      : <String, Object?>{};
  final to = props['to'] is Map
      ? coerceObjectMap(props['to'] as Map)
      : <String, Object?>{};
  final scalarTo = <String, Object?>{
    if (props['opacity'] != null) 'opacity': props['opacity'],
    if (props['scale'] != null) 'scale': props['scale'],
    if (props['offset'] != null) 'offset': props['offset'],
    if (props['rotation'] != null) 'rotation': props['rotation'],
    if (props['blur'] != null) 'blur': props['blur'],
    if (props['color'] != null) 'color': props['color'],
  };
  final mergedTo = StylingTokens.mergeMaps(to, scalarTo);

  final points = <_FramePoint>[
    _FramePoint(t: 0.0, props: from),
    _FramePoint(t: 1.0, props: mergedTo),
  ];

  final rawKeyframes = props['keyframes'];
  if (rawKeyframes is List) {
    points.clear();
    for (final entry in rawKeyframes) {
      if (entry is! Map) continue;
      final map = coerceObjectMap(entry);
      final t =
          (coerceDouble(
                    map['t'] ?? map['time'] ?? map['at'] ?? map['progress'],
                  ) ??
                  0.0)
              .clamp(0.0, 1.0);
      final frameProps = map['props'] is Map
          ? coerceObjectMap(map['props'] as Map)
          : map;
      points.add(_FramePoint(t: t, props: frameProps));
    }
    if (points.isEmpty || points.first.t > 0.0) {
      points.add(_FramePoint(t: 0.0, props: from));
    }
    if (points.every((f) => f.t < 1.0)) {
      points.add(_FramePoint(t: 1.0, props: mergedTo));
    }
  }
  points.sort((a, b) => a.t.compareTo(b.t));
  return points;
}

Map<String, Object?> _sampleTrack(List<_FramePoint> points, double t) {
  if (points.isEmpty) return const <String, Object?>{};
  if (t <= points.first.t) return points.first.props;
  if (t >= points.last.t) return points.last.props;
  for (var i = 0; i < points.length - 1; i += 1) {
    final a = points[i];
    final b = points[i + 1];
    if (t < a.t || t > b.t) continue;
    final span = (b.t - a.t).abs();
    final localT = span <= 0.000001 ? 0.0 : ((t - a.t) / span).clamp(0.0, 1.0);
    return _interpolateMaps(a.props, b.props, localT);
  }
  return points.last.props;
}

Map<String, Object?> _interpolateMaps(
  Map<String, Object?> a,
  Map<String, Object?> b,
  double t,
) {
  final keys = <String>{...a.keys, ...b.keys};
  final out = <String, Object?>{};
  for (final key in keys) {
    final av = a[key];
    final bv = b[key];
    final ad = coerceDouble(av);
    final bd = coerceDouble(bv);
    if (ad != null && bd != null) {
      out[key] = lerpDouble(ad, bd, t);
      continue;
    }
    final ac = coerceColor(av);
    final bc = coerceColor(bv);
    if (ac != null && bc != null) {
      out[key] = Color.lerp(ac, bc, t);
      continue;
    }
    if (t < 0.5) {
      out[key] = av ?? bv;
    } else {
      out[key] = bv ?? av;
    }
  }
  return out;
}

Widget _resolveChild(
  Map<String, Object?> props,
  List<dynamic> rawChildren,
  Widget Function(Map<String, Object?> child) buildChild,
) {
  for (final raw in rawChildren) {
    if (raw is Map) return buildChild(coerceObjectMap(raw));
  }
  final propChild = props['child'];
  if (propChild is Map) return buildChild(coerceObjectMap(propChild));
  return const SizedBox.shrink();
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
      return const Duration(milliseconds: 160);
    case 'long':
      return const Duration(milliseconds: 420);
    case 'medium':
    default:
      return const Duration(milliseconds: 260);
  }
}

double? _readDouble(Map<String, Object?> frame, String key) =>
    coerceDouble(frame[key]);

double? _readOffset(Map<String, Object?> frame, {required String axis}) {
  final offset = frame['offset'] ?? frame['translate'] ?? frame['position'];
  if (offset is List && offset.length >= 2) {
    return coerceDouble(axis == 'x' ? offset[0] : offset[1]);
  }
  if (offset is Map) {
    final map = coerceObjectMap(offset);
    return coerceDouble(map[axis]);
  }
  return null;
}

Color? _readColor(Map<String, Object?> frame, String key) =>
    coerceColor(frame[key]);

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

class _FramePoint {
  final double t;
  final Map<String, Object?> props;

  const _FramePoint({required this.t, required this.props});
}
