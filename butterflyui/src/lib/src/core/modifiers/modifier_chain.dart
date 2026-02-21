import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../candy/theme.dart';
import '../control_utils.dart';
import '../motion/motion_pack.dart';
import 'control_capabilities.dart';

Widget applyControlModifierChain({
  required Widget child,
  required String controlType,
  required String controlId,
  required List<Object?> modifiers,
  required Object? motion,
  required CandyTokens tokens,
  required Map<String, Object?> motionPack,
  required Map<String, Object?> effectPresets,
}) {
  final capabilities = ControlModifierCapabilities.forControl(controlType);
  final bundle = _ModifierBundle.fromList(
    modifiers,
    tokens: tokens,
    effectPresets: effectPresets,
  ).restrictedTo(capabilities);
  if (!bundle.enabled) {
    return child;
  }
  final motionSpec = ButterflyUIMotionPack.resolve(
    motion,
    pack: motionPack,
    fallbackName: 'hover',
  );
  return _ModifierHost(
    controlType: controlType,
    controlId: controlId,
    bundle: bundle,
    motion: motionSpec,
    tokens: tokens,
    child: child,
  );
}

class _ModifierBundle {
  final bool hoverLift;
  final bool pressScale;
  final bool focusRing;
  final bool glass;
  final bool elevation;
  final bool clickBurst;
  final bool sound;
  final bool haptics;
  final bool transition;

  final double hoverDistance;
  final double hoverScale;
  final double pressTargetScale;
  final double focusRingWidth;
  final double focusRingRadius;
  final double glassBlur;
  final double glassRadius;
  final double elevationIdle;
  final double elevationHover;
  final double burstRadius;
  final int burstDurationMs;
  final String hapticsStyle;
  final Color? focusRingColor;
  final Color? glassTintColor;
  final Color? glassBorderColor;
  final Color? burstColor;

  const _ModifierBundle({
    required this.hoverLift,
    required this.pressScale,
    required this.focusRing,
    required this.glass,
    required this.elevation,
    required this.clickBurst,
    required this.sound,
    required this.haptics,
    required this.transition,
    required this.hoverDistance,
    required this.hoverScale,
    required this.pressTargetScale,
    required this.focusRingWidth,
    required this.focusRingRadius,
    required this.glassBlur,
    required this.glassRadius,
    required this.elevationIdle,
    required this.elevationHover,
    required this.burstRadius,
    required this.burstDurationMs,
    required this.hapticsStyle,
    required this.focusRingColor,
    required this.glassTintColor,
    required this.glassBorderColor,
    required this.burstColor,
  });

  bool get enabled =>
      hoverLift ||
      pressScale ||
      focusRing ||
      glass ||
      elevation ||
      clickBurst ||
      sound ||
      haptics ||
      transition;

  _ModifierBundle restrictedTo(ControlModifierCapabilities capabilities) {
    final allowInteractive = capabilities.supportsInteractiveModifiers;
    final allowGlass = capabilities.supportsGlassModifiers;
    final allowTransition = capabilities.supportsTransitionModifiers;
    return _ModifierBundle(
      hoverLift: allowInteractive ? hoverLift : false,
      pressScale: allowInteractive ? pressScale : false,
      focusRing: allowInteractive ? focusRing : false,
      glass: allowGlass ? glass : false,
      elevation: allowInteractive ? elevation : false,
      clickBurst: allowInteractive ? clickBurst : false,
      sound: allowInteractive ? sound : false,
      haptics: allowInteractive ? haptics : false,
      transition: allowTransition ? transition : false,
      hoverDistance: hoverDistance,
      hoverScale: hoverScale,
      pressTargetScale: pressTargetScale,
      focusRingWidth: focusRingWidth,
      focusRingRadius: focusRingRadius,
      glassBlur: glassBlur,
      glassRadius: glassRadius,
      elevationIdle: elevationIdle,
      elevationHover: elevationHover,
      burstRadius: burstRadius,
      burstDurationMs: burstDurationMs,
      hapticsStyle: hapticsStyle,
      focusRingColor: focusRingColor,
      glassTintColor: glassTintColor,
      glassBorderColor: glassBorderColor,
      burstColor: burstColor,
    );
  }

