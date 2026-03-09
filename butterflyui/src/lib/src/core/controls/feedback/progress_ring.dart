import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/styling/theme_extension.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildProgressRingControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ProgressRingControl(
    controlId,
    props,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}

class _ProgressRingControl extends StatefulWidget {
  const _ProgressRingControl(
    this.controlId,
    this.props,
    this.registerInvokeHandler,
    this.unregisterInvokeHandler,
    this.sendEvent,
  );

  final String controlId;
  final Map<String, Object?> props;
  final ButterflyUIRegisterInvokeHandler registerInvokeHandler;
  final ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler;
  final ButterflyUISendRuntimeEvent sendEvent;

  @override
  State<_ProgressRingControl> createState() => _ProgressRingControlState();
}

class _ProgressRingControlState extends State<_ProgressRingControl>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1700),
  );

  double? _value;

  @override
  void initState() {
    super.initState();
    _syncFromProps();
    _controller.repeat();
    if (widget.controlId.isNotEmpty) {
      widget.registerInvokeHandler(widget.controlId, _handleInvoke);
    }
  }

  @override
  void didUpdateWidget(covariant _ProgressRingControl oldWidget) {
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
    _controller.dispose();
    if (widget.controlId.isNotEmpty) {
      widget.unregisterInvokeHandler(widget.controlId);
    }
    super.dispose();
  }

  void _syncFromProps() {
    _value = _normalizeProgressValue(coerceDouble(widget.props['value']));
    final durationMs =
        (coerceOptionalInt(widget.props['animation_duration_ms']) ?? 1700)
            .clamp(300, 14000);
    _controller.duration = Duration(milliseconds: durationMs);
    if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  Future<Object?> _handleInvoke(
    String method,
    Map<String, Object?> args,
  ) async {
    switch (method) {
      case 'set_value':
        final next = _normalizeProgressValue(coerceDouble(args['value']));
        if (next != null || args.containsKey('value')) {
          setState(() => _value = next);
          _emit('change', _statePayload());
        }
        return _statePayload();
      case 'get_state':
        return _statePayload();
      case 'emit':
        final event = (args['event'] ?? 'change').toString();
        final payload = args['payload'] is Map
            ? coerceObjectMap(args['payload'] as Map)
            : <String, Object?>{};
        _emit(event, payload);
        return null;
      default:
        throw UnsupportedError('Unknown progress_ring method: $method');
    }
  }

  Map<String, Object?> _statePayload() {
    return <String, Object?>{
      'value': _value,
      'indeterminate': _value == null,
      if (_value != null) 'percent': (_value! * 100.0),
    };
  }

  void _emit(String event, Map<String, Object?> payload) {
    if (widget.controlId.isEmpty) return;
    widget.sendEvent(widget.controlId, event, payload);
  }

  @override
  Widget build(BuildContext context) {
    final propValue = _normalizeProgressValue(
      coerceDouble(widget.props['value']),
    );
    final value = _value ?? propValue;
    final indeterminate =
        widget.props['indeterminate'] == true || value == null;
    final variant = _normalizeProgressRingVariant(widget.props['variant']);
    final palette = _resolveProgressPalette(context, widget.props);
    final size = _resolveRingSize(widget.props);
    final strokeWidth =
        (coerceDouble(widget.props['stroke_width']) ??
                math.max(6.0, size * 0.12))
            .clamp(2.0, size / 2);
    final label = widget.props['label']?.toString();
    final helper =
        widget.props['helper']?.toString() ??
        widget.props['helper_text']?.toString();
    final showValue = widget.props['show_value'] == true;
    final centerLabel =
        widget.props['center_label']?.toString() ??
        (showValue
            ? _formatProgressValue(
                value,
                template: widget.props['value_template']?.toString(),
              )
            : null);

    Widget ring = AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return _buildRingIndicator(
          props: widget.props,
          palette: palette,
          variant: variant,
          value: value,
          indeterminate: indeterminate,
          size: size,
          strokeWidth: strokeWidth,
          phase: _controller.value,
          centerLabel: centerLabel,
        );
      },
    );

    Widget content = ring;
    if ((label != null && label.isNotEmpty) ||
        (helper != null && helper.isNotEmpty)) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          content,
          if (label != null && label.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: palette.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (helper != null && helper.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              helper,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: palette.textColor.withValues(alpha: 0.72),
                fontSize: 12,
              ),
            ),
          ],
        ],
      );
    }

    return _applyProgressTransparency(child: content, props: widget.props);
  }
}

