library candy_motion;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/effects/motion.dart';

import 'candy_submodule_context.dart';

// Entry point — returns null for non-motion modules.
Widget? buildCandyMotionModule(String module, CandySubmoduleContext ctx) {
  return switch (module) {
    'animation' || 'motion' => _buildAnimation(ctx),
    'transition' => _buildTransition(ctx),
    _ => null,
  };
}

// ─── animation / motion ───────────────────────────────────────────────────────
// duration_ms, curve, opacity, scale, autoplay, loop, reverse.
// Both 'animation' and 'motion' map here — same prop schema, different intent:
//   animation → explicit value-driven transitions (opacity, scale).
//   motion    → gesture-aware / physics-like transforms.
Widget _buildAnimation(CandySubmoduleContext ctx) {
  return buildMotionControl(
    ctx.merged,
    ctx.rawChildren,
    ctx.buildChild,
  );
}

// ─── transition ───────────────────────────────────────────────────────────────
// duration_ms, curve, preset (fade|scale|slide|slide_up|slide_down), key/state/value.
// AnimatedSwitcher keyed by the discriminator prop fires a new animation cycle
// whenever the key changes — use this for tab switches, theme changes, etc.
Widget _buildTransition(CandySubmoduleContext ctx) {
  final m = ctx.merged;
  final durationMs =
      (coerceOptionalInt(m['duration_ms']) ?? 220).clamp(1, 120000);
  final curve = candyParseCurve(m['curve']);
  final preset = candyNorm((m['preset'] ?? 'fade').toString());

  Widget Function(Widget, Animation<double>) builder;
  switch (preset) {
    case 'scale':
      builder = (child, anim) => ScaleTransition(scale: anim, child: child);
    case 'slide':
      builder = (child, anim) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.08, 0),
              end: Offset.zero,
            ).animate(anim),
            child: FadeTransition(opacity: anim, child: child),
          );
    case 'slide_up':
      builder = (child, anim) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.08),
              end: Offset.zero,
            ).animate(anim),
            child: FadeTransition(opacity: anim, child: child),
          );
    case 'slide_down':
      builder = (child, anim) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.08),
              end: Offset.zero,
            ).animate(anim),
            child: FadeTransition(opacity: anim, child: child),
          );
    default:
      // fade (default)
      builder = (child, anim) => FadeTransition(opacity: anim, child: child);
  }

  // Discriminator — first non-null of key, state, value drives re-animation.
  final discriminator = m['key'] ?? m['state'] ?? m['value'];

  return AnimatedSwitcher(
    duration: Duration(milliseconds: durationMs),
    switchInCurve: curve,
    switchOutCurve: curve,
    transitionBuilder: builder,
    child: KeyedSubtree(
      key: ValueKey(discriminator),
      child: candyFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild),
    ),
  );
}
