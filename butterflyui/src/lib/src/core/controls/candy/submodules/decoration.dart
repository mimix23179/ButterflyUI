library candy_decoration;

import 'package:flutter/material.dart';

import 'package:butterflyui_runtime/src/core/control_utils.dart';
import 'package:butterflyui_runtime/src/core/controls/customization/border.dart';
import 'package:butterflyui_runtime/src/core/controls/customization/color_tools.dart';
import 'package:butterflyui_runtime/src/core/controls/effects/shimmer_shadow.dart';

import 'candy_submodule_context.dart';

// Entry point — returns null for non-decoration modules.
Widget? buildCandyDecorationModule(String module, CandySubmoduleContext ctx) {
  return switch (module) {
    'border' => _buildBorder(ctx),
    'shadow' => _buildShadow(ctx),
    'outline' => _buildOutline(ctx),
    'gradient' => _buildGradient(ctx),
    'decorated_box' => _buildDecoratedBox(ctx),
    'clip' => _buildClip(ctx),
    _ => null,
  };
}

// ─── border ───────────────────────────────────────────────────────────────────
// color, width, radius, side (all|top|bottom|left|right|horizontal|vertical),
// padding. Rendered via the full border control which supports invoke.
Widget _buildBorder(CandySubmoduleContext ctx) {
  return buildBorderControl(
    '${ctx.controlId}::border',
    ctx.merged,
    ctx.rawChildren,
    ctx.buildChild,
    ctx.registerInvokeHandler,
    ctx.unregisterInvokeHandler,
  );
}

// ─── shadow ───────────────────────────────────────────────────────────────────
// color, blur, spread, dx, dy. Multiple shadows via 'shadows' list.
// Wraps child in a drop-shadow container using Skins elevation tokens.
Widget _buildShadow(CandySubmoduleContext ctx) {
  return buildShadowStackControl(
    ctx.merged,
    candyFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild),
  );
}

// ─── outline ──────────────────────────────────────────────────────────────────
// Focus / accent ring drawn outside the child. outline_color, outline_width,
// radius. Distinct from border — used for a11y focus indicators and selection.
Widget _buildOutline(CandySubmoduleContext ctx) {
  final m = ctx.merged;
  final outlineColor =
      coerceColor(m['outline_color']) ?? ctx.style.outlineColor;
  final outlineWidth =
      coerceDouble(m['outline_width']) ?? ctx.style.outlineWidth;
  final radius = coerceDouble(m['radius']) ?? ctx.style.radius;
  final padding = candyCoercePadding(m['padding']);

  Widget child = candyFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild);
  if (padding != null) child = Padding(padding: padding, child: child);

  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: outlineColor, width: outlineWidth),
      borderRadius: radius > 0 ? BorderRadius.circular(radius) : null,
    ),
    child: child,
  );
}

// ─── gradient ─────────────────────────────────────────────────────────────────
// variant (linear|radial|sweep), colors, stops, begin, end, angle.
// Delegates to the animated gradient control (supports color-cycling invoke).
Widget _buildGradient(CandySubmoduleContext ctx) {
  return buildGradientControl(
    ctx.merged,
    ctx.rawChildren,
    ctx.buildChild,
    controlId: '${ctx.controlId}::gradient',
    registerInvokeHandler: ctx.registerInvokeHandler,
    unregisterInvokeHandler: ctx.unregisterInvokeHandler,
    sendEvent: ctx.sendEvent,
  );
}

// ─── decorated_box ────────────────────────────────────────────────────────────
// Composite decoration: bgcolor, gradient, border, radius, shadow.
// Use this when multiple decoration layers must be composed on one surface.
Widget _buildDecoratedBox(CandySubmoduleContext ctx) {
  final m = ctx.merged;
  final gradient = coerceGradient(m['gradient']);
  final bgcolor = coerceColor(m['bgcolor'] ?? m['background']);
  final radius = coerceDouble(m['radius']) ?? ctx.style.radius;
  final shadows = coerceBoxShadow(m['shadow']);
  final border = candyCoerceBorder(m);
  final padding = candyCoercePadding(m['padding']);

  Widget child = candyFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild);
  if (padding != null) child = Padding(padding: padding, child: child);

  return DecoratedBox(
    decoration: BoxDecoration(
      // gradient takes precedence over flat fill
      color: gradient != null ? null : bgcolor,
      gradient: gradient,
      border: border,
      borderRadius: radius > 0 ? BorderRadius.circular(radius) : null,
      boxShadow: shadows,
    ),
    child: child,
  );
}

// ─── clip ─────────────────────────────────────────────────────────────────────
// shape (rect|oval|circle), clip_behavior, radius.
// rect → ClipRRect, oval/circle → ClipOval.
Widget _buildClip(CandySubmoduleContext ctx) {
  final m = ctx.merged;
  final child = candyFirstChildOrEmpty(ctx.rawChildren, ctx.buildChild);
  final shape = candyNorm(
    (m['shape'] ?? m['clip_shape'] ?? 'rect').toString(),
  );
  final clipBehavior = candyParseClip(m['clip_behavior']) ?? Clip.antiAlias;
  final radius = coerceDouble(m['radius']) ?? ctx.style.radius;

  if (shape == 'oval' || shape == 'circle') {
    return ClipOval(clipBehavior: clipBehavior, child: child);
  }

  return ClipRRect(
    clipBehavior: clipBehavior,
    borderRadius: radius > 0 ? BorderRadius.circular(radius) : BorderRadius.zero,
    child: child,
  );
}
