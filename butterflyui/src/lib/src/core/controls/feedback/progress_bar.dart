import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/styling/theme_extension.dart';
import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/webview/webview_api.dart';

Widget buildProgressBarControl(
  String controlId,
  Map<String, Object?> props,
  ButterflyUIRegisterInvokeHandler registerInvokeHandler,
  ButterflyUIUnregisterInvokeHandler unregisterInvokeHandler,
  ButterflyUISendRuntimeEvent sendEvent,
) {
  return _ProgressBarControl(
    controlId,
    props,
    registerInvokeHandler,
    unregisterInvokeHandler,
    sendEvent,
  );
}

class _ProgressBarControl extends StatefulWidget {
  const _ProgressBarControl(
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
  State<_ProgressBarControl> createState() => _ProgressBarControlState();
}

class _ProgressBarControlState extends State<_ProgressBarControl>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
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
  void didUpdateWidget(covariant _ProgressBarControl oldWidget) {
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
        (coerceOptionalInt(widget.props['animation_duration_ms']) ?? 1600)
            .clamp(300, 12000);
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
        throw UnsupportedError('Unknown progress_bar method: $method');
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
    final variant = _normalizeProgressVariant(widget.props['variant']);
    final palette = _resolveProgressPalette(context, widget.props);
    final barHeight = _resolveProgressBarHeight(widget.props, variant);
    final radius =
        coerceDouble(widget.props['radius']) ??
        coerceDouble(widget.props['corner_radius']) ??
        (barHeight / 2);
    final label = widget.props['label']?.toString();
    final helper =
        widget.props['helper']?.toString() ??
        widget.props['helper_text']?.toString();
    final showValue = widget.props['show_value'] == true;
    final progressText = showValue
        ? _formatProgressValue(
            value,
            template: widget.props['value_template']?.toString(),
          )
        : null;

    Widget indicator = AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return _buildProgressBarIndicator(
          context: context,
          props: widget.props,
          value: value,
          indeterminate: indeterminate,
          variant: variant,
          palette: palette,
          height: barHeight,
          radius: radius,
          phase: _controller.value,
        );
      },
    );

    final width = coerceDouble(widget.props['width']);
    if (width != null && width > 0) {
      indicator = SizedBox(width: width, child: indicator);
    }

    Widget content = indicator;
    if ((label != null && label.isNotEmpty) ||
        (helper != null && helper.isNotEmpty) ||
        (progressText != null && progressText.isNotEmpty)) {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if ((label != null && label.isNotEmpty) ||
              (progressText != null && progressText.isNotEmpty))
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (label != null && label.isNotEmpty)
                    Expanded(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: palette.textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  if (progressText != null && progressText.isNotEmpty) ...[
                    const SizedBox(width: 12),
                    Text(
                      progressText,
                      style: TextStyle(
                        color: palette.textColor.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          content,
          if (helper != null && helper.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              helper,
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

Widget _buildProgressBarIndicator({
  required BuildContext context,
  required Map<String, Object?> props,
  required double? value,
  required bool indeterminate,
  required String variant,
  required _ProgressPalette palette,
  required double height,
  required double radius,
  required double phase,
}) {
  final borderColor = coerceColor(props['border_color']);
  final borderWidth = coerceDouble(props['border_width']) ?? 0.0;
  final trackShadow = _resolveProgressTrackShadow(
    props,
    accent: palette.accent,
    variant: variant,
  );
  final decoration = BoxDecoration(
    color: palette.trackColor,
    borderRadius: BorderRadius.circular(radius),
    border: borderColor == null || borderWidth <= 0
        ? null
        : Border.all(color: borderColor, width: borderWidth),
    boxShadow: trackShadow,
  );

  return SizedBox(
    height: height,
    child: DecoratedBox(
      decoration: decoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final trackWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : 180.0;
            if (variant == 'segmented') {
              return _buildSegmentedBar(
                props: props,
                value: value,
                indeterminate: indeterminate,
                palette: palette,
                radius: radius,
                phase: phase,
              );
            }
            return Stack(
              fit: StackFit.expand,
              children: [
                if (indeterminate)
                  _buildIndeterminateBarFill(
                    props: props,
                    palette: palette,
                    variant: variant,
                    height: height,
                    radius: radius,
                    phase: phase,
                    width: trackWidth,
                  )
                else
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: value?.clamp(0.0, 1.0) ?? 0.0,
                      child: _buildProgressFillBox(
                        props: props,
                        palette: palette,
                        variant: variant,
                        height: height,
                        radius: radius,
                        phase: phase,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    ),
  );
}

Widget _buildSegmentedBar({
  required Map<String, Object?> props,
  required double? value,
  required bool indeterminate,
  required _ProgressPalette palette,
  required double radius,
  required double phase,
}) {
  final segments = (coerceOptionalInt(props['segments']) ?? 12).clamp(2, 64);
  final gap = (coerceDouble(props['segment_gap']) ?? 4.0).clamp(1.0, 24.0);
  final activeSegments = value == null
      ? 0
      : (value.clamp(0.0, 1.0) * segments).round();
  final movingHead = (phase * segments).floor() % segments;
  final movingWindow = math.max(2, (segments * 0.24).round());

  return Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: List.generate(segments, (index) {
      final active = indeterminate
          ? ((index - movingHead) % segments + segments) % segments <
                movingWindow
          : index < activeSegments;
      final fillGradient = active ? palette.fillGradient : null;
      final fillColor = active ? palette.accent : palette.trackColor;
      return Expanded(
        child: Padding(
          padding: EdgeInsets.only(right: index == segments - 1 ? 0 : gap),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: fillGradient == null ? fillColor : null,
              gradient: fillGradient,
              borderRadius: BorderRadius.circular(radius),
              boxShadow: active
                  ? _resolveProgressFillShadow(
                      accent: palette.glowColor,
                      variant: 'glow',
                      props: props,
                    )
                  : null,
            ),
          ),
        ),
      );
    }),
  );
}

Widget _buildIndeterminateBarFill({
  required Map<String, Object?> props,
  required _ProgressPalette palette,
  required String variant,
  required double height,
  required double radius,
  required double phase,
  required double width,
}) {
  final segmentWidthFactor =
      (coerceDouble(props['indeterminate_width_factor']) ?? 0.34).clamp(
        0.12,
        0.8,
      );
  final segmentWidth = width * segmentWidthFactor;
  final travel = width + segmentWidth;
  final left = (travel * phase) - segmentWidth;

  return Stack(
    fit: StackFit.expand,
    children: [
      Positioned(
        left: left,
        width: segmentWidth,
        top: 0,
        bottom: 0,
        child: _buildProgressFillBox(
          props: props,
          palette: palette,
          variant: variant,
          height: height,
          radius: radius,
          phase: phase,
        ),
      ),
    ],
  );
}

Widget _buildProgressFillBox({
  required Map<String, Object?> props,
  required _ProgressPalette palette,
  required String variant,
  required double height,
  required double radius,
  required double phase,
}) {
  final striped = variant == 'striped';
  final decoration = BoxDecoration(
    color: palette.fillGradient == null ? palette.accent : null,
    gradient: palette.fillGradient,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: _resolveProgressFillShadow(
      accent: palette.glowColor,
      variant: variant,
      props: props,
    ),
  );

  Widget fill = DecoratedBox(decoration: decoration);
  if (striped) {
    fill = CustomPaint(
      painter: _StripedOverlayPainter(
        color: Colors.white.withValues(alpha: 0.18),
        phase: phase,
      ),
      child: fill,
    );
  }
  return fill;
}

List<BoxShadow>? _resolveProgressTrackShadow(
  Map<String, Object?> props, {
  required Color accent,
  required String variant,
}) {
  final explicit = coerceBoxShadow(props['shadow']);
  if (explicit != null) {
    return explicit;
  }
  if (variant != 'glow' && props['glow'] != true) {
    return null;
  }
  return <BoxShadow>[
    BoxShadow(
      color: accent.withValues(alpha: 0.18),
      blurRadius: 18,
      spreadRadius: 0.5,
      offset: const Offset(0, 0),
    ),
  ];
}

List<BoxShadow>? _resolveProgressFillShadow({
  required Color accent,
  required String variant,
  required Map<String, Object?> props,
}) {
  if (variant != 'glow' && props['glow'] != true) {
    return null;
  }
  final blur = (coerceDouble(props['glow_blur']) ?? 18).clamp(4.0, 40.0);
  return <BoxShadow>[
    BoxShadow(
      color: accent.withValues(alpha: 0.34),
      blurRadius: blur,
      spreadRadius: 0.5,
      offset: const Offset(0, 0),
    ),
  ];
}

double _resolveProgressBarHeight(Map<String, Object?> props, String variant) {
  final explicitHeight =
      coerceDouble(props['track_height'] ?? props['bar_height']) ??
      coerceDouble(props['stroke_width']);
  if (explicitHeight != null) {
    return explicitHeight.clamp(2.0, 40.0);
  }
  if (variant == 'soft') {
    return 12.0;
  }
  if (variant == 'segmented') {
    return 10.0;
  }
  return 8.0;
}

String _normalizeProgressVariant(Object? value) {
  final normalized = value
      ?.toString()
      .trim()
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');
  switch (normalized) {
    case 'soft':
    case 'striped':
    case 'gradient':
    case 'glow':
    case 'segmented':
      return normalized!;
    default:
      return 'solid';
  }
}

String? _formatProgressValue(double? value, {String? template}) {
  if (value == null) return null;
  final percent = (value.clamp(0.0, 1.0) * 100).round();
  if (template != null && template.isNotEmpty) {
    return template.replaceAll('{percent}', '$percent');
  }
  return '$percent%';
}

class _ProgressPalette {
  const _ProgressPalette({
    required this.accent,
    required this.accentAlt,
    required this.trackColor,
    required this.textColor,
    required this.glowColor,
    required this.fillGradient,
  });

  final Color accent;
  final Color accentAlt;
  final Color trackColor;
  final Color textColor;
  final Color glowColor;
  final Gradient? fillGradient;
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
  final textColor =
      coerceColor(props['text_color'] ?? props['foreground']) ??
      tokens?.text ??
      theme.colorScheme.onSurface;
  final trackColor =
      coerceColor(props['background_color'] ?? props['track_color']) ??
      accent.withValues(alpha: 0.16);
  final glowColor =
      coerceColor(props['glow_color']) ?? accentAlt.withValues(alpha: 0.88);
  final fillGradient =
      _resolveProgressLinearGradient(props) ??
      (_normalizeProgressVariant(props['variant']) == 'gradient' ||
              _normalizeProgressVariant(props['variant']) == 'glow'
          ? LinearGradient(
              colors: <Color>[
                accent,
                Color.lerp(accent, accentAlt, 0.55) ?? accentAlt,
                accentAlt,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )
          : null);

  return _ProgressPalette(
    accent: accent,
    accentAlt: accentAlt,
    trackColor: trackColor,
    textColor: textColor,
    glowColor: glowColor,
    fillGradient: fillGradient,
  );
}

Gradient? _resolveProgressLinearGradient(Map<String, Object?> props) {
  final gradient = coerceGradient(props['gradient']);
  if (gradient is LinearGradient) {
    return gradient;
  }
  if (gradient is RadialGradient) {
    return LinearGradient(
      colors: gradient.colors,
      stops: gradient.stops,
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      tileMode: gradient.tileMode,
    );
  }
  return null;
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

class _StripedOverlayPainter extends CustomPainter {
  const _StripedOverlayPainter({required this.color, required this.phase});

  final Color color;
  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final stripeWidth = math.max(6.0, size.height * 0.78);
    final spacing = stripeWidth * 1.7;
    final travel = spacing * phase;

    for (
      double start = -size.height * 2 + travel;
      start < size.width + size.height * 2;
      start += spacing
    ) {
      final path = Path()
        ..moveTo(start, size.height)
        ..lineTo(start + stripeWidth, size.height)
        ..lineTo(start + stripeWidth + size.height, 0)
        ..lineTo(start + size.height, 0)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StripedOverlayPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.phase != phase;
  }
}

double? _normalizeProgressValue(double? raw) {
  if (raw == null) return null;
  final unit = raw > 1 ? (raw / 100.0) : raw;
  return unit.clamp(0.0, 1.0);
}