  factory _ModifierBundle.fromList(
    List<Object?> raw, {
    required CandyTokens tokens,
    required Map<String, Object?> effectPresets,
  }) {
    var hoverLift = false;
    var pressScale = false;
    var focusRing = false;
    var glass = false;
    var elevation = false;
    var clickBurst = false;
    var sound = false;
    var haptics = false;
    var transition = false;

    var hoverDistance = 3.0;
    var hoverScale = 1.01;
    var pressTargetScale = 0.97;
    var focusRingWidth = 2.0;
    var focusRingRadius = tokens.number('radii', 'md') ?? 12.0;
    var glassBlur = tokens.number('effects', 'glass_blur') ?? 18.0;
    var glassRadius = tokens.number('radii', 'md') ?? 12.0;
    var elevationIdle = 0.0;
    var elevationHover = 8.0;
    var burstRadius = 56.0;
    var burstDurationMs = 260;
    var hapticsStyle = 'light';
    Color? focusRingColor = tokens.color('primary');
    Color? glassTintColor = const Color(0x14FFFFFF);
    Color? glassBorderColor = const Color(0x33FFFFFF);
    Color? burstColor = tokens.color('primary');

    Map<String, Object?> resolvePresetMap(Map<String, Object?> item) {
      final presetName = item['preset']?.toString();
      if (presetName == null || presetName.isEmpty) return item;
      final preset = effectPresets[presetName];
      if (preset is! Map) return item;
      return CandyTokens.mergeMaps(coerceObjectMap(preset), item);
    }

    for (final value in raw) {
      if (value == null) continue;
      String type = '';
      Map<String, Object?> data = <String, Object?>{};
      if (value is String) {
        type = _normalize(value);
      } else if (value is Map) {
        data = resolvePresetMap(coerceObjectMap(value));
        type = _normalize(
          data['type']?.toString() ??
              data['id']?.toString() ??
              data['name']?.toString() ??
              '',
        );
      }
      if (type.isEmpty) continue;
      switch (type) {
        case 'hovereffectmodifier':
        case 'hovereffect':
        case 'hover_lift':
        case 'hoverlift':
          hoverLift = true;
          hoverDistance = coerceDouble(data['distance']) ?? hoverDistance;
          hoverScale = coerceDouble(data['scale']) ?? hoverScale;
          break;
        case 'presseffectmodifier':
        case 'presseffect':
        case 'press_scale':
        case 'pressscale':
          pressScale = true;
          pressTargetScale = coerceDouble(data['scale']) ?? pressTargetScale;
          break;
        case 'focusringmodifier':
        case 'focusring':
        case 'focus_ring':
          focusRing = true;
          focusRingWidth = coerceDouble(data['width']) ?? focusRingWidth;
          focusRingRadius = coerceDouble(data['radius']) ?? focusRingRadius;
          focusRingColor = coerceColor(data['color']) ?? focusRingColor;
          break;
        case 'glassmodifier':
        case 'glass':
        case 'glass_overlay':
        case 'glassoverlay':
          glass = true;
          glassBlur = coerceDouble(data['blur']) ?? glassBlur;
          glassRadius = coerceDouble(data['radius']) ?? glassRadius;
          glassTintColor = coerceColor(data['tint']) ?? glassTintColor;
          glassBorderColor =
              coerceColor(data['border_color']) ?? glassBorderColor;
          break;
        case 'elevationmodifier':
        case 'elevation':
          elevation = true;
          elevationIdle = coerceDouble(data['idle']) ?? elevationIdle;
          elevationHover = coerceDouble(data['hover']) ?? elevationHover;
          break;
        case 'clickburstmodifier':
        case 'clickburst':
        case 'click_burst':
        case 'burstparticles':
          clickBurst = true;
          burstRadius = coerceDouble(data['radius']) ?? burstRadius;
          burstDurationMs =
              coerceOptionalInt(data['duration_ms']) ?? burstDurationMs;
          burstColor = coerceColor(data['color']) ?? burstColor;
          break;
        case 'soundmodifier':
        case 'sound':
        case 'soundonclick':
          sound = true;
          break;
        case 'hapticsmodifier':
        case 'haptics':
          haptics = true;
          hapticsStyle = (data['style']?.toString() ?? hapticsStyle)
              .toLowerCase();
          break;
        case 'transitionmodifier':
        case 'transition':
          transition = true;
          break;
      }
    }

    return _ModifierBundle(
      hoverLift: hoverLift,
      pressScale: pressScale,
      focusRing: focusRing,
      glass: glass,
      elevation: elevation,
      clickBurst: clickBurst,
      sound: sound,
      haptics: haptics,
      transition: transition,
      hoverDistance: hoverDistance,
      hoverScale: hoverScale,
      pressTargetScale: pressTargetScale,
      focusRingWidth: focusRingWidth,
      focusRingRadius: focusRingRadius,
      glassBlur: glassBlur,
      glassRadius: glassRadius,
      elevationIdle: elevationIdle,
      elevationHover: elevationHover,
      burstRadius: burstRadius,
      burstDurationMs: burstDurationMs,
      hapticsStyle: hapticsStyle,
      focusRingColor: focusRingColor,
      glassTintColor: glassTintColor,
      glassBorderColor: glassBorderColor,
      burstColor: burstColor,
    );
  }

  static String _normalize(String value) {
    return value.trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
  }
}

class _ModifierHost extends StatefulWidget {
  final String controlType;
  final String controlId;
  final _ModifierBundle bundle;
  final ButterflyUIMotionSpec motion;
  final CandyTokens tokens;
  final Widget child;

  const _ModifierHost({
    required this.controlType,
    required this.controlId,
    required this.bundle,
    required this.motion,
    required this.tokens,
    required this.child,
  });

  @override
  State<_ModifierHost> createState() => _ModifierHostState();
}

