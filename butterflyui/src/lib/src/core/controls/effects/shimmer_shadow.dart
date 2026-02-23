import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildShimmerControl(
  String controlId,
  Map<String, Object?> props,
  Widget child,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
) {
  return _ShimmerControl(
    controlId: controlId,
    props: props,
    child: child,
    registerInvokeHandler: registerInvokeHandler,
    unregisterInvokeHandler: unregisterInvokeHandler,
  );
}

class _ShimmerControl extends StatefulWidget {
  const _ShimmerControl({
    required this.controlId,
    required this.props,
    required this.child,
    required this.registerInvokeHandler,
    required this.unregisterInvokeHandler,
  });

  final String controlId;
  final Map<String, Object?> props;
  final Widget child;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;

  @override
  State<_ShimmerControl> createState() => _ShimmerControlState();
}

class _ShimmerControlState extends State<_ShimmerControl>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _playing = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _updateTimingAndPlayback();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ShimmerControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlId != widget.controlId) {
      if (oldWidget.controlId.isNotEmpty) {
        oldWidget.unregisterInvokeHandler(oldWidget.controlId);
      }
      if (widget.controlId.isNotEmpty) {
        widget.registerInvokeHandler(widget.controlId, _handleInvoke);
      }
    }
    _updateTimingAndPlayback();
  }

  void _updateTimingAndPlayback() {
    final durationMs = (coerceOptionalInt(widget.props['duration_ms']) ?? 1200)
        .clamp(200, 600000);
    _controller.duration = Duration(milliseconds: durationMs);
    if (_playing) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    _controller.dispose();
    super.dispose();
  }

  Future<Object?> _handleInvoke(String method, Map<String, Object?> args) async {
    switch (method) {
      case 'start':
      case 'play':
        _playing = true;
        _controller.repeat();
        return true;
      case 'stop':
      case 'pause':
        _playing = false;
        _controller.stop();
        return true;
      case 'get_state':
        return {
          'playing': _playing,
          'duration_ms': _controller.duration?.inMilliseconds,
        };
      default:
        throw UnsupportedError('Unknown shimmer method: $method');
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseColor =
        coerceColor(widget.props['base_color']) ??
        Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.45);
    final highlightColor =
        coerceColor(widget.props['highlight_color']) ??
        Theme.of(context).colorScheme.surface.withOpacity(0.75);
    final opacity = (coerceDouble(widget.props['opacity']) ?? 0.85)
        .clamp(0.0, 1.0)
        .toDouble();
    final angleDegrees = coerceDouble(widget.props['angle']) ?? 18.0;
    final angle = angleDegrees * math.pi / 180.0;

    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final t = _controller.value;
        final begin = Alignment(-1.2 + (2.4 * t), -0.2);
        final end = Alignment(-0.2 + (2.4 * t), 0.2);
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (rect) {
            return LinearGradient(
              begin: begin,
              end: end,
              colors: [baseColor, highlightColor, baseColor],
              stops: const [0.1, 0.5, 0.9],
              transform: GradientRotation(angle),
            ).createShader(rect);
          },
          child: Opacity(opacity: opacity, child: child),
        );
      },
    );
  }
}

Widget buildShadowStackControl(
  Map<String, Object?> props,
  Widget child,
) {
  final radius = coerceDouble(props['radius']) ?? 12;
  final shadows = _coerceShadowList(props['shadows']);
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      boxShadow: shadows,
    ),
    child: child,
  );
}

List<BoxShadow> _coerceShadowList(Object? value) {
  if (value is List) {
    final parsed = <BoxShadow>[];
    for (final item in value) {
      if (item is! Map) continue;
      final map = coerceObjectMap(item);
      parsed.add(
        BoxShadow(
          color: coerceColor(map['color']) ?? const Color(0x33000000),
          blurRadius: coerceDouble(map['blur']) ?? 8,
          spreadRadius: coerceDouble(map['spread']) ?? 0,
          offset: Offset(
            coerceDouble(map['offset_x']) ?? 0,
            coerceDouble(map['offset_y']) ?? 2,
          ),
        ),
      );
    }
    if (parsed.isNotEmpty) return parsed;
  }
  return const [
    BoxShadow(color: Color(0x1F000000), blurRadius: 8, offset: Offset(0, 2)),
    BoxShadow(color: Color(0x14000000), blurRadius: 20, offset: Offset(0, 8)),
  ];
}
