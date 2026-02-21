import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'animated_transition.dart';
import 'blur_fade_preset.dart' as blur_fade_preset;
import 'curtain_preset.dart' as curtain_preset;
import 'elastic_preset.dart' as elastic_preset;
import 'fade_scale_preset.dart' as fade_scale_preset;
import 'fade_preset.dart' as fade_preset;
import 'fade_through_preset.dart' as fade_through_preset;
import 'flip_preset.dart' as flip_preset;
import 'grow_from_point_preset.dart' as grow_from_point_preset;
import 'scale_preset.dart' as scale_preset;
import 'shared_axis_preset.dart' as shared_axis_preset;
import 'slide_and_fade_preset.dart' as slide_and_fade_preset;
import 'slide_preset.dart' as slide_preset;

/// Lightweight structure that describes an animation/preset from JSON-like map.
class AnimationSpec {
  final String? preset;
  final Duration duration;
  final Curve curve;
  final Offset offset;
  final double? blurSigma;
  final Axis? axis;
  final Alignment? origin;
  final bool instant;
  final bool animateOnMount;

  const AnimationSpec({
    this.preset,
    this.duration = const Duration(milliseconds: 220),
    this.curve = Curves.easeOut,
    this.offset = const Offset(0.0, -0.06),
    this.blurSigma,
    this.axis,
    this.origin,
    this.instant = false,
    this.animateOnMount = true,
  });

  factory AnimationSpec.fromJson(Map<String, Object?>? json) {
    if (json == null) return const AnimationSpec();
    String? preset;
    if (json.containsKey('preset')) preset = json['preset']?.toString();
    Duration duration = const Duration(milliseconds: 220);
    if (json['duration_ms'] != null) {
      final v = int.tryParse(json['duration_ms'].toString());
      if (v != null) duration = Duration(milliseconds: v);
    }
    Curve curve = Curves.easeOut;
    if (json['curve'] is String) {
      final s = (json['curve'] as String).toLowerCase();
      switch (s) {
        case 'ease_in':
          curve = Curves.easeIn;
          break;
        case 'ease_in_out':
        case 'easeinout':
          curve = Curves.easeInOut;
          break;
        case 'linear':
          curve = Curves.linear;
          break;
        case 'ease_out':
        default:
          curve = Curves.easeOut;
          break;
      }
    }
    Offset offset = const Offset(0.0, -0.06);
    if (json['offset'] is List && (json['offset'] as List).length >= 2) {
      final a = json['offset'] as List;
      final dx = double.tryParse(a[0].toString()) ?? 0.0;
      final dy = double.tryParse(a[1].toString()) ?? 0.0;
      offset = Offset(dx, dy);
    }
    final blurRaw = json['max_sigma'] ?? json['blur_sigma'];
    final blurSigma = blurRaw == null ? null : (double.tryParse(blurRaw.toString()));
    final axis = _parseAxis(json['axis']);
    final origin = _parseAlignment(json['origin'] ?? json['anchor'] ?? json['alignment']);
    final instant = json['instant'] == true;
    final animateOnMount = json['animate_on_mount'] == null ? true : (json['animate_on_mount'] == true);
    return AnimationSpec(
      preset: preset,
      duration: duration,
      curve: curve,
      offset: offset,
      blurSigma: blurSigma,
      axis: axis,
      origin: origin,
      instant: instant,
      animateOnMount: animateOnMount,
    );
  }