class _ModifierHostState extends State<_ModifierHost>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;
  Offset _burstOrigin = Offset.zero;
  late final AnimationController _burstController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: widget.bundle.burstDurationMs),
  );

  @override
  void didUpdateWidget(covariant _ModifierHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bundle.burstDurationMs != widget.bundle.burstDurationMs) {
      _burstController.duration = Duration(
        milliseconds: widget.bundle.burstDurationMs,
      );
    }
  }

  @override
  void dispose() {
    _burstController.dispose();
    super.dispose();
  }

  void _triggerFeedback(TapDownDetails details) {
    if (widget.bundle.haptics) {
      switch (widget.bundle.hapticsStyle) {
        case 'medium':
          HapticFeedback.mediumImpact();
          break;
        case 'heavy':
          HapticFeedback.heavyImpact();
          break;
        case 'selection':
          HapticFeedback.selectionClick();
          break;
        default:
          HapticFeedback.lightImpact();
          break;
      }
    }
    if (widget.bundle.sound) {
      SystemSound.play(SystemSoundType.click);
    }
    if (widget.bundle.clickBurst) {
      _burstOrigin = details.localPosition;
      _burstController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bundle = widget.bundle;
    final duration = widget.motion.duration;
    final curve = widget.motion.curve;
    final baseShadowColor =
        widget.tokens.color('border') ?? const Color(0x33000000);
    final transformScale = _pressed
        ? bundle.pressTargetScale
        : (_hovered ? bundle.hoverScale : 1.0);
    final dy = _pressed ? 0.0 : (_hovered ? -bundle.hoverDistance : 0.0);
    final dynamicElevation = _hovered
        ? bundle.elevationHover
        : bundle.elevationIdle;
    final focusColor =
        bundle.focusRingColor ?? Theme.of(context).colorScheme.primary;
    final borderRadius = BorderRadius.circular(
      bundle.glass ? bundle.glassRadius : bundle.focusRingRadius,
    );

    Widget body = widget.child;
    if (bundle.transition) {
      body = AnimatedSwitcher(
        duration: duration,
        switchInCurve: curve,
        switchOutCurve: Curves.easeOutCubic,
        child: KeyedSubtree(
          key: ValueKey<Object>(widget.child.hashCode),
          child: body,
        ),
      );
    }

    body = AnimatedContainer(
      duration: duration,
      curve: curve,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: bundle.focusRing && _focused
            ? Border.all(color: focusColor, width: bundle.focusRingWidth)
            : null,
        boxShadow: bundle.elevation && dynamicElevation > 0
            ? <BoxShadow>[
                BoxShadow(
                  color: baseShadowColor,
                  blurRadius: dynamicElevation,
                  spreadRadius: dynamicElevation * 0.12,
                  offset: Offset(0, dynamicElevation * 0.35),
                ),
              ]
            : null,
      ),
      child: Transform.translate(
        offset: Offset(0, dy),
        child: Transform.scale(scale: transformScale, child: body),
      ),
    );

    if (bundle.glass) {
      body = ClipRRect(
        borderRadius: BorderRadius.circular(bundle.glassRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: bundle.glassBlur,
            sigmaY: bundle.glassBlur,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: bundle.glassTintColor,
              borderRadius: BorderRadius.circular(bundle.glassRadius),
              border: Border.all(
                color: bundle.glassBorderColor ?? const Color(0x33FFFFFF),
              ),
            ),
            child: body,
          ),
        ),
      );
    }

    if (bundle.clickBurst) {
      body = Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          body,
          IgnorePointer(
            child: Positioned.fill(
              child: AnimatedBuilder(
                animation: _burstController,
                builder: (context, _) {
                  if (_burstController.value <= 0.0) {
                    return const SizedBox.shrink();
                  }
                  return CustomPaint(
                    painter: _BurstPainter(
                      progress: _burstController.value,
                      color: bundle.burstColor ?? focusColor,
                      origin: _burstOrigin,
                      radius: bundle.burstRadius,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
    }

    final wantsHover = bundle.hoverLift || bundle.elevation;
    final wantsPress =
        bundle.pressScale ||
        bundle.haptics ||
        bundle.sound ||
        bundle.clickBurst;
    final wantsFocus = bundle.focusRing;

    if (wantsPress) {
      body = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (details) {
          setState(() => _pressed = true);
          _triggerFeedback(details);
        },
        onTapUp: (_) {
          if (mounted) {
            setState(() => _pressed = false);
          }
        },
        onTapCancel: () {
          if (mounted) {
            setState(() => _pressed = false);
          }
        },
        child: body,
      );
    }

    if (wantsHover) {
      body = MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: body,
      );
    }

    if (wantsFocus) {
      body = Focus(
        onFocusChange: (value) => setState(() => _focused = value),
        child: body,
      );
    }

    return body;
  }
}

class _BurstPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Offset origin;
  final double radius;

  const _BurstPainter({
    required this.progress,
    required this.color,
    required this.origin,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color.withValues(alpha: (1.0 - progress) * 0.3);
    final r = radius * progress;
    canvas.drawCircle(origin, r, paint);
  }

  @override
  bool shouldRepaint(covariant _BurstPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.origin != origin ||
        oldDelegate.radius != radius;
  }
}
