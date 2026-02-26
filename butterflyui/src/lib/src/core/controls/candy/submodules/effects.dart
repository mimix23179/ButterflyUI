library candy_effects;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/controls/display/canvas_control.dart';
import 'package:butterflyui_runtime/src/core/controls/effects/layer.dart';
import 'package:butterflyui_runtime/src/core/controls/effects/particle_field.dart';
import 'package:butterflyui_runtime/src/core/controls/effects/shimmer_shadow.dart';

import 'candy_submodule_context.dart';

// Entry point — returns null for non-effects modules.
Widget? buildCandyEffectsModule(String module, CandySubmoduleContext ctx) {
  return switch (module) {
    'effects' => _buildEffects(ctx),
    'particles' => _buildParticles(ctx),
    'canvas' => _buildCanvas(ctx),
    _ => null,
  };
}

// ─── effects ──────────────────────────────────────────────────────────────────
// shimmer, blur, opacity, overlay. Composable — multiple can be active.
// Base: buildLayerControl handles blur/opacity/tint.
// shimmer: sweeping highlight animation wraps the base layer.
Widget _buildEffects(CandySubmoduleContext ctx) {
  Widget child = buildLayerControl(
    ctx.merged,
    ctx.rawChildren,
    ctx.buildChild,
  );

  if (ctx.merged['shimmer'] == true) {
    child = buildShimmerControl(
      '${ctx.controlId}::effects',
      ctx.merged,
      child,
      ctx.registerInvokeHandler,
      ctx.unregisterInvokeHandler,
    );
  }

  return child;
}

// ─── particles ────────────────────────────────────────────────────────────────
// count, speed, size, gravity, drift, overlay (default true), colors.
// overlay=true → particle field floats above child via Stack + IgnorePointer.
// overlay=false → particles replace child content entirely.
Widget _buildParticles(CandySubmoduleContext ctx) {
  final particleField = buildParticleFieldControl(
    '${ctx.controlId}::particles',
    ctx.merged,
    ctx.registerInvokeHandler,
    ctx.unregisterInvokeHandler,
    ctx.sendEvent,
  );

  final shouldOverlay = ctx.merged['overlay'] != false;
  if (!shouldOverlay) return particleField;

  final child = candyFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild);
  return Stack(
    fit: StackFit.expand,
    children: [
      child,
      IgnorePointer(child: particleField),
    ],
  );
}

// ─── canvas ───────────────────────────────────────────────────────────────────
// width, height, commands (list of drawing command maps).
// Exposes a raw CustomPainter surface driven by JSON draw commands from Python.
// Invoke: draw (new commands), clear, set_size.
Widget _buildCanvas(CandySubmoduleContext ctx) {
  return buildCanvasControl(
    '${ctx.controlId}::canvas',
    ctx.merged,
    ctx.registerInvokeHandler,
    ctx.unregisterInvokeHandler,
    ctx.sendEvent,
  );
}