  /// Wrap [child] with the selected preset or a simple AnimatedTransition if preset is null.
  Widget wrap(Widget child, {bool visible = true, VoidCallback? onExitCompleted}) {
    final p = preset?.toLowerCase().replaceAll('-', '_');
    switch (p) {
      case 'slide_from_top':
        return slide_preset.slideFromTop(child: child, visible: visible, duration: duration, curve: curve, instant: instant, onExitCompleted: onExitCompleted);
      case 'slide_from_left':
        return slide_preset.slideFromLeft(child: child, visible: visible, duration: duration, curve: curve, instant: instant, onExitCompleted: onExitCompleted);
      case 'slide_from_right':
        return slide_preset.slideFromRight(child: child, visible: visible, duration: duration, curve: curve, instant: instant, onExitCompleted: onExitCompleted);
      case 'slide_from_bottom':
        return slide_preset.slideFromBottom(child: child, visible: visible, duration: duration, curve: curve, instant: instant, onExitCompleted: onExitCompleted);
      case 'fade':
        return fade_preset.fadePreset(child: child, visible: visible, duration: duration, curve: curve, instant: instant, onExitCompleted: onExitCompleted);
      case 'fade_through':
      case 'fadethrough':
        return fade_through_preset.fadeThrough(
          child: visible ? child : const SizedBox.shrink(),
          duration: duration,
        );
      case 'fade_scale':
      case 'fadescale':
        return fade_scale_preset.fadeScalePreset(
          child: visible ? child : const SizedBox.shrink(),
          duration: duration,
        );
      case 'shared_axis':
      case 'shared_axis_scale':
        return shared_axis_preset.sharedAxisPreset(
          child: visible ? child : const SizedBox.shrink(),
          duration: duration,
        );
      case 'shared_axis_x':
      case 'shared_axis_horizontal':
        return shared_axis_preset.sharedAxisPreset(
          child: visible ? child : const SizedBox.shrink(),
          duration: duration,
          transitionType: SharedAxisTransitionType.horizontal,
        );
      case 'shared_axis_y':
      case 'shared_axis_vertical':
        return shared_axis_preset.sharedAxisPreset(
          child: visible ? child : const SizedBox.shrink(),
          duration: duration,
          transitionType: SharedAxisTransitionType.vertical,
        );
      case 'flip':
        return flip_preset.FlipTransition(child: child, visible: visible, duration: duration, instant: instant, onExitCompleted: onExitCompleted);
      case 'blur_fade':
      case 'blurfade':
        return blur_fade_preset.blurFade(
          child: child,
          visible: visible,
          duration: duration,
          maxSigma: blurSigma ?? 6.0,
          instant: instant,
          onExitCompleted: onExitCompleted,
        );
      case 'curtain':
      case 'curtain_reveal':
        return curtain_preset.CurtainReveal(
          child: child,
          visible: visible,
          axis: axis ?? Axis.vertical,
          duration: duration,
          instant: instant,
          onExitCompleted: onExitCompleted,
        );
      case 'curtain_horizontal':
        return curtain_preset.CurtainReveal(
          child: child,
          visible: visible,
          axis: Axis.horizontal,
          duration: duration,
          instant: instant,
          onExitCompleted: onExitCompleted,
        );
      case 'curtain_vertical':
        return curtain_preset.CurtainReveal(
          child: child,
          visible: visible,
          axis: Axis.vertical,
          duration: duration,
          instant: instant,
          onExitCompleted: onExitCompleted,
        );
      case 'elastic':
      case 'elastic_out':
        return elastic_preset.ElasticTransition(
          child: child,
          visible: visible,
          duration: duration,
          instant: instant,
          onExitCompleted: onExitCompleted,
        );
      case 'scale':
      case 'scale_pop':
        return scale_preset.ScalePop(
          child: child,
          visible: visible,
          duration: duration,
          instant: instant,
          onExitCompleted: onExitCompleted,
        );
      case 'slide_and_fade':
        return slide_and_fade_preset.slideAndFade(
          child: child,
          visible: visible,
          duration: duration,
          curve: curve,
          offset: offset,
          instant: instant,
          onExitCompleted: onExitCompleted,
        );
      case 'grow_from_point':
      case 'grow_from':
        return grow_from_point_preset.GrowFromPoint(
          child: child,
          visible: visible,
          duration: duration,
          origin: origin ?? Alignment.center,
          instant: instant,
          onExitCompleted: onExitCompleted,
        );
      default:
        return AnimatedTransition(child: child, visible: visible, duration: duration, curve: curve, offset: offset, instant: instant, onExitCompleted: onExitCompleted, animateOnMount: animateOnMount);
    }
  }
}

/// Convenience helper: wrap a widget using a JSON-like spec map.
Widget animateWithSpec({required Widget child, Map<String, Object?>? spec, bool visible = true, VoidCallback? onExitCompleted}) {
  final s = AnimationSpec.fromJson(spec);
  return s.wrap(child, visible: visible, onExitCompleted: onExitCompleted);
}

Axis? _parseAxis(Object? value) {
  if (value == null) return null;
  final raw = value.toString().toLowerCase().replaceAll('-', '_');
  if (raw == 'horizontal' || raw == 'x') return Axis.horizontal;
  if (raw == 'vertical' || raw == 'y') return Axis.vertical;
  return null;
}

Alignment? _parseAlignment(Object? value) {
  if (value == null) return null;
  if (value is List && value.length >= 2) {
    final x = double.tryParse(value[0].toString()) ?? 0.0;
    final y = double.tryParse(value[1].toString()) ?? 0.0;
    return Alignment(x, y);
  }
  if (value is Map) {
    final x = value['x'] ?? value['dx'] ?? value['left'];
    final y = value['y'] ?? value['dy'] ?? value['top'];
    if (x != null || y != null) {
      final dx = x == null ? 0.0 : (double.tryParse(x.toString()) ?? 0.0);
      final dy = y == null ? 0.0 : (double.tryParse(y.toString()) ?? 0.0);
      return Alignment(dx, dy);
    }
  }
  final s = value.toString().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
  switch (s) {
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
  }
  return null;
}