Widget _buildRingIndicator({
  required Map<String, Object?> props,
  required _ProgressPalette palette,
  required String variant,
  required double? value,
  required bool indeterminate,
  required double size,
  required double strokeWidth,
  required double phase,
  required String? centerLabel,
}) {
  final glow = variant == 'glow' || props['glow'] == true;
  final padding = glow ? math.max(6.0, strokeWidth * 0.8) : 2.0;
  final startAngle = _resolveRingStartAngle(props, variant);
  final sweepAngle = _resolveRingSweepAngle(props, variant);
  final segments = (coerceOptionalInt(props['segments']) ?? 20).clamp(4, 96);
  final cap = _resolveStrokeCap(props['cap']);
  final textColor = palette.textColor;

  Widget ring = SizedBox.square(
    dimension: size + padding * 2,
    child: Center(
      child: SizedBox.square(
        dimension: size,
        child: CustomPaint(
          painter: _ProgressRingPainter(
            progress: value ?? 0.0,
            indeterminate: indeterminate,
            phase: phase,
            strokeWidth: strokeWidth,
            accent: palette.accent,
            trackColor: palette.trackColor,
            glowColor: palette.glowColor,
            gradientColors: _resolveProgressGradientColors(
              props,
              palette.accent,
              palette.accentAlt,
            ),
            gradientStops: _resolveProgressGradientStops(props),
            variant: variant,
            segments: segments,
            startAngle: startAngle,
            sweepAngle: sweepAngle,
            cap: cap,
            glow: glow,
          ),
        ),
      ),
    ),
  );

  if (centerLabel != null && centerLabel.isNotEmpty) {
    ring = Stack(
      alignment: Alignment.center,
      children: [
        ring,
        Padding(
          padding: EdgeInsets.all(padding + strokeWidth * 0.75),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              centerLabel,
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  return Align(alignment: Alignment.center, child: ring);
}

double _resolveRingSize(Map<String, Object?> props) {
  final explicit =
      coerceDouble(props['size']) ??
      _minNonNull(coerceDouble(props['width']), coerceDouble(props['height']));
  return (explicit ?? 56.0).clamp(24.0, 240.0);
}

double _resolveRingStartAngle(Map<String, Object?> props, String variant) {
  final explicitDegrees = coerceDouble(props['start_angle']);
  if (explicitDegrees != null) {
    return explicitDegrees * (math.pi / 180.0);
  }
  if (variant == 'dashboard') {
    return math.pi * 0.75;
  }
  return -math.pi / 2;
}

double _resolveRingSweepAngle(Map<String, Object?> props, String variant) {
  final explicitDegrees = coerceDouble(props['sweep_angle']);
  if (explicitDegrees != null) {
    return explicitDegrees.clamp(10.0, 360.0) * (math.pi / 180.0);
  }
  if (variant == 'dashboard') {
    return math.pi * 1.5;
  }
  return math.pi * 2;
}

StrokeCap _resolveStrokeCap(Object? value) {
  final normalized = value?.toString().trim().toLowerCase();
  switch (normalized) {
    case 'square':
      return StrokeCap.square;
    case 'butt':
      return StrokeCap.butt;
    default:
      return StrokeCap.round;
  }
}

String _normalizeProgressRingVariant(Object? value) {
  final normalized = value
      ?.toString()
      .trim()
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');
  switch (normalized) {
    case 'soft':
    case 'gradient':
    case 'glow':
    case 'segmented':
    case 'dashboard':
      return normalized!;
    default:
      return 'solid';
  }
}

double? _normalizeProgressValue(double? raw) {
  if (raw == null) return null;
  final unit = raw > 1 ? (raw / 100.0) : raw;
  return unit.clamp(0.0, 1.0);
}

String? _formatProgressValue(double? value, {String? template}) {
  if (value == null) return null;
  final percent = (value.clamp(0.0, 1.0) * 100).round();
  if (template != null && template.isNotEmpty) {
    return template.replaceAll('{percent}', '$percent');
  }
  return '$percent%';
}

double? _minNonNull(double? a, double? b) {
  if (a == null) return b;
  if (b == null) return a;
  return math.min(a, b);
}

class _ProgressPalette {
  const _ProgressPalette({
    required this.accent,
    required this.accentAlt,
    required this.trackColor,
    required this.textColor,
    required this.glowColor,
  });

  final Color accent;
  final Color accentAlt;
  final Color trackColor;
  final Color textColor;
  final Color glowColor;
}

_ProgressPalette _resolveProgressPalette(
  BuildContext context,
  Map<String, Object?> props,
) {
  final theme = Theme.of(context);
  final tokens = theme.extension<ButterflyUIThemeTokens>();
  final inheritedTint = coerceColor(
    props['surface_tint_color'] ??
        props['__surface_tint_color'] ??
        props['surface_color'],
  );
  final accent =
      coerceColor(
        props['color'] ??
            props['progress_color'] ??
            props['accent_color'] ??
            props['bgcolor'] ??
            props['background'],
      ) ??
      inheritedTint ??
      tokens?.primary ??
      theme.colorScheme.primary;
  final accentAlt =
      coerceColor(props['secondary_color'] ?? props['gradient_end']) ??
      tokens?.secondary ??
      theme.colorScheme.secondary;
  final trackColor =
      coerceColor(props['background_color'] ?? props['track_color']) ??
      accent.withValues(alpha: 0.16);
  final textColor =
      coerceColor(props['text_color'] ?? props['foreground']) ??
      tokens?.text ??
      theme.colorScheme.onSurface;
  final glowColor =
      coerceColor(props['glow_color']) ?? accentAlt.withValues(alpha: 0.86);

  return _ProgressPalette(
    accent: accent,
    accentAlt: accentAlt,
    trackColor: trackColor,
    textColor: textColor,
    glowColor: glowColor,
  );
}

List<Color>? _resolveProgressGradientColors(
  Map<String, Object?> props,
  Color accent,
  Color accentAlt,
) {
  if (props['gradient'] is Map) {
    final map = coerceObjectMap(props['gradient'] as Map);
    final colors = (map['colors'] as List?)
        ?.map(coerceColor)
        .whereType<Color>()
        .toList();
    if (colors != null && colors.isNotEmpty) {
      return colors;
    }
  }
  final variant = _normalizeProgressRingVariant(props['variant']);
  if (variant == 'gradient' || variant == 'glow') {
    return <Color>[
      accent,
      Color.lerp(accent, accentAlt, 0.55) ?? accentAlt,
      accentAlt,
    ];
  }
  return null;
}

List<double>? _resolveProgressGradientStops(Map<String, Object?> props) {
  if (props['gradient'] is! Map) return null;
  final map = coerceObjectMap(props['gradient'] as Map);
  final stops = (map['stops'] as List?)
      ?.map(coerceDouble)
      .whereType<double>()
      .toList();
  return stops;
}

Widget _applyProgressTransparency({
  required Widget child,
  required Map<String, Object?> props,
}) {
  final explicitOpacity = coerceDouble(props['opacity']);
  final transparency = coerceDouble(
    props['transparency'] ?? props['alpha'] ?? props['translucency'],
  );
  double? resolvedOpacity = explicitOpacity;
  if (transparency != null) {
    final normalized = transparency > 1
        ? (transparency / 100.0).clamp(0.0, 1.0)
        : transparency.clamp(0.0, 1.0);
    final transparencyOpacity = 1.0 - normalized;
    resolvedOpacity = resolvedOpacity == null
        ? transparencyOpacity
        : (resolvedOpacity * transparencyOpacity).clamp(0.0, 1.0);
  }
  if (resolvedOpacity == null || resolvedOpacity >= 1.0) {
    return child;
  }
  return Opacity(opacity: resolvedOpacity.clamp(0.0, 1.0), child: child);
}

class _ProgressRingPainter extends CustomPainter {
  const _ProgressRingPainter({
    required this.progress,
    required this.indeterminate,
    required this.phase,
    required this.strokeWidth,
    required this.accent,
    required this.trackColor,
    required this.glowColor,
    required this.gradientColors,
    required this.gradientStops,
    required this.variant,
    required this.segments,
    required this.startAngle,
    required this.sweepAngle,
    required this.cap,
    required this.glow,
  });

  final double progress;
  final bool indeterminate;
  final double phase;
  final double strokeWidth;
  final Color accent;
  final Color trackColor;
  final Color glowColor;
  final List<Color>? gradientColors;
  final List<double>? gradientStops;
  final String variant;
  final int segments;
  final double startAngle;
  final double sweepAngle;
  final StrokeCap cap;
  final bool glow;

  @override
  void paint(Canvas canvas, Size size) {
    final shortestSide = math.min(size.width, size.height);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.max(0.0, (shortestSide - strokeWidth) / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = cap
      ..color = variant == 'soft'
          ? trackColor.withValues(alpha: 0.34)
          : trackColor;

    if (variant == 'segmented') {
      _paintSegmented(canvas, rect, trackPaint);
      return;
    }

    canvas.drawArc(rect, startAngle, sweepAngle, false, trackPaint);

    final activeStart = indeterminate
        ? startAngle + phase * math.pi * 2
        : startAngle;
    final activeSweep = indeterminate
        ? sweepAngle *
              (0.18 + 0.18 * (0.5 + 0.5 * math.sin(phase * math.pi * 2)))
        : sweepAngle * progress.clamp(0.0, 1.0);
    if (activeSweep <= 0) return;

    if (glow) {
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 4
        ..strokeCap = cap
        ..color = glowColor.withValues(alpha: 0.28)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawArc(rect, activeStart, activeSweep, false, glowPaint);
    }

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = cap;

    final resolvedColors = gradientColors;
    if (resolvedColors != null && resolvedColors.isNotEmpty) {
      paint.shader = SweepGradient(
        colors: resolvedColors,
        stops: gradientStops,
        startAngle: activeStart,
        endAngle: activeStart + activeSweep,
      ).createShader(rect);
    } else {
      paint.color = accent;
    }

    canvas.drawArc(rect, activeStart, activeSweep, false, paint);
  }

  void _paintSegmented(Canvas canvas, Rect rect, Paint trackPaint) {
    final segmentGap =
        (sweepAngle / segments) *
        0.22.clamp(0.08, 0.28); // compact but visually separated
    final segmentSweep = (sweepAngle / segments) - segmentGap;
    final activeCount = indeterminate
        ? math.max(2, (segments * 0.22).round())
        : (progress.clamp(0.0, 1.0) * segments).round();
    final movingHead = (phase * segments).floor() % segments;

    for (var index = 0; index < segments; index += 1) {
      final segmentStart = startAngle + index * (segmentSweep + segmentGap);
      canvas.drawArc(rect, segmentStart, segmentSweep, false, trackPaint);

      final active = indeterminate
          ? ((index - movingHead) % segments + segments) % segments <
                activeCount
          : index < activeCount;
      if (!active) continue;

      if (glow) {
        final glowPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 4
          ..strokeCap = cap
          ..color = glowColor.withValues(alpha: 0.22)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawArc(rect, segmentStart, segmentSweep, false, glowPaint);
      }

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = cap;
      if (gradientColors != null && gradientColors!.isNotEmpty) {
        paint.shader = SweepGradient(
          colors: gradientColors!,
          stops: gradientStops,
          startAngle: segmentStart,
          endAngle: segmentStart + segmentSweep,
        ).createShader(rect);
      } else {
        paint.color = accent;
      }
      canvas.drawArc(rect, segmentStart, segmentSweep, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.indeterminate != indeterminate ||
        oldDelegate.phase != phase ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.accent != accent ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.glowColor != glowColor ||
        oldDelegate.variant != variant ||
        oldDelegate.segments != segments ||
        oldDelegate.startAngle != startAngle ||
        oldDelegate.sweepAngle != sweepAngle ||
        oldDelegate.cap != cap ||
        oldDelegate.glow != glow;
  }
}
